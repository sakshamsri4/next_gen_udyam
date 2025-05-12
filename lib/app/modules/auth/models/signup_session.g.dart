// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SignupSessionAdapter extends TypeAdapter<SignupSession> {
  @override
  final int typeId = 3;

  @override
  SignupSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SignupSession(
      email: fields[0] as String,
      name: fields[1] as String?,
      step: fields[2] as SignupStep,
      timestamp: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SignupSession obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.step)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignupSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SignupStepAdapter extends TypeAdapter<SignupStep> {
  @override
  final int typeId = 4;

  @override
  SignupStep read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SignupStep.initial;
      case 1:
        return SignupStep.credentials;
      case 2:
        return SignupStep.accountCreated;
      case 3:
        return SignupStep.verificationSent;
      case 4:
        return SignupStep.emailVerified;
      case 5:
        return SignupStep.roleSelected;
      case 6:
        return SignupStep.profileCompleted;
      case 7:
        return SignupStep.completed;
      default:
        return SignupStep.initial;
    }
  }

  @override
  void write(BinaryWriter writer, SignupStep obj) {
    switch (obj) {
      case SignupStep.initial:
        writer.writeByte(0);
        break;
      case SignupStep.credentials:
        writer.writeByte(1);
        break;
      case SignupStep.accountCreated:
        writer.writeByte(2);
        break;
      case SignupStep.verificationSent:
        writer.writeByte(3);
        break;
      case SignupStep.emailVerified:
        writer.writeByte(4);
        break;
      case SignupStep.roleSelected:
        writer.writeByte(5);
        break;
      case SignupStep.profileCompleted:
        writer.writeByte(6);
        break;
      case SignupStep.completed:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignupStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
