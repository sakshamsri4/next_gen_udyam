import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/admin_side_nav.dart';
import 'package:next_gen/app/shared/widgets/employee_bottom_nav.dart';
import 'package:next_gen/app/shared/widgets/employer_bottom_nav.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Factory class for creating role-specific navigation components
///
/// This class provides static methods to get the appropriate navigation component
/// based on the user's role. It handles both bottom navigation and drawer navigation.
class RoleBasedNavigationFactory {
  /// Private constructor to prevent instantiation
  RoleBasedNavigationFactory._();

  /// Get the appropriate bottom navigation bar based on user role
  ///
  /// Returns:
  /// - EmployeeBottomNav for UserType.employee
  /// - EmployerBottomNav for UserType.employer
  /// - Empty container for UserType.admin (uses side nav instead)
  /// - Empty container if role is null
  static Widget getBottomNav() {
    // Get the navigation controller to determine the user role
    late final NavigationController navigationController;
    try {
      navigationController = Get.find<NavigationController>();
    } catch (e) {
      // Handle the case where NavigationController is not found
      debugPrint('Error finding NavigationController: $e');

      // Try to log the error if LoggerService is available
      try {
        Get.find<LoggerService>().e('Error finding NavigationController', e);
      } catch (_) {
        // Silently ignore if LoggerService is not available
      }

      // Return an empty container if we can't find the controller
      return const SizedBox.shrink();
    }

    // Use Obx to observe the userRole
    return Obx(() {
      final userRole = navigationController.userRole.value;

      // Return the appropriate navigation component based on role
      switch (userRole) {
        case UserType.employee:
          return const EmployeeBottomNav();
        case UserType.employer:
          return const EmployerBottomNav();
        case UserType.admin:
          // Admin uses side nav, so return empty container for bottom nav
          return const SizedBox.shrink();
        case null:
          // Return empty container if role is null
          return const SizedBox.shrink();
      }
    });
  }

  /// Get the appropriate drawer navigation based on user role
  ///
  /// Returns:
  /// - AdminSideNav for UserType.admin
  /// - Custom drawer for other roles (to be implemented)
  /// - Empty container if role is null
  static Widget getDrawerNav() {
    // Get the navigation controller to determine the user role
    late final NavigationController navigationController;
    try {
      navigationController = Get.find<NavigationController>();
    } catch (e) {
      // Handle the case where NavigationController is not found
      debugPrint('Error finding NavigationController: $e');

      // Try to log the error if LoggerService is available
      try {
        Get.find<LoggerService>().e('Error finding NavigationController', e);
      } catch (_) {
        // Silently ignore if LoggerService is not available
      }

      // Return an empty container if we can't find the controller
      return const SizedBox.shrink();
    }

    // Use Obx to observe the userRole
    return Obx(() {
      final userRole = navigationController.userRole.value;

      // Return the appropriate navigation component based on role
      switch (userRole) {
        case UserType.admin:
          return const AdminSideNav();
        case UserType.employee:
        case UserType.employer:
          // For now, return empty container
          // TODO(developer): Implement role-specific drawers for employee and employer
          return const SizedBox.shrink();
        case null:
          // Return empty container if role is null
          return const SizedBox.shrink();
      }
    });
  }

  /// Check if the current role uses a bottom navigation bar
  ///
  /// Returns:
  /// - true for UserType.employee and UserType.employer
  /// - false for UserType.admin and null
  static bool usesBottomNav() {
    // Get the navigation controller to determine the user role
    late final NavigationController navigationController;
    try {
      navigationController = Get.find<NavigationController>();
      final userRole = navigationController.userRole.value;

      return userRole == UserType.employee || userRole == UserType.employer;
    } catch (e) {
      // Return false if we can't find the controller
      return false;
    }
  }

  /// Check if the current role uses a side navigation drawer
  ///
  /// Returns:
  /// - true for UserType.admin
  /// - false for other roles and null
  static bool usesSideNav() {
    // Get the navigation controller to determine the user role
    late final NavigationController navigationController;
    try {
      navigationController = Get.find<NavigationController>();
      final userRole = navigationController.userRole.value;

      return userRole == UserType.admin;
    } catch (e) {
      // Return false if we can't find the controller
      return false;
    }
  }
}
