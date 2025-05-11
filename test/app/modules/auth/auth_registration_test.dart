import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/auth/services/signup_session_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

import '../../../helpers/test_accounts.dart';
import '../../../helpers/test_helpers.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockLoggerService extends Mock implements LoggerService {}

class MockStorageService extends Mock implements StorageService {}

class MockSignupSessionService extends Mock implements SignupSessionService {}

class MockUserCredential extends Mock implements firebase.UserCredential {
  @override
  firebase.User get user => MockUser();
}

class MockUser extends Mock implements firebase.User {
  @override
  String get uid => 'test-uid';

  @override
  String? get email => TestAccounts.employeeEmail;

  @override
  bool get emailVerified => false;
}

void main() {
  late MockAuthService mockAuthService;
  late MockLoggerService mockLoggerService;
  late MockStorageService mockStorageService;
  late MockSignupSessionService mockSignupSessionService;
  late AuthController authController;

  setUp(() {
    // Initialize GetX test mode
    GetTestWidgetHelper.setupGetTest();

    // Create mocks
    mockAuthService = MockAuthService();
    mockLoggerService = MockLoggerService();
    mockStorageService = MockStorageService();
    mockSignupSessionService = MockSignupSessionService();

    // Register mocks with GetX
    Get.put<AuthService>(mockAuthService);
    Get.put<LoggerService>(mockLoggerService);
    Get.put<StorageService>(mockStorageService);
    Get.put<SignupSessionService>(mockSignupSessionService);

    // Set up default mock behavior
    when(() => mockLoggerService.d(any())).thenReturn(null);
    when(() => mockLoggerService.i(any())).thenReturn(null);
    when(() => mockLoggerService.e(any(), any(), any())).thenReturn(null);

    // Create controller
    authController = Get.put<AuthController>(AuthController());
  });

  tearDown(GetTestWidgetHelper.tearDownGetTest);

  group('User Registration Tests (P0)', () {
    test('REG-01: Register as employee with valid credentials', () async {
      // Arrange
      const name = TestAccounts.employeeName;
      const email = TestAccounts.employeeEmail;
      const password = TestAccounts.employeePassword;

      // Set up form controllers
      authController.nameController.text = name;
      authController.emailController.text = email;
      authController.passwordController.text = password;
      authController.confirmPasswordController.text = password;

      // Mock successful registration
      when(
        () => mockAuthService.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).thenAnswer((_) async => MockUserCredential());

      when(
        () => mockAuthService.updateUserProfile(
          displayName: name,
        ),
      ).thenAnswer((_) async => true);

      when(() => mockAuthService.sendEmailVerification())
          .thenAnswer((_) async => true);

      // Act
      final result = await authController.signUp();

      // Assert
      expect(result, isTrue);
      expect(authController.isLoading.value, isFalse);
      expect(authController.nameError.value, isEmpty);
      expect(authController.emailError.value, isEmpty);
      expect(authController.passwordError.value, isEmpty);
      expect(authController.confirmPasswordError.value, isEmpty);

      // Verify service calls
      verify(
        () => mockAuthService.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);

      verify(
        () => mockAuthService.updateUserProfile(
          displayName: name,
        ),
      ).called(1);

      verify(() => mockAuthService.sendEmailVerification()).called(1);
    });

    test('REG-04: Attempt registration with invalid email format', () async {
      // Arrange
      const name = TestAccounts.employeeName;
      const email = 'invalid-email';
      const password = TestAccounts.employeePassword;

      // Set up form controllers
      authController.nameController.text = name;
      authController.emailController.text = email;
      authController.passwordController.text = password;
      authController.confirmPasswordController.text = password;

      // Act
      final result = await authController.signUp();

      // Assert
      expect(result, isFalse);
      expect(authController.isLoading.value, isFalse);
      expect(authController.emailError.value, isNotEmpty);

      // Verify service calls
      verifyNever(
        () => mockAuthService.createUserWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });

    test('REG-05: Attempt registration with weak password', () async {
      // Arrange
      const name = TestAccounts.employeeName;
      const email = TestAccounts.employeeEmail;
      const password = 'weak';

      // Set up form controllers
      authController.nameController.text = name;
      authController.emailController.text = email;
      authController.passwordController.text = password;
      authController.confirmPasswordController.text = password;

      // Act
      final result = await authController.signUp();

      // Assert
      expect(result, isFalse);
      expect(authController.isLoading.value, isFalse);
      expect(authController.passwordError.value, isNotEmpty);

      // Verify service calls
      verifyNever(
        () => mockAuthService.createUserWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });

    test('REG-06: Attempt registration with existing email', () async {
      // Arrange
      const name = TestAccounts.employeeName;
      const email = TestAccounts.employeeEmail;
      const password = TestAccounts.employeePassword;

      // Set up form controllers
      authController.nameController.text = name;
      authController.emailController.text = email;
      authController.passwordController.text = password;
      authController.confirmPasswordController.text = password;

      // Mock email already exists error
      when(
        () => mockAuthService.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).thenThrow(
        firebase.FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'The email address is already in use by another account.',
        ),
      );

      // Act
      final result = await authController.signUp();

      // Assert
      expect(result, isFalse);
      expect(authController.isLoading.value, isFalse);
      expect(authController.emailError.value, isNotEmpty);
      expect(authController.emailError.value, contains('already in use'));

      // Verify service calls
      verify(
        () => mockAuthService.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);
    });

    test('REG-07: Test form validation (empty fields)', () async {
      // Arrange - all fields empty
      authController.nameController.text = '';
      authController.emailController.text = '';
      authController.passwordController.text = '';
      authController.confirmPasswordController.text = '';

      // Act
      final result = await authController.signUp();

      // Assert
      expect(result, isFalse);
      expect(authController.isLoading.value, isFalse);
      expect(authController.nameError.value, isNotEmpty);
      expect(authController.emailError.value, isNotEmpty);
      expect(authController.passwordError.value, isNotEmpty);
      expect(authController.confirmPasswordError.value, isNotEmpty);

      // Verify service calls
      verifyNever(
        () => mockAuthService.createUserWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });
  });
}
