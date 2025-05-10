// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchFilterAdapter extends TypeAdapter<SearchFilter> {
  @override
  final int typeId = 4;

  @override
  SearchFilter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchFilter(
      query: fields[0] as String,
      location: fields[1] as String,
      minSalary: fields[2] as int,
      maxSalary: fields[3] as int,
      jobTypes: (fields[4] as List).cast<String>(),
      experience: (fields[5] as List).cast<String>(),
      education: (fields[6] as List).cast<String>(),
      skills: (fields[7] as List).cast<String>(),
      industries: (fields[8] as List).cast<String>(),
      isRemote: fields[9] as bool,
      sortBy: fields[10] as SortOption,
      sortOrder: fields[11] as SortOrder,
    );
  }

  @override
  void write(BinaryWriter writer, SearchFilter obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.minSalary)
      ..writeByte(3)
      ..write(obj.maxSalary)
      ..writeByte(4)
      ..write(obj.jobTypes)
      ..writeByte(5)
      ..write(obj.experience)
      ..writeByte(6)
      ..write(obj.education)
      ..writeByte(7)
      ..write(obj.skills)
      ..writeByte(8)
      ..write(obj.industries)
      ..writeByte(9)
      ..write(obj.isRemote)
      ..writeByte(10)
      ..write(obj.sortBy)
      ..writeByte(11)
      ..write(obj.sortOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortOptionAdapter extends TypeAdapter<SortOption> {
  @override
  final int typeId = 5;

  @override
  SortOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortOption.relevance;
      case 1:
        return SortOption.date;
      case 2:
        return SortOption.salary;
      case 3:
        return SortOption.company;
      case 4:
        return SortOption.location;
      default:
        return SortOption.relevance;
    }
  }

  @override
  void write(BinaryWriter writer, SortOption obj) {
    switch (obj) {
      case SortOption.relevance:
        writer.writeByte(0);
        break;
      case SortOption.date:
        writer.writeByte(1);
        break;
      case SortOption.salary:
        writer.writeByte(2);
        break;
      case SortOption.company:
        writer.writeByte(3);
        break;
      case SortOption.location:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortOrderAdapter extends TypeAdapter<SortOrder> {
  @override
  final int typeId = 6;

  @override
  SortOrder read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortOrder.ascending;
      case 1:
        return SortOrder.descending;
      default:
        return SortOrder.ascending;
    }
  }

  @override
  void write(BinaryWriter writer, SortOrder obj) {
    switch (obj) {
      case SortOrder.ascending:
        writer.writeByte(0);
        break;
      case SortOrder.descending:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
