import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/interview_management/models/interview_model.dart';

/// Register Hive adapters for interview management models
void registerInterviewHiveAdapters() {
  // Register InterviewModel adapter
  if (!Hive.isAdapterRegistered(interviewModelTypeId)) {
    Hive.registerAdapter<InterviewModel>(InterviewModelAdapter());
  }

  // Register InterviewStatus adapter
  if (!Hive.isAdapterRegistered(61)) {
    Hive.registerAdapter<InterviewStatus>(InterviewStatusAdapter());
  }

  // Register InterviewType adapter
  if (!Hive.isAdapterRegistered(62)) {
    Hive.registerAdapter<InterviewType>(InterviewTypeAdapter());
  }
}

/// Adapter for InterviewModel
class InterviewModelAdapter extends TypeAdapter<InterviewModel> {
  @override
  final int typeId = interviewModelTypeId;

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

/// Adapter for InterviewStatus
class InterviewStatusAdapter extends TypeAdapter<InterviewStatus> {
  @override
  final int typeId = 61;

  @override
  InterviewStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InterviewStatus.scheduled;
      case 1:
        return InterviewStatus.confirmed;
      case 2:
        return InterviewStatus.completed;
      case 3:
        return InterviewStatus.canceled;
      case 4:
        return InterviewStatus.rescheduled;
      default:
        return InterviewStatus.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, InterviewStatus obj) {
    switch (obj) {
      case InterviewStatus.scheduled:
        writer.writeByte(0);
      case InterviewStatus.confirmed:
        writer.writeByte(1);
      case InterviewStatus.completed:
        writer.writeByte(2);
      case InterviewStatus.canceled:
        writer.writeByte(3);
      case InterviewStatus.rescheduled:
        writer.writeByte(4);
    }
  }
}

/// Adapter for InterviewType
class InterviewTypeAdapter extends TypeAdapter<InterviewType> {
  @override
  final int typeId = 62;

  @override
  InterviewType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InterviewType.phone;
      case 1:
        return InterviewType.video;
      case 2:
        return InterviewType.inPerson;
      case 3:
        return InterviewType.technical;
      case 4:
        return InterviewType.cultural;
      default:
        return InterviewType.phone;
    }
  }

  @override
  void write(BinaryWriter writer, InterviewType obj) {
    switch (obj) {
      case InterviewType.phone:
        writer.writeByte(0);
      case InterviewType.video:
        writer.writeByte(1);
      case InterviewType.inPerson:
        writer.writeByte(2);
      case InterviewType.technical:
        writer.writeByte(3);
      case InterviewType.cultural:
        writer.writeByte(4);
    }
  }
}
