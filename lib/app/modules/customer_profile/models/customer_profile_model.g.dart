// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerProfileModelAdapter extends TypeAdapter<CustomerProfileModel> {
  @override
  final int typeId = 5;

  @override
  CustomerProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerProfileModel(
      uid: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      photoURL: fields[3] as String?,
      jobTitle: fields[4] as String?,
      description: fields[5] as String?,
      workExperience: (fields[6] as List).cast<WorkExperience>(),
      education: (fields[7] as List).cast<Education>(),
      skills: (fields[8] as List).cast<String>(),
      languages: (fields[9] as List).cast<Language>(),
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerProfileModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.photoURL)
      ..writeByte(4)
      ..write(obj.jobTitle)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.workExperience)
      ..writeByte(7)
      ..write(obj.education)
      ..writeByte(8)
      ..write(obj.skills)
      ..writeByte(9)
      ..write(obj.languages)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkExperienceAdapter extends TypeAdapter<WorkExperience> {
  @override
  final int typeId = 6;

  @override
  WorkExperience read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkExperience(
      company: fields[0] as String,
      position: fields[1] as String,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime?,
      description: fields[4] as String?,
      isCurrentPosition: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkExperience obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.company)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.isCurrentPosition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkExperienceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EducationAdapter extends TypeAdapter<Education> {
  @override
  final int typeId = 7;

  @override
  Education read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Education(
      institution: fields[0] as String,
      degree: fields[1] as String,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime?,
      description: fields[4] as String?,
      isCurrentEducation: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Education obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.institution)
      ..writeByte(1)
      ..write(obj.degree)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.isCurrentEducation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LanguageAdapter extends TypeAdapter<Language> {
  @override
  final int typeId = 8;

  @override
  Language read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Language(
      name: fields[0] as String,
      proficiency: fields[1] as LanguageProficiency,
    );
  }

  @override
  void write(BinaryWriter writer, Language obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.proficiency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LanguageProficiencyAdapter extends TypeAdapter<LanguageProficiency> {
  @override
  final int typeId = 9;

  @override
  LanguageProficiency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LanguageProficiency.beginner;
      case 1:
        return LanguageProficiency.intermediate;
      case 2:
        return LanguageProficiency.advanced;
      case 3:
        return LanguageProficiency.native;
      default:
        return LanguageProficiency.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, LanguageProficiency obj) {
    switch (obj) {
      case LanguageProficiency.beginner:
        writer.writeByte(0);
        break;
      case LanguageProficiency.intermediate:
        writer.writeByte(1);
        break;
      case LanguageProficiency.advanced:
        writer.writeByte(2);
        break;
      case LanguageProficiency.native:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageProficiencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
