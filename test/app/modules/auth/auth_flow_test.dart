import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/auth/views/login_view.dart';
import 'package:next_gen/app/modules/auth/views/signup_view.dart';
import 'package:next_gen/app/modules/auth/views/verification_success_view.dart';
import 'package:next_gen/app/modules/auth/views/welcome_view.dart';
import 'package:next_gen/app/modules/role_selection/controllers/role_selection_controller.dart';
import 'package:next_gen/app/modules/role_selection/views/role_selection_view.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

import 'auth_flow_test.mocks.dart';

// Generate mocks for the dependencies
@GenerateMocks([
  AuthService,
  LoggerService,
  StorageService,
  UserCredential,
  User,
  FirebaseAuth,
])
void main() {
  late MockAuthService mockAuthService;
  late MockLoggerService mockLoggerService;
  late MockStorageService mockStorageService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    // Create mocks
    mockAuthService = MockAuthService();
    mockLoggerService = MockLoggerService();
    mockStorageService = MockStorageService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockFirebaseAuth = MockFirebaseAuth();

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
    Get.put<StorageService>(mockStorageService);
  });

  tearDown(Get.reset);

  group('Authentication Flow - Phase 4 Tests', () {
    testWidgets('Complete signup to role selection flow',
        (WidgetTester tester) async {
      // Arrange
      when(mockAuthService.registerWithEmailAndPassword(any, any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockAuthService.updateUserProfile(
              displayName: anyNamed('displayName')))
          .thenAnswer((_) async => {});
      when(mockAuthService.getUserFromFirebase()).thenAnswer(
        (_) async => UserModel(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
        ),
      );

      // Build the signup view
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.signup,
          getPages: [
            GetPage(
              name: Routes.signup,
              page: () => const SignupView(),
              binding: BindingsBuilder(() {
                Get.put(AuthController());
              }),
            ),
            GetPage(
              name: Routes.roleSelection,
              page: () => const RoleSelectionView(),
              binding: BindingsBuilder(() {
                Get.put(
                  RoleSelectionController(
                    authController: Get.find<AuthController>(),
                    storageService: mockStorageService,
                    loggerService: mockLoggerService,
                  ),
                );
              }),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Fill in the signup form
      await tester.enterText(find.byKey(const Key('nameField')), 'Test User');
      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'Password123!');
      await tester.enterText(
          find.byKey(const Key('confirmPasswordField')), 'Password123!');

      // Tap the signup button
      await tester.tap(find.byKey(const Key('signupButton')));
      await tester.pumpAndSettle();

      // Verify navigation to role selection
      expect(find.byType(RoleSelectionView), findsOneWidget);

      // Verify the auth service was called correctly
      verify(mockAuthService.registerWithEmailAndPassword(
              'test@example.com', 'Password123!'))
          .called(1);
      verify(mockAuthService.updateUserProfile(displayName: 'Test User'))
          .called(1);
    });

    testWidgets('Verification success to role selection flow',
        (WidgetTester tester) async {
      // Arrange
      when(mockAuthService.getUserFromFirebase()).thenAnswer(
        (_) async => UserModel(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
        ),
      );

      // Build the verification success view
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.verificationSuccess,
          getPages: [
            GetPage(
              name: Routes.verificationSuccess,
              page: () => const VerificationSuccessView(),
              binding: BindingsBuilder(() {
                final authController = AuthController();
                authController.user.value = mockUser;
                Get.put(authController);
              }),
            ),
            GetPage(
              name: Routes.roleSelection,
              page: () => const RoleSelectionView(),
              binding: BindingsBuilder(() {
                Get.put(
                  RoleSelectionController(
                    authController: Get.find<AuthController>(),
                    storageService: mockStorageService,
                    loggerService: mockLoggerService,
                  ),
                );
              }),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Tap the continue button
      await tester.tap(find.text('CONTINUE'));
      await tester.pumpAndSettle();

      // Verify navigation to role selection
      expect(find.byType(RoleSelectionView), findsOneWidget);

      // Verify the auth service was called correctly
      verify(mockAuthService.getUserFromFirebase()).called(1);
    });

    testWidgets('Welcome screen to role selection flow',
        (WidgetTester tester) async {
      // Arrange
      when(mockAuthService.getUserFromFirebase()).thenAnswer(
        (_) async => UserModel(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
        ),
      );

      // Build the welcome view
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.welcome,
          getPages: [
            GetPage(
              name: Routes.welcome,
              page: () => const WelcomeView(),
              binding: BindingsBuilder(() {
                final authController = AuthController();
                authController.user.value = mockUser;
                Get.put(authController);
              }),
            ),
            GetPage(
              name: Routes.roleSelection,
              page: () => const RoleSelectionView(),
              binding: BindingsBuilder(() {
                Get.put(
                  RoleSelectionController(
                    authController: Get.find<AuthController>(),
                    storageService: mockStorageService,
                    loggerService: mockLoggerService,
                  ),
                );
              }),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Tap the continue button
      await tester.tap(find.text('CONTINUE'));
      await tester.pumpAndSettle();

      // Verify navigation to role selection
      expect(find.byType(RoleSelectionView), findsOneWidget);

      // Verify the auth service was called correctly
      verify(mockAuthService.getUserFromFirebase()).called(1);
    });
  });
}
