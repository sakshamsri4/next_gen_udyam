import 'package:hive/hive.dart';

part 'search_filter.g.dart';

/// Type ID for SearchFilter in Hive
const int searchFilterTypeId = 4;

/// Model class for search filters
@HiveType(typeId: searchFilterTypeId)
class SearchFilter {
  /// Constructor
  SearchFilter({
    this.query = '',
    this.location = '',
    this.minSalary = 0,
    this.maxSalary = 200000, // Changed from 1000000 to match RangeSlider max
    this.jobTypes = const [],
    this.experience = const [],
    this.education = const [],
    this.skills = const [],
    this.industries = const [],
    this.isRemote = false,
    this.sortBy = SortOption.relevance,
    this.sortOrder = SortOrder.descending,
  });

  /// Factory constructor from JSON
  factory SearchFilter.fromJson(Map<String, dynamic> json) {
    return SearchFilter(
      query: json['query'] as String? ?? '',
      location: json['location'] as String? ?? '',
      minSalary: json['minSalary'] as int? ?? 0,
      maxSalary: json['maxSalary'] as int? ?? 200000, // Changed from 1000000
      jobTypes: List<String>.from(json['jobTypes'] as List? ?? []),
      experience: List<String>.from(json['experience'] as List? ?? []),
      education: List<String>.from(json['education'] as List? ?? []),
      skills: List<String>.from(json['skills'] as List? ?? []),
      industries: List<String>.from(json['industries'] as List? ?? []),
      isRemote: json['isRemote'] as bool? ?? false,
      sortBy: _parseSortOption(json['sortBy'] as String?),
      sortOrder: _parseSortOrder(json['sortOrder'] as String?),
    );
  }

  /// Search query
  @HiveField(0)
  final String query;

  /// Location filter
  @HiveField(1)
  final String location;

  /// Minimum salary filter
  @HiveField(2)
  final int minSalary;

  /// Maximum salary filter
  @HiveField(3)
  final int maxSalary;

  /// Job types filter (Full-time, Part-time, Contract, etc.)
  @HiveField(4)
  final List<String> jobTypes;

  /// Experience filter
  @HiveField(5)
  final List<String> experience;

  /// Education filter
  @HiveField(6)
  final List<String> education;

  /// Skills filter
  @HiveField(7)
  final List<String> skills;

  /// Industries filter
  @HiveField(8)
  final List<String> industries;

  /// Remote filter
  @HiveField(9)
  final bool isRemote;

  /// Sort option
  @HiveField(10)
  final SortOption sortBy;

  /// Sort order
  @HiveField(11)
  final SortOrder sortOrder;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'location': location,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'jobTypes': jobTypes,
      'experience': experience,
      'education': education,
      'skills': skills,
      'industries': industries,
      'isRemote': isRemote,
      'sortBy': sortBy.toString(),
      'sortOrder': sortOrder.toString(),
    };
  }

  /// Parse sort option from string
  static SortOption _parseSortOption(String? value) {
    if (value == null) return SortOption.relevance;
    return SortOption.values.firstWhere(
      (option) => option.toString() == value,
      orElse: () => SortOption.relevance,
    );
  }

  /// Parse sort order from string
  static SortOrder _parseSortOrder(String? value) {
    if (value == null) return SortOrder.descending;
    return SortOrder.values.firstWhere(
      (order) => order.toString() == value,
      orElse: () => SortOrder.descending,
    );
  }

  /// Create a copy of this object with the given fields replaced
  SearchFilter copyWith({
    String? query,
    String? location,
    int? minSalary,
    int? maxSalary,
    List<String>? jobTypes,
    List<String>? experience,
    List<String>? education,
    List<String>? skills,
    List<String>? industries,
    bool? isRemote,
    SortOption? sortBy,
    SortOrder? sortOrder,
  }) {
    return SearchFilter(
      query: query ?? this.query,
      location: location ?? this.location,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      jobTypes: jobTypes ?? this.jobTypes,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      industries: industries ?? this.industries,
      isRemote: isRemote ?? this.isRemote,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Check if the filter is empty
  bool get isEmpty {
    return query.isEmpty &&
        location.isEmpty &&
        minSalary == 0 &&
        maxSalary == 200000 && // Changed from 1000000 to match default
        jobTypes.isEmpty &&
        experience.isEmpty &&
        education.isEmpty &&
        skills.isEmpty &&
        industries.isEmpty &&
        !isRemote;
  }

  /// Check if the filter is not empty
  bool get isNotEmpty => !isEmpty;
}

/// Sort options for search results
@HiveType(typeId: 5)
enum SortOption {
  /// Sort by relevance
  @HiveField(0)
  relevance,

  /// Sort by date
  @HiveField(1)
  date,

  /// Sort by salary
  @HiveField(2)
  salary,

  /// Sort by company
  @HiveField(3)
  company,

  /// Sort by location
  @HiveField(4)
  location,
}

/// Sort order for search results
@HiveType(typeId: 6)
enum SortOrder {
  /// Ascending order
  @HiveField(0)
  ascending,

  /// Descending order
  @HiveField(1)
  descending,
}
