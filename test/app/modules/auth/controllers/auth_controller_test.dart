import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

// Mock AuthService for testing
class TestAuthService implements AuthService {
  // Mock user data
  UserModel? mockUser;
  String? mockErrorMessage;
  bool mockIsLoggedIn = false;

  // Function variables for mocking
  Future<UserCredential> Function(String, String)?
      _mockSignInWithEmailAndPassword;
  Future<UserCredential> Function(String, String)?
      _mockRegisterWithEmailAndPassword;
  Future<UserCredential?> Function()? _mockSignInWithGoogle;
  Future<void> Function()? _mockSignOut;
  Future<void> Function(String)? _mockResetPassword;

  // Setters for mock functions
  set mockSignInWithEmailAndPasswordFn(
    Future<UserCredential> Function(String, String) fn,
  ) {
    _mockSignInWithEmailAndPassword = fn;
  }

  set mockRegisterWithEmailAndPasswordFn(
    Future<UserCredential> Function(String, String) fn,
  ) {
    _mockRegisterWithEmailAndPassword = fn;
  }

  set mockSignInWithGoogleFn(Future<UserCredential?> Function() fn) {
    _mockSignInWithGoogle = fn;
  }

  set mockSignOutFn(Future<void> Function() fn) {
    _mockSignOut = fn;
  }

  set mockResetPasswordFn(Future<void> Function(String) fn) {
    _mockResetPassword = fn;
  }

  // Override methods to use mocks
  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (_mockSignInWithEmailAndPassword != null) {
      return _mockSignInWithEmailAndPassword!(email, password);
    }
    throw UnimplementedError('Mock not set for signInWithEmailAndPassword');
  }

  @override
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (_mockRegisterWithEmailAndPassword != null) {
      return _mockRegisterWithEmailAndPassword!(email, password);
    }
    throw UnimplementedError('Mock not set for registerWithEmailAndPassword');
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    if (_mockSignInWithGoogle != null) {
      return _mockSignInWithGoogle!();
    }
    throw UnimplementedError('Mock not set for signInWithGoogle');
  }

  @override
  Future<void> signOut() async {
    if (_mockSignOut != null) {
      return _mockSignOut!();
    }
    throw UnimplementedError('Mock not set for signOut');
  }

  @override
  Future<void> resetPassword(String email) async {
    if (_mockResetPassword != null) {
      return _mockResetPassword!(email);
    }
    throw UnimplementedError('Mock not set for resetPassword');
  }

  // Implement required getters
  @override
  bool get isLoggedIn => mockIsLoggedIn;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  String getErrorMessage(dynamic error) {
    return mockErrorMessage ?? 'Mock error message';
  }

  @override
  Future<UserModel?> getUserFromHive() async {
    return mockUser;
  }

  // Implement other required methods with minimal implementations
  @override
  User? get currentUser => null;

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {}

  @override
  Future<UserModel?> getUserFromFirebase() async => null;

  @override
  bool get isEmailVerified => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  // Provide a logger for testing
  LoggerService get log => LoggerService();
}

// Create a testable version of AuthController
class TestableAuthController extends AuthController {
  // Constructor that takes our mock service
  TestableAuthController(this.authService);
  // Override the authService getter to return our mock
  @override
  final TestAuthService authService;

  // Override onInit to avoid Firebase initialization
  @override
  void onInit() {
    // Call super.onInit() to satisfy @mustCallSuper
    super.onInit();

    // Override the behavior that would normally happen in the parent class
    // by resetting the values that would be set in the parent's onInit

    // This is a modified implementation to avoid Firebase initialization
    // issues in the test environment while still satisfying @mustCallSuper
  }
}

void main() {
  late TestAuthService mockAuthService;
  late TestableAuthController authController;

  setUp(() {
    // Initialize GetX for testing
    Get.testMode = true;
    Get.reset();

    // Create a fresh mock service for each test
    mockAuthService = TestAuthService();

    // Create the controller with our mock service and initialize it
    authController = TestableAuthController(mockAuthService)..onInit();
  });

  tearDown(() {
    // Clean up after each test
    authController.onClose();
    Get.reset();
  });

  group('AuthController Basic Tests', () {
    test('initializes with expected default values', () {
      // Verify initial values
      expect(authController.isLoading.value, false);
      expect(authController.isLoggedIn.value, false);
      expect(authController.errorMessage.value, '');
      expect(authController.user.value, null);

      // Verify controllers are initialized
      expect(authController.emailController, isA<TextEditingController>());
      expect(authController.passwordController, isA<TextEditingController>());
      expect(authController.nameController, isA<TextEditingController>());
    });
  });

  group('AuthController Authentication Tests', () {
    test('signInWithEmailAndPassword calls AuthService with correct parameters',
        () async {
      // Setup the mock
      var methodCalled = false;
      mockAuthService.mockSignInWithEmailAndPasswordFn =
          (String email, String password) async {
        methodCalled = true;
        expect(email, 'test@example.com');
        expect(password, 'password123');
        throw FirebaseAuthException(code: 'user-not-found');
      };

      // Set the controller's text fields
      authController.emailController.text = 'test@example.com';
      authController.passwordController.text = 'password123';

      // Call the method
      await authController.signInWithEmailAndPassword();

      // Verify the mock was called
      expect(methodCalled, true);

      // Verify loading state is reset
      expect(authController.isLoading.value, false);
    });

    test('signInWithEmailAndPassword handles FirebaseAuthException correctly',
        () async {
      // Setup the mock to throw a specific Firebase exception
      mockAuthService.mockSignInWithEmailAndPasswordFn =
          (String email, String password) async {
        throw FirebaseAuthException(code: 'wrong-password');
      };

      // Set the controller's text fields
      authController.emailController.text = 'test@example.com';
      authController.passwordController.text = 'wrong-password';

      // Call the method
      await authController.signInWithEmailAndPassword();

      // Verify error message is set correctly
      expect(authController.errorMessage.value, 'Wrong password');

      // Verify loading state is reset
      expect(authController.isLoading.value, false);
    });

    test('registerWithEmailAndPassword calls AuthService correctly', () async {
      // Setup the mock
      var methodCalled = false;
      mockAuthService.mockRegisterWithEmailAndPasswordFn =
          (String email, String password) async {
        methodCalled = true;
        expect(email, 'new@example.com');
        expect(password, 'newpassword123');
        throw FirebaseAuthException(code: 'email-already-in-use');
      };

      // Set the controller's text fields
      authController.emailController.text = 'new@example.com';
      authController.passwordController.text = 'newpassword123';
      authController.nameController.text = 'New User';

      // Call the method
      await authController.registerWithEmailAndPassword();

      // Verify the mock was called
      expect(methodCalled, true);

      // Verify error message is set correctly
      expect(authController.errorMessage.value, 'Email is already in use');

      // Verify loading state is reset
      expect(authController.isLoading.value, false);
    });

    test('signInWithGoogle calls AuthService', () async {
      // Setup the mock
      var methodCalled = false;
      mockAuthService.mockSignInWithGoogleFn = () async {
        methodCalled = true;
        throw FirebaseAuthException(code: 'operation-not-allowed');
      };

      // Call the method
      await authController.signInWithGoogle();

      // Verify the mock was called
      expect(methodCalled, true);

      // Verify error message is set correctly
      expect(
        authController.errorMessage.value,
        'This operation is not allowed',
      );

      // Verify loading state is reset
      expect(authController.isLoading.value, false);
    });

    test('signOut calls AuthService', () async {
      // Setup the mock
      var methodCalled = false;
      mockAuthService.mockSignOutFn = () async {
        methodCalled = true;
      };

      // Call the method
      await authController.signOut();

      // Verify the mock was called
      expect(methodCalled, true);

      // Verify user state is reset
      expect(authController.isLoggedIn.value, false);
      expect(authController.user.value, null);

      // Verify loading state is reset
      expect(authController.isLoading.value, false);
    });

    test('resetPassword calls AuthService with correct email', () async {
      // Setup the mock
      var methodCalled = false;
      mockAuthService.mockResetPasswordFn = (String email) async {
        methodCalled = true;
        expect(email, 'reset@example.com');
      };

      // Set the controller's email field
      authController.emailController.text = 'reset@example.com';

      // Call the method
      await authController.resetPassword();

      // Verify the mock was called
      expect(methodCalled, true);

      // Verify loading state is reset
      expect(authController.isLoading.value, false);
    });
  });

  group('Firebase Auth Error Handling', () {
    test('signInWithEmailAndPassword handles common error codes appropriately',
        () async {
      // Test various error codes
      final errorCodes = {
        'user-not-found': 'No user found with this email',
        'wrong-password': 'Wrong password',
        'invalid-email': 'Invalid email format',
        'user-disabled': 'This user account has been disabled',
      };

      for (final entry in errorCodes.entries) {
        // Setup the mock to throw the specific error
        mockAuthService.mockSignInWithEmailAndPasswordFn =
            (String email, String password) async {
          throw FirebaseAuthException(code: entry.key);
        };

        // Set the controller's text fields
        authController.emailController.text = 'test@example.com';
        authController.passwordController.text = 'password123';

        // Call the method
        await authController.signInWithEmailAndPassword();

        // Verify error message is set correctly
        expect(authController.errorMessage.value, entry.value);
      }
    });

    test(
        'registerWithEmailAndPassword handles common error codes appropriately',
        () async {
      // Test various error codes
      final errorCodes = {
        'email-already-in-use': 'Email is already in use',
        'weak-password': 'Password is too weak',
        'invalid-email': 'Invalid email format',
        'operation-not-allowed': 'This operation is not allowed',
      };

      for (final entry in errorCodes.entries) {
        // Setup the mock to throw the specific error
        mockAuthService.mockRegisterWithEmailAndPasswordFn =
            (String email, String password) async {
          throw FirebaseAuthException(code: entry.key);
        };

        // Set the controller's text fields
        authController.emailController.text = 'new@example.com';
        authController.passwordController.text = 'newpassword123';

        // Call the method
        await authController.registerWithEmailAndPassword();

        // Verify error message is set correctly
        expect(authController.errorMessage.value, entry.value);
      }
    });

    test('sets a default error message for unknown error codes', () async {
      // Setup the mock to throw an unknown error code
      mockAuthService.mockSignInWithEmailAndPasswordFn =
          (String email, String password) async {
        throw FirebaseAuthException(
          code: 'unknown-code',
          message: 'Some unknown error occurred',
        );
      };

      // Set the controller's text fields
      authController.emailController.text = 'test@example.com';
      authController.passwordController.text = 'password123';

      // Call the method
      await authController.signInWithEmailAndPassword();

      // Verify error message contains the original message
      expect(
        authController.errorMessage.value,
        contains('Authentication error: Some unknown error occurred'),
      );
    });
  });
}
