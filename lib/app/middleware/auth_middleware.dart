import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Middleware to handle authentication state and redirects
class AuthMiddleware extends GetMiddleware {
  AuthMiddleware() {
    try {
      _logger = Get.find<LoggerService>();
    } catch (e) {
      // Fallback if logger is not available
      _logger = Get.put(LoggerService(), permanent: true);
    }
  }
  late final LoggerService _logger;

  @override
  int? get priority => 2; // Lower priority than OnboardingMiddleware

  @override
  RouteSettings? redirect(String? route) {
    _logger.d('AuthMiddleware.redirect called for route: $route');

    // Skip auth check for these routes
    final publicRoutes = [Routes.onboarding];
    if (publicRoutes.contains(route)) {
      _logger.d('Route $route is public, skipping auth check');
      return null;
    }

    // Try to get the auth controller
    AuthController? authController;
    try {
      authController = Get.find<AuthController>();
      _logger.d('AuthController found');
    } catch (e) {
      _logger.w('AuthController not found, registering it now');
      // Register the controller if it's not found
      authController = Get.put<AuthController>(
        AuthController(),
        permanent: true,
      );
    }

    // If the user is logged in, redirect to home
    // Otherwise, continue to the auth page
    if (authController.user.value != null) {
      // Don't redirect if already on home or a protected route
      if (route == Routes.home) {
        _logger.d('Already on home route, no redirect needed');
        return null;
      }

      _logger.i('User is logged in, redirecting to home');
      return const RouteSettings(name: Routes.home);
    }

    _logger.d('User is not logged in, continuing to requested route');
    return null;
  }
}
