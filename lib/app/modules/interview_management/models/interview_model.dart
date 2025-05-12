import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

// We're using custom adapters defined in hive_adapters.dart instead of generated ones
// part 'interview_model.g.dart';

/// Type ID for InterviewModel Hive adapter
const interviewModelTypeId = 60;

/// Status of an interview
enum InterviewStatus {
  /// Scheduled but not yet confirmed
  scheduled,

  /// Confirmed by the candidate
  confirmed,

  /// Completed
  completed,

  /// Canceled
  canceled,

  /// Rescheduled
  rescheduled,
}

/// Type of interview
enum InterviewType {
  /// Phone screening
  phone,

  /// Video interview
  video,

  /// In-person interview
  inPerson,

  /// Technical assessment
  technical,

  /// Cultural fit assessment
  cultural,
}

/// Model for interview data
@HiveType(typeId: interviewModelTypeId)
class InterviewModel {
  /// Constructor
  InterviewModel({
    required this.id,
    required this.applicationId,
    required this.jobId,
    required this.candidateId,
    required this.candidateName,
    required this.jobTitle,
    required this.scheduledDate,
    required this.duration,
    required this.status,
    required this.type,
    this.notes,
    this.feedback,
    this.interviewerIds = const [],
    this.interviewerNames = const [],
    this.location,
    this.videoLink,
    this.phoneNumber,
    this.preparationResources = const [],
    this.questions = const [],
    this.candidateResponse,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from Firestore document
  factory InterviewModel.fromFirestore(Map<String, dynamic> data) {
    return InterviewModel(
      id: data['id'] as String,
      applicationId: data['applicationId'] as String,
      jobId: data['jobId'] as String,
      candidateId: data['candidateId'] as String,
      candidateName: data['candidateName'] as String,
      jobTitle: data['jobTitle'] as String,
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
      duration: data['duration'] as int,
      status: _parseInterviewStatus(data['status'] as String),
      type: _parseInterviewType(data['type'] as String),
      notes: data['notes'] as String?,
      feedback: data['feedback'] as String?,
      interviewerIds: List<String>.from(data['interviewerIds'] as List? ?? []),
      interviewerNames:
          List<String>.from(data['interviewerNames'] as List? ?? []),
      location: data['location'] as String?,
      videoLink: data['videoLink'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      preparationResources:
          List<String>.from(data['preparationResources'] as List? ?? []),
      questions: List<String>.from(data['questions'] as List? ?? []),
      candidateResponse: data['candidateResponse'] as String?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Unique identifier
  @HiveField(0)
  final String id;

  /// Application ID
  @HiveField(1)
  final String applicationId;

  /// Job ID
  @HiveField(2)
  final String jobId;

  /// Candidate ID
  @HiveField(3)
  final String candidateId;

  /// Candidate name
  @HiveField(4)
  final String candidateName;

  /// Job title
  @HiveField(5)
  final String jobTitle;

  /// Scheduled date and time
  @HiveField(6)
  final DateTime scheduledDate;

  /// Duration in minutes
  @HiveField(7)
  final int duration;

  /// Status of the interview
  @HiveField(8)
  final InterviewStatus status;

  /// Type of interview
  @HiveField(9)
  final InterviewType type;

  /// Notes about the interview
  @HiveField(10)
  final String? notes;

  /// Feedback after the interview
  @HiveField(11)
  final String? feedback;

  /// IDs of interviewers
  @HiveField(12)
  final List<String> interviewerIds;

  /// Names of interviewers
  @HiveField(13)
  final List<String> interviewerNames;

  /// Location for in-person interviews
  @HiveField(14)
  final String? location;

  /// Video link for video interviews
  @HiveField(15)
  final String? videoLink;

  /// Phone number for phone interviews
  @HiveField(16)
  final String? phoneNumber;

  /// Preparation resources for the candidate
  @HiveField(17)
  final List<String> preparationResources;

  /// Interview questions
  @HiveField(18)
  final List<String> questions;

  /// Candidate response to the interview invitation
  @HiveField(19)
  final String? candidateResponse;

  /// Created at timestamp
  @HiveField(20)
  final DateTime? createdAt;

  /// Updated at timestamp
  @HiveField(21)
  final DateTime? updatedAt;

  /// Create a copy with updated fields
  InterviewModel copyWith({
    String? id,
    String? applicationId,
    String? jobId,
    String? candidateId,
    String? candidateName,
    String? jobTitle,
    DateTime? scheduledDate,
    int? duration,
    InterviewStatus? status,
    InterviewType? type,
    String? notes,
    String? feedback,
    List<String>? interviewerIds,
    List<String>? interviewerNames,
    String? location,
    String? videoLink,
    String? phoneNumber,
    List<String>? preparationResources,
    List<String>? questions,
    String? candidateResponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InterviewModel(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      jobId: jobId ?? this.jobId,
      candidateId: candidateId ?? this.candidateId,
      candidateName: candidateName ?? this.candidateName,
      jobTitle: jobTitle ?? this.jobTitle,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      feedback: feedback ?? this.feedback,
      interviewerIds: interviewerIds ?? this.interviewerIds,
      interviewerNames: interviewerNames ?? this.interviewerNames,
      location: location ?? this.location,
      videoLink: videoLink ?? this.videoLink,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preparationResources: preparationResources ?? this.preparationResources,
      questions: questions ?? this.questions,
      candidateResponse: candidateResponse ?? this.candidateResponse,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'applicationId': applicationId,
      'jobId': jobId,
      'candidateId': candidateId,
      'candidateName': candidateName,
      'jobTitle': jobTitle,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'duration': duration,
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'notes': notes,
      'feedback': feedback,
      'interviewerIds': interviewerIds,
      'interviewerNames': interviewerNames,
      'location': location,
      'videoLink': videoLink,
      'phoneNumber': phoneNumber,
      'preparationResources': preparationResources,
      'questions': questions,
      'candidateResponse': candidateResponse,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Parse interview status from string
  static InterviewStatus _parseInterviewStatus(String status) {
    switch (status) {
      case 'scheduled':
        return InterviewStatus.scheduled;
      case 'confirmed':
        return InterviewStatus.confirmed;
      case 'completed':
        return InterviewStatus.completed;
      case 'canceled':
        return InterviewStatus.canceled;
      case 'rescheduled':
        return InterviewStatus.rescheduled;
      default:
        return InterviewStatus.scheduled;
    }
  }

  /// Parse interview type from string
  static InterviewType _parseInterviewType(String type) {
    switch (type) {
      case 'phone':
        return InterviewType.phone;
      case 'video':
        return InterviewType.video;
      case 'inPerson':
        return InterviewType.inPerson;
      case 'technical':
        return InterviewType.technical;
      case 'cultural':
        return InterviewType.cultural;
      default:
        return InterviewType.phone;
    }
  }
}
