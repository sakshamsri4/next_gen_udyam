import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';

// We're using custom adapters defined in hive_adapters.dart instead of generated ones
// part 'applicant_filter_model.g.dart';

/// Type ID for Hive
const applicantFilterModelTypeId = 20;

/// Sort options for applicant results
@HiveType(typeId: 21)
enum ApplicantSortOption {
  /// Sort by application date
  @HiveField(0)
  applicationDate,

  /// Sort by name
  @HiveField(1)
  name,

  /// Sort by status
  @HiveField(2)
  status,

  /// Sort by match score
  @HiveField(3)
  matchScore,
}

/// Sort order for applicant results
@HiveType(typeId: 22)
enum ApplicantSortOrder {
  /// Sort in ascending order
  @HiveField(0)
  ascending,

  /// Sort in descending order
  @HiveField(1)
  descending,
}

/// Model class for applicant filters
@HiveType(typeId: applicantFilterModelTypeId)
class ApplicantFilterModel {
  /// Constructor
  ApplicantFilterModel({
    this.jobId = '',
    this.name = '',
    this.skills = const [],
    this.experience = const [],
    this.education = const [],
    this.statuses = const [],
    this.applicationDateStart,
    this.applicationDateEnd,
    this.hasResume = false,
    this.hasCoverLetter = false,
    this.sortBy = ApplicantSortOption.applicationDate,
    this.sortOrder = ApplicantSortOrder.descending,
    this.page = 1,
    this.limit = 10,
  });

  /// Job ID to filter by
  @HiveField(0)
  final String jobId;

  /// Applicant name to filter by
  @HiveField(1)
  final String name;

  /// Skills to filter by
  @HiveField(2)
  final List<String> skills;

  /// Experience levels to filter by
  @HiveField(3)
  final List<String> experience;

  /// Education levels to filter by
  @HiveField(4)
  final List<String> education;

  /// Application statuses to filter by
  @HiveField(5)
  final List<ApplicationStatus> statuses;

  /// Application date start range
  @HiveField(6)
  final DateTime? applicationDateStart;

  /// Application date end range
  @HiveField(7)
  final DateTime? applicationDateEnd;

  /// Whether to filter for applicants with resumes
  @HiveField(8)
  final bool hasResume;

  /// Whether to filter for applicants with cover letters
  @HiveField(9)
  final bool hasCoverLetter;

  /// Sort option
  @HiveField(10)
  final ApplicantSortOption sortBy;

  /// Sort order
  @HiveField(11)
  final ApplicantSortOrder sortOrder;

  /// Page number for pagination
  @HiveField(12)
  final int page;

  /// Number of results per page
  @HiveField(13)
  final int limit;

  /// Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'jobId': jobId,
      'name': name,
      'skills': skills,
      'experience': experience,
      'education': education,
      'statuses': statuses.map((s) => s.toString().split('.').last).toList(),
      'applicationDateStart': applicationDateStart != null
          ? Timestamp.fromDate(applicationDateStart!)
          : null,
      'applicationDateEnd': applicationDateEnd != null
          ? Timestamp.fromDate(applicationDateEnd!)
          : null,
      'hasResume': hasResume,
      'hasCoverLetter': hasCoverLetter,
      'sortBy': sortBy.toString().split('.').last,
      'sortOrder': sortOrder.toString().split('.').last,
      'page': page,
      'limit': limit,
    };
  }

  /// Create a copy of this model with the given fields replaced
  ApplicantFilterModel copyWith({
    String? jobId,
    String? name,
    List<String>? skills,
    List<String>? experience,
    List<String>? education,
    List<ApplicationStatus>? statuses,
    DateTime? applicationDateStart,
    DateTime? applicationDateEnd,
    bool? hasResume,
    bool? hasCoverLetter,
    ApplicantSortOption? sortBy,
    ApplicantSortOrder? sortOrder,
    int? page,
    int? limit,
  }) {
    return ApplicantFilterModel(
      jobId: jobId ?? this.jobId,
      name: name ?? this.name,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      statuses: statuses ?? this.statuses,
      applicationDateStart: applicationDateStart ?? this.applicationDateStart,
      applicationDateEnd: applicationDateEnd ?? this.applicationDateEnd,
      hasResume: hasResume ?? this.hasResume,
      hasCoverLetter: hasCoverLetter ?? this.hasCoverLetter,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  /// Check if the filter is empty
  bool get isEmpty {
    return jobId.isEmpty &&
        name.isEmpty &&
        skills.isEmpty &&
        experience.isEmpty &&
        education.isEmpty &&
        statuses.isEmpty &&
        applicationDateStart == null &&
        applicationDateEnd == null &&
        !hasResume &&
        !hasCoverLetter;
  }

  /// Check if the filter is not empty
  bool get isNotEmpty => !isEmpty;
}
