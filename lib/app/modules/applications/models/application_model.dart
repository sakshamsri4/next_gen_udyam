import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'application_model.g.dart';

/// Type ID for Hive
const applicationModelTypeId = 10;

/// Status of a job application
enum ApplicationStatus {
  /// Application has been submitted but not reviewed
  pending,

  /// Application has been reviewed
  reviewed,

  /// Applicant has been shortlisted
  shortlisted,

  /// Applicant has been invited for interview
  interview,

  /// Applicant has been offered the job
  offered,

  /// Applicant has been hired
  hired,

  /// Application has been rejected
  rejected,
}

/// Model class for job application data
@HiveType(typeId: applicationModelTypeId)
class ApplicationModel {
  /// Constructor
  ApplicationModel({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.jobTitle,
    required this.company,
    required this.appliedAt,
    this.status = ApplicationStatus.pending,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.coverLetter = '',
    this.resumeUrl,
    this.lastUpdated,
    this.feedback,
    this.interviewDate,
  });

  /// Factory constructor from Firestore document
  factory ApplicationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    // Parse status from string
    final statusStr = data['status'] as String? ?? 'pending';
    final status = ApplicationStatus.values.firstWhere(
      (e) => e.toString().split('.').last == statusStr,
      orElse: () => ApplicationStatus.pending,
    );

    // Parse timestamps
    final appliedAtTimestamp = data['appliedAt'] as Timestamp?;
    final lastUpdatedTimestamp = data['lastUpdated'] as Timestamp?;
    final interviewDateTimestamp = data['interviewDate'] as Timestamp?;

    return ApplicationModel(
      id: doc.id,
      userId: data['userId'] as String,
      jobId: data['jobId'] as String,
      jobTitle: data['jobTitle'] as String? ?? 'Unknown Job',
      company: data['company'] as String? ?? 'Unknown Company',
      appliedAt: appliedAtTimestamp?.toDate() ?? DateTime.now(),
      status: status,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      coverLetter: data['coverLetter'] as String? ?? '',
      resumeUrl: data['resumeUrl'] as String?,
      lastUpdated: lastUpdatedTimestamp?.toDate(),
      feedback: data['feedback'] as String?,
      interviewDate: interviewDateTimestamp?.toDate(),
    );
  }

  /// Application ID
  @HiveField(0)
  final String id;

  /// User ID
  @HiveField(1)
  final String userId;

  /// Job ID
  @HiveField(2)
  final String jobId;

  /// Job title
  @HiveField(3)
  final String jobTitle;

  /// Company name
  @HiveField(4)
  final String company;

  /// Date when the application was submitted
  @HiveField(5)
  final DateTime appliedAt;

  /// Application status
  @HiveField(6)
  final ApplicationStatus status;

  /// Applicant name
  @HiveField(7)
  final String name;

  /// Applicant email
  @HiveField(8)
  final String email;

  /// Applicant phone
  @HiveField(9)
  final String phone;

  /// Cover letter
  @HiveField(10)
  final String coverLetter;

  /// Resume URL
  @HiveField(11)
  final String? resumeUrl;

  /// Last updated date
  @HiveField(12)
  final DateTime? lastUpdated;

  /// Feedback from employer
  @HiveField(13)
  final String? feedback;

  /// Interview date if scheduled
  @HiveField(14)
  final DateTime? interviewDate;

  /// Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'company': company,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'status': status.toString().split('.').last,
      'name': name,
      'email': email,
      'phone': phone,
      'coverLetter': coverLetter,
      'resumeUrl': resumeUrl,
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
      'feedback': feedback,
      'interviewDate':
          interviewDate != null ? Timestamp.fromDate(interviewDate!) : null,
    };
  }

  /// Create a copy of this model with the given fields replaced
  ApplicationModel copyWith({
    String? id,
    String? userId,
    String? jobId,
    String? jobTitle,
    String? company,
    DateTime? appliedAt,
    ApplicationStatus? status,
    String? name,
    String? email,
    String? phone,
    String? coverLetter,
    String? resumeUrl,
    DateTime? lastUpdated,
    String? feedback,
    DateTime? interviewDate,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      coverLetter: coverLetter ?? this.coverLetter,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      feedback: feedback ?? this.feedback,
      interviewDate: interviewDate ?? this.interviewDate,
    );
  }
}
