import 'package:hive/hive.dart';

part 'user_role.g.dart';

/// UserRole enum representing different user roles in the application.
///
/// - [admin]: Administrator with full access to all features
/// - [employer]: Company representative who can post jobs
/// and manage applications
/// - [employee]: Job seeker who can apply for jobs and manage their profile
@HiveType(typeId: 3)
enum UserRole {
  @HiveField(0)
  admin,

  @HiveField(1)
  employer,

  @HiveField(2)
  employee,
}

/// Extension methods for UserRole enum
extension UserRoleExtension on UserRole {
  /// Returns a user-friendly name for the role
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.employer:
        return 'Employer';
      case UserRole.employee:
        return 'Job Seeker';
    }
  }

  /// Returns a description for the role
  String get description {
    switch (this) {
      case UserRole.admin:
        return 'Manage the entire platform and users';
      case UserRole.employer:
        return 'Post jobs and manage applications';
      case UserRole.employee:
        return 'Apply for jobs and manage your profile';
    }
  }

  /// Returns an icon name for the role
  /// (for use with FontAwesome or other icon libraries)
  String get iconName {
    switch (this) {
      case UserRole.admin:
        return 'shield';
      case UserRole.employer:
        return 'building';
      case UserRole.employee:
        return 'user';
    }
  }

  /// Returns true if the role has admin privileges
  bool get isAdmin => this == UserRole.admin;

  /// Returns true if the role is an employer
  bool get isEmployer => this == UserRole.employer;

  /// Returns true if the role is an employee
  bool get isEmployee => this == UserRole.employee;
}
