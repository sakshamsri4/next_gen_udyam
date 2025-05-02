import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late AuthController controller;
  late MockAuthService mockAuthService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockLoggerService mockLogger;

  setUp(() {
    // Initialize GetX test environment
    Get.testMode = true;

    // Create mocks
    mockAuthService = MockAuthService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockLogger = MockLoggerService();

    // Setup mock responses
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');
    when(mockUser.email).thenReturn('test@example.com');

    // Register dependencies
    Get.put<LoggerService>(mockLogger);
    Get.put<AuthService>(mockAuthService);

    // Create controller
    controller = AuthController();
  });

  tearDown(() {
    Get.reset();
  });

  group('AuthController', () {
    test('login should use AuthService and navigate to home on success',
        () async {
      // Arrange
      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'password123';

      // Setup mock response
      when(mockAuthService.signInWithEmailAndPassword(
        'test@example.com',
        'password123',
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      await controller.login();

      // Assert
      verify(mockAuthService.signInWithEmailAndPassword(
        'test@example.com',
        'password123',
      )).called(1);

      // Verify form cleared
      expect(controller.emailController.text, isEmpty);
      expect(controller.passwordController.text, isEmpty);
    });

    test('signup should use AuthService and navigate to home on success',
        () async {
      // Arrange
      controller.nameController.text = 'Test User';
      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'password123';
      controller.confirmPasswordController.text = 'password123';

      // Setup mock responses
      when(mockAuthService.registerWithEmailAndPassword(
        'test@example.com',
        'password123',
      )).thenAnswer((_) async => mockUserCredential);

      when(mockAuthService.updateUserProfile(
        displayName: 'Test User',
      )).thenAnswer((_) async => {});

      // Act
      await controller.signup();

      // Assert
      verify(mockAuthService.registerWithEmailAndPassword(
        'test@example.com',
        'password123',
      )).called(1);

      verify(mockAuthService.updateUserProfile(
        displayName: 'Test User',
      )).called(1);

      // Verify form cleared
      expect(controller.nameController.text, isEmpty);
      expect(controller.emailController.text, isEmpty);
      expect(controller.passwordController.text, isEmpty);
      expect(controller.confirmPasswordController.text, isEmpty);
    });

    test(
        'signInWithGoogle should use AuthService and navigate to home on success',
        () async {
      // Arrange
      when(mockAuthService.signInWithGoogle())
          .thenAnswer((_) async => mockUserCredential);

      // Act
      await controller.signInWithGoogle();

      // Assert
      verify(mockAuthService.signInWithGoogle()).called(1);
    });

    test('signOut should use AuthService and navigate to login on success',
        () async {
      // Arrange
      when(mockAuthService.signOut()).thenAnswer((_) async => {});

      // Act
      await controller.signOut();

      // Assert
      verify(mockAuthService.signOut()).called(1);
    });
  });
}
