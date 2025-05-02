import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:next_gen/app/modules/onboarding/models/onboarding_status.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

class OnboardingMiddleware extends GetMiddleware {
  OnboardingMiddleware() {
    try {
      _logger = Get.find<LoggerService>();
    } catch (e) {
      // Fallback if logger is not available
      _logger = Get.put(LoggerService(), permanent: true);
    }
  }
  late final LoggerService _logger;

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Skip onboarding if user is already logged in
    final currentUser = FirebaseAuth.instance.currentUser;

    // If user is logged in, no need to show onboarding
    if (currentUser != null) {
      _logger.d('User is already logged in, skipping onboarding check');
      return null;
    }

    // First check if this is a fresh install by looking for any existing
    // Hive data
    final isFreshInstall = _isFreshInstall();

    // If it's not a fresh install and we have any previous data,
    // skip onboarding
    if (!isFreshInstall) {
      _logger.d('Not a fresh install, skipping onboarding');
      return null;
    }

    // For fresh installs, check if the user has completed onboarding
    var hasCompletedOnboarding = false;

    try {
      // Try to get onboarding status from Hive
      final box = Hive.box<OnboardingStatus>(onboardingStatusBoxName);
      final status = box.get('status');
      hasCompletedOnboarding = status?.hasCompletedOnboarding ?? false;
      _logger.d('Onboarding status from Hive: $hasCompletedOnboarding');
    } catch (e) {
      // If there's an error accessing Hive, try to use the controller
      _logger.w('Error accessing Hive for onboarding status', e);

      // Try to find the controller if it exists
      OnboardingController? controller;
      try {
        controller = Get.find<OnboardingController>();
      } catch (e) {
        // Controller not found, create it
        controller = Get.put(OnboardingController());
      }

      // Use the synchronous version as fallback
      hasCompletedOnboarding = controller?.checkOnboardingStatusSync() ?? false;
      _logger.d('Onboarding status from controller: $hasCompletedOnboarding');
    }

    // If onboarding is not completed and we're not already on the
    // onboarding route, redirect to onboarding
    if (!hasCompletedOnboarding &&
        route != null &&
        route != Routes.onboarding &&
        Get.currentRoute != Routes.onboarding) {
      _logger.i('Redirecting to onboarding');
      return const RouteSettings(name: Routes.onboarding);
    }

    return null; // No redirection needed
  }

  // Check if this is a fresh install by looking for any existing Hive data
  bool _isFreshInstall() {
    try {
      // Check if the user box exists and has data
      if (Hive.isBoxOpen('user_box')) {
        final userBox = Hive.box<UserModel>('user_box');
        if (userBox.isNotEmpty) {
          _logger.d('Found existing user data, not a fresh install');
          return false;
        }
      }

      // Check if the onboarding status box exists and has data
      if (Hive.isBoxOpen(onboardingStatusBoxName)) {
        final onboardingBox =
            Hive.box<OnboardingStatus>(onboardingStatusBoxName);
        if (onboardingBox.isNotEmpty) {
          _logger.d('Found existing onboarding data, not a fresh install');
          return false;
        }
      }

      // If we reach here, no existing data was found
      _logger.i('No existing data found, treating as fresh install');
      return true;
    } catch (e) {
      // If there's an error, assume it's not a fresh install to be safe
      _logger.w('Error checking if fresh install, assuming not fresh', e);
      return false;
    }
  }
}
