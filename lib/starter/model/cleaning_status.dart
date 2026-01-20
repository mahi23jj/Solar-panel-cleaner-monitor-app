// enum CleaningPhase {
//   idle,
//   sprayingWater,
//   movingUp,
//   movingDown,
//   reachedTop,
//   reachedBottom,
//   cleaningComplete,
//   stopped,
//   waiting,
// }

// class CleaningStatus {
//   final CleaningPhase phase;
//   final int currentCycle;
//   final int maxCycles;
//   final bool isCleaning;

//   const CleaningStatus({
//     required this.phase,
//     required this.currentCycle,
//     required this.maxCycles,
//     required this.isCleaning,
//   });

//   factory CleaningStatus.initial() {
//     return const CleaningStatus(
//       phase: CleaningPhase.idle,
//       currentCycle: 0,
//       maxCycles: 0,
//       isCleaning: false,
//     );
//   }

//   CleaningStatus copyWith({
//     CleaningPhase? phase,
//     int? currentCycle,
//     int? maxCycles,
//     bool? isCleaning,
//   }) {
//     return CleaningStatus(
//       phase: phase ?? this.phase,
//       currentCycle: currentCycle ?? this.currentCycle,
//       maxCycles: maxCycles ?? this.maxCycles,
//       isCleaning: isCleaning ?? this.isCleaning,
//     );
//   }
// }
// enum CleaningPhase {
//   idle,
//   sprayingWater,
//   movingUp,
//   movingDown,
//   reachedTop,
//   reachedBottom,
//   cleaningComplete,
//   waiting,
//   stopped,
//   error,
// }

enum CleaningPhase {
  idle,                    // System monitoring dust (default)
  dustDetected,            // Dust above threshold detected
  sprayingWater,           // Water pump ON
  aggressiveCleaning,      // Servo sweeping (all cycles)
  cleaningCycle,           // Individual servo cycle (1..MAX)
  returningToHome,         // Servo returning to 65°
  cleaningComplete,        // Cleaning finished
  waitingBeforeResume,     // 10s delay before monitoring
  stopped,                 // Manually stopped by user
  error,                   // System or communication error
}



class CleaningStatus {
  final CleaningPhase phase;
  final int currentCycle;
  final int maxCycles;
  final bool isCleaning;

  const CleaningStatus({
    required this.phase,
    required this.currentCycle,
    required this.maxCycles,
    required this.isCleaning,
  });

  factory CleaningStatus.initial() {
    return const CleaningStatus(
      phase: CleaningPhase.idle,
      currentCycle: 0,
      maxCycles: 0,
      isCleaning: false,
    );
  }

  CleaningStatus copyWith({
    CleaningPhase? phase,
    int? currentCycle,
    int? maxCycles,
    bool? isCleaning,
  }) {
    return CleaningStatus(
      phase: phase ?? this.phase,
      currentCycle: currentCycle ?? this.currentCycle,
      maxCycles: maxCycles ?? this.maxCycles,
      isCleaning: isCleaning ?? this.isCleaning,
    );
  }
}
