import 'package:hive/hive.dart';

part 'search_history.g.dart';

/// Type ID for SearchHistory in Hive
const int searchHistoryTypeId = 3;

/// Model class for search history
@HiveType(typeId: searchHistoryTypeId)
class SearchHistory {
  /// Constructor
  SearchHistory({
    required this.query,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Factory constructor from JSON
  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Search query
  @HiveField(0)
  final String query;

  /// Timestamp of the search
  @HiveField(1)
  final DateTime timestamp;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create a copy of this object with the given fields replaced
  SearchHistory copyWith({
    String? query,
    DateTime? timestamp,
  }) {
    return SearchHistory(
      query: query ?? this.query,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
