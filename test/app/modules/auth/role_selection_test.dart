import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/role_selection/controllers/role_selection_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

import '../../../helpers/test_accounts.dart';
import '../../../helpers/test_helpers.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockLoggerService extends Mock implements LoggerService {}

class MockStorageService extends Mock implements StorageService {}

class MockUser extends Mock implements firebase.User {
  @override
  String get uid => 'test-uid';

  @override
  String? get email => TestAccounts.employeeEmail;

  @override
  bool get emailVerified => true;
}

void main() {
  late MockAuthService mockAuthService;
  late MockLoggerService mockLoggerService;
  late MockStorageService mockStorageService;
  late AuthController authController;
  late RoleSelectionController roleSelectionController;

  setUp(() {
    // Initialize GetX test mode
    GetTestWidgetHelper.setupGetTest();

    // Create mocks
    mockAuthService = MockAuthService();
    mockLoggerService = MockLoggerService();
    mockStorageService = MockStorageService();

    // Register mocks with GetX
    Get.put<AuthService>(mockAuthService);
    Get.put<LoggerService>(mockLoggerService);
    Get.put<StorageService>(mockStorageService);

    // Set up default mock behavior
    when(() => mockLoggerService.d(any())).thenReturn(null);
    when(() => mockLoggerService.i(any())).thenReturn(null);
    when(() => mockLoggerService.e(any(), any(), any())).thenReturn(null);

    // Mock navigation
    Get.testMode = true;

    // Create controllers
    authController = Get.put<AuthController>(AuthController());
    roleSelectionController =
        Get.put<RoleSelectionController>(RoleSelectionController());

    // Mock current user
    final mockUser = MockUser();
    authController.user.value = mockUser;
    when(() => mockAuthService.currentUser).thenReturn(mockUser);
  });

  tearDown(GetTestWidgetHelper.tearDownGetTest);

  group('Role Selection Tests (P0)', () {
    test('ROLE-01: Select employee role during registration', () async {
      // Arrange
      // Mock successful role update
      when(() => mockAuthService.updateUserRole(UserType.employee))
          .thenAnswer((_) async => true);

      // Act
      roleSelectionController.selectedRole.value = UserType.employee;
      final result = await roleSelectionController.confirmRoleSelection();

      // Assert
      expect(result, isTrue);
      expect(roleSelectionController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockAuthService.updateUserRole(UserType.employee)).called(1);
    });

    test('ROLE-02: Select employer role during registration', () async {
      // Arrange
      // Mock successful role update
      when(() => mockAuthService.updateUserRole(UserType.employer))
          .thenAnswer((_) async => true);

      // Act
      roleSelectionController.selectedRole.value = UserType.employer;
      final result = await roleSelectionController.confirmRoleSelection();

      // Assert
      expect(result, isTrue);
      expect(roleSelectionController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockAuthService.updateUserRole(UserType.employer)).called(1);
    });

    test('ROLE-03: Select admin role during registration', () async {
      // Arrange
      // Mock successful role update
      when(() => mockAuthService.updateUserRole(UserType.admin))
          .thenAnswer((_) async => true);

      // Act
      roleSelectionController.selectedRole.value = UserType.admin;
      final result = await roleSelectionController.confirmRoleSelection();

      // Assert
      expect(result, isTrue);
      expect(roleSelectionController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockAuthService.updateUserRole(UserType.admin)).called(1);
    });

    test('ROLE-04: Verify role persistence after logout and login', () async {
      // Arrange
      // Mock user with role
      final userModel = UserModel(
        uid: 'test-uid',
        email: TestAccounts.employeeEmail,
        userType: UserType.employee,
      );

      // Mock getting user data
      when(() => mockAuthService.getUserData())
          .thenAnswer((_) async => userModel);

      // Act
      await roleSelectionController.loadUserRole();

      // Assert
      expect(
          roleSelectionController.currentRole.value, equals(UserType.employee));

      // Verify service calls
      verify(() => mockAuthService.getUserData()).called(1);
    });

    test('ROLE-05: Test role-specific navigation and access control', () async {
      // Arrange
      // Mock user with employee role
      final userModel = UserModel(
        uid: 'test-uid',
        email: TestAccounts.employeeEmail,
        userType: UserType.employee,
      );

      // Mock getting user data
      when(() => mockAuthService.getUserData())
          .thenAnswer((_) async => userModel);

      // Act
      await roleSelectionController.loadUserRole();
      final canAccessEmployeeRoute =
          roleSelectionController.canAccessRoute(Routes.jobs);
      final canAccessEmployerRoute =
          roleSelectionController.canAccessRoute(Routes.jobPosting);

      // Assert
      expect(
          roleSelectionController.currentRole.value, equals(UserType.employee));
      expect(canAccessEmployeeRoute, isTrue);
      expect(canAccessEmployerRoute, isFalse);

      // Verify service calls
      verify(() => mockAuthService.getUserData()).called(1);
    });

    test('ROLE-05: Test role change updates navigation access', () async {
      // Arrange
      // First set as employee
      final employeeModel = UserModel(
        uid: 'test-uid',
        email: TestAccounts.employeeEmail,
        userType: UserType.employee,
      );

      // Then change to employer
      final employerModel = UserModel(
        uid: 'test-uid',
        email: TestAccounts.employeeEmail,
        userType: UserType.employer,
      );

      // Mock getting user data (first call returns employee, second returns employer)
      when(() => mockAuthService.getUserData())
          .thenAnswer((_) async => employeeModel)
          .thenAnswer((_) async => employerModel);

      // Mock role update
      when(() => mockAuthService.updateUserRole(UserType.employer))
          .thenAnswer((_) async => true);

      // Act - First load as employee
      await roleSelectionController.loadUserRole();
      final initialEmployeeAccess =
          roleSelectionController.canAccessRoute(Routes.jobs);
      final initialEmployerAccess =
          roleSelectionController.canAccessRoute(Routes.jobPosting);

      // Then change to employer
      roleSelectionController.selectedRole.value = UserType.employer;
      await roleSelectionController.confirmRoleSelection();
      await roleSelectionController.loadUserRole(); // Reload role

      final updatedEmployeeAccess =
          roleSelectionController.canAccessRoute(Routes.jobs);
      final updatedEmployerAccess =
          roleSelectionController.canAccessRoute(Routes.jobPosting);

      // Assert
      expect(
          roleSelectionController.currentRole.value, equals(UserType.employer));
      expect(initialEmployeeAccess, isTrue);
      expect(initialEmployerAccess, isFalse);
      expect(updatedEmployeeAccess, isFalse);
      expect(updatedEmployerAccess, isTrue);

      // Verify service calls
      verify(() => mockAuthService.updateUserRole(UserType.employer)).called(1);
      verify(() => mockAuthService.getUserData()).called(2);
    });
  });
}
