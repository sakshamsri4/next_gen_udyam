import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_navigation_factory.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the NavigationController
class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Get logger if available
    LoggerService? logger;
    try {
      logger = Get.find<LoggerService>();
    } catch (e) {
      debugPrint('LoggerService not available during NavigationBinding: $e');
    }

    // Check if NavigationController is already registered
    if (!Get.isRegistered<NavigationController>()) {
      // Register the controller if it's not already registered
      Get.put<NavigationController>(
        NavigationController(),
        permanent: true,
      );
      logger?.i('NavigationController registered in NavigationBinding');
    } else {
      logger
          ?.d('NavigationController already registered, skipping registration');
    }

    // Initialize the RoleBasedNavigationFactory
    try {
      RoleBasedNavigationFactory.init();
      logger?.i('RoleBasedNavigationFactory initialized in NavigationBinding');
    } catch (e) {
      logger?.e('Failed to initialize RoleBasedNavigationFactory', e);
      debugPrint('Failed to initialize RoleBasedNavigationFactory: $e');
    }
  }
}
