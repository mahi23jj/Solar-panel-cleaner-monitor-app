// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';

// import 'package:ietp_project/starter/model/cleaning_status.dart';
// import 'package:ietp_project/starter/services/websocket_service.dart';

// class CleaningViewModel extends ChangeNotifier {
//   WebSocketService? _socket;
//   StreamSubscription<String>? _subscription;

//   CleaningStatus _status = CleaningStatus.initial();
//   CleaningStatus get status => _status;

//   CleaningViewModel({WebSocketService? arduino}) {
//     if (arduino != null) {
//       attachSocket(arduino);
//     }
//   }

//   /// Attach / reattach websocket safely
//   void attachSocket(WebSocketService socket) {
//     _subscription?.cancel();
//     _socket = socket;

//     _subscription = _socket!.dataStream.listen(
//       _handleMessage,
//       onError: (_) => _handleDisconnect(),
//       onDone: _handleDisconnect,
//       cancelOnError: true,
//     );
//   }

//   void _handleDisconnect() {
//     _status = CleaningStatus.initial();
//     notifyListeners();
//   }

//   void _handleMessage(String msg) {
//     msg = msg.trim();
//     bool updated = false;

//     print("WS → $msg");

//     try {
//       final Map<String, dynamic> data = json.decode(msg);

        
//         // Update from nested cleaningStatus map
        
//     } catch (_) {
//       print("Invalid message format");
//     }

//      notifyListeners();
//   }

//   CleaningPhase _phaseFromString(String phaseStr) {
//     switch (phaseStr.toUpperCase()) {
//       case 'SPRAYING_WATER':
//       case 'SPRAYINGWATER':
//         return CleaningPhase.sprayingWater;
//       case 'MOVING_UP':
//       case 'MOVINGUP':
//         return CleaningPhase.movingUp;
//       case 'MOVING_DOWN':
//       case 'MOVINGDOWN':
//         return CleaningPhase.movingDown;
//       case 'REACHED_TOP':
//       case 'REACHEDTOP':
//         return CleaningPhase.reachedTop;
//       case 'REACHED_BOTTOM':
//       case 'REACHEDBOTTOM':
//         return CleaningPhase.reachedBottom;
//       case 'CLEANING_COMPLETE':
//       case 'CLEANINGCOMPLETE':
//         return CleaningPhase.cleaningComplete;
//       case 'STOPPED':
//         return CleaningPhase.stopped;
//       case 'WAITING':
//         return CleaningPhase.waiting;
//       default:
//         return CleaningPhase.idle;
//     }
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }
// }
