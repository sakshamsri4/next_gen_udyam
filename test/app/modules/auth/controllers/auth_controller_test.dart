import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {
  @override
  User? get user => MockUser();
}

void main() {
  late AuthController controller;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();

    // Set up GetX test environment
    Get.testMode = true;

    // Initialize controller
    controller = AuthController();

    // Clean up after each test
    addTearDown(() {
      Get.reset();
    });
  });

  group('AuthController Tests', () {
    test('initial values are correct', () {
      expect(controller.isLoading.value, false);
      expect(controller.isLoggedIn.value, false);
      expect(controller.errorMessage.value, '');
      expect(controller.user.value, null);
      expect(controller.firebaseUser.value, null);
    });

    test(
        'registerWithEmailAndPassword sets error message when fields are empty',
        () async {
      // Arrange
      controller.emailController.text = '';
      controller.passwordController.text = '';

      // Act
      await controller.registerWithEmailAndPassword();

      // Assert
      expect(
          controller.errorMessage.value, 'Email and password cannot be empty');
      expect(controller.isLoading.value, false);
    });

    test('signInWithEmailAndPassword sets error message when fields are empty',
        () async {
      // Arrange
      controller.emailController.text = '';
      controller.passwordController.text = '';

      // Act
      await controller.signInWithEmailAndPassword();

      // Assert
      expect(
          controller.errorMessage.value, 'Email and password cannot be empty');
      expect(controller.isLoading.value, false);
    });

    test('resetPassword sets error message when email is empty', () async {
      // Arrange
      controller.emailController.text = '';

      // Act
      await controller.resetPassword();

      // Assert
      expect(controller.errorMessage.value, 'Email cannot be empty');
      expect(controller.isLoading.value, false);
    });

    // Add more tests for successful authentication, error handling, etc.
  });
}
