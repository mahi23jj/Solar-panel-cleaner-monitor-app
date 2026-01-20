// local_notification_service.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class InAppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String status;
  final bool isAuto;
  final bool isDismissed;
  final Duration duration;

  InAppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.status,
    required this.isAuto,
    this.isDismissed = false,
    this.duration = const Duration(seconds: 5),
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'isAuto': isAuto,
      'isDismissed': isDismissed,
    };
  }

  factory InAppNotification.fromMap(Map<String, dynamic> map) {
    return InAppNotification(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'],
      isAuto: map['isAuto'],
      isDismissed: map['isDismissed'] ?? false,
    );
  }
}