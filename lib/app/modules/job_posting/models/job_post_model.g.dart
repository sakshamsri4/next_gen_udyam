// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobPostModelAdapter extends TypeAdapter<JobPostModel> {
  @override
  final int typeId = 15;

  @override
  JobPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobPostModel(
      id: fields[0] as String,
      companyId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      location: fields[4] as String,
      salary: fields[5] as int,
      postedDate: fields[6] as DateTime,
      requirements: (fields[7] as List).cast<String>(),
      responsibilities: (fields[8] as List).cast<String>(),
      skills: (fields[9] as List).cast<String>(),
      jobType: fields[10] as String,
      experience: fields[11] as String,
      education: fields[12] as String,
      industry: fields[13] as String,
      isRemote: fields[14] as bool,
      applicationDeadline: fields[15] as DateTime?,
      status: fields[16] as JobStatus,
      benefits: (fields[17] as List).cast<String>(),
      isFeatured: fields[18] as bool,
      viewCount: fields[19] as int,
      applicationCount: fields[20] as int,
      lastUpdated: fields[21] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JobPostModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.salary)
      ..writeByte(6)
      ..write(obj.postedDate)
      ..writeByte(7)
      ..write(obj.requirements)
      ..writeByte(8)
      ..write(obj.responsibilities)
      ..writeByte(9)
      ..write(obj.skills)
      ..writeByte(10)
      ..write(obj.jobType)
      ..writeByte(11)
      ..write(obj.experience)
      ..writeByte(12)
      ..write(obj.education)
      ..writeByte(13)
      ..write(obj.industry)
      ..writeByte(14)
      ..write(obj.isRemote)
      ..writeByte(15)
      ..write(obj.applicationDeadline)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.benefits)
      ..writeByte(18)
      ..write(obj.isFeatured)
      ..writeByte(19)
      ..write(obj.viewCount)
      ..writeByte(20)
      ..write(obj.applicationCount)
      ..writeByte(21)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobStatusAdapter extends TypeAdapter<JobStatus> {
  @override
  final int typeId = 16;

  @override
  JobStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return JobStatus.active;
      case 1:
        return JobStatus.paused;
      case 2:
        return JobStatus.closed;
      case 3:
        return JobStatus.draft;
      default:
        return JobStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, JobStatus obj) {
    switch (obj) {
      case JobStatus.active:
        writer.writeByte(0);
        break;
      case JobStatus.paused:
        writer.writeByte(1);
        break;
      case JobStatus.closed:
        writer.writeByte(2);
        break;
      case JobStatus.draft:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
