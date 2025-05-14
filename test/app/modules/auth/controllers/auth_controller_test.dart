import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/signup_session.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

import 'auth_controller_test.mocks.dart';

// Generate mocks for the dependencies
@GenerateMocks([AuthService, LoggerService, UserCredential, User])
void main() {
  late AuthController controller;
  late MockAuthService mockAuthService;
  late MockLoggerService mockLoggerService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    // Create mocks
    mockAuthService = MockAuthService();
    mockLoggerService = MockLoggerService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    // Set up mock user
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.displayName).thenReturn('Test User');
    when(mockUser.emailVerified).thenReturn(false);

    // Initialize GetX
    Get.reset();

    // Register the mock services
    Get.put<LoggerService>(mockLoggerService);
    Get.put<AuthService>(mockAuthService);

    // Create the controller
    controller = AuthController();
  });

  tearDown(Get.reset);

  group('AuthController - Phase 4 Authentication Flow Tests', () {
    test('signup should navigate to role selection after successful signup',
        () async {
      // Arrange
      when(mockAuthService.registerWithEmailAndPassword(any, any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockAuthService.updateUserProfile(
              displayName: anyNamed('displayName')))
          .thenAnswer((_) async => {});

      // Fill in the form fields
      controller.nameController.text = 'Test User';
      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'Password123!';
      controller.confirmPasswordController.text = 'Password123!';

      // Mock the navigation
      final mockRoute = RxString('');
      Get.routing = Routing(
        current: mockRoute,
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      Get.testMode = true;

      // Act
      await controller.signup();

      // Assert
      verify(mockAuthService.registerWithEmailAndPassword(
              'test@example.com', 'Password123!'))
          .called(1);
      verify(mockAuthService.updateUserProfile(displayName: 'Test User'))
          .called(1);
      expect(mockRoute.value, Routes.roleSelection);
    });

    test(
        'signInWithGoogle should navigate to role selection if user has no role',
        () async {
      // Arrange
      when(mockAuthService.signInWithGoogle())
          .thenAnswer((_) async => mockUserCredential);
      when(mockAuthService.getUserFromFirebase()).thenAnswer(
        (_) async => UserModel(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
        ),
      );

      // Mock the navigation
      final mockRoute = RxString('');
      Get.routing = Routing(
        current: mockRoute,
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      Get.testMode = true;

      // Act
      await controller.signInWithGoogle();

      // Assert
      verify(mockAuthService.signInWithGoogle()).called(1);
      verify(mockAuthService.getUserFromFirebase()).called(1);
      expect(mockRoute.value, Routes.roleSelection);
    });

    test('signInWithGoogle should navigate to dashboard if user has a role',
        () async {
      // Arrange
      when(mockAuthService.signInWithGoogle())
          .thenAnswer((_) async => mockUserCredential);
      when(mockAuthService.getUserFromFirebase()).thenAnswer(
        (_) async => UserModel(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          userType: UserType.employee, // Role is selected
        ),
      );

      // Mock the navigation
      final mockRoute = RxString('');
      Get.routing = Routing(
        current: mockRoute,
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      Get.testMode = true;

      // Act
      await controller.signInWithGoogle();

      // Assert
      verify(mockAuthService.signInWithGoogle()).called(1);
      verify(mockAuthService.getUserFromFirebase()).called(1);
      expect(mockRoute.value, Routes.dashboard);
    });

    test('saveSignupSession should save the current signup state', () async {
      // Arrange
      when(mockAuthService.saveSignupSession(any)).thenAnswer((_) async => {});

      // Act
      await controller.saveSignupSession(step: SignupStep.accountCreated);

      // Assert
      verify(
        mockAuthService.saveSignupSession(
          argThat(
            predicate<SignupSession>(
              (session) =>
                  session.step == SignupStep.accountCreated &&
                  session.email == controller.emailController.text,
            ),
          ),
        ),
      ).called(1);
      expect(controller.currentSignupStep.value, SignupStep.accountCreated);
    });

    test(
        'checkEmailVerification should navigate to verification success when email is verified',
        () async {
      // Arrange
      when(mockUser.emailVerified).thenReturn(true);
      controller.user.value = mockUser;

      // Mock the navigation
      final mockRoute = RxString('');
      Get.routing = Routing(
        current: mockRoute,
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      Get.testMode = true;

      // Set current signup step
      controller.currentSignupStep.value = SignupStep.verificationSent;

      // Act
      await controller.checkEmailVerification();

      // Assert
      expect(mockRoute.value, Routes.verificationSuccess);
    });
  });
}
