// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyModelAdapter extends TypeAdapter<CompanyModel> {
  @override
  final int typeId = 17;

  @override
  CompanyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyModel(
      uid: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      description: fields[3] as String?,
      industry: fields[4] as String?,
      size: fields[5] as String?,
      location: fields[6] as String?,
      website: fields[7] as String?,
      phone: fields[8] as String?,
      logoUrl: fields[9] as String?,
      socialLinks: (fields[10] as List?)?.cast<String>(),
      isVerified: fields[11] as bool,
      verificationStatus: fields[12] as VerificationStatus,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.industry)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.website)
      ..writeByte(8)
      ..write(obj.phone)
      ..writeByte(9)
      ..write(obj.logoUrl)
      ..writeByte(10)
      ..write(obj.socialLinks)
      ..writeByte(11)
      ..write(obj.isVerified)
      ..writeByte(12)
      ..write(obj.verificationStatus)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VerificationStatusAdapter extends TypeAdapter<VerificationStatus> {
  @override
  final int typeId = 18;

  @override
  VerificationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VerificationStatus.notVerified;
      case 1:
        return VerificationStatus.pending;
      case 2:
        return VerificationStatus.verified;
      case 3:
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.notVerified;
    }
  }

  @override
  void write(BinaryWriter writer, VerificationStatus obj) {
    switch (obj) {
      case VerificationStatus.notVerified:
        writer.writeByte(0);
        break;
      case VerificationStatus.pending:
        writer.writeByte(1);
        break;
      case VerificationStatus.verified:
        writer.writeByte(2);
        break;
      case VerificationStatus.rejected:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
