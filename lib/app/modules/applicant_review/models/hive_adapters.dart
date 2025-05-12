import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/applicant_review/models/applicant_comparison_model.dart';
import 'package:next_gen/app/modules/applicant_review/models/applicant_filter_model.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';

/// Adapter for ApplicantFilterModel
class ApplicantFilterModelAdapter extends TypeAdapter<ApplicantFilterModel> {
  @override
  final int typeId = 20;

  @override
  ApplicantFilterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicantFilterModel(
      jobId: fields[0] as String,
      name: fields[1] as String,
      skills: (fields[2] as List).cast<String>(),
      experience: (fields[3] as List).cast<String>(),
      education: (fields[4] as List).cast<String>(),
      statuses: (fields[5] as List).cast<ApplicationStatus>(),
      applicationDateStart: fields[6] as DateTime?,
      applicationDateEnd: fields[7] as DateTime?,
      hasResume: fields[8] as bool,
      hasCoverLetter: fields[9] as bool,
      sortBy: fields[10] as ApplicantSortOption,
      sortOrder: fields[11] as ApplicantSortOrder,
      page: fields[12] as int,
      limit: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicantFilterModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.jobId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.skills)
      ..writeByte(3)
      ..write(obj.experience)
      ..writeByte(4)
      ..write(obj.education)
      ..writeByte(5)
      ..write(obj.statuses)
      ..writeByte(6)
      ..write(obj.applicationDateStart)
      ..writeByte(7)
      ..write(obj.applicationDateEnd)
      ..writeByte(8)
      ..write(obj.hasResume)
      ..writeByte(9)
      ..write(obj.hasCoverLetter)
      ..writeByte(10)
      ..write(obj.sortBy)
      ..writeByte(11)
      ..write(obj.sortOrder)
      ..writeByte(12)
      ..write(obj.page)
      ..writeByte(13)
      ..write(obj.limit);
  }
}

/// Adapter for ApplicantSortOption
class ApplicantSortOptionAdapter extends TypeAdapter<ApplicantSortOption> {
  @override
  final int typeId = 21;

  @override
  ApplicantSortOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplicantSortOption.applicationDate;
      case 1:
        return ApplicantSortOption.name;
      case 2:
        return ApplicantSortOption.status;
      case 3:
        return ApplicantSortOption.matchScore;
      default:
        return ApplicantSortOption.applicationDate;
    }
  }

  @override
  void write(BinaryWriter writer, ApplicantSortOption obj) {
    switch (obj) {
      case ApplicantSortOption.applicationDate:
        writer.writeByte(0);
      case ApplicantSortOption.name:
        writer.writeByte(1);
      case ApplicantSortOption.status:
        writer.writeByte(2);
      case ApplicantSortOption.matchScore:
        writer.writeByte(3);
    }
  }
}

/// Adapter for ApplicantSortOrder
class ApplicantSortOrderAdapter extends TypeAdapter<ApplicantSortOrder> {
  @override
  final int typeId = 22;

  @override
  ApplicantSortOrder read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplicantSortOrder.ascending;
      case 1:
        return ApplicantSortOrder.descending;
      default:
        return ApplicantSortOrder.ascending;
    }
  }

  @override
  void write(BinaryWriter writer, ApplicantSortOrder obj) {
    switch (obj) {
      case ApplicantSortOrder.ascending:
        writer.writeByte(0);
      case ApplicantSortOrder.descending:
        writer.writeByte(1);
    }
  }
}

/// Adapter for ApplicantComparisonModel
class ApplicantComparisonModelAdapter
    extends TypeAdapter<ApplicantComparisonModel> {
  @override
  final int typeId = 23;

  @override
  ApplicantComparisonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicantComparisonModel(
      id: fields[0] as String,
      jobId: fields[1] as String,
      applicantIds: (fields[2] as List).cast<String>(),
      createdAt: fields[3] as DateTime,
      notes: fields[4] as String,
      ratings: (fields[5] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ApplicantComparisonModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.applicantIds)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.ratings);
  }
}

/// Register Hive adapters for applicant review models
void registerApplicantReviewHiveAdapters() {
  // Register ApplicantFilterModel adapter
  if (!Hive.isAdapterRegistered(applicantFilterModelTypeId)) {
    Hive.registerAdapter<ApplicantFilterModel>(ApplicantFilterModelAdapter());
  }

  // Register ApplicantSortOption adapter
  if (!Hive.isAdapterRegistered(21)) {
    Hive.registerAdapter<ApplicantSortOption>(ApplicantSortOptionAdapter());
  }

  // Register ApplicantSortOrder adapter
  if (!Hive.isAdapterRegistered(22)) {
    Hive.registerAdapter<ApplicantSortOrder>(ApplicantSortOrderAdapter());
  }

  // Register ApplicantComparisonModel adapter
  if (!Hive.isAdapterRegistered(applicantComparisonModelTypeId)) {
    Hive.registerAdapter<ApplicantComparisonModel>(
      ApplicantComparisonModelAdapter(),
    );
  }

  // Register ApplicationStatus adapter if not already registered
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter<ApplicationStatus>(ApplicationStatusAdapter());
  }
}
