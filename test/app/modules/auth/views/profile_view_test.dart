import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/views/profile_view.dart';

// Create a test implementation of AuthController instead of using Mockito
class TestAuthController extends GetxController implements AuthController {
  TestAuthController({
    UserModel? initialUser,
    bool initialLoading = false,
  })  : user = Rx<UserModel?>(initialUser),
        isLoading = initialLoading.obs;
  @override
  final Rx<UserModel?> user;

  @override
  final RxBool isLoading;

  bool signOutCalled = false;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  // Implement other required methods with minimal functionality
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  final testUser = UserModel(
    uid: 'test-uid',
    email: 'test@example.com',
    displayName: 'Test User',
    emailVerified: true,
    createdAt: DateTime(2023),
  );

  // Helper function to pump the widget with necessary bindings
  Future<void> pumpProfileView(
    WidgetTester tester,
    TestAuthController controller,
  ) async {
    // Set up GetX
    Get
      ..reset()
      ..testMode = true

      // Register the test controller
      ..put<AuthController>(controller);

    // Use GetMaterialApp directly
    await tester.pumpWidget(
      const GetMaterialApp(
        home: ProfileView(),
      ),
    );
    await tester.pump();
  }

  testWidgets('ProfileView renders correctly with user data', (tester) async {
    // Arrange - Create controller with test user
    final controller = TestAuthController(initialUser: testUser);
    await pumpProfileView(tester, controller);

    // Assert - Check that UI elements are displayed correctly
    expect(find.text('My Profile'), findsOneWidget); // AppBar title
    expect(find.byIcon(Icons.logout), findsOneWidget); // Logout button
    expect(find.text(testUser.displayName!), findsOneWidget); // User name
    expect(find.text(testUser.email), findsOneWidget); // User email
    expect(find.text('Account Information'), findsOneWidget);
    expect(find.text('Email Verification'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget); // Email verified status
    expect(find.text('Account Created'), findsOneWidget);
    expect(find.text('EDIT PROFILE'), findsOneWidget); // Edit profile button
  });

  testWidgets('ProfileView shows loading indicator when isLoading is true',
      (tester) async {
    // Arrange - Create controller with loading state
    final controller =
        TestAuthController(initialUser: testUser, initialLoading: true);
    await pumpProfileView(tester, controller);

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      find.text(testUser.displayName!),
      findsNothing,
    ); // User data not shown
  });

  testWidgets('ProfileView shows message when user is null', (tester) async {
    // Arrange - Create controller with null user
    final controller = TestAuthController();
    await pumpProfileView(tester, controller);

    // Assert
    expect(find.text('User not found. Please login again.'), findsOneWidget);
    expect(
      find.text('Account Information'),
      findsNothing,
    ); // User data not shown
  });

  testWidgets('ProfileView shows unverified status when email not verified',
      (tester) async {
    // Arrange - Create controller with unverified user
    final unverifiedUser = testUser.copyWith(emailVerified: false);
    final controller = TestAuthController(initialUser: unverifiedUser);
    await pumpProfileView(tester, controller);

    // Assert
    expect(find.text('Not verified - Please check your email'), findsOneWidget);
    expect(find.byIcon(Icons.warning), findsOneWidget);
  });

  testWidgets('Tapping logout icon calls signOut on controller',
      (tester) async {
    // Arrange - Create controller and pump widget
    final controller = TestAuthController(initialUser: testUser);
    await pumpProfileView(tester, controller);

    // Act - Tap the logout icon
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Find and tap the LOGOUT button in the confirmation dialog
    await tester.tap(find.text('LOGOUT'));
    await tester.pumpAndSettle();

    // Assert that signOut was called
    expect(controller.signOutCalled, true);
  });
}
