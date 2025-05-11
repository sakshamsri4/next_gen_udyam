import 'package:next_gen/app/modules/auth/models/user_model.dart';

/// A utility class for test accounts
class TestAccounts {
  /// Private constructor to prevent instantiation
  TestAccounts._();

  /// Test employee account
  static const employeeEmail = 'test_employee@example.com';
  static const employeePassword = 'Test@123';
  static const employeeName = 'Test Employee';

  /// Test employer account
  static const employerEmail = 'test_employer@example.com';
  static const employerPassword = 'Test@123';
  static const employerName = 'Test Employer';
  static const companyName = 'Test Company';

  /// Create a test employee user model
  static UserModel createTestEmployee() {
    return UserModel(
      uid: 'test_employee_uid',
      email: employeeEmail,
      displayName: employeeName,
      userType: UserType.employee,
      emailVerified: true,
      createdAt: DateTime.now(),
    );
  }

  /// Create a test employer user model
  static UserModel createTestEmployer() {
    return UserModel(
      uid: 'test_employer_uid',
      email: employerEmail,
      displayName: employerName,
      userType: UserType.employer,
      emailVerified: true,
      createdAt: DateTime.now(),
    );
  }
}
