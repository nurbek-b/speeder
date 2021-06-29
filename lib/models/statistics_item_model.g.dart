// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatisticItemAdapter extends TypeAdapter<StatisticItem> {
  @override
  final int typeId = 0;

  @override
  StatisticItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatisticItem(
      date: fields[0] as DateTime,
      distance: fields[1] as String,
      maxSpeed: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StatisticItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.distance)
      ..writeByte(2)
      ..write(obj.maxSpeed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
