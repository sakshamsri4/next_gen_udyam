import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'job_post_model.g.dart';

/// Type ID for Hive
const jobPostModelTypeId = 15;

/// Status of a job posting
@HiveType(typeId: 16)
enum JobStatus {
  /// Job is active and visible to job seekers
  @HiveField(0)
  active,

  /// Job is paused and not visible to job seekers
  @HiveField(1)
  paused,

  /// Job is closed and not visible to job seekers
  @HiveField(2)
  closed,

  /// Job is in draft mode and not visible to job seekers
  @HiveField(3)
  draft,
}

/// Model class for job posting data
@HiveType(typeId: jobPostModelTypeId)
class JobPostModel {
  /// Constructor
  JobPostModel({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.postedDate,
    this.requirements = const [],
    this.responsibilities = const [],
    this.skills = const [],
    this.jobType = 'Full-time',
    this.experience = '0-1 years',
    this.education = "Bachelor's",
    this.industry = 'Technology',
    this.isRemote = false,
    this.applicationDeadline,
    this.status = JobStatus.active,
    this.benefits = const [],
    this.isFeatured = false,
    this.viewCount = 0,
    this.applicationCount = 0,
    this.lastUpdated,
  });

  /// Factory constructor from Firestore document
  factory JobPostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    // Parse job status
    var status = JobStatus.active;
    if (data['status'] != null) {
      final statusStr = data['status'] as String;
      switch (statusStr) {
        case 'active':
          status = JobStatus.active;
        case 'paused':
          status = JobStatus.paused;
        case 'closed':
          status = JobStatus.closed;
        case 'draft':
          status = JobStatus.draft;
      }
    }

    return JobPostModel(
      id: doc.id,
      companyId: data['companyId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      location: data['location'] as String? ?? '',
      salary: data['salary'] as int? ?? 0,
      postedDate:
          (data['postedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      requirements: List<String>.from(data['requirements'] as List? ?? []),
      responsibilities:
          List<String>.from(data['responsibilities'] as List? ?? []),
      skills: List<String>.from(data['skills'] as List? ?? []),
      jobType: data['jobType'] as String? ?? 'Full-time',
      experience: data['experience'] as String? ?? '0-1 years',
      education: data['education'] as String? ?? "Bachelor's",
      industry: data['industry'] as String? ?? 'Technology',
      isRemote: data['isRemote'] as bool? ?? false,
      applicationDeadline:
          (data['applicationDeadline'] as Timestamp?)?.toDate(),
      status: status,
      benefits: List<String>.from(data['benefits'] as List? ?? []),
      isFeatured: data['isFeatured'] as bool? ?? false,
      viewCount: data['viewCount'] as int? ?? 0,
      applicationCount: data['applicationCount'] as int? ?? 0,
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate(),
    );
  }

  /// Job ID
  @HiveField(0)
  final String id;

  /// Company ID
  @HiveField(1)
  final String companyId;

  /// Job title
  @HiveField(2)
  final String title;

  /// Job description
  @HiveField(3)
  final String description;

  /// Job location
  @HiveField(4)
  final String location;

  /// Job salary
  @HiveField(5)
  final int salary;

  /// Date when the job was posted
  @HiveField(6)
  final DateTime postedDate;

  /// Job requirements
  @HiveField(7)
  final List<String> requirements;

  /// Job responsibilities
  @HiveField(8)
  final List<String> responsibilities;

  /// Required skills
  @HiveField(9)
  final List<String> skills;

  /// Job type (Full-time, Part-time, Contract, etc.)
  @HiveField(10)
  final String jobType;

  /// Required experience
  @HiveField(11)
  final String experience;

  /// Required education
  @HiveField(12)
  final String education;

  /// Industry
  @HiveField(13)
  final String industry;

  /// Whether the job is remote
  @HiveField(14)
  final bool isRemote;

  /// Application deadline
  @HiveField(15)
  final DateTime? applicationDeadline;

  /// Job status
  @HiveField(16)
  final JobStatus status;

  /// Job benefits
  @HiveField(17)
  final List<String> benefits;

  /// Whether the job is featured
  @HiveField(18)
  final bool isFeatured;

  /// Number of views
  @HiveField(19)
  final int viewCount;

  /// Number of applications
  @HiveField(20)
  final int applicationCount;

  /// Last updated date
  @HiveField(21)
  final DateTime? lastUpdated;

  /// Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'companyId': companyId,
      'title': title,
      'description': description,
      'location': location,
      'salary': salary,
      'postedDate': Timestamp.fromDate(postedDate),
      'requirements': requirements,
      'responsibilities': responsibilities,
      'skills': skills,
      'jobType': jobType,
      'experience': experience,
      'education': education,
      'industry': industry,
      'isRemote': isRemote,
      'applicationDeadline': applicationDeadline != null
          ? Timestamp.fromDate(applicationDeadline!)
          : null,
      'status': status.toString().split('.').last,
      'benefits': benefits,
      'isFeatured': isFeatured,
      'viewCount': viewCount,
      'applicationCount': applicationCount,
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
    };
  }

  /// Create a copy of this model with the given fields replaced
  JobPostModel copyWith({
    String? id,
    String? companyId,
    String? title,
    String? description,
    String? location,
    int? salary,
    DateTime? postedDate,
    List<String>? requirements,
    List<String>? responsibilities,
    List<String>? skills,
    String? jobType,
    String? experience,
    String? education,
    String? industry,
    bool? isRemote,
    DateTime? applicationDeadline,
    JobStatus? status,
    List<String>? benefits,
    bool? isFeatured,
    int? viewCount,
    int? applicationCount,
    DateTime? lastUpdated,
  }) {
    return JobPostModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      postedDate: postedDate ?? this.postedDate,
      requirements: requirements ?? this.requirements,
      responsibilities: responsibilities ?? this.responsibilities,
      skills: skills ?? this.skills,
      jobType: jobType ?? this.jobType,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      industry: industry ?? this.industry,
      isRemote: isRemote ?? this.isRemote,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      status: status ?? this.status,
      benefits: benefits ?? this.benefits,
      isFeatured: isFeatured ?? this.isFeatured,
      viewCount: viewCount ?? this.viewCount,
      applicationCount: applicationCount ?? this.applicationCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
