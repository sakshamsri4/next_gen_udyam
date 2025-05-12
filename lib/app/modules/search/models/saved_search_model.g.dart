// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_search_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedSearchModelAdapter extends TypeAdapter<SavedSearchModel> {
  @override
  final int typeId = 5;

  @override
  SavedSearchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedSearchModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      query: fields[2] as String,
      filter: fields[3] as SearchFilter,
      createdAt: fields[4] as DateTime,
      lastUsedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedSearchModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.query)
      ..writeByte(3)
      ..write(obj.filter)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastUsedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedSearchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
