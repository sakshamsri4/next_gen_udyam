import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/customer_profile/models/customer_profile_model.dart';
import 'package:next_gen/app/modules/customer_profile/services/customer_profile_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the customer profile screen
class CustomerProfileController extends GetxController {
  /// The customer profile service
  final CustomerProfileService _profileService =
      Get.find<CustomerProfileService>();

  /// The auth controller
  final AuthController _authController = Get.find<AuthController>();

  /// The logger service
  final LoggerService _logger = Get.find<LoggerService>();

  /// The current user
  final Rx<User?> user = Rx<User?>(null);

  /// The customer profile
  final Rx<CustomerProfileModel?> profile = Rx<CustomerProfileModel?>(null);

  /// Whether the profile is loading
  final RxBool isLoading = false.obs;

  /// Whether the profile is being updated
  final RxBool isUpdating = false.obs;

  /// Whether the profile is in edit mode
  final RxBool isEditMode = false.obs;

  /// The selected profile image
  final Rx<File?> selectedImage = Rx<File?>(null);

  /// The tab controller for the profile tabs
  final RxInt selectedTabIndex = 0.obs;

  /// Profile completeness percentage (0.0 to 1.0)
  final RxDouble profileCompleteness = 0.0.obs;

  /// Map of skill ratings (skill name -> rating 0-5)
  final RxMap<String, int> skillRatings = <String, int>{}.obs;

  /// Custom skill text controller
  final TextEditingController customSkillController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _logger.i('CustomerProfileController initialized');

    // Get the current user
    user.value = _authController.user.value;

    // Load the profile
    _loadProfile();
  }

  @override
  void onReady() {
    super.onReady();
    _logger.d('CustomerProfileController ready');
  }

  @override
  void onClose() {
    _logger.d('CustomerProfileController closed');
    customSkillController.dispose();
    super.onClose();
  }

  /// Load the customer profile
  Future<void> _loadProfile() async {
    try {
      isLoading.value = true;
      _logger.i('Loading customer profile');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      final customerProfile = await _profileService.getCurrentUserProfile();

      if (customerProfile != null) {
        profile.value = customerProfile;
        _logger.i('Customer profile loaded successfully');
      } else {
        // Create a basic profile from the user data
        _logger.i('No profile found, creating a basic profile');
        profile.value = CustomerProfileModel(
          uid: user.value!.uid,
          name: user.value!.displayName ?? 'User',
          email: user.value!.email ?? '',
          photoURL: user.value!.photoURL,
        );
      }

      // Calculate profile completeness
      _calculateProfileCompleteness();
    } catch (e) {
      _logger.e('Error loading customer profile', e);
      Get.snackbar(
        'Error',
        'Failed to load profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh the profile
  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  /// Update the profile
  Future<void> updateProfile({
    String? name,
    String? jobTitle,
    String? description,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? skills,
    List<Language>? languages,
  }) async {
    try {
      isUpdating.value = true;
      _logger.i('Updating customer profile');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      final updatedProfile = await _profileService.updateProfile(
        uid: user.value!.uid,
        name: name ?? profile.value!.name,
        email: profile.value!.email,
        photoURL: profile.value!.photoURL,
        jobTitle: jobTitle ?? profile.value!.jobTitle,
        description: description ?? profile.value!.description,
        workExperience: workExperience ?? profile.value!.workExperience,
        education: education ?? profile.value!.education,
        skills: skills ?? profile.value!.skills,
        languages: languages ?? profile.value!.languages,
        profileImage: selectedImage.value,
      );

      if (updatedProfile != null) {
        profile.value = updatedProfile;
        _logger.i('Customer profile updated successfully');

        // Update the user's display name in Firebase Auth
        if (name != null && name != user.value!.displayName) {
          await user.value!.updateDisplayName(name);
          await _authController.refreshUser();
        }

        // Update the user's photo URL in Firebase Auth
        if (selectedImage.value != null) {
          await user.value!.updatePhotoURL(updatedProfile.photoURL);
          await _authController.refreshUser();
        }

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _logger.e('Failed to update customer profile');
        Get.snackbar(
          'Error',
          'Failed to update profile. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      _logger.e('Error updating customer profile', e);
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

  /// Add work experience
  Future<void> addWorkExperience(WorkExperience experience) async {
    try {
      isUpdating.value = true;
      _logger.i('Adding work experience');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      final success = await _profileService.addWorkExperience(
        uid: user.value!.uid,
        experience: experience,
      );

      if (success) {
        await refreshProfile();
        _logger.i('Work experience added successfully');
        Get.snackbar(
          'Success',
          'Work experience added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _logger.e('Failed to add work experience');
        Get.snackbar(
          'Error',
          'Failed to add work experience. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      _logger.e('Error adding work experience', e);
      Get.snackbar(
        'Error',
        'Failed to add work experience. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Add education
  Future<void> addEducation(Education education) async {
    try {
      isUpdating.value = true;
      _logger.i('Adding education');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      final success = await _profileService.addEducation(
        uid: user.value!.uid,
        education: education,
      );

      if (success) {
        await refreshProfile();
        _logger.i('Education added successfully');
        Get.snackbar(
          'Success',
          'Education added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _logger.e('Failed to add education');
        Get.snackbar(
          'Error',
          'Failed to add education. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      _logger.e('Error adding education', e);
      Get.snackbar(
        'Error',
        'Failed to add education. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update skills
  Future<void> updateSkills(List<String> skills) async {
    try {
      isUpdating.value = true;
      _logger.i('Updating skills');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      final success = await _profileService.updateSkills(
        uid: user.value!.uid,
        skills: skills,
      );

      if (success) {
        await refreshProfile();
        _logger.i('Skills updated successfully');
        Get.snackbar(
          'Success',
          'Skills updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _logger.e('Failed to update skills');
        Get.snackbar(
          'Error',
          'Failed to update skills. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      _logger.e('Error updating skills', e);
      Get.snackbar(
        'Error',
        'Failed to update skills. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update languages
  Future<void> updateLanguages(List<Language> languages) async {
    try {
      isUpdating.value = true;
      _logger.i('Updating languages');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      final success = await _profileService.updateLanguages(
        uid: user.value!.uid,
        languages: languages,
      );

      if (success) {
        await refreshProfile();
        _logger.i('Languages updated successfully');
        Get.snackbar(
          'Success',
          'Languages updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _logger.e('Failed to update languages');
        Get.snackbar(
          'Error',
          'Failed to update languages. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      _logger.e('Error updating languages', e);
      Get.snackbar(
        'Error',
        'Failed to update languages. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Set the selected profile image
  // ignore: use_setters_to_change_properties
  void setSelectedImage(File image) {
    selectedImage.value = image;
  }

  /// Toggle edit mode
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  /// Set the selected tab index
  // ignore: use_setters_to_change_properties
  void setSelectedTabIndex(int index) {
    selectedTabIndex.value = index;
  }

  /// Calculate profile completeness
  void _calculateProfileCompleteness() {
    if (profile.value == null) {
      profileCompleteness.value = 0.0;
      return;
    }

    // Define the total number of profile fields to check
    const totalFields = 8;
    var completedFields = 0;

    // Basic info
    if (profile.value!.name.isNotEmpty) {
      completedFields++;
    }
    if (profile.value!.email.isNotEmpty) {
      completedFields++;
    }
    if (profile.value!.photoURL != null &&
        profile.value!.photoURL!.isNotEmpty) {
      completedFields++;
    }
    if (profile.value!.jobTitle != null &&
        profile.value!.jobTitle!.isNotEmpty) {
      completedFields++;
    }
    if (profile.value!.description != null &&
        profile.value!.description!.isNotEmpty) {
      completedFields++;
    }

    // Work experience
    if (profile.value!.workExperience.isNotEmpty) {
      completedFields++;
    }

    // Education
    if (profile.value!.education.isNotEmpty) {
      completedFields++;
    }

    // Skills
    if (profile.value!.skills.isNotEmpty) {
      completedFields++;
    }

    // Calculate percentage
    profileCompleteness.value = completedFields / totalFields;

    _logger.d(
      'Profile completeness: ${(profileCompleteness.value * 100).toStringAsFixed(0)}%',
    );
  }

  /// Navigate to skills assessment view
  void navigateToSkillsAssessment() {
    Get.toNamed<dynamic>('${Routes.profile}/skills-assessment');
  }

  /// Get skill rating
  int getSkillRating(String skill) {
    return skillRatings[skill] ?? 0;
  }

  /// Update skill rating
  void updateSkillRating(String skill, int rating) {
    skillRatings[skill] = rating;
  }

  /// Add custom skill
  void addCustomSkill() {
    final skill = customSkillController.text.trim();
    if (skill.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a skill name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Add to skill ratings
    skillRatings[skill] = 0;

    // Clear the text field
    customSkillController.clear();

    Get.snackbar(
      'Success',
      'Skill added successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Save skills
  Future<void> saveSkills() async {
    try {
      isUpdating.value = true;
      _logger.i('Saving skills assessment');

      if (user.value == null) {
        _logger.w('No user is currently signed in');
        return;
      }

      // Convert skill ratings to list of skills
      final skills = skillRatings.entries
          .where((entry) => entry.value > 0)
          .map((entry) => '${entry.key} (${entry.value}/5)')
          .toList();

      // Update skills
      await updateSkills(skills);

      Get.snackbar(
        'Success',
        'Skills assessment saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e('Error saving skills assessment', e);
      Get.snackbar(
        'Error',
        'Failed to save skills assessment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }
}
