import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/views/login_view.dart';
import 'package:next_gen/core/theme/app_theme.dart';

// Mock classes
class MockAuthController extends GetxController
    with Mock
    implements AuthController {
  @override
  final RxBool isLoading = false.obs;

  @override
  final RxString errorMessage = ''.obs;

  @override
  final TextEditingController emailController = TextEditingController();

  @override
  final TextEditingController passwordController = TextEditingController();

  @override
  Future<void> signInWithEmailAndPassword() async {
    // Mock implementation
  }

  @override
  Future<void> signInWithGoogle() async {
    // Mock implementation
  }

  @override
  Future<void> resetPassword() async {
    // Mock implementation
  }
}

void main() {
  late MockAuthController mockController;

  setUp(() {
    mockController = MockAuthController();

    // Set up GetX test environment
    Get.testMode = true;
    Get.put<AuthController>(mockController);
  });

  tearDown(Get.reset);

  testWidgets('LoginView displays all required elements',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const LoginView(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('Next Gen Job Portal'), findsOneWidget);

    // Verify that the email and password fields are displayed
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify that the login button is displayed
    expect(find.text('LOGIN'), findsOneWidget);

    // Verify that the Google sign-in button is displayed
    expect(find.text('Sign in with Google'), findsOneWidget);

    // Verify that the forgot password link is displayed
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Verify that the sign-up link is displayed
    expect(find.textContaining("Don't have an account"), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('LoginView shows error message when provided',
      (WidgetTester tester) async {
    // Set error message
    mockController.errorMessage.value = 'Invalid credentials';

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const LoginView(),
      ),
    );

    // Verify that the error message is displayed
    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  // Add more widget tests for interactions
}
