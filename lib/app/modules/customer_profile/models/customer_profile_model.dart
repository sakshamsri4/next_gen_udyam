import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'customer_profile_model.g.dart';

/// A model representing a customer profile
@HiveType(typeId: 5)
class CustomerProfileModel {
  /// Creates a new customer profile model
  CustomerProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoURL,
    this.jobTitle,
    this.description,
    this.workExperience = const [],
    this.education = const [],
    this.skills = const [],
    this.languages = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Create a model from a map
  factory CustomerProfileModel.fromMap(Map<String, dynamic> map) {
    return CustomerProfileModel(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      photoURL: map['photoURL']?.toString(),
      jobTitle: map['jobTitle']?.toString(),
      description: map['description']?.toString(),
      workExperience: (map['workExperience'] is List)
          ? List<WorkExperience>.from(
              (map['workExperience'] as List).map(
                (x) => WorkExperience.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      education: (map['education'] is List)
          ? List<Education>.from(
              (map['education'] as List)
                  .map((x) => Education.fromMap(x as Map<String, dynamic>)),
            )
          : [],
      skills: (map['skills'] is List)
          ? List<String>.from(
              (map['skills'] as List).map((x) => x?.toString() ?? ''),
            )
          : [],
      languages: (map['languages'] is List)
          ? List<Language>.from(
              (map['languages'] as List)
                  .map((x) => Language.fromMap(x as Map<String, dynamic>)),
            )
          : [],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  /// Create a model from a Firestore document
  factory CustomerProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return CustomerProfileModel(
        uid: doc.id,
        name: '',
        email: '',
      );
    }

    return CustomerProfileModel.fromMap({
      'uid': doc.id,
      ...data,
    });
  }

  /// The user ID
  @HiveField(0)
  final String uid;

  /// The user's name
  @HiveField(1)
  final String name;

  /// The user's email
  @HiveField(2)
  final String email;

  /// The URL of the user's profile photo
  @HiveField(3)
  final String? photoURL;

  /// The user's job title
  @HiveField(4)
  final String? jobTitle;

  /// The user's description or bio
  @HiveField(5)
  final String? description;

  /// The user's work experience
  @HiveField(6)
  final List<WorkExperience> workExperience;

  /// The user's education
  @HiveField(7)
  final List<Education> education;

  /// The user's skills
  @HiveField(8)
  final List<String> skills;

  /// The user's languages
  @HiveField(9)
  final List<Language> languages;

  /// When the profile was created
  @HiveField(10)
  final DateTime? createdAt;

  /// When the profile was last updated
  @HiveField(11)
  final DateTime? updatedAt;

  /// Create a copy of this profile with the given fields replaced
  CustomerProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoURL,
    String? jobTitle,
    String? description,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? skills,
    List<Language>? languages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      jobTitle: jobTitle ?? this.jobTitle,
      description: description ?? this.description,
      workExperience: workExperience ?? this.workExperience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert this model to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'jobTitle': jobTitle,
      'description': description,
      'workExperience': workExperience.map((x) => x.toMap()).toList(),
      'education': education.map((x) => x.toMap()).toList(),
      'skills': skills,
      'languages': languages.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }
}

/// A model representing work experience
@HiveType(typeId: 6)
class WorkExperience {
  /// Creates a new work experience
  WorkExperience({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    this.description,
    this.isCurrentPosition = false,
  });

  /// Create a model from a map
  factory WorkExperience.fromMap(Map<String, dynamic> map) {
    return WorkExperience(
      company: map['company']?.toString() ?? '',
      position: map['position']?.toString() ?? '',
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
      description: map['description']?.toString(),
      isCurrentPosition: map['isCurrentPosition'] == true,
    );
  }

  /// The company name
  @HiveField(0)
  final String company;

  /// The position or job title
  @HiveField(1)
  final String position;

  /// When the position started
  @HiveField(2)
  final DateTime startDate;

  /// When the position ended
  @HiveField(3)
  final DateTime? endDate;

  /// A description of the position
  @HiveField(4)
  final String? description;

  /// Whether this is the current position
  @HiveField(5)
  final bool isCurrentPosition;

  /// Create a copy of this experience with the given fields replaced
  WorkExperience copyWith({
    String? company,
    String? position,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isCurrentPosition,
  }) {
    return WorkExperience(
      company: company ?? this.company,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isCurrentPosition: isCurrentPosition ?? this.isCurrentPosition,
    );
  }

  /// Convert this model to a map
  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'position': position,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'description': description,
      'isCurrentPosition': isCurrentPosition,
    };
  }
}

/// A model representing education
@HiveType(typeId: 7)
class Education {
  /// Creates a new education
  Education({
    required this.institution,
    required this.degree,
    required this.startDate,
    this.endDate,
    this.description,
    this.isCurrentEducation = false,
  });

  /// Create a model from a map
  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution']?.toString() ?? '',
      degree: map['degree']?.toString() ?? '',
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
      description: map['description']?.toString(),
      isCurrentEducation: map['isCurrentEducation'] == true,
    );
  }

  /// The institution name
  @HiveField(0)
  final String institution;

  /// The degree or field of study
  @HiveField(1)
  final String degree;

  /// When the education started
  @HiveField(2)
  final DateTime startDate;

  /// When the education ended
  @HiveField(3)
  final DateTime? endDate;

  /// A description of the education
  @HiveField(4)
  final String? description;

  /// Whether this is the current education
  @HiveField(5)
  final bool isCurrentEducation;

  /// Create a copy of this education with the given fields replaced
  Education copyWith({
    String? institution,
    String? degree,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isCurrentEducation,
  }) {
    return Education(
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isCurrentEducation: isCurrentEducation ?? this.isCurrentEducation,
    );
  }

  /// Convert this model to a map
  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'degree': degree,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'description': description,
      'isCurrentEducation': isCurrentEducation,
    };
  }
}

/// A model representing a language
@HiveType(typeId: 8)
class Language {
  /// Creates a new language
  Language({
    required this.name,
    required this.proficiency,
  });

  /// Create a model from a map
  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      name: map['name']?.toString() ?? '',
      proficiency: LanguageProficiency
          .values[(map['proficiency'] is int) ? map['proficiency'] as int : 0],
    );
  }

  /// The language name
  @HiveField(0)
  final String name;

  /// The proficiency level
  @HiveField(1)
  final LanguageProficiency proficiency;

  /// Create a copy of this language with the given fields replaced
  Language copyWith({
    String? name,
    LanguageProficiency? proficiency,
  }) {
    return Language(
      name: name ?? this.name,
      proficiency: proficiency ?? this.proficiency,
    );
  }

  /// Convert this model to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'proficiency': proficiency.index,
    };
  }
}

/// Language proficiency levels
@HiveType(typeId: 9)
enum LanguageProficiency {
  /// Beginner level
  @HiveField(0)
  beginner,

  /// Intermediate level
  @HiveField(1)
  intermediate,

  /// Advanced level
  @HiveField(2)
  advanced,

  /// Native level
  @HiveField(3)
  native,
}

/// Extension to get the display name of a language proficiency
extension LanguageProficiencyExtension on LanguageProficiency {
  /// Get the display name of this proficiency level
  String get displayName {
    switch (this) {
      case LanguageProficiency.beginner:
        return 'Beginner';
      case LanguageProficiency.intermediate:
        return 'Intermediate';
      case LanguageProficiency.advanced:
        return 'Advanced';
      case LanguageProficiency.native:
        return 'Native';
    }
  }
}
