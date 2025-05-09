import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Model class for job categories
@immutable
class JobCategory {
  /// Constructor
  const JobCategory({
    required this.id,
    required this.title,
    this.count = 0,
  });

  /// Factory constructor from Firestore document
  factory JobCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return JobCategory(
      id: doc.id,
      title: data['title'] as String? ?? '',
      count: data['count'] as int? ?? 0,
    );
  }

  /// Factory constructor for "All" category
  factory JobCategory.all() {
    return const JobCategory(
      id: 'all',
      title: 'All',
    );
  }

  /// Category ID
  final String id;

  /// Category title
  final String title;

  /// Number of jobs in this category
  final int count;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'count': count,
    };
  }

  /// Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'count': count,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
