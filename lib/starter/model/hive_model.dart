import 'package:hive/hive.dart';

part 'hive_model.g.dart';

@HiveType(typeId: 2)
class HiveCleaningNotification extends HiveObject {
  @HiveField(0)
  String id; // UUID for each notification

  @HiveField(1)
  DateTime timestamp; // When the event occurred

  @HiveField(2)
  String title; // e.g., "Auto Cleaning Started"

  @HiveField(3)
  String message; // e.g., "Cycle 1 of 2 in progress"

  @HiveField(4)
  bool isAuto; // true if auto-cleaning, false if manual

  @HiveField(5)
  String status; // "started", "completed", "stopped", "error"

  HiveCleaningNotification({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.message,
    required this.isAuto,
    required this.status,
  });
}
