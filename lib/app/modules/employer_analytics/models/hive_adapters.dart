import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/employer_analytics/models/analytics_data_model.dart';

/// Register Hive adapters for analytics models
void registerAnalyticsHiveAdapters() {
  // Register AnalyticsDataModel adapter
  if (!Hive.isAdapterRegistered(analyticsDataModelTypeId)) {
    Hive.registerAdapter<AnalyticsDataModel>(AnalyticsDataModelAdapter());
  }

  // Register TopPerformingJob adapter
  if (!Hive.isAdapterRegistered(51)) {
    Hive.registerAdapter<TopPerformingJob>(TopPerformingJobAdapter());
  }
}

/// Adapter for AnalyticsDataModel
class AnalyticsDataModelAdapter extends TypeAdapter<AnalyticsDataModel> {
  @override
  final int typeId = analyticsDataModelTypeId;

  @override
  AnalyticsDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsDataModel(
      id: fields[0] as String,
      period: fields[1] as String,
      jobViews: (fields[2] as Map).cast<String, int>(),
      applications: (fields[3] as Map).cast<String, int>(),
      interviews: (fields[4] as Map).cast<String, int>(),
      offers: (fields[5] as Map).cast<String, int>(),
      hires: (fields[6] as Map).cast<String, int>(),
      conversionRates: (fields[7] as Map).cast<String, double>(),
      topPerformingJobs: (fields[8] as List).cast<TopPerformingJob>(),
      applicantSources: (fields[9] as Map).cast<String, int>(),
      timestamp: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsDataModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.period)
      ..writeByte(2)
      ..write(obj.jobViews)
      ..writeByte(3)
      ..write(obj.applications)
      ..writeByte(4)
      ..write(obj.interviews)
      ..writeByte(5)
      ..write(obj.offers)
      ..writeByte(6)
      ..write(obj.hires)
      ..writeByte(7)
      ..write(obj.conversionRates)
      ..writeByte(8)
      ..write(obj.topPerformingJobs)
      ..writeByte(9)
      ..write(obj.applicantSources)
      ..writeByte(10)
      ..write(obj.timestamp);
  }
}

/// Adapter for TopPerformingJob
class TopPerformingJobAdapter extends TypeAdapter<TopPerformingJob> {
  @override
  final int typeId = 51;

  @override
  TopPerformingJob read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopPerformingJob(
      jobId: fields[0] as String,
      jobTitle: fields[1] as String,
      views: fields[2] as int,
      applications: fields[3] as int,
      conversionRate: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TopPerformingJob obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.jobId)
      ..writeByte(1)
      ..write(obj.jobTitle)
      ..writeByte(2)
      ..write(obj.views)
      ..writeByte(3)
      ..write(obj.applications)
      ..writeByte(4)
      ..write(obj.conversionRate);
  }
}
