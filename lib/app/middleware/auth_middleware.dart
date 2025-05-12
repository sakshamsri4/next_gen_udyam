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
    final publicRoutes = [
      Routes.onboarding,
      Routes.login,
      Routes.signup,
      Routes.forgotPassword,
      Routes.auth,
    ];

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

    // If the user is logged in, allow access to protected routes
    // Otherwise, redirect to login
    if (authController.user.value != null) {
      // List of protected routes that should be accessible when logged in
      final protectedRoutes = [
        Routes.dashboard,
        Routes.jobs,
        Routes.resume,
        Routes.profile,
        Routes.customerProfile,
        Routes.companyProfile,
        Routes.search,
        Routes.applications,
        Routes.savedJobs,
        Routes.roleSelection,
        Routes.settings,
      ];

      // If the route is a protected route, allow access
      if (protectedRoutes.contains(route)) {
        _logger
            .d('User is logged in, allowing access to protected route: $route');
        return null;
      }

      // If not on a protected route, redirect to dashboard
      _logger.i(
        'User is logged in but not on a protected route, '
        'redirecting to dashboard',
      );
      return const RouteSettings(name: Routes.dashboard);
    }

    // If user is not logged in and trying
    // to access a protected route, redirect to login
    final protectedRoutes = [
      Routes.dashboard,
      Routes.jobs,
      Routes.resume,
      Routes.profile,
      Routes.customerProfile,
      Routes.companyProfile,
      Routes.search,
      Routes.applications,
      Routes.savedJobs,
      Routes.roleSelection,
      Routes.settings,
    ];

    if (protectedRoutes.contains(route)) {
      _logger.i('User is not logged in, redirecting to login');
      return const RouteSettings(name: Routes.login);
    }

    _logger.d('User is not logged in, continuing to requested route');
    return null;
  }
}
