import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

/// Middleware to check if user has selected a role
class RoleMiddleware extends GetMiddleware {
  /// Constructor
  RoleMiddleware({int? priority}) : super(priority: priority ?? 3);

  final LoggerService _logger = Get.find<LoggerService>();
  final StorageService _storageService = Get.find<StorageService>();

  @override
  RouteSettings? redirect(String? route) {
    _logger.d(
      'RoleMiddleware: Checking if user has selected a role for route: $route',
    );

    // Skip role check for role selection route itself to avoid infinite redirects
    if (route == Routes.roleSelection) {
      _logger.d(
        'RoleMiddleware: Already on role selection screen, skipping check',
      );
      return null;
    }

    // Skip role check for auth-related routes
    final authRoutes = [
      Routes.login,
      Routes.signup,
      Routes.forgotPassword,
      Routes.auth,
      Routes.onboarding,
    ];

    if (authRoutes.contains(route)) {
      _logger.d(
        'RoleMiddleware: Route $route is auth-related, skipping role check',
      );
      return null;
    }

    // Get the auth controller
    AuthController? authController;
    try {
      authController = Get.find<AuthController>();
    } catch (e) {
      _logger.w('RoleMiddleware: AuthController not found, registering it now');
      // Register the controller if it's not found
      authController = Get.put<AuthController>(
        AuthController(),
        permanent: true,
      );
    }

    // If user is not logged in, redirect to login
    if (authController.user.value == null) {
      _logger.d('RoleMiddleware: User not logged in, redirecting to login');
      return const RouteSettings(name: Routes.login);
    }

    // Try to get user from storage (this is synchronous)
    UserModel? userModel;
    try {
      userModel = _storageService.getUser();
      _logger
          .d('RoleMiddleware: User model from storage: ${userModel?.toMap()}');
    } catch (e) {
      _logger.e('RoleMiddleware: Error getting user from storage', e);
      // Continue with null userModel
    }

    // If user model is null or has no role, try to get it from Firebase
    if (userModel == null || userModel.userType == null) {
      _logger
        ..d('RoleMiddleware: User has no role in storage, checking Firebase')
        ..d('RoleMiddleware: Redirecting to role selection');

      return const RouteSettings(name: Routes.roleSelection);
    }

    _logger.d('RoleMiddleware: User has selected role: ${userModel.userType}');
    return null; // No redirection needed
  }
}
