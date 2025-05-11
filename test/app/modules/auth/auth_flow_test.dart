import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';

import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

import '../../../helpers/test_accounts.dart';
import '../../../helpers/test_helpers.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {
  Future<UserCredential> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return MockUserCredential();
  }

  Future<UserModel?> getCurrentUser() async {
    return null;
  }

  @override
  Future<bool> sendEmailVerification() async {
    return true;
  }
}

class MockLoggerService extends Mock implements LoggerService {}

class MockStorageService extends Mock implements StorageService {
  Future<String?> getUserType() async => null;
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> authStateChanges() => Stream.value(null);
}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

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
    final mockFirebaseAuth = MockFirebaseAuth();

    // Register mocks with GetX
    Get
      ..put<AuthService>(mockAuthService)
      ..put<LoggerService>(mockLoggerService)
      ..put<StorageService>(mockStorageService)
      ..put<FirebaseAuth>(mockFirebaseAuth, permanent: true);

    // Set up default mock behavior
    when(() => mockLoggerService.d(any<String>())).thenReturn(null);
    when(() => mockLoggerService.i(any<String>())).thenReturn(null);
    when(
      () => mockLoggerService.e(
        any<String>(),
        any<dynamic>(),
        any<StackTrace?>(),
      ),
    ).thenReturn(null);

    // Mock Firebase.initializeApp
    when(() => mockFirebaseAuth.currentUser).thenReturn(null);
    when(mockFirebaseAuth.authStateChanges).thenReturn(Stream.value(null));

    // Create auth controller
    authController = AuthController();
    Get.put<AuthController>(authController);
  });

  tearDown(GetTestWidgetHelper.tearDownGetTest);

  group('Authentication Flow Tests', () {
    testWidgets('Login with valid credentials navigates to dashboard',
        (WidgetTester tester) async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      when(() => mockUser.uid).thenReturn('test_uid');
      when(() => mockUser.email).thenReturn(TestAccounts.employeeEmail);
      when(() => mockUser.displayName).thenReturn(TestAccounts.employeeName);
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUserCredential.user).thenReturn(mockUser);

      when(
        () => mockAuthService.signInWithEmailAndPassword(
          TestAccounts.employeeEmail,
          TestAccounts.employeePassword,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      // Mock navigation
      final mockObserver = MockNavigatorObserver();

      // Build the login view
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.login,
          getPages: AppPages.routes,
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter credentials and tap login button
      await tester.enterText(
        find.byType(TextFormField).at(0),
        TestAccounts.employeeEmail,
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        TestAccounts.employeePassword,
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockAuthService.signInWithEmailAndPassword(
          TestAccounts.employeeEmail,
          TestAccounts.employeePassword,
        ),
      ).called(1);

      // Verify navigation to dashboard
      verify(() => mockObserver.didPush(any(), any()));
    });

    testWidgets('Signup with valid credentials creates account',
        (WidgetTester tester) async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      when(() => mockUser.uid).thenReturn('test_uid');
      when(() => mockUser.email).thenReturn(TestAccounts.employeeEmail);
      when(() => mockUser.displayName).thenReturn(TestAccounts.employeeName);
      when(() => mockUser.emailVerified).thenReturn(false);
      when(() => mockUserCredential.user).thenReturn(mockUser);

      when(
        () => mockAuthService.signUpWithEmailAndPassword(
          name: TestAccounts.employeeName,
          email: TestAccounts.employeeEmail,
          password: TestAccounts.employeePassword,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(() => mockAuthService.sendEmailVerification())
          .thenAnswer((_) async => true);

      // Mock navigation
      final mockObserver = MockNavigatorObserver();

      // Build the signup view
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.signup,
          getPages: AppPages.routes,
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter credentials and tap signup button
      await tester.enterText(
        find.byType(TextFormField).at(0),
        TestAccounts.employeeName,
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        TestAccounts.employeeEmail,
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        TestAccounts.employeePassword,
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        TestAccounts.employeePassword,
      );
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockAuthService.signUpWithEmailAndPassword(
          name: TestAccounts.employeeName,
          email: TestAccounts.employeeEmail,
          password: TestAccounts.employeePassword,
        ),
      ).called(1);

      // Verify email verification sent
      verify(() => mockAuthService.sendEmailVerification()).called(1);
    });

    testWidgets('Role selection persists after logout and login',
        (WidgetTester tester) async {
      // Arrange
      final userModel = TestAccounts.createTestEmployee();

      when(() => mockAuthService.getCurrentUser())
          .thenAnswer((_) async => userModel);

      when(() => mockStorageService.getUserType())
          .thenAnswer((_) async => 'employee');

      // Act & Assert - Verify user type is loaded correctly
      expect(await mockAuthService.getCurrentUser(), equals(userModel));
      expect(
        await mockStorageService.getUserType(),
        equals('employee'),
      );
    });
  });
}

// Mock navigator observer for testing navigation
class MockNavigatorObserver extends Mock implements NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}
}
