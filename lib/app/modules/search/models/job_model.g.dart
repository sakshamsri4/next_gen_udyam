// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobModelAdapter extends TypeAdapter<JobModel> {
  @override
  final int typeId = 2;

  @override
  JobModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobModel(
      id: fields[0] as String,
      title: fields[1] as String,
      company: fields[2] as String,
      location: fields[3] as String,
      description: fields[4] as String,
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
      logoUrl: fields[16] as String?,
      companyDescription: fields[17] as String?,
      benefits: (fields[18] as List).cast<String>(),
      isActive: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, JobModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.company)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.description)
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
      ..write(obj.logoUrl)
      ..writeByte(17)
      ..write(obj.companyDescription)
      ..writeByte(18)
      ..write(obj.benefits)
      ..writeByte(19)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
