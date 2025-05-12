import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';

/// Type ID for Hive
const savedSearchModelTypeId = 5;

/// Model class for saved search data
@HiveType(typeId: savedSearchModelTypeId)
class SavedSearchModel {
  /// Constructor
  SavedSearchModel({
    required this.id,
    required this.userId,
    required this.query,
    required this.filter,
    required this.createdAt,
    this.lastUsedAt,
  });

  /// Create from a map
  factory SavedSearchModel.fromMap(Map<String, dynamic> map) {
    return SavedSearchModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      query: map['query'] as String,
      filter: SearchFilter.fromMap(map['filter'] as Map<String, dynamic>),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastUsedAt: map['lastUsedAt'] != null
          ? (map['lastUsedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create from a Firestore document
  factory SavedSearchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return SavedSearchModel.fromMap({
      'id': doc.id,
      ...data,
    });
  }

  /// Unique identifier
  @HiveField(0)
  final String id;

  /// User ID
  @HiveField(1)
  final String userId;

  /// Search query
  @HiveField(2)
  final String query;

  /// Search filter
  @HiveField(3)
  final SearchFilter filter;

  /// Creation timestamp
  @HiveField(4)
  final DateTime createdAt;

  /// Last used timestamp
  @HiveField(5)
  final DateTime? lastUsedAt;

  /// Create a copy with updated fields
  SavedSearchModel copyWith({
    String? id,
    String? userId,
    String? query,
    SearchFilter? filter,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) {
    return SavedSearchModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  /// Convert to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'query': query,
      'filter': filter.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUsedAt': lastUsedAt != null ? Timestamp.fromDate(lastUsedAt!) : null,
    };
  }

  /// Get a display name for the saved search
  String get displayName {
    if (query.isNotEmpty) {
      return query;
    }

    final parts = <String>[];

    if (filter.jobTypes.isNotEmpty) {
      parts.add(filter.jobTypes.first);
    }

    if (filter.location.isNotEmpty) {
      parts.add(filter.location);
    }

    if (filter.industries.isNotEmpty) {
      parts.add(filter.industries.first);
    }

    if (parts.isEmpty) {
      return 'Saved Search';
    }

    return parts.join(' • ');
  }
}
