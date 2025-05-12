// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterviewModelAdapter extends TypeAdapter<InterviewModel> {
  @override
  final int typeId = 60;

  @override
  InterviewModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InterviewModel(
      id: fields[0] as String,
      applicationId: fields[1] as String,
      jobId: fields[2] as String,
      candidateId: fields[3] as String,
      candidateName: fields[4] as String,
      jobTitle: fields[5] as String,
      scheduledDate: fields[6] as DateTime,
      duration: fields[7] as int,
      status: fields[8] as InterviewStatus,
      type: fields[9] as InterviewType,
      notes: fields[10] as String?,
      feedback: fields[11] as String?,
      interviewerIds: (fields[12] as List).cast<String>(),
      interviewerNames: (fields[13] as List).cast<String>(),
      location: fields[14] as String?,
      videoLink: fields[15] as String?,
      phoneNumber: fields[16] as String?,
      preparationResources: (fields[17] as List).cast<String>(),
      questions: (fields[18] as List).cast<String>(),
      candidateResponse: fields[19] as String?,
      createdAt: fields[20] as DateTime?,
      updatedAt: fields[21] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, InterviewModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.applicationId)
      ..writeByte(2)
      ..write(obj.jobId)
      ..writeByte(3)
      ..write(obj.candidateId)
      ..writeByte(4)
      ..write(obj.candidateName)
      ..writeByte(5)
      ..write(obj.jobTitle)
      ..writeByte(6)
      ..write(obj.scheduledDate)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.feedback)
      ..writeByte(12)
      ..write(obj.interviewerIds)
      ..writeByte(13)
      ..write(obj.interviewerNames)
      ..writeByte(14)
      ..write(obj.location)
      ..writeByte(15)
      ..write(obj.videoLink)
      ..writeByte(16)
      ..write(obj.phoneNumber)
      ..writeByte(17)
      ..write(obj.preparationResources)
      ..writeByte(18)
      ..write(obj.questions)
      ..writeByte(19)
      ..write(obj.candidateResponse)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterviewModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
