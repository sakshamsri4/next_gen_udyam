// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardingStatusAdapter extends TypeAdapter<OnboardingStatus> {
  @override
  final int typeId = 3;

  @override
  OnboardingStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnboardingStatus(
      hasCompletedOnboarding: fields[0] as bool,
      lastUpdated: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingStatus obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hasCompletedOnboarding)
      ..writeByte(1)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
