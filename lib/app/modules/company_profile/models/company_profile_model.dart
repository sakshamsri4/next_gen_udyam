import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'company_profile_model.g.dart';

/// A model representing a company profile
@HiveType(typeId: 10)
class CompanyProfileModel {
  /// Creates a new company profile model
  CompanyProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    this.logoURL,
    this.website,
    this.description,
    this.industry,
    this.location,
    this.size,
    this.founded,
    this.socialLinks = const {},
    this.createdAt,
    this.updatedAt,
  });

  /// Create a model from a map
  factory CompanyProfileModel.fromMap(Map<String, dynamic> map) {
    return CompanyProfileModel(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      logoURL: map['logoURL']?.toString(),
      website: map['website']?.toString(),
      description: map['description']?.toString(),
      industry: map['industry']?.toString(),
      location: map['location']?.toString(),
      size: map['size']?.toString(),
      founded: map['founded'] is int ? map['founded'] as int : null,
      socialLinks: (map['socialLinks'] is Map)
          ? Map<String, String>.fromEntries(
              (map['socialLinks'] as Map).entries.map(
                    (entry) => MapEntry(
                      entry.key.toString(),
                      entry.value?.toString() ?? '',
                    ),
                  ),
            )
          : {},
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  /// Create a model from a Firestore document
  factory CompanyProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return CompanyProfileModel(
        uid: doc.id,
        name: '',
        email: '',
      );
    }

    return CompanyProfileModel.fromMap({
      'uid': doc.id,
      ...data,
    });
  }

  /// The company ID
  @HiveField(0)
  final String uid;

  /// The company name
  @HiveField(1)
  final String name;

  /// The company email
  @HiveField(2)
  final String email;

  /// The URL of the company logo
  @HiveField(3)
  final String? logoURL;

  /// The company website
  @HiveField(4)
  final String? website;

  /// The company description
  @HiveField(5)
  final String? description;

  /// The company industry
  @HiveField(6)
  final String? industry;

  /// The company location
  @HiveField(7)
  final String? location;

  /// The company size (number of employees)
  @HiveField(8)
  final String? size;

  /// When the company was founded
  @HiveField(9)
  final int? founded;

  /// The company's social media links
  @HiveField(10)
  final Map<String, String> socialLinks;

  /// When the profile was created
  @HiveField(11)
  final DateTime? createdAt;

  /// When the profile was last updated
  @HiveField(12)
  final DateTime? updatedAt;

  /// Create a copy of this profile with the given fields replaced
  CompanyProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? logoURL,
    String? website,
    String? description,
    String? industry,
    String? location,
    String? size,
    int? founded,
    Map<String, String>? socialLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      logoURL: logoURL ?? this.logoURL,
      website: website ?? this.website,
      description: description ?? this.description,
      industry: industry ?? this.industry,
      location: location ?? this.location,
      size: size ?? this.size,
      founded: founded ?? this.founded,
      socialLinks: socialLinks ?? this.socialLinks,
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
      'logoURL': logoURL,
      'website': website,
      'description': description,
      'industry': industry,
      'location': location,
      'size': size,
      'founded': founded,
      'socialLinks': socialLinks,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }
}
