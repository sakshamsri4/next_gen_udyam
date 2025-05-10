import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/company_profile/models/company_profile_model.dart';
import 'package:next_gen/app/modules/company_profile/services/company_profile_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the company profile screen
class CompanyProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// The company profile service
  final CompanyProfileService _profileService =
      Get.find<CompanyProfileService>();

  /// The auth controller
  final AuthController _authController = Get.find<AuthController>();

  /// The logger service
  final LoggerService _logger = Get.find<LoggerService>();

  /// The current user
  final Rx<User?> user = Rx<User?>(null);

  /// The company profile
  final Rx<CompanyProfileModel?> profile = Rx<CompanyProfileModel?>(null);

  /// Whether the profile is loading
  final RxBool isLoading = false.obs;

  /// Whether the profile is being updated
  final RxBool isUpdating = false.obs;

  /// Whether the profile is in edit mode
  final RxBool isEditMode = false.obs;

  /// The selected logo image
  final Rx<File?> selectedImage = Rx<File?>(null);

  /// The company jobs
  final RxList<Map<String, dynamic>> jobs = <Map<String, dynamic>>[].obs;

  /// Whether the jobs are loading
  final RxBool isJobsLoading = false.obs;

  /// The tab controller for the profile tabs
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    _logger.i('CompanyProfileController initialized');

    // Initialize tab controller
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        // Load jobs when switching to the jobs tab
        if (tabController.index == 1 && jobs.isEmpty && !isJobsLoading.value) {
          _loadCompanyJobs();
        }
      }
    });

    // Keep user in sync with AuthController
    user.bindStream(_authController.user.stream);

    // Listen for user changes and reload profile when user changes
    ever(user, (User? newUser) {
      if (newUser != null) {
        _loadProfile();
      } else {
        // Clear profile when user is null (signed out)
        profile.value = null;
        jobs.clear();
      }
    });

    // Initial load of the profile
    if (user.value != null) {
      _loadProfile();
    }
  }

  @override
  void onReady() {
    super.onReady();
    _logger.d('CompanyProfileController ready');
  }

  @override
  void onClose() {
    tabController.dispose();
    _logger.d('CompanyProfileController closed');
    super.onClose();
  }

  /// Load the company profile
  Future<void> _loadProfile() async {
    try {
      isLoading.value = true;
      _logger.i('Loading company profile');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      final companyProfile = await _profileService.getCurrentCompanyProfile();

      if (companyProfile != null) {
        profile.value = companyProfile;
        _logger.i('Company profile loaded successfully');
      } else {
        // Create a basic profile from the user data
        _logger.i('No profile found, creating a basic profile');
        final tempProfile = CompanyProfileModel(
          uid: user.value!.uid,
          name: user.value!.displayName ?? 'Company',
          email: user.value!.email ?? '',
          logoURL: user.value!.photoURL,
        );
        profile.value = tempProfile;

        // Persist the skeleton profile so that subsequent loads
        // hit the fast-path.
        await _profileService.updateCompanyProfile(
          uid: tempProfile.uid,
          name: tempProfile.name,
          email: tempProfile.email,
          logoURL: tempProfile.logoURL,
        );
      }
    } catch (e) {
      _logger.e('Error loading company profile', e);
      Get.snackbar(
        'Error',
        'Failed to load profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load company jobs
  Future<void> _loadCompanyJobs() async {
    try {
      isJobsLoading.value = true;
      _logger.i('Loading company jobs');

      if (profile.value == null) {
        _logger.w('No company profile loaded');
        return;
      }

      final companyJobs =
          await _profileService.getCompanyJobs(profile.value!.uid);
      jobs.value = companyJobs;
      _logger.i('Company jobs loaded successfully: ${jobs.length} jobs');
    } catch (e) {
      _logger.e('Error loading company jobs', e);
      Get.snackbar(
        'Error',
        'Failed to load jobs. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isJobsLoading.value = false;
    }
  }

  /// Refresh the profile
  Future<void> refreshProfile() async {
    await _loadProfile();
    if (tabController.index == 1) {
      await _loadCompanyJobs();
    }
  }

  /// Update the profile
  Future<void> updateProfile({
    String? name,
    String? website,
    String? description,
    String? industry,
    String? location,
    String? size,
    int? founded,
    Map<String, String>? socialLinks,
  }) async {
    try {
      isUpdating.value = true;
      _logger.i('Updating company profile');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      final updatedProfile = await _profileService.updateCompanyProfile(
        uid: user.value!.uid,
        name: name ?? profile.value!.name,
        email: profile.value!.email,
        logoURL: profile.value!.logoURL,
        website: website ?? profile.value!.website,
        description: description ?? profile.value!.description,
        industry: industry ?? profile.value!.industry,
        location: location ?? profile.value!.location,
        size: size ?? profile.value!.size,
        founded: founded ?? profile.value!.founded,
        socialLinks: socialLinks ?? profile.value!.socialLinks,
        logoImage: selectedImage.value,
      );

      if (updatedProfile != null) {
        profile.value = updatedProfile;
        _logger.i('Company profile updated successfully');

        // Update the user's display name in Firebase Auth
        if (name != null && name != user.value!.displayName) {
          await user.value!.updateDisplayName(name);
          await _authController.refreshUser();
        }

        // Update the user's photo URL in Firebase Auth
        if (selectedImage.value != null) {
          await user.value!.updatePhotoURL(updatedProfile.logoURL);
          await _authController.refreshUser();
        }

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _logger.e('Failed to update company profile');
        Get.snackbar(
          'Error',
          'Failed to update profile. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      _logger.e('Error updating company profile', e);
      Get.snackbar(
        'Error',
        'Failed to update profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
      isEditMode.value = false;
      selectedImage.value = null;
    }
  }

  /// Set the selected logo image
  void setSelectedImage(File image) {
    selectedImage.value = image;
  }

  /// Toggle edit mode
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }
}
