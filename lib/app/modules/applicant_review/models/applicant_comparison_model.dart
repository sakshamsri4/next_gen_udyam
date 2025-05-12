import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

// We're using custom adapters defined in hive_adapters.dart instead of generated ones
// part 'applicant_comparison_model.g.dart';

/// Type ID for Hive
const applicantComparisonModelTypeId = 23;

/// Model class for applicant comparison
@HiveType(typeId: applicantComparisonModelTypeId)
class ApplicantComparisonModel {
  /// Constructor
  ApplicantComparisonModel({
    required this.id,
    required this.jobId,
    required this.applicantIds,
    required this.createdAt,
    this.notes = '',
    this.ratings = const {},
  });

  /// Factory constructor from Firestore document
  factory ApplicantComparisonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return ApplicantComparisonModel(
        id: doc.id,
        jobId: '',
        applicantIds: [],
        createdAt: DateTime.now(),
      );
    }

    // Parse timestamp
    final createdAtTimestamp = data['createdAt'] as Timestamp?;
    final createdAt = createdAtTimestamp?.toDate() ?? DateTime.now();

    // Parse ratings
    final ratingsData = data['ratings'] as Map<String, dynamic>? ?? {};
    final ratings = <String, int>{};
    for (final entry in ratingsData.entries) {
      ratings[entry.key] = entry.value as int;
    }

    return ApplicantComparisonModel(
      id: doc.id,
      jobId: data['jobId'] as String? ?? '',
      applicantIds: List<String>.from(data['applicantIds'] as List? ?? []),
      createdAt: createdAt,
      notes: data['notes'] as String? ?? '',
      ratings: ratings,
    );
  }

  /// Comparison ID
  @HiveField(0)
  final String id;

  /// Job ID
  @HiveField(1)
  final String jobId;

  /// List of applicant IDs being compared
  @HiveField(2)
  final List<String> applicantIds;

  /// Date when the comparison was created
  @HiveField(3)
  final DateTime createdAt;

  /// Notes about the comparison
  @HiveField(4)
  final String notes;

  /// Ratings for each applicant (applicantId -> rating)
  @HiveField(5)
  final Map<String, int> ratings;

  /// Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'jobId': jobId,
      'applicantIds': applicantIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'notes': notes,
      'ratings': ratings,
    };
  }

  /// Create a copy of this model with the given fields replaced
  ApplicantComparisonModel copyWith({
    String? id,
    String? jobId,
    List<String>? applicantIds,
    DateTime? createdAt,
    String? notes,
    Map<String, int>? ratings,
  }) {
    return ApplicantComparisonModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      applicantIds: applicantIds ?? this.applicantIds,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      ratings: ratings ?? this.ratings,
    );
  }

  /// Get the rating for an applicant
  int getRating(String applicantId) {
    return ratings[applicantId] ?? 0;
  }

  /// Set the rating for an applicant
  ApplicantComparisonModel withRating(String applicantId, int rating) {
    final newRatings = Map<String, int>.from(ratings);
    newRatings[applicantId] = rating;
    return copyWith(ratings: newRatings);
  }
}
