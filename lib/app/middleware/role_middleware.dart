import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
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
    _logger.d('RoleMiddleware: Checking if user has selected a role');

    // Get the auth controller
    final authController = Get.find<AuthController>();

    // If user is not logged in, redirect to login
    if (!authController.isLoggedIn) {
      _logger.d('RoleMiddleware: User not logged in, redirecting to login');
      return const RouteSettings(name: Routes.login);
    }

    // Get user from storage (this is synchronous)
    final userModel = _storageService.getUser();

    if (userModel == null || userModel.userType == null) {
      _logger.d(
        'RoleMiddleware: User has not selected a role, redirecting to role selection',
      );
      return const RouteSettings(name: Routes.roleSelection);
    }

    _logger.d('RoleMiddleware: User has selected role: ${userModel.userType}');
    return null; // No redirection needed
  }
}
