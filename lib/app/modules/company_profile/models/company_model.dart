import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'company_model.g.dart';

/// Type ID for Hive
const companyModelTypeId = 17;

/// Verification status of a company
@HiveType(typeId: 18)
enum VerificationStatus {
  /// Company is not verified
  @HiveField(0)
  notVerified,

  /// Verification is pending
  @HiveField(1)
  pending,

  /// Company is verified
  @HiveField(2)
  verified,

  /// Verification was rejected
  @HiveField(3)
  rejected,
}

/// Model class for company data
@HiveType(typeId: companyModelTypeId)
class CompanyModel {
  /// Constructor
  CompanyModel({
    required this.uid,
    required this.name,
    required this.email,
    this.description,
    this.industry,
    this.size,
    this.location,
    this.website,
    this.phone,
    this.logoUrl,
    this.socialLinks,
    this.isVerified = false,
    this.verificationStatus = VerificationStatus.notVerified,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor from Firestore document
  factory CompanyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    // Parse verification status
    var status = VerificationStatus.notVerified;
    if (data['verificationStatus'] != null) {
      final statusStr = data['verificationStatus'] as String;
      switch (statusStr) {
        case 'notVerified':
          status = VerificationStatus.notVerified;
        case 'pending':
          status = VerificationStatus.pending;
        case 'verified':
          status = VerificationStatus.verified;
        case 'rejected':
          status = VerificationStatus.rejected;
      }
    }

    // Parse social links
    List<String>? socialLinks;
    if (data['socialLinks'] != null) {
      socialLinks = List<String>.from(data['socialLinks'] as List? ?? []);
    }

    return CompanyModel(
      uid: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      description: data['description'] as String?,
      industry: data['industry'] as String?,
      size: data['size'] as String?,
      location: data['location'] as String?,
      website: data['website'] as String?,
      phone: data['phone'] as String?,
      logoUrl: data['logoUrl'] as String?,
      socialLinks: socialLinks,
      isVerified: data['isVerified'] as bool? ?? false,
      verificationStatus: status,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Company ID
  @HiveField(0)
  final String uid;

  /// Company name
  @HiveField(1)
  final String name;

  /// Company email
  @HiveField(2)
  final String email;

  /// Company description
  @HiveField(3)
  final String? description;

  /// Company industry
  @HiveField(4)
  final String? industry;

  /// Company size
  @HiveField(5)
  final String? size;

  /// Company location
  @HiveField(6)
  final String? location;

  /// Company website
  @HiveField(7)
  final String? website;

  /// Company phone
  @HiveField(8)
  final String? phone;

  /// Company logo URL
  @HiveField(9)
  final String? logoUrl;

  /// Company social links
  @HiveField(10)
  final List<String>? socialLinks;

  /// Whether the company is verified
  @HiveField(11)
  final bool isVerified;

  /// Verification status
  @HiveField(12)
  final VerificationStatus verificationStatus;

  /// Created at timestamp
  @HiveField(13)
  final DateTime? createdAt;

  /// Updated at timestamp
  @HiveField(14)
  final DateTime? updatedAt;

  /// Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'description': description,
      'industry': industry,
      'size': size,
      'location': location,
      'website': website,
      'phone': phone,
      'logoUrl': logoUrl,
      'socialLinks': socialLinks,
      'isVerified': isVerified,
      'verificationStatus': verificationStatus.toString().split('.').last,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Create a copy of this model with the given fields replaced
  CompanyModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? description,
    String? industry,
    String? size,
    String? location,
    String? website,
    String? phone,
    String? logoUrl,
    List<String>? socialLinks,
    bool? isVerified,
    VerificationStatus? verificationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      description: description ?? this.description,
      industry: industry ?? this.industry,
      size: size ?? this.size,
      location: location ?? this.location,
      website: website ?? this.website,
      phone: phone ?? this.phone,
      logoUrl: logoUrl ?? this.logoUrl,
      socialLinks: socialLinks ?? this.socialLinks,
      isVerified: isVerified ?? this.isVerified,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
