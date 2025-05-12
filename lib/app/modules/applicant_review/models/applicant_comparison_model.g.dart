// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_comparison_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicantComparisonModelAdapter
    extends TypeAdapter<ApplicantComparisonModel> {
  @override
  final int typeId = 23;

  @override
  ApplicantComparisonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicantComparisonModel(
      id: fields[0] as String,
      jobId: fields[1] as String,
      applicantIds: (fields[2] as List).cast<String>(),
      createdAt: fields[3] as DateTime,
      notes: fields[4] as String,
      ratings: (fields[5] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ApplicantComparisonModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.applicantIds)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.ratings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicantComparisonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
