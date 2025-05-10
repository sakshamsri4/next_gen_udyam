// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyProfileModelAdapter extends TypeAdapter<CompanyProfileModel> {
  @override
  final int typeId = 10;

  @override
  CompanyProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyProfileModel(
      uid: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      logoURL: fields[3] as String?,
      website: fields[4] as String?,
      description: fields[5] as String?,
      industry: fields[6] as String?,
      location: fields[7] as String?,
      size: fields[8] as String?,
      founded: fields[9] as int?,
      socialLinks: (fields[10] as Map).cast<String, String>(),
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyProfileModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.logoURL)
      ..writeByte(4)
      ..write(obj.website)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.industry)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.size)
      ..writeByte(9)
      ..write(obj.founded)
      ..writeByte(10)
      ..write(obj.socialLinks)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
