import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'resume_model.g.dart';

/// Type ID for Hive
const resumeModelTypeId = 12;

/// Model class for resume data
@HiveType(typeId: resumeModelTypeId)
class ResumeModel {
  /// Constructor
  ResumeModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.fileUrl,
    required this.uploadedAt,
    this.fileSize,
    this.fileType,
    this.isDefault = false,
    this.description,
  });

  /// Factory constructor from Firestore document
  factory ResumeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    // Parse timestamp
    final uploadedAtTimestamp = data['uploadedAt'] as Timestamp?;

    return ResumeModel(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      fileUrl: data['fileUrl'] as String,
      uploadedAt: uploadedAtTimestamp?.toDate() ?? DateTime.now(),
      fileSize: data['fileSize'] as int?,
      fileType: data['fileType'] as String?,
      isDefault: data['isDefault'] as bool? ?? false,
      description: data['description'] as String?,
    );
  }

  /// Resume ID
  @HiveField(0)
  final String id;

  /// User ID
  @HiveField(1)
  final String userId;

  /// Resume name
  @HiveField(2)
  final String name;

  /// Resume file URL
  @HiveField(3)
  final String fileUrl;

  /// Date when the resume was uploaded
  @HiveField(4)
  final DateTime uploadedAt;

  /// File size in bytes
  @HiveField(5)
  final int? fileSize;

  /// File type (e.g., PDF, DOCX)
  @HiveField(6)
  final String? fileType;

  /// Whether this is the default resume
  @HiveField(7)
  final bool isDefault;

  /// Optional description
  @HiveField(8)
  final String? description;

  /// Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'fileUrl': fileUrl,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'fileSize': fileSize,
      'fileType': fileType,
      'isDefault': isDefault,
      'description': description,
    };
  }

  /// Create a copy of this model with the given fields replaced
  ResumeModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? fileUrl,
    DateTime? uploadedAt,
    int? fileSize,
    String? fileType,
    bool? isDefault,
    String? description,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      fileUrl: fileUrl ?? this.fileUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      isDefault: isDefault ?? this.isDefault,
      description: description ?? this.description,
    );
  }
}
