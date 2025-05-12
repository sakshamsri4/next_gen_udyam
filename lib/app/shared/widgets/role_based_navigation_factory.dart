import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/admin_side_nav.dart';
import 'package:next_gen/app/shared/widgets/employee_drawer_nav.dart';
import 'package:next_gen/app/shared/widgets/employer_drawer_nav.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Factory class for creating role-specific navigation components
///
/// This class provides static methods to get the appropriate navigation component
/// based on the user's role. It handles both bottom navigation and drawer navigation.
class RoleBasedNavigationFactory {
  /// Private constructor to prevent instantiation
  RoleBasedNavigationFactory._();

  /// Cached instance of NavigationController to avoid repeated lookups
  static NavigationController? _cachedNavigationController;

  /// Cached instance of LoggerService to avoid repeated lookups
  static LoggerService? _cachedLoggerService;

  /// Initialize the factory by finding and caching required controllers
  /// This should be called early in the app lifecycle
  static void init() {
    try {
      _cachedNavigationController = Get.find<NavigationController>();
      _logInfo('NavigationController found and cached');
    } catch (e) {
      _logError('Error finding NavigationController', e);
    }

    try {
      _cachedLoggerService = Get.find<LoggerService>();
      _logInfo('LoggerService found and cached');
    } catch (e) {
      debugPrint('Error finding LoggerService: $e');
    }
  }

  /// Helper method to log info messages
  static void _logInfo(String message) {
    _cachedLoggerService?.i(message);
    if (_cachedLoggerService == null) {
      debugPrint(message);
    }
  }

  /// Helper method to log warning messages
  static void _logWarning(String message) {
    _cachedLoggerService?.w(message);
    if (_cachedLoggerService == null) {
      debugPrint('WARNING: $message');
    }
  }

  /// Helper method to log error messages
  static void _logError(
    String message,
    Object error, {
    StackTrace? stackTrace,
  }) {
    _cachedLoggerService?.e(message, error, stackTrace);
    if (_cachedLoggerService == null) {
      debugPrint('ERROR: $message: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  /// Get the NavigationController, initializing it if necessary
  static NavigationController? _getNavigationController() {
    if (_cachedNavigationController != null) {
      return _cachedNavigationController;
    }

    try {
      _cachedNavigationController = Get.find<NavigationController>();
      _logInfo('NavigationController found and cached');
      return _cachedNavigationController;
    } catch (e) {
      _logError('Error finding NavigationController', e);

      // Try to register the controller if it's not found
      try {
        _cachedNavigationController = Get.put(
          NavigationController(),
          permanent: true,
        );
        _logInfo('NavigationController registered and cached');
        return _cachedNavigationController;
      } catch (registerError) {
        _logError('Error registering NavigationController', registerError);
        return null;
      }
    }
  }

  /// Get the bottom navigation bar
  ///
  /// Returns a unified bottom navigation bar that adapts to the user's role.
  /// The UnifiedBottomNav handles role-specific styling and navigation internally.
  ///
  /// This method includes error handling to ensure a consistent UI even if there
  /// are issues with the navigation controller.
  ///
  /// Returns:
  /// - UnifiedBottomNav for all roles (which internally adapts to the role)
  static Widget getBottomNav() {
    try {
      // Ensure the navigation controller is registered
      if (!Get.isRegistered<NavigationController>()) {
        _logWarning(
          'NavigationController not registered when getting bottom nav',
        );

        // Register the controller if it's not found
        _cachedNavigationController = Get.put(
          NavigationController(),
          permanent: true,
        );
        _logInfo('NavigationController registered in getBottomNav');
      }

      return const UnifiedBottomNav();
    } catch (e, stackTrace) {
      _logError(
        'Error getting bottom navigation',
        e,
        stackTrace: stackTrace,
      );

      // Return a minimal bottom nav as fallback
      return Container(
        height: 56,
        color: Colors.white,
        child: const Center(
          child: Text(
            'Navigation unavailable',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }

  /// Get the appropriate drawer navigation based on user role
  ///
  /// Returns:
  /// - AdminSideNav for UserType.admin
  /// - Custom drawer for other roles (to be implemented)
  /// - Empty container if role is null
  static Widget getDrawerNav() {
    // Get the navigation controller to determine the user role
    final navigationController = _getNavigationController();
    if (navigationController == null) {
      return const SizedBox.shrink();
    }

    // Use a StatefulBuilder instead of Obx to avoid reactive state issues
    return StatefulBuilder(
      builder: (context, setState) {
        // Set up a listener for the userRole
        ever(navigationController.userRole, (_) {
          if (context.mounted) {
            setState(() {});
          }
        });

        final userRole = navigationController.userRole.value;

        // Return the appropriate navigation component based on role
        switch (userRole) {
          case UserType.admin:
            return const AdminSideNav();
          case UserType.employee:
            return const EmployeeDrawerNav();
          case UserType.employer:
            return const EmployerDrawerNav();
          case null:
            // Return empty container if role is null
            return const SizedBox.shrink();
        }
      },
    );
  }

  /// Check if the current role uses a bottom navigation bar
  ///
  /// Returns:
  /// - true for UserType.employee and UserType.employer
  /// - false for UserType.admin and null
  static bool usesBottomNav() {
    // Get the navigation controller to determine the user role
    final navigationController = _getNavigationController();
    if (navigationController == null) {
      return false;
    }

    final userRole = navigationController.userRole.value;
    return userRole == UserType.employee || userRole == UserType.employer;
  }

  /// Check if the current role uses a side navigation drawer
  ///
  /// All roles now use side navigation for consistency, but it's the primary
  /// navigation method only for admin users.
  ///
  /// Returns:
  /// - true for all valid user roles (admin, employee, employer)
  /// - false for null role
  static bool usesSideNav() {
    // Get the navigation controller to determine the user role
    final navigationController = _getNavigationController();
    if (navigationController == null) {
      return false;
    }

    final userRole = navigationController.userRole.value;
    return userRole != null;
  }
}
