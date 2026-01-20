import 'dart:async';

import 'package:hive/hive.dart';
import 'package:ietp_project/starter/model/hive_model.dart';
import 'package:ietp_project/starter/model/notification_model.dart';
import 'package:uuid/uuid.dart';

class LocalNotificationService {
  final Box<HiveCleaningNotification> notificationBox;
  final Uuid _uuid = const Uuid();

  // Stream controller for in-app notifications
  final _inAppNotificationsController =
      StreamController<List<InAppNotification>>.broadcast();
  Stream<List<InAppNotification>> get inAppNotificationsStream =>
      _inAppNotificationsController.stream;

  // Active in-app notifications
  final List<InAppNotification> _activeNotifications = [];

  // get inAppNotificationsStream

  List<InAppNotification> get activeNotifications =>
      List.from(_activeNotifications);

  LocalNotificationService(this.notificationBox);

  final Map<String, Timer> _autoDismissTimers = {};

  // Save notification to Hive
  Future<void> saveNotification({
    required String title,
    required String message,
    required bool isAuto,
    required String status,
  }) async {
    final notification = HiveCleaningNotification(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      title: title,
      message: message,
      isAuto: isAuto,
      status: status,
    );

    await notificationBox.add(notification);
  }

  // Show in-app notification
  Future<void> showInAppNotification({
    required String title,
    required String message,
    required String status,
    required bool isAuto,
    Duration duration = const Duration(seconds: 1),
  }) async {
    final id = _uuid.v4();

    final notification = InAppNotification(
      id: id,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      status: status,
      isAuto: isAuto,
      duration: duration,
    );

    // Add to active notifications
    _activeNotifications.add(notification);
    _inAppNotificationsController.add(List.from(_activeNotifications));

    // Start auto-dismiss timer AFTER it is shown
    _autoDismissTimers[id] = Timer(duration, () {
      removeInAppNotification(id);
    });

    // Save persistently
    await saveNotification(
      title: title,
      message: message,
      isAuto: isAuto,
      status: status,
    );
  }

  // Remove specific in-app notification
  void removeInAppNotification(String id) {
    _autoDismissTimers[id]?.cancel();
    _autoDismissTimers.remove(id);

    _activeNotifications.removeWhere((n) => n.id == id);
    _inAppNotificationsController.add(List.from(_activeNotifications));
  }

  // Dismiss all in-app notifications
  void dismissAllInAppNotifications() {
    for (final timer in _autoDismissTimers.values) {
      timer.cancel();
    }
    _autoDismissTimers.clear();

    _activeNotifications.clear();
    _inAppNotificationsController.add([]);
  }

  // Get all notifications from Hive
  List<HiveCleaningNotification> getAllNotifications() {
    return notificationBox.values.toList().reversed.toList();
  }

  // Mark notification as read
  Future<void> markAsRead(String id) async {
    final notification = notificationBox.values.firstWhere(
      (n) => n.id == id,
      orElse: () => throw Exception('Notification not found'),
    );
    // You can add a 'read' field to the HiveCleaningNotification model
    // For now, we'll just remove it from active notifications
    removeInAppNotification(id);
  }

  // Clear all notifications from Hive
  Future<void> clearAllNotifications() async {
    await notificationBox.clear();
    _activeNotifications.clear();
    _inAppNotificationsController.add([]);
  }

  void dispose() {
    dismissAllInAppNotifications();
    _inAppNotificationsController.close();
  }
}
