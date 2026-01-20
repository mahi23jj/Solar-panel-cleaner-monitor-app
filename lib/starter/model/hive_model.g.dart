// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCleaningNotificationAdapter
    extends TypeAdapter<HiveCleaningNotification> {
  @override
  final int typeId = 2;

  @override
  HiveCleaningNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCleaningNotification(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      title: fields[2] as String,
      message: fields[3] as String,
      isAuto: fields[4] as bool,
      status: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCleaningNotification obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.isAuto)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCleaningNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
