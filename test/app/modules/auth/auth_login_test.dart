import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

import '../../../helpers/test_accounts.dart';
import '../../../helpers/test_helpers.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockLoggerService extends Mock implements LoggerService {}

class MockStorageService extends Mock implements StorageService {}

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
  late AuthController authController;

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

    // Create controller
    authController = Get.put<AuthController>(AuthController());
  });

  tearDown(GetTestWidgetHelper.tearDownGetTest);

  group('User Login Tests (P0)', () {
    test('LOG-01: Login with valid employee credentials', () async {
      // Arrange
      const email = TestAccounts.employeeEmail;
      const password = TestAccounts.employeePassword;

      // Set up form controllers
      authController.emailController.text = email;
      authController.passwordController.text = password;

      // Mock successful login
      when(
        () => mockAuthService.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).thenAnswer((_) async => MockUserCredential());

      when(() => mockAuthService.isEmailVerified).thenReturn(true);

      // Mock navigation
      Get.routing.current = Routes.login;

      // Act
      final result = await authController.login();

      // Assert
      expect(result, isTrue);
      expect(authController.isLoading.value, isFalse);
      expect(authController.emailError.value, isEmpty);
      expect(authController.passwordError.value, isEmpty);

      // Verify service calls
      verify(
        () => mockAuthService.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);
    });

    test('LOG-04: Attempt login with invalid credentials', () async {
      // Arrange
      const email = TestAccounts.employeeEmail;
      const password = 'wrong-password';

      // Set up form controllers
      authController.emailController.text = email;
      authController.passwordController.text = password;

      // Mock login failure
      when(
        () => mockAuthService.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).thenThrow(
        firebase.FirebaseAuthException(
          code: 'wrong-password',
          message:
              'The password is invalid or the user does not have a password.',
        ),
      );

      // Act
      final result = await authController.login();

      // Assert
      expect(result, isFalse);
      expect(authController.isLoading.value, isFalse);
      expect(authController.passwordError.value, isNotEmpty);

      // Verify service calls
      verify(
        () => mockAuthService.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);
    });

    test('LOG-06: Test "Forgot Password" flow', () async {
      // Arrange
      const email = TestAccounts.employeeEmail;

      // Set up form controller
      authController.resetEmailController.text = email;

      // Mock successful password reset
      when(() => mockAuthService.sendPasswordResetEmail(email))
          .thenAnswer((_) async => true);

      // Act
      final result = await authController.resetPassword();

      // Assert
      expect(result, isTrue);
      expect(authController.isResetLoading.value, isFalse);
      expect(authController.resetEmailError.value, isEmpty);

      // Verify service calls
      verify(() => mockAuthService.sendPasswordResetEmail(email)).called(1);
    });

    test('LOG-07: Test login with Google account', () async {
      // Arrange
      // Mock successful Google sign-in
      when(() => mockAuthService.signInWithGoogle())
          .thenAnswer((_) async => MockUserCredential());

      when(() => mockAuthService.isEmailVerified).thenReturn(true);

      // Mock navigation
      Get.routing.current = Routes.login;

      // Act
      final result = await authController.signInWithGoogle();

      // Assert
      expect(result, isTrue);
      expect(authController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockAuthService.signInWithGoogle()).called(1);
    });

    test('LOG-08: Test persistent login across app restarts', () async {
      // Arrange
      // Mock successful session restoration
      final mockUser = MockUser();
      when(() => mockAuthService.restoreUserSession())
          .thenAnswer((_) async => mockUser);

      // Act
      await authController.checkPersistedLogin();

      // Assert
      expect(authController.isRestoringSession.value, isTrue);
      expect(authController.user.value, equals(mockUser));

      // Verify service calls
      verify(() => mockAuthService.restoreUserSession()).called(1);
    });

    test('LOG-09: Test login during poor connectivity', () async {
      // Arrange
      const email = TestAccounts.employeeEmail;
      const password = TestAccounts.employeePassword;

      // Set up form controllers
      authController.emailController.text = email;
      authController.passwordController.text = password;

      // Mock network error
      when(
        () => mockAuthService.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).thenThrow(
        firebase.FirebaseAuthException(
          code: 'network-request-failed',
          message: 'A network error has occurred.',
        ),
      );

      // Act
      final result = await authController.login();

      // Assert
      expect(result, isFalse);
      expect(authController.isLoading.value, isFalse);
      expect(
          authController.emailError.value.toLowerCase(), contains('network'));

      // Verify service calls
      verify(
        () => mockAuthService.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);
    });
  });
}
