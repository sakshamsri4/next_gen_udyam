import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/middleware/auth_middleware.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';

import 'auth_middleware_test.mocks.dart';

@GenerateMocks([AuthController])
void main() {
  late MockAuthController mockAuthController;
  late AuthMiddleware authMiddleware;

  setUp(() {
    // Initialize GetX in test mode
    Get.testMode = true;

    // Create a mock for the AuthController
    mockAuthController = MockAuthController();

    // Important: define these mocks before any test runs
    when(mockAuthController.onStart()).thenReturn(null);
    when(mockAuthController.onInit()).thenReturn(null);

    // Create the middleware to test
    authMiddleware = AuthMiddleware();

    // Register the controller with GetX
    Get.put<AuthController>(mockAuthController);
  });

  tearDown(Get.reset);

  test('should redirect to home route if user is logged in', () {
    // Set up the mock controller to return logged in state
    when(mockAuthController.isLoggedIn).thenReturn(true.obs);

    // Call the redirect method
    final result = authMiddleware.redirect(Routes.auth);

    // Should be redirected to home
    expect(result, Routes.home);
  });

  test('should return null (allow access) if user is not logged in', () {
    // Set up the mock controller to return not logged in state
    when(mockAuthController.isLoggedIn).thenReturn(false.obs);

    // Call the redirect method
    final result = authMiddleware.redirect(Routes.auth);

    // Should not redirect
    expect(result, null);
  });

  test('should handle finding AuthController correctly', () {
    // We already put the mock controller in Get in setUp()

    // Call the redirect method
    authMiddleware.redirect(Routes.auth);

    // Verify the middleware could find the controller
    verify(mockAuthController.isLoggedIn).called(1);
  });
}
