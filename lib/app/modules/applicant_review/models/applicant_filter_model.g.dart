// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_filter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicantFilterModelAdapter extends TypeAdapter<ApplicantFilterModel> {
  @override
  final int typeId = 20;

  @override
  ApplicantFilterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicantFilterModel(
      jobId: fields[0] as String,
      name: fields[1] as String,
      skills: (fields[2] as List).cast<String>(),
      experience: (fields[3] as List).cast<String>(),
      education: (fields[4] as List).cast<String>(),
      statuses: (fields[5] as List).cast<ApplicationStatus>(),
      applicationDateStart: fields[6] as DateTime?,
      applicationDateEnd: fields[7] as DateTime?,
      hasResume: fields[8] as bool,
      hasCoverLetter: fields[9] as bool,
      sortBy: fields[10] as ApplicantSortOption,
      sortOrder: fields[11] as ApplicantSortOrder,
      page: fields[12] as int,
      limit: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicantFilterModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.jobId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.skills)
      ..writeByte(3)
      ..write(obj.experience)
      ..writeByte(4)
      ..write(obj.education)
      ..writeByte(5)
      ..write(obj.statuses)
      ..writeByte(6)
      ..write(obj.applicationDateStart)
      ..writeByte(7)
      ..write(obj.applicationDateEnd)
      ..writeByte(8)
      ..write(obj.hasResume)
      ..writeByte(9)
      ..write(obj.hasCoverLetter)
      ..writeByte(10)
      ..write(obj.sortBy)
      ..writeByte(11)
      ..write(obj.sortOrder)
      ..writeByte(12)
      ..write(obj.page)
      ..writeByte(13)
      ..write(obj.limit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicantFilterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicantSortOptionAdapter extends TypeAdapter<ApplicantSortOption> {
  @override
  final int typeId = 21;

  @override
  ApplicantSortOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplicantSortOption.applicationDate;
      case 1:
        return ApplicantSortOption.name;
      case 2:
        return ApplicantSortOption.status;
      case 3:
        return ApplicantSortOption.matchScore;
      default:
        return ApplicantSortOption.applicationDate;
    }
  }

  @override
  void write(BinaryWriter writer, ApplicantSortOption obj) {
    switch (obj) {
      case ApplicantSortOption.applicationDate:
        writer.writeByte(0);
        break;
      case ApplicantSortOption.name:
        writer.writeByte(1);
        break;
      case ApplicantSortOption.status:
        writer.writeByte(2);
        break;
      case ApplicantSortOption.matchScore:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicantSortOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicantSortOrderAdapter extends TypeAdapter<ApplicantSortOrder> {
  @override
  final int typeId = 22;

  @override
  ApplicantSortOrder read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplicantSortOrder.ascending;
      case 1:
        return ApplicantSortOrder.descending;
      default:
        return ApplicantSortOrder.ascending;
    }
  }

  @override
  void write(BinaryWriter writer, ApplicantSortOrder obj) {
    switch (obj) {
      case ApplicantSortOrder.ascending:
        writer.writeByte(0);
        break;
      case ApplicantSortOrder.descending:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicantSortOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
