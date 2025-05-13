import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'job_model.g.dart';

/// Type ID for JobModel in Hive
const int jobModelTypeId = 2;

/// Model class for job data
@HiveType(typeId: jobModelTypeId)
class JobModel {
  /// Constructor
  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.salary,
    required this.postedDate,
    this.requirements = const [],
    this.responsibilities = const [],
    this.skills = const [],
    this.jobType = 'Full-time',
    this.experience = '0-1 years',
    this.education = "Bachelor's",
    this.industry = 'Automotive',
    this.isRemote = false,
    this.applicationDeadline,
    this.logoUrl,
    this.companyDescription,
    this.benefits = const [],
    this.isActive = true,
  });

  /// Factory constructor from Firestore document
  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return JobModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      company: data['company'] as String? ?? '',
      location: data['location'] as String? ?? '',
      description: data['description'] as String? ?? '',
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
      industry: data['industry'] as String? ?? 'Automotive',
      isRemote: data['isRemote'] as bool? ?? false,
      applicationDeadline:
          (data['applicationDeadline'] as Timestamp?)?.toDate(),
      logoUrl: data['logoUrl'] as String?,
      companyDescription: data['companyDescription'] as String?,
      benefits: List<String>.from(data['benefits'] as List? ?? []),
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  /// Factory constructor from JSON
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      salary: json['salary'] as int,
      postedDate: DateTime.parse(json['postedDate'] as String),
      requirements: List<String>.from(json['requirements'] as List? ?? []),
      responsibilities:
          List<String>.from(json['responsibilities'] as List? ?? []),
      skills: List<String>.from(json['skills'] as List? ?? []),
      jobType: json['jobType'] as String? ?? 'Full-time',
      experience: json['experience'] as String? ?? '0-1 years',
      education: json['education'] as String? ?? "Bachelor's",
      industry: json['industry'] as String? ?? 'Automotive',
      isRemote: json['isRemote'] as bool? ?? false,
      applicationDeadline: json['applicationDeadline'] != null
          ? DateTime.parse(json['applicationDeadline'] as String)
          : null,
      logoUrl: json['logoUrl'] as String?,
      companyDescription: json['companyDescription'] as String?,
      benefits: List<String>.from(json['benefits'] as List? ?? []),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Job ID
  @HiveField(0)
  final String id;

  /// Job title
  @HiveField(1)
  final String title;

  /// Company name
  @HiveField(2)
  final String company;

  /// Job location
  @HiveField(3)
  final String location;

  /// Job description
  @HiveField(4)
  final String description;

  /// Salary amount
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

  /// Company logo URL
  @HiveField(16)
  final String? logoUrl;

  /// Company description
  @HiveField(17)
  final String? companyDescription;

  /// Job benefits
  @HiveField(18)
  final List<String> benefits;

  /// Whether the job is active
  @HiveField(19)
  final bool isActive;

  /// Match percentage for the job based on user profile (0-100)
  /// This is a calculated field, not stored in the database
  int? get matchPercentage {
    // In a real implementation, this would be calculated based on the user's profile
    // For now, we'll return a random value between 60 and 95
    if (_cachedMatchPercentage == null) {
      // Use a deterministic approach based on job ID to ensure consistency
      final hash = id.hashCode.abs();
      _cachedMatchPercentage = 60 + (hash % 36); // Range: 60-95
    }
    return _cachedMatchPercentage;
  }

  // Cache the match percentage to ensure consistency
  int? _cachedMatchPercentage;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'salary': salary,
      'postedDate': postedDate.toIso8601String(),
      'requirements': requirements,
      'responsibilities': responsibilities,
      'skills': skills,
      'jobType': jobType,
      'experience': experience,
      'education': education,
      'industry': industry,
      'isRemote': isRemote,
      'applicationDeadline': applicationDeadline?.toIso8601String(),
      'logoUrl': logoUrl,
      'companyDescription': companyDescription,
      'benefits': benefits,
      'isActive': isActive,
    };
  }

  /// Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'description': description,
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
      'logoUrl': logoUrl,
      'companyDescription': companyDescription,
      'benefits': benefits,
      'isActive': isActive,
    };
  }

  /// Create a copy of this object with the given fields replaced
  JobModel copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? description,
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
    String? logoUrl,
    String? companyDescription,
    List<String>? benefits,
    bool? isActive,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      description: description ?? this.description,
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
      logoUrl: logoUrl ?? this.logoUrl,
      companyDescription: companyDescription ?? this.companyDescription,
      benefits: benefits ?? this.benefits,
      isActive: isActive ?? this.isActive,
    );
  }
}
