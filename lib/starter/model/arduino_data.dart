// import 'package:ietp_project/starter/model/cleaning_status.dart';

// class ArduinoData {
//   final double dustLevel;
//   final double threshold;
//   final bool aboveThreshold;
//   final bool cleaningInProgress;
//   final String cycle;
//   final CleaningStatus cleaningStatus;
//   final bool autoCleaningEnabled;
//   final DateTime timestamp;

//   ArduinoData({
//     required this.dustLevel,
//     required this.threshold,
//     required this.aboveThreshold,
//     required this.cleaningInProgress,
//     required this.cleaningStatus,
//     required this.cycle,
//     required this.autoCleaningEnabled,
//     required this.timestamp,
//   });

//   // ---------------- PARSERS ----------------
//   static bool _parseBool(dynamic value, [bool fallback = false]) {
//     if (value is bool) return value;
//     if (value is String) {
//       final v = value.toLowerCase();
//       return v == 'true' || v == 'yes' || v == 'on';
//     }
//     if (value is int) return value == 1;
//     return fallback;
//   }

//   static double _parseDouble(dynamic value, [double fallback = 0.0]) {
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value) ?? fallback;
//     return fallback;
//   }

//   static String _parseString(dynamic value, [String fallback = '0/0']) {
//     if (value == null) return fallback;
//     return value.toString();
//   }

//   static CleaningPhase _parsePhase(dynamic value) {
//     if (value is String) {
//       switch (value.toLowerCase()) {
//         case 'spraying_water':
//           return CleaningPhase.sprayingWater;
//         case 'moving_up':
//           return CleaningPhase.movingUp;
//         case 'moving_down':
//           return CleaningPhase.movingDown;
//         case 'reached_top':
//           return CleaningPhase.reachedTop;
//         case 'reached_bottom':
//           return CleaningPhase.reachedBottom;
//         case 'cleaning_complete':
//           return CleaningPhase.cleaningComplete;
//         case 'stopped':
//           return CleaningPhase.stopped;
//         case 'waiting':
//           return CleaningPhase.waiting;
//         default:
//           return CleaningPhase.idle;
//       }
//     }
//     return CleaningPhase.idle;
//   }

//   // ---------------- FACTORY ----------------
//   factory ArduinoData.fromMap(Map<String, dynamic> map) {
//     final cleaningInProgress = _parseBool(map['cleaning']);
//     CleaningStatus? status;

//     if (cleaningInProgress) {
//       // Parse cleaningStatus only if cleaningInProgress is true
//       status = CleaningStatus(
//         phase: _parsePhase(map['phase']),
//         currentCycle: map['currentCycle'] ?? 0,
//         maxCycles: map['maxCycles'] ?? 0,
//         isCleaning: cleaningInProgress,
//       );
//     } else {
//       status = CleaningStatus.initial();
//     }

//     return ArduinoData(
//       dustLevel: _parseDouble(map['dust']),
//       threshold: _parseDouble(map['threshold']),
//       aboveThreshold: _parseBool(map['above']),
//       cleaningInProgress: cleaningInProgress,
//       cycle: _parseString(map['cycle']),
//       autoCleaningEnabled: _parseBool(map['auto']),
//       timestamp: DateTime.now(),
//       cleaningStatus: status,
//     );
//   }

//   // ---------------- UPDATE ----------------
//   ArduinoData copyWithMap(Map<String, dynamic> map) {
//     final cleaningInProgress = _parseBool(map['cleaning']);
//     CleaningStatus? status;

//     if (cleaningInProgress) {
//       // Parse cleaningStatus only if cleaningInProgress is true
//       status = CleaningStatus(
//         phase: _parsePhase(map['phase']),
//         currentCycle: map['currentCycle'] ?? 0,
//         maxCycles: map['maxCycles'] ?? 0,
//         isCleaning: cleaningInProgress,
//       );
//     } else {
//       status = CleaningStatus.initial();
//     }

//     return ArduinoData(
//       dustLevel: _parseDouble(map['dust'], dustLevel),
//       threshold: _parseDouble(map['threshold'], threshold),
//       aboveThreshold: _parseBool(map['above'], aboveThreshold),
//       cleaningInProgress: _parseBool(map['cleaning'], cleaningInProgress),
//       cycle: _parseString(map['cycle'], cycle),
//       autoCleaningEnabled: _parseBool(map['auto'], autoCleaningEnabled),
//       timestamp: DateTime.now(),
//       cleaningStatus: status,
//     );
//   }
// }

import 'package:ietp_project/starter/model/cleaning_status.dart';

class ArduinoData {
  final double dustLevel;
  final double threshold;
  final bool aboveThreshold;
  final bool cleaningInProgress;
  final String cycle;
  final bool autoCleaningEnabled;
  final CleaningStatus cleaningStatus;
  final DateTime timestamp;

  ArduinoData({
    required this.dustLevel,
    required this.threshold,
    required this.aboveThreshold,
    required this.cleaningInProgress,
    required this.cycle,
    required this.autoCleaningEnabled,
    required this.cleaningStatus,
    required this.timestamp,
  });

  factory ArduinoData.initial() {
    return ArduinoData(
      dustLevel: 0,
      threshold: 600, // default to match ESP32 firmware threshold
      aboveThreshold: false,
      cleaningInProgress: false,
      cycle: '0/0',
      autoCleaningEnabled: true,
      cleaningStatus: CleaningStatus.initial(),
      timestamp: DateTime.now(),
    );
  }

  ArduinoData copyWith({
    double? dustLevel,
    double? threshold,
    bool? aboveThreshold,
    bool? cleaningInProgress,
    String? cycle,
    bool? autoCleaningEnabled,
    CleaningStatus? cleaningStatus,
  }) {
    return ArduinoData(
      dustLevel: dustLevel ?? this.dustLevel,
      threshold: threshold ?? this.threshold,
      aboveThreshold: aboveThreshold ?? this.aboveThreshold,
      cleaningInProgress: cleaningInProgress ?? this.cleaningInProgress,
      cycle: cycle ?? this.cycle,
      autoCleaningEnabled: autoCleaningEnabled ?? this.autoCleaningEnabled,
      cleaningStatus: cleaningStatus ?? this.cleaningStatus,
      timestamp: DateTime.now(),
    );
  }
}
