import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ietp_project/starter/model/cleaning_status.dart';
import 'package:ietp_project/starter/model/hive_model.dart';
import 'package:ietp_project/starter/model/notification_model.dart';
import 'package:ietp_project/starter/services/notification_service.dart';
import 'package:uuid/uuid.dart';

import '../model/arduino_data.dart';
import '../services/websocket_service.dart';

class ArduinoProvider with ChangeNotifier {
  // ================= SERVICES =================
  // final WebSocketService _socket = WebSocketService();
  final WebSocketService _socket = WebSocketService();

  late final LocalNotificationService _notifier;
  // final LocalNotificationService _notifier = LocalNotificationService();
  final Uuid _uuid = const Uuid();

  // ================= STATE =================
  ArduinoData? _currentData;
  final List<ArduinoData> _dataHistory = [];

  bool _isConnected = false; // REAL device connection
  bool _isLoading = true; // App startup loading
  String _connectionStatus = 'Initializing';
  bool _hasNavigated = false;

  final List<String> _messages = [];

  // ================= GETTERS =================
  ArduinoData? get currentData => _currentData;
  List<ArduinoData> get dataHistory => _dataHistory;

  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String get connectionStatus => _connectionStatus;

  List<String> get messages => _messages;
  WebSocketService get socket => _socket;

  final void Function(bool isAuto)? onCleaningStarted;

  LocalNotificationService get notifier => _notifier;

  // Add getter for in-app notifications stream
  Stream<List<InAppNotification>> get inAppNotificationsStream =>
      _notifier.inAppNotificationsStream;

  // ================= INIT =================
  ArduinoProvider(
    this.onCleaningStarted, {
    required Box<HiveCleaningNotification> notificationBox,
  }) {
    _notifier = LocalNotificationService(notificationBox);

    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    final socketOpened = await _socket.connect();

    print('inital connection $socketOpened');

    if (!socketOpened) {
      _connectionStatus = 'Socket connection failed';
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Socket is open, but Arduino may not be ready
    _connectionStatus = 'Waiting for Arduino...';

    _socket.dataStream.listen(
      _handleIncomingData,
      onDone: _handleSocketClosed,
      onError: _handleSocketError,
    );

    _isLoading = false;
    notifyListeners();
  }

  // ================= DATA HANDLER =================
  // void _handleIncomingData(String data) {
  //   _messages.add(data);

  //   // ---- CONNECTION SIGNALS ----
  //   if (data == 'CONNECTED') {
  //     _isConnected = true;
  //     _connectionStatus = 'Connected';
  //     notifyListeners();
  //     return;
  //   }

  //   if (data == 'DISCONNECTED') {
  //     _isConnected = false;
  //     _connectionStatus = 'Disconnected';
  //     _currentData = null;
  //     notifyListeners();
  //     return;
  //   }

  //   // ---- JSON PAYLOAD ----
  //   try {
  //     final Map<String, dynamic> json = jsonDecode(data);

  //     print('Arduino Data: $json');

  //     _currentData = ArduinoData.fromMap(json);

  //     print('currentData: $_currentData');

  //     // --- NAVIGATE IF CLEANING STARTED ---
  //     if (_currentData!.cleaningInProgress && !_hasNavigated) {
  //       _hasNavigated = true;
  //       if (onCleaningStarted != null) {
  //         onCleaningStarted!(_currentData!.cleaningStatus.isCleaning);
  //       }
  //     } else if (!_currentData!.cleaningInProgress) {
  //       _hasNavigated = false; // reset when cleaning stops
  //     }

  //     _dataHistory.add(_currentData!);
  //     if (_dataHistory.length > 100) {
  //       _dataHistory.removeAt(0);
  //     }

  //     notifyListeners();
  //   } catch (_) {
  //     // Ignore non-JSON messages
  //   }
  // }

  // ... existing code ...

  // ================= NOTIFICATION METHODS =================
  Future<void> notifyDustAlert(double dustLevel) async {
    await _notifier.showInAppNotification(
      title: 'Dust Alert',
      message: 'Dust level exceeded ${dustLevel}μg/m³',
      status: 'dust_alert',
      isAuto: true,
      duration: const Duration(seconds: 8),
    );
  }

  Future<void> notifyCleaningStarted() async {
    print('notifyCleaningStarted called');
    await _notifier.showInAppNotification(
      title: 'Cleaning Started',
      message: 'Auto-cleaning sequence initiated',
      status: 'started',
      isAuto: true,
    );
  }

  Future<void> notifyCleaningCompleted(
    String cycles,
    double dustReduction,
  ) async {
    await _notifier.showInAppNotification(
      title: 'Cleaning Completed',
      message:
          'Completed $cycles cycles. Dust reduced by ${dustReduction}μg/m³',
      status: 'completed',
      isAuto: true,
    );
  }

  Future<void> notifyMotorError() async {
    await _notifier.showInAppNotification(
      title: 'Motor Error',
      message: 'Motor stopped unexpectedly. Check system.',
      status: 'error',
      isAuto: false,
      duration: const Duration(seconds: 10),
    );
  }

  Future<void> notifyWaterLow() async {
    await _notifier.showInAppNotification(
      title: 'Water Level Low',
      message: 'Water reservoir needs refilling',
      status: 'warning',
      isAuto: false,
      duration: const Duration(seconds: 8),
    );
  }

  Map<String, String> _parseStatus(String msg) {
    final data = <String, String>{};
    final raw = msg.replaceFirst('STATUS:', '');
    final parts = raw.split(',');

    for (final p in parts) {
      final kv = p.split(RegExp('[:=]'));
      if (kv.length >= 2) {
        final key = kv[0].trim().toUpperCase();
        final value = kv.sublist(1).join('=').trim();
        data[key] = value;
      }
    }
    return data;
  }

  CleaningPhase _phaseFromEvent(String event) {
    final e = event.toUpperCase();

    if (e.contains('SPRAYING_WATER')) {
      return CleaningPhase.sprayingWater;
    }

    if (e.contains('SWEEP') || e.contains('SERVO_WIPER') || e.contains('STEP2')) {
      return CleaningPhase.aggressiveCleaning;
    }

    if (e.contains('CYCLE:')) {
      return CleaningPhase.cleaningCycle;
    }

    if (e.contains('CLEANING:COMPLETE') || e.contains('CLEANING_COMPLETE')) {
      return CleaningPhase.cleaningComplete;
    }

    if (e.contains('WAITING') || e.contains('PAUSE')) {
      return CleaningPhase.waitingBeforeResume;
    }

    if (e.contains('STOP') || e.contains('FORCE')) {
      return CleaningPhase.stopped;
    }

    if (e.contains('ABOVE') || e.contains('THRESHOLD')) {
      return CleaningPhase.dustDetected;
    }

    return CleaningPhase.idle;
  }

  List<int> _parseCycleParts(String? cycle) {
    if (cycle == null || !cycle.contains('/')) return [0, 0];
    final parts = cycle.split('/');
    final current = int.tryParse(parts[0]) ?? 0;
    final max = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    return [current, max];
  }

  // ================= UPDATE DATA HANDLER =================

  void _handleIncomingData(String data) {
    _messages.add(data);
    debugPrint('WS → $data');

    // ================= CONNECTION =================
    if (data == 'CONNECTED') {
      _isConnected = true;
      _connectionStatus = 'Connected';
      notifyListeners();
      return;
    }

    if (data == 'DISCONNECTED') {
      _isConnected = false;
      _connectionStatus = 'Disconnected';
      _currentData = null;
      notifyListeners();
      return;
    }

    // ================= STATUS =================
    if (data.startsWith('STATUS:')) {
      final map = _parseStatus(data);

      final dust = double.tryParse(map['DUST'] ?? '0') ?? 0;
      final threshold =
          double.tryParse(map['TH'] ?? map['THRESHOLD'] ?? '600') ?? 600;

      final statusText = (map['STATUS'] ?? map['STATE'] ?? '').toUpperCase();
      bool above = statusText.contains('ABOVE');
      if (!above) {
        final aboveRaw = (map['ABOVE'] ?? '').toUpperCase();
        above = aboveRaw == 'YES' || aboveRaw == 'TRUE' || aboveRaw == '1';
      }

      final cleaningText = (map['CLEANING'] ?? '').toUpperCase();
      final cleaning = cleaningText == 'ACTIVE' ||
          cleaningText == 'ON' ||
          cleaningText == 'RUNNING';

      final cycleRaw = map['CYCLE'] ?? '0/0';
      final cycleParts = _parseCycleParts(cycleRaw);

      _currentData ??= ArduinoData.initial();

      final phase = cleaning
          ? CleaningPhase.aggressiveCleaning
          : (above ? CleaningPhase.dustDetected : CleaningPhase.idle);

      _currentData = _currentData!.copyWith(
        dustLevel: dust,
        threshold: threshold,
        aboveThreshold: above,
        cleaningInProgress: cleaning,
        cycle: cycleRaw,
        cleaningStatus: _currentData!.cleaningStatus.copyWith(
          phase: phase,
          isCleaning: cleaning,
          currentCycle: cycleParts[0],
          maxCycles: cycleParts[1],
        ),
      );

      if (above && !cleaning) {
        notifyDustAlert(dust);
      }

      _dataHistory.add(_currentData!);
      if (_dataHistory.length > 100) _dataHistory.removeAt(0);

      notifyListeners();
      return;
    }

    // ================= EVENT =================
    if (data.startsWith('EVENT:') || data.startsWith('CLEANING:')) {
      final phase = _phaseFromEvent(data);

      _currentData ??= ArduinoData.initial();

      String cycleRaw = _currentData!.cycle;
      if (data.toUpperCase().contains('CYCLE:')) {
        cycleRaw = data.substring(data.lastIndexOf(':') + 1);
      }
      final cycleParts = _parseCycleParts(cycleRaw);

      final isCleaning = phase != CleaningPhase.cleaningComplete &&
          phase != CleaningPhase.stopped &&
          phase != CleaningPhase.idle;

      _currentData = _currentData!.copyWith(
        cleaningInProgress: isCleaning,
        cycle: cycleRaw,
        cleaningStatus: _currentData!.cleaningStatus.copyWith(
          phase: phase,
          isCleaning: isCleaning,
          currentCycle: cycleParts[0],
          maxCycles: cycleParts[1],
        ),
      );

      if (phase == CleaningPhase.sprayingWater && !_hasNavigated) {
        _hasNavigated = true;
        notifyCleaningStarted();
      }

      if (phase == CleaningPhase.cleaningComplete) {
        notifyCleaningCompleted(_currentData!.cycle, 0);
        _hasNavigated = false;
      }

      notifyListeners();
      return;
    }
  }

  /* void _handleIncomingData(String data) {



    _messages.add(data);

    print('connection level in mid $data' );

    // ---- CONNECTION SIGNALS ----
    if (data == 'CONNECTED') {
      _isConnected = true;
      _connectionStatus = 'Connected';

      // Show connection notification
      _notifier.showInAppNotification(
        title: 'Device Connected',
        message: 'Arduino device connected successfully',
        status: 'connected',
        isAuto: false,
      );

      notifyListeners();
      return;
    }

    if (data == 'DISCONNECTED') {
      _isConnected = false;
      _connectionStatus = 'Disconnected';
      _currentData = null;

      // Show disconnection notification
      _notifier.showInAppNotification(
        title: 'Device Disconnected',
        message: 'Arduino device disconnected',
        status: 'disconnected',
        isAuto: false,
        duration: const Duration(seconds: 10),
      );

      notifyListeners();
      return;
    }

    // ---- JSON PAYLOAD ----
    try {
      final Map<String, dynamic> json = jsonDecode(data);
      print('Arduino Data: $json');

      // final previousDustLevel = _currentData?.dustLevel ?? 0;
      _currentData = ArduinoData.fromMap(json);
      final currentDustLevel = _currentData!.dustLevel;

      print('currentData: $_currentData');

      // --- DUST ALERT NOTIFICATION ---
      if (currentDustLevel > _currentData!.threshold) {
        notifyDustAlert(currentDustLevel);
      }

      // --- WATER LOW NOTIFICATION ---
      /*    if (_currentData!. < 20) {
        notifyWaterLow();
      } */

      // --- MOTOR ERROR NOTIFICATION ---
      // if (_currentData!.motorStatus == 'ERROR') {
      //   notifyMotorError();
      // }

      // --- CLEANING START/STOP NOTIFICATIONS ---
      if (_currentData!.cleaningInProgress && !_hasNavigated) {
        _hasNavigated = true;
        notifyCleaningStarted();

        if (onCleaningStarted != null) {
          onCleaningStarted!(_currentData!.cleaningStatus.isCleaning);
        }
      } else if (!_currentData!.cleaningInProgress && _hasNavigated) {
        // Calculate dust reduction
        final startDust = _dataHistory.isNotEmpty
            ? _dataHistory.last.dustLevel
            : currentDustLevel;
        final dustReduction = startDust - currentDustLevel;

        notifyCleaningCompleted(_currentData!.cycle, dustReduction);
        _hasNavigated = false;
      }

      _dataHistory.add(_currentData!);
      if (_dataHistory.length > 100) {
        _dataHistory.removeAt(0);
      }

      notifyListeners();
    } catch (_) {
      // Ignore non-JSON messages
    }
  }
 */
  // Add method to get all notifications
  List<HiveCleaningNotification> getNotifications() {
    return _notifier.getAllNotifications();
  }

  // Add method to clear notifications
  Future<void> clearNotifications() async {
    await _notifier.clearAllNotifications();
    notifyListeners();
  }

  // Add method to dismiss in-app notification
  void dismissInAppNotification(String id) {
    _notifier.removeInAppNotification(id);
    notifyListeners();
  }

  // Add method to dismiss all in-app notifications
  void dismissAllInAppNotifications() {
    _notifier.dismissAllInAppNotifications();
    notifyListeners();
  }

  // ... rest of existing code ...

  void _handleSocketClosed() {
    _isConnected = false;
    _connectionStatus = 'Socket closed';
    _currentData = null;
    notifyListeners();
  }

  void _handleSocketError(dynamic error) {
    _isConnected = false;
    _connectionStatus = 'Socket error';
    _currentData = null;
    notifyListeners();
  }

  // ================= COMMANDS =================
  Future<void> getStatus() => _send('STATUS');
  Future<void> startAutoCleaning() => _send('START');
  Future<void> stopAutoCleaning() => _send('STOP');
  Future<void> manualClean() => _send('START');
  Future<void> servoTest() => _send('SERVO_TEST');
  Future<void> dustDebug() => _send('DUST_DEBUG');

  Future<void> _send(String cmd) async {
    if (!_isConnected) {
      _messages.add('Not connected');
      notifyListeners();
      return;
    }

    final sent = await _socket.sendCommand(cmd);
    _messages.add(sent ? 'Sent: $cmd' : 'Failed: $cmd');
    notifyListeners();
  }

  // ================= CLEANING LOG =================
  // Future<void> startCleaningLog() async {
  //   if (_currentData == null) return;

  //   _currentLog = HiveCleaningLog(
  //     id: _uuid.v4(),
  //     startTime: DateTime.now(),
  //     initialDustLevel: _currentData!.dustLevel,
  //     waterSpraySeconds: 10,
  //     motorCycles: _currentData!.cycle,
  //     status: 'running',
  //     parameters: {'mode': 'auto'},
  //   );

  //   await _hive.saveCleaningLog(_currentLog!);
  //   await _notifier.notifyCleaningStarted();
  // }

  // ================= DISCONNECT =================
  Future<void> disconnect() async {
    await _socket.disconnect();
    _isConnected = false;
    _connectionStatus = 'Disconnected';
    _currentData = null;
    _messages.clear();
    notifyListeners();
  }

  // ================= CLEANUP =================
  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }
}
