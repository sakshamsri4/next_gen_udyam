import 'package:next_gen/app/modules/auth/models/user_model.dart';

/// Model for user management filters
class UserFilterModel {
  /// Creates a new user filter model
  UserFilterModel({
    this.searchQuery = '',
    this.userTypes = const [],
    this.isVerified,
    this.sortBy = UserSortOption.newest,
    this.dateRange,
  });

  /// Search query for filtering users
  final String searchQuery;

  /// User types to filter by
  final List<UserType> userTypes;

  /// Filter by verification status
  final bool? isVerified;

  /// Sort option
  final UserSortOption sortBy;

  /// Date range for filtering by creation date
  final DateTimeRange? dateRange;

  /// Copy with a new value
  UserFilterModel copyWith({
    String? searchQuery,
    List<UserType>? userTypes,
    bool? isVerified,
    UserSortOption? sortBy,
    DateTimeRange? dateRange,
    bool clearIsVerified = false,
    bool clearDateRange = false,
  }) {
    return UserFilterModel(
      searchQuery: searchQuery ?? this.searchQuery,
      userTypes: userTypes ?? this.userTypes,
      isVerified: clearIsVerified ? null : (isVerified ?? this.isVerified),
      sortBy: sortBy ?? this.sortBy,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
    );
  }

  /// Check if the filter is active (has any non-default values)
  bool get isActive {
    return searchQuery.isNotEmpty ||
        userTypes.isNotEmpty ||
        isVerified != null ||
        sortBy != UserSortOption.newest ||
        dateRange != null;
  }

  /// Reset all filters to default values
  UserFilterModel reset() {
    return UserFilterModel();
  }
}

/// Date range for filtering
class DateTimeRange {
  /// Creates a new date range
  DateTimeRange({
    required this.start,
    required this.end,
  });

  /// Start date
  final DateTime start;

  /// End date
  final DateTime end;
}

/// Sort options for users
enum UserSortOption {
  /// Sort by newest first
  newest,

  /// Sort by oldest first
  oldest,

  /// Sort by name (A-Z)
  nameAsc,

  /// Sort by name (Z-A)
  nameDesc,
}

/// Extension to get display name for sort options
extension UserSortOptionExtension on UserSortOption {
  /// Get display name for the sort option
  String get displayName {
    switch (this) {
      case UserSortOption.newest:
        return 'Newest First';
      case UserSortOption.oldest:
        return 'Oldest First';
      case UserSortOption.nameAsc:
        return 'Name (A-Z)';
      case UserSortOption.nameDesc:
        return 'Name (Z-A)';
    }
  }
}
