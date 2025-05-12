import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/signup_session.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/theme/theme_controller.dart';

/// Controller for the role selection screen
class RoleSelectionController extends GetxController {
  /// Get instance of RoleSelectionController
  static RoleSelectionController get to => Get.find();

  final AuthController _authController = Get.find<AuthController>();
  final AuthService _authService = Get.find<AuthService>();
  final LoggerService _logger = Get.find<LoggerService>();

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Selected role
  final Rx<UserType?> selectedRole = Rx<UserType?>(null);

  /// Confirmation state
  final RxBool isConfirmationShown = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Check if user already has a role in their profile
    _checkExistingRole();
  }

  /// Check if the user already has a role and set it as selected
  Future<void> _checkExistingRole() async {
    try {
      // First check local storage for user role
      final storageService = Get.find<StorageService>();
      final userModel = storageService.getUser();

      if (userModel != null && userModel.userType != null) {
        _logger.d('User already has role: ${userModel.userType}');
        // Set the existing role without showing confirmation
        selectedRole.value = userModel.userType;
        return;
      }

      // If not in local storage, try to get from Firebase
      final userFromFirebase = await _authService.getUserFromFirebase();
      if (userFromFirebase != null && userFromFirebase.userType != null) {
        _logger.d('User has role in Firebase: ${userFromFirebase.userType}');
        // Set the existing role without showing confirmation
        selectedRole.value = userFromFirebase.userType;
        return;
      }

      // If no role found, set default to employee but allow changing
      _logger.d('No existing role found, setting default role to employee');
      // Just set the value directly without calling setRole to avoid snackbar
      selectedRole.value = UserType.employee;
      _logger.i('Default role set to: ${selectedRole.value}');
    } catch (e) {
      _logger
        ..e('Error checking existing role', e)
        ..d('Falling back to default role (employee)');
      // If there's an error, fall back to default role
      // Just set the value directly without calling setRole to avoid snackbar
      selectedRole.value = UserType.employee;
      _logger.i('Default role set to: ${selectedRole.value} after error');
    }
  }

  /// Role descriptions for confirmation dialog
  final Map<UserType, String> roleDescriptions = {
    UserType.employee:
        "As a Job Seeker, you'll be able to search for jobs, apply to positions, track your applications, and manage your professional profile.",
    UserType.employer:
        "As an Employer, you'll be able to post job listings, review applicants, manage your company profile, and access hiring analytics.",
    UserType.admin:
        "As an Admin, you'll have access to system settings, user management, content moderation, and platform analytics.",
  };

  /// Check if continue button is enabled
  bool get isContinueEnabled => selectedRole.value != null && !isLoading.value;

  /// Set the selected role
  void setRole(UserType role) {
    _logger.d('Setting role to: $role (current role: ${selectedRole.value})');

    // Only show snackbar if role actually changes
    final isRoleChanged = selectedRole.value != role;

    // Set the selected role - always update the value to ensure UI refresh
    selectedRole.value = role;
    _logger.i('Selected role set to: $role');

    // Reset confirmation state
    isConfirmationShown.value = false;

    // Update theme based on role
    try {
      if (Get.isRegistered<ThemeController>()) {
        Get.find<ThemeController>().setUserRole(role);
        _logger.d('Updated theme for role: $role');
      }
    } catch (e) {
      _logger.w('Failed to update theme for role: $e');
    }

    // Add haptic feedback
    try {
      HapticFeedback.selectionClick();
    } catch (e) {
      _logger.w('Failed to trigger haptic feedback: $e');
    }

    // Show snackbar only if role changed
    if (isRoleChanged) {
      Get.snackbar(
        'Role Selected',
        'You selected the ${_getRoleName(role)} role',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Helper method to get a readable role name
  String _getRoleName(UserType role) {
    switch (role) {
      case UserType.employee:
        return 'Job Seeker';
      case UserType.employer:
        return 'Employer';
      case UserType.admin:
        return 'Admin';
    }
  }

  /// Cancel role selection
  void cancelRoleSelection() {
    isConfirmationShown.value = false;
  }

  /// Continue with the selected role
  Future<void> continueWithRole() async {
    if (selectedRole.value == null) {
      Get.snackbar(
        'Error',
        'Please select a role to continue',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Show confirmation dialog directly without the intermediate confirmation state
    // This simplifies the flow and makes it more intuitive
    final confirmed = await Get.dialog<bool>(
      _buildConfirmationDialog(),
      barrierDismissible: false,
    );

    // If user cancelled, return
    if (confirmed != true) {
      return;
    }

    isLoading.value = true;

    try {
      _logger.i('Setting user role: ${selectedRole.value}');

      // Get current user
      final user = _authController.user.value;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Update user model with selected role
      final userModel = await _authService.getUserFromFirebase();
      if (userModel == null) {
        throw Exception('Failed to get user model');
      }

      // Update user profile with role
      final updatedUserModel = userModel.copyWith(
        userType: selectedRole.value,
      );

      // Save to Firestore with retry mechanism
      var firestoreUpdateSuccess = false;
      for (var attempt = 1; attempt <= 3; attempt++) {
        try {
          _logger.d('Attempt $attempt to update user role in Firestore');
          await _authService.updateUserInFirestore(updatedUserModel);
          _logger.d(
            'Successfully updated user role in Firestore on attempt $attempt',
          );
          firestoreUpdateSuccess = true;
          break;
        } catch (e, stackTrace) {
          _logger.e(
            'Error updating user role in Firestore (attempt $attempt)',
            e,
            stackTrace,
          );
          if (attempt < 3) {
            // Wait before retrying
            await Future<void>.delayed(Duration(milliseconds: 500 * attempt));
          }
        }
      }

      if (!firestoreUpdateSuccess) {
        _logger.w('Failed to update user role in Firestore after 3 attempts');
        // Continue anyway, as we'll still update local storage
      }

      // Save to local storage using StorageService
      try {
        _logger.d('Updating user role in local storage');
        // Get the storage service
        final storageService = Get.find<StorageService>();
        await storageService.saveUser(updatedUserModel);
        _logger.d('Successfully updated user role in local storage');
      } catch (e, stackTrace) {
        _logger.e('Error updating user role in local storage', e, stackTrace);
        // Continue anyway, as we've already updated Firestore
      }

      // Update theme based on confirmed role
      try {
        if (Get.isRegistered<ThemeController>()) {
          Get.find<ThemeController>().setUserRole(selectedRole.value);
          _logger.d('Updated theme for confirmed role: ${selectedRole.value}');
        }
      } catch (e) {
        _logger.w('Failed to update theme for confirmed role: $e');
      }

      // Try to update signup session if we're in the signup flow
      if (_authController.currentSignupStep.value == SignupStep.emailVerified) {
        try {
          await _authController.saveSignupSession(
            step: SignupStep.roleSelected,
          );
          _logger.d('Signup session updated to role selected');
        } catch (e, stackTrace) {
          // Log the error but continue
          _logger.e(
            'Error updating signup session to role selected, continuing anyway',
            e,
            stackTrace,
          );
          // Don't show an error to the user as this is not critical
        }
      }

      // Navigate to appropriate screen based on role
      _logger.d('Navigating to dashboard with role: ${selectedRole.value}');
      await Get.offAllNamed<dynamic>(Routes.dashboard);

      // Try to clear signup session as we've completed the flow
      try {
        await _authController.clearSignupSession();
        _logger.d('Signup session cleared successfully');
      } catch (e, stackTrace) {
        // Log the error but continue
        _logger.e(
          'Error clearing signup session, continuing anyway',
          e,
          stackTrace,
        );
        // Don't show an error to the user as this is not critical
      }
    } catch (e, stackTrace) {
      _logger.e('Error setting user role', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to set user role. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Build the confirmation dialog
  Widget _buildConfirmationDialog() {
    final role = selectedRole.value;
    if (role == null) return const SizedBox.shrink();

    // Get role-specific color
    var roleColor = Get.theme.primaryColor;
    if (role == UserType.employee) {
      roleColor = const Color(0xFF2563EB); // Blue
    } else if (role == UserType.employer) {
      roleColor = const Color(0xFF059669); // Green
    } else if (role == UserType.admin) {
      roleColor = const Color(0xFF4F46E5); // Indigo
    }

    // Get role title
    var roleTitle = 'Unknown';
    if (role == UserType.employee) {
      roleTitle = 'Job Seeker';
    } else if (role == UserType.employer) {
      roleTitle = 'Employer';
    } else if (role == UserType.admin) {
      roleTitle = 'Admin';
    }

    return AlertDialog(
      title: Text(
        'Confirm Role Selection',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: roleColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have selected the $roleTitle role.',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            roleDescriptions[role] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Get.theme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You can change your role later from the settings.',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Get.theme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back<bool>(result: false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Get.back<bool>(result: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: roleColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
