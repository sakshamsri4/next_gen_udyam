import 'package:hive/hive.dart';

// We're using custom adapters defined in hive_adapters.dart instead of generated ones
// part 'analytics_data_model.g.dart';

/// Type ID for AnalyticsDataModel Hive adapter
const analyticsDataModelTypeId = 50;

/// Model for analytics data
@HiveType(typeId: analyticsDataModelTypeId)
class AnalyticsDataModel {
  /// Constructor
  AnalyticsDataModel({
    required this.id,
    required this.period,
    required this.jobViews,
    required this.applications,
    required this.interviews,
    required this.offers,
    required this.hires,
    required this.conversionRates,
    required this.topPerformingJobs,
    required this.applicantSources,
    required this.timestamp,
  });

  /// Create from Firestore document
  factory AnalyticsDataModel.fromFirestore(Map<String, dynamic> data) {
    return AnalyticsDataModel(
      id: data['id'] as String,
      period: data['period'] as String,
      jobViews: Map<String, int>.from(data['jobViews'] as Map),
      applications: Map<String, int>.from(data['applications'] as Map),
      interviews: Map<String, int>.from(data['interviews'] as Map),
      offers: Map<String, int>.from(data['offers'] as Map),
      hires: Map<String, int>.from(data['hires'] as Map),
      conversionRates: Map<String, double>.from(data['conversionRates'] as Map),
      topPerformingJobs: (data['topPerformingJobs'] as List)
          .map((job) => TopPerformingJob.fromMap(job as Map<String, dynamic>))
          .toList(),
      applicantSources: Map<String, int>.from(data['applicantSources'] as Map),
      timestamp: data['timestamp'] as DateTime,
    );
  }

  /// Create mock data for testing
  factory AnalyticsDataModel.mock() {
    return AnalyticsDataModel(
      id: 'mock-analytics-1',
      period: 'monthly',
      jobViews: {
        'Jan': 120,
        'Feb': 150,
        'Mar': 180,
        'Apr': 210,
        'May': 250,
        'Jun': 200,
      },
      applications: {
        'Jan': 25,
        'Feb': 30,
        'Mar': 40,
        'Apr': 45,
        'May': 55,
        'Jun': 50,
      },
      interviews: {
        'Jan': 10,
        'Feb': 15,
        'Mar': 20,
        'Apr': 25,
        'May': 30,
        'Jun': 28,
      },
      offers: {
        'Jan': 5,
        'Feb': 8,
        'Mar': 10,
        'Apr': 12,
        'May': 15,
        'Jun': 14,
      },
      hires: {
        'Jan': 3,
        'Feb': 5,
        'Mar': 7,
        'Apr': 8,
        'May': 10,
        'Jun': 9,
      },
      conversionRates: {
        'view_to_apply': 22.5,
        'apply_to_interview': 50.0,
        'interview_to_offer': 48.0,
        'offer_to_hire': 66.7,
        'overall': 4.0,
      },
      topPerformingJobs: [
        TopPerformingJob(
          jobId: 'job-1',
          jobTitle: 'Senior Flutter Developer',
          views: 450,
          applications: 85,
          conversionRate: 18.9,
        ),
        TopPerformingJob(
          jobId: 'job-2',
          jobTitle: 'UX Designer',
          views: 380,
          applications: 65,
          conversionRate: 17.1,
        ),
        TopPerformingJob(
          jobId: 'job-3',
          jobTitle: 'Product Manager',
          views: 320,
          applications: 50,
          conversionRate: 15.6,
        ),
      ],
      applicantSources: {
        'Direct': 120,
        'LinkedIn': 80,
        'Indeed': 65,
        'Referral': 40,
        'Other': 25,
      },
      timestamp: DateTime.now(),
    );
  }

  /// Unique identifier
  @HiveField(0)
  final String id;

  /// Time period (daily, weekly, monthly)
  @HiveField(1)
  final String period;

  /// Job view data
  @HiveField(2)
  final Map<String, int> jobViews;

  /// Application data
  @HiveField(3)
  final Map<String, int> applications;

  /// Interview data
  @HiveField(4)
  final Map<String, int> interviews;

  /// Offer data
  @HiveField(5)
  final Map<String, int> offers;

  /// Hire data
  @HiveField(6)
  final Map<String, int> hires;

  /// Conversion rates
  @HiveField(7)
  final Map<String, double> conversionRates;

  /// Top performing jobs
  @HiveField(8)
  final List<TopPerformingJob> topPerformingJobs;

  /// Applicant sources
  @HiveField(9)
  final Map<String, int> applicantSources;

  /// Timestamp
  @HiveField(10)
  final DateTime timestamp;

  /// Create a copy with updated fields
  AnalyticsDataModel copyWith({
    String? id,
    String? period,
    Map<String, int>? jobViews,
    Map<String, int>? applications,
    Map<String, int>? interviews,
    Map<String, int>? offers,
    Map<String, int>? hires,
    Map<String, double>? conversionRates,
    List<TopPerformingJob>? topPerformingJobs,
    Map<String, int>? applicantSources,
    DateTime? timestamp,
  }) {
    return AnalyticsDataModel(
      id: id ?? this.id,
      period: period ?? this.period,
      jobViews: jobViews ?? this.jobViews,
      applications: applications ?? this.applications,
      interviews: interviews ?? this.interviews,
      offers: offers ?? this.offers,
      hires: hires ?? this.hires,
      conversionRates: conversionRates ?? this.conversionRates,
      topPerformingJobs: topPerformingJobs ?? this.topPerformingJobs,
      applicantSources: applicantSources ?? this.applicantSources,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'period': period,
      'jobViews': jobViews,
      'applications': applications,
      'interviews': interviews,
      'offers': offers,
      'hires': hires,
      'conversionRates': conversionRates,
      'topPerformingJobs': topPerformingJobs.map((job) => job.toMap()).toList(),
      'applicantSources': applicantSources,
      'timestamp': timestamp,
    };
  }
}

/// Model for top performing jobs
@HiveType(typeId: 51)
class TopPerformingJob {
  /// Constructor
  TopPerformingJob({
    required this.jobId,
    required this.jobTitle,
    required this.views,
    required this.applications,
    required this.conversionRate,
  });

  /// Create from Map
  factory TopPerformingJob.fromMap(Map<String, dynamic> map) {
    return TopPerformingJob(
      jobId: map['jobId'] as String,
      jobTitle: map['jobTitle'] as String,
      views: map['views'] as int,
      applications: map['applications'] as int,
      conversionRate: map['conversionRate'] as double,
    );
  }

  /// Job ID
  @HiveField(0)
  final String jobId;

  /// Job title
  @HiveField(1)
  final String jobTitle;

  /// Number of views
  @HiveField(2)
  final int views;

  /// Number of applications
  @HiveField(3)
  final int applications;

  /// Conversion rate (applications / views * 100)
  @HiveField(4)
  final double conversionRate;

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'jobTitle': jobTitle,
      'views': views,
      'applications': applications,
      'conversionRate': conversionRate,
    };
  }
}
