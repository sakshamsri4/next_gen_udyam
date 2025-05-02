import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:logger/logger.dart';
import 'package:next_gen/app/modules/onboarding/models/onboarding_info.dart';
import 'package:next_gen/app/modules/onboarding/models/onboarding_status.dart';
import 'package:next_gen/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  final Logger _logger = Logger();

  // Store the key provided by the view
  GlobalKey<IntroductionScreenState>? _introKey;

  /// Register the IntroductionScreen key from the view
  // ignore: use_setters_to_change_properties
  void registerIntroKey(GlobalKey<IntroductionScreenState> key) {
    _introKey = key;
    // Using a method instead of a setter because it's clearer in this context
    // and we don't need a corresponding getter
  }

  final RxBool isLoading = false.obs;
  final RxInt currentPage = 0.obs;
  final RxList<OnboardingInfo> pages = onboardingPages.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeOnboarding();
  }

  Future<void> _initializeOnboarding() async {
    try {
      isLoading.value = true;
      // Initialize any required services
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      _logger.e('Error initializing onboarding: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize onboarding. Please restart the app.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Using a method instead of a setter because this is called by
  // IntroductionScreen which expects a method with this signature
  // ignore: use_setters_to_change_properties
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> onDone() async {
    try {
      isLoading.value = true;

      // Mark onboarding as complete in Hive
      final box = await Hive.openBox<OnboardingStatus>(onboardingStatusBoxName);
      final status = OnboardingStatus(hasCompletedOnboarding: true);
      await box.put('status', status);
      _logger.i('Onboarding marked as complete');

      isLoading.value = false;
      await Get.offAllNamed<dynamic>(Routes.login);
    } catch (e) {
      isLoading.value = false;
      _logger.e('Error completing onboarding: $e');
      Get.snackbar(
        'Error',
        'Failed to complete onboarding. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void onSkip() {
    onDone();
  }

  void goToNextPage() {
    _introKey?.currentState?.animateScroll(currentPage.value + 1);
  }

  void goToPreviousPage() {
    _introKey?.currentState?.animateScroll(currentPage.value - 1);
  }

  Future<bool> checkOnboardingStatus() async {
    try {
      // Check if onboarding is completed in Hive
      final box = await Hive.openBox<OnboardingStatus>(onboardingStatusBoxName);
      final status = box.get('status');
      return status?.hasCompletedOnboarding ?? false;
    } catch (e) {
      _logger.e('Error checking onboarding status: $e');
      return false;
    }
  }

  // Synchronous version for middleware
  bool? checkOnboardingStatusSync() {
    try {
      // Try to get the box if it's already open
      if (Hive.isBoxOpen(onboardingStatusBoxName)) {
        final box = Hive.box<OnboardingStatus>(onboardingStatusBoxName);
        final status = box.get('status');
        return status?.hasCompletedOnboarding ?? false;
      }

      // If the box isn't open, we can't check synchronously
      // Default to false to show onboarding
      return false;
    } catch (e) {
      _logger.e('Error checking onboarding status synchronously: $e');
      return false;
    }
  }

  Future<void> resetOnboardingStatus() async {
    try {
      // Reset onboarding status in Hive
      final box = await Hive.openBox<OnboardingStatus>(onboardingStatusBoxName);
      final status = OnboardingStatus();
      await box.put('status', status);
      _logger.i('Onboarding status reset');
    } catch (e) {
      _logger.e('Error resetting onboarding status: $e');
    }
  }
}
