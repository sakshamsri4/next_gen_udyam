// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationModelAdapter extends TypeAdapter<ApplicationModel> {
  @override
  final int typeId = 10;

  @override
  ApplicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      jobId: fields[2] as String,
      jobTitle: fields[3] as String,
      company: fields[4] as String,
      appliedAt: fields[5] as DateTime,
      status: fields[6] as ApplicationStatus,
      name: fields[7] as String,
      email: fields[8] as String,
      phone: fields[9] as String,
      coverLetter: fields[10] as String,
      resumeUrl: fields[11] as String?,
      lastUpdated: fields[12] as DateTime?,
      feedback: fields[13] as String?,
      interviewDate: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.jobId)
      ..writeByte(3)
      ..write(obj.jobTitle)
      ..writeByte(4)
      ..write(obj.company)
      ..writeByte(5)
      ..write(obj.appliedAt)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.coverLetter)
      ..writeByte(11)
      ..write(obj.resumeUrl)
      ..writeByte(12)
      ..write(obj.lastUpdated)
      ..writeByte(13)
      ..write(obj.feedback)
      ..writeByte(14)
      ..write(obj.interviewDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicationStatusAdapter extends TypeAdapter<ApplicationStatus> {
  @override
  final int typeId = 11;

  @override
  ApplicationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplicationStatus.pending;
      case 1:
        return ApplicationStatus.reviewed;
      case 2:
        return ApplicationStatus.shortlisted;
      case 3:
        return ApplicationStatus.interview;
      case 4:
        return ApplicationStatus.offered;
      case 5:
        return ApplicationStatus.hired;
      case 6:
        return ApplicationStatus.rejected;
      case 7:
        return ApplicationStatus.withdrawn;
      default:
        return ApplicationStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ApplicationStatus obj) {
    switch (obj) {
      case ApplicationStatus.pending:
        writer.writeByte(0);
        break;
      case ApplicationStatus.reviewed:
        writer.writeByte(1);
        break;
      case ApplicationStatus.shortlisted:
        writer.writeByte(2);
        break;
      case ApplicationStatus.interview:
        writer.writeByte(3);
        break;
      case ApplicationStatus.offered:
        writer.writeByte(4);
        break;
      case ApplicationStatus.hired:
        writer.writeByte(5);
        break;
      case ApplicationStatus.rejected:
        writer.writeByte(6);
        break;
      case ApplicationStatus.withdrawn:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
