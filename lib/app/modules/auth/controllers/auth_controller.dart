import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:next_gen/app/modules/auth/models/signup_session.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/auth/services/signup_session_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

class AuthController extends GetxController {
  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // User state
  final Rx<User?> user = Rx<User?>(null);

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final resetEmailController = TextEditingController();

  // Form validation
  final nameError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final resetEmailError = ''.obs;

  // UI state
  final isLoading = false.obs;
  final isResetLoading = false.obs;
  final isSignOutLoading = false.obs;
  final isVerificationLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Email verification state
  final isVerificationBannerVisible = true.obs;
  final verificationSent = false.obs;

  // Button state
  final isLoginButtonEnabled = false.obs;
  final isSignupButtonEnabled = false.obs;
  final isResetButtonEnabled = false.obs;

  // Flag to track if we're restoring a session
  final isRestoringSession = false.obs;

  // Signup session state
  final currentSignupStep = Rx<SignupStep>(SignupStep.initial);

  // Role selection state - used for compatibility with existing code
  // The actual role selection is now handled by RoleSelectionController
  final Rx<UserType?> selectedRole = Rx<UserType?>(null);

  // Services
  late final SignupSessionService _signupSessionService;

  @override
  void onInit() {
    super.onInit();

    // Reset all loading states
    isLoading.value = false;
    isResetLoading.value = false;
    isSignOutLoading.value = false;

    // Initialize services
    try {
      _signupSessionService = Get.find<SignupSessionService>();
      log.d('SignupSessionService found');
    } catch (e) {
      _signupSessionService = Get.put(SignupSessionService());
      log.d('SignupSessionService registered');
    }

    // Listen to auth state changes
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
    });

    // Check for persisted login
    _checkPersistedLogin();

    log.d('AuthController initialized with loading states reset');
  }

  // Check if user is persisted in Hive and restore session if needed
  Future<void> _checkPersistedLogin() async {
    try {
      log.d('Checking for persisted login in Hive');

      // If Firebase already has a user, no need to restore
      if (_auth.currentUser != null) {
        log.d(
          'User already logged in via Firebase, no need to restore from Hive',
        );

        // Update the user value to ensure UI consistency
        user.value = _auth.currentUser;

        // Still need to check if we should navigate to dashboard
        if (Get.currentRoute != Routes.dashboard &&
            Get.currentRoute != Routes.roleSelection) {
          // Check if user has a role before navigating to dashboard
          try {
            final authService = Get.find<AuthService>();
            final userModel = await authService.getUserFromFirebase();

            if (userModel?.userType == null) {
              log.d('User has no role, navigating to role selection screen');
              await Get.offAllNamed<dynamic>(Routes.roleSelection);
            } else {
              log.d(
                'User has role: ${userModel?.userType}, navigating to dashboard',
              );
              await Get.offAllNamed<dynamic>(Routes.dashboard);
            }
          } catch (e) {
            log.e('Error checking user role during persisted login', e);
            // Default to dashboard if we can't check the role
            await Get.offAllNamed<dynamic>(Routes.dashboard);
          }
        }
        return;
      }

      // Try to get the auth service with retry mechanism
      AuthService? authService;
      for (var attempt = 1; attempt <= 3; attempt++) {
        try {
          authService = Get.find<AuthService>();
          log.d(
            'AuthService found on attempt $attempt, proceeding with session restoration',
          );
          break;
        } catch (e) {
          log.w('AuthService not found on attempt $attempt: $e');
          if (attempt < 3) {
            // Wait before retrying
            await Future<void>.delayed(Duration(milliseconds: 300 * attempt));
          } else {
            log.e('Failed to find AuthService after all attempts');
            return; // Exit early, we can't restore without AuthService
          }
        }
      }

      // If we still couldn't find the AuthService, exit
      if (authService == null) {
        log.e('AuthService not available, cannot restore session');
        return;
      }

      // Set flag to indicate we're attempting to restore a session
      isRestoringSession.value = true;

      // Try to restore the Firebase session
      final restoredUser = await authService.restoreUserSession();

      if (restoredUser != null) {
        log.i(
          'Successfully restored Firebase session for user: '
          '${restoredUser.uid}',
        );

        // Update the user value to trigger UI updates
        user.value = restoredUser;

        // Check if user has a role before navigating
        final userModel = await authService.getUserFromFirebase();

        // Reset the restoring session flag
        isRestoringSession.value = false;

        if (userModel?.userType == null) {
          log.d(
            'Restored user has no role, navigating to role selection screen',
          );
          await Get.offAllNamed<dynamic>(Routes.roleSelection);
        } else {
          log.d(
            'Restored user has role: ${userModel?.userType}, navigating to dashboard',
          );
          await Get.offAllNamed<dynamic>(Routes.dashboard);
        }
      } else {
        log.d('Could not restore Firebase session, user needs to login again');
        isRestoringSession.value = false;
      }
    } catch (e, stackTrace) {
      log.e('Error checking for persisted login', e, stackTrace);
      isRestoringSession.value = false;
    }
  }

  @override
  void onClose() {
    // Safely dispose controllers if they haven't been disposed already
    try {
      nameController.dispose();
    } catch (e) {
      log.d('nameController already disposed');
    }

    try {
      emailController.dispose();
    } catch (e) {
      log.d('emailController already disposed');
    }

    try {
      passwordController.dispose();
    } catch (e) {
      log.d('passwordController already disposed');
    }

    try {
      confirmPasswordController.dispose();
    } catch (e) {
      log.d('confirmPasswordController already disposed');
    }

    try {
      resetEmailController.dispose();
    } catch (e) {
      log.d('resetEmailController already disposed');
    }

    super.onClose();
  }

  // Form validation methods
  void validateName(String value) {
    if (value.isEmpty) {
      nameError.value = 'Name is required';
    } else if (value.length < 3) {
      nameError.value = 'Name must be at least 3 characters';
    } else {
      nameError.value = '';
    }
    _updateSignupButtonState();
  }

  void validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      emailError.value = 'Enter a valid email address';
    } else {
      emailError.value = '';
    }
    _updateLoginButtonState();
    _updateSignupButtonState();
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
    _updateLoginButtonState();
    _updateSignupButtonState();

    // Also validate confirm password if it's not empty
    if (confirmPasswordController.text.isNotEmpty) {
      validateConfirmPassword(confirmPasswordController.text);
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
    } else if (value != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
    _updateSignupButtonState();
  }

  void validateResetEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value.isEmpty) {
      resetEmailError.value = 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      resetEmailError.value = 'Enter a valid email address';
    } else {
      resetEmailError.value = '';
    }
    _updateResetButtonState();
  }

  // Update button states
  void _updateLoginButtonState() {
    isLoginButtonEnabled.value = emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void _updateSignupButtonState() {
    isSignupButtonEnabled.value = nameError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  void _updateResetButtonState() {
    isResetButtonEnabled.value =
        resetEmailError.value.isEmpty && resetEmailController.text.isNotEmpty;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Role selection methods
  /// Sets the selected role (legacy method for compatibility)
  /// This method is used to change a property, but we're keeping it for compatibility
  /// with existing code. In the future, consider using the selectedRole.value directly.
  // ignore: use_setters_to_change_properties
  void setRole(UserType role) {
    selectedRole.value = role;
  }

  /// Toggles the role selection visibility
  /// This method is deprecated and will be removed in a future update
  /// Role selection is now handled by RoleSelectionController
  @Deprecated('Use RoleSelectionController instead')
  void toggleRoleSelection() {
    // No-op - role selection is now handled by RoleSelectionController
    log.d('toggleRoleSelection called - this method is deprecated');
  }

  // Authentication methods
  Future<void> login() async {
    if (!isLoginButtonEnabled.value) {
      log.d('Login button not enabled, returning');
      return;
    }

    try {
      log.i('Attempting login with email: ${emailController.text.trim()}');
      isLoading.value = true;

      // Get the auth service to handle Hive persistence
      AuthService? authService;
      try {
        authService = Get.find<AuthService>();
      } catch (e) {
        log.e('AuthService not found, cannot proceed with login', e);
        Get.snackbar(
          'Login Failed',
          'Internal error: Authentication service not available. '
              'Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // Log the authentication attempt
      log.d('Calling AuthService signInWithEmailAndPassword');
      final userCredential = await authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      log
        ..i('Login successful for user: ${userCredential.user?.uid}')
        // Check if user has a role
        ..d('Checking if user has a role');

      final userModel = await authService.getUserFromFirebase();
      log.d('User model from Firebase: ${userModel?.toMap()}');

      // Clear form
      emailController.clear();
      passwordController.clear();

      // Navigate based on role
      if (userModel?.userType == null) {
        log.d('User has no role, navigating to role selection screen');
        await Get.offAllNamed<dynamic>(Routes.roleSelection);
      } else {
        log.d('User has role: ${userModel?.userType}, navigating to dashboard');
        await Get.offAllNamed<dynamic>(Routes.dashboard);
      }
    } on FirebaseAuthException catch (e) {
      log.e('Firebase Auth Exception during login', e, e.stackTrace);
      var errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
        log.w('Login failed: User not found');
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
        log.w('Login failed: Wrong password');
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
        log.w('Login failed: Invalid email');
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This user has been disabled.';
        log.w('Login failed: User disabled');
      } else {
        log.e('Login failed with code: ${e.code}', e.message);
      }

      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      log.e('Unexpected error during login', e, stackTrace);
      Get.snackbar(
        'Login Failed',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      log.d('Login process completed');
    }
  }

  /// Save the current signup session
  Future<void> saveSignupSession({
    SignupStep step = SignupStep.credentials,
  }) async {
    try {
      log.d('Saving signup session with step: $step');

      // Create a session object
      final session = SignupSession(
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        step: step,
      );

      // Save the session
      await _signupSessionService.saveSession(session);

      // Update the current step
      currentSignupStep.value = step;

      log.d('Signup session saved successfully');
    } catch (e, stackTrace) {
      log.e('Error saving signup session', e, stackTrace);
    }
  }

  /// Check for an existing signup session
  Future<bool> checkForExistingSession(String email) async {
    try {
      log.d('Checking for existing signup session for email: $email');

      // Check if a session exists
      final hasSession = _signupSessionService.hasSession(email);

      if (hasSession) {
        // Get the session
        final session = _signupSessionService.getSession(email);

        if (session != null) {
          log.d('Found existing signup session with step: ${session.step}');

          // Update the current step
          currentSignupStep.value = session.step;

          // Populate form fields if needed
          if (session.name != null && session.name!.isNotEmpty) {
            nameController.text = session.name!;
          }

          emailController.text = session.email;

          return true;
        }
      }

      log.d('No existing signup session found');
      return false;
    } catch (e, stackTrace) {
      log.e('Error checking for existing signup session', e, stackTrace);
      return false;
    }
  }

  /// Clear the current signup session
  Future<void> clearSignupSession() async {
    try {
      log.d('Clearing signup session');

      final email = emailController.text.trim();
      if (email.isEmpty) {
        log.w('Cannot clear signup session: email is empty');
        return;
      }

      // Check if session exists before trying to delete it
      if (_signupSessionService.hasSession(email)) {
        // Delete the session
        await _signupSessionService.deleteSession(email);
        log.d('Signup session deleted successfully');
      } else {
        log.d('No signup session found to clear for email: $email');
      }

      // Reset the current step regardless of whether a session was found
      currentSignupStep.value = SignupStep.initial;

      log.d('Signup session cleared successfully');
    } catch (e, stackTrace) {
      log.e('Error clearing signup session', e, stackTrace);

      // Try an alternative approach if the first one fails
      try {
        final email = emailController.text.trim();
        if (email.isNotEmpty) {
          // Try to use direct Hive access as a last resort
          if (Hive.isBoxOpen(SignupSessionService.signupSessionBoxName)) {
            final box = Hive.box<SignupSession>(
              SignupSessionService.signupSessionBoxName,
            );
            await box.delete(email);
            log.d('Signup session cleared via direct Hive access');
          }
        }

        // Reset the current step
        currentSignupStep.value = SignupStep.initial;
      } catch (e2, stackTrace2) {
        log.e(
          'Error in fallback attempt to clear signup session',
          e2,
          stackTrace2,
        );
        // At this point, we've tried everything we can
      }
    }
  }

  Future<void> signup() async {
    if (!isSignupButtonEnabled.value) {
      log.d('Signup button not enabled, returning');
      return;
    }

    // Role selection is now handled by RoleSelectionController
    // This check is no longer needed

    try {
      log.i('Attempting signup with email: ${emailController.text.trim()}');
      isLoading.value = true;

      // Try to save the current signup session, but continue even if it fails
      try {
        await saveSignupSession();
        log.d('Signup session saved successfully');
      } catch (e, stackTrace) {
        // Log the error but continue with signup
        log.e(
          'Error saving signup session, continuing with signup',
          e,
          stackTrace,
        );
        // Don't show an error to the user as this is not critical
      }

      // Get the auth service to handle Hive persistence
      AuthService? authService;
      try {
        authService = Get.find<AuthService>();
      } catch (e) {
        log.e('AuthService not found, cannot proceed with signup', e);
        Get.snackbar(
          'Signup Failed',
          'Internal error: Authentication service not available. '
              'Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // Create user
      log.d('Calling AuthService registerWithEmailAndPassword');
      final userCredential = await authService.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      log
        ..i('User created with ID: ${userCredential.user?.uid}')
        // Update display name and reload user profile
        ..d('Updating display name for user')
        ..d('Reloading user profile');

      // Update the display name
      await authService.updateUserProfile(
        displayName: nameController.text.trim(),
      );

      // Try to update signup session to account created, but continue even if it fails
      try {
        await saveSignupSession(step: SignupStep.accountCreated);
        log.d('Signup session updated to account created');
      } catch (e, stackTrace) {
        // Log the error but continue with signup
        log.e(
          'Error updating signup session to account created, continuing with signup',
          e,
          stackTrace,
        );
        // Don't show an error to the user as this is not critical
      }

      // Clear form
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Reset role selection
      selectedRole.value = null;

      // Always navigate to role selection screen after signup
      log.d('Navigating to role selection screen after signup');
      await Get.offAllNamed<dynamic>(Routes.roleSelection);

      // No need for a snackbar here as the welcome screen will show a success message
    } on FirebaseAuthException catch (e) {
      log.e('Firebase Auth Exception during signup', e, e.stackTrace);
      var errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
        log.w('Signup failed: Weak password');
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for this email.';
        log.w('Signup failed: Email already in use');
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
        log.w('Signup failed: Invalid email');
      } else {
        log.e('Signup failed with code: ${e.code}', e.message);
      }

      Get.snackbar(
        'Signup Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      log.e('Unexpected error during signup', e, stackTrace);
      Get.snackbar(
        'Signup Failed',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      log.d('Signup process completed');
    }
  }

  Future<void> resetPassword() async {
    if (!isResetButtonEnabled.value) {
      log.d('Reset button not enabled, returning');
      return;
    }

    try {
      log.i(
        'Attempting password reset for email:'
        ' ${resetEmailController.text.trim()}',
      );
      isResetLoading.value = true;

      log.d('Calling Firebase sendPasswordResetEmail');
      await _auth.sendPasswordResetEmail(
        email: resetEmailController.text.trim(),
      );

      log.i('Password reset email sent successfully');

      // Clear form
      resetEmailController.clear();

      Get.snackbar(
        'Success',
        'Password reset link sent to your email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Go back to login
      log.d('Navigating back to login screen');
      Get.back<dynamic>();
    } on FirebaseAuthException catch (e) {
      log.e('Firebase Auth Exception during password reset', e, e.stackTrace);
      var errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
        log.w('Password reset failed: User not found');
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
        log.w('Password reset failed: Invalid email');
      } else {
        log.e('Password reset failed with code: ${e.code}', e.message);
      }

      Get.snackbar(
        'Reset Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      log.e('Unexpected error during password reset', e, stackTrace);
      Get.snackbar(
        'Reset Failed',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isResetLoading.value = false;
      log.d('Password reset process completed');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      log.i('Attempting Google sign-in');
      isLoading.value = true;

      // Get the auth service to handle Hive persistence
      AuthService? authService;
      try {
        authService = Get.find<AuthService>();
      } catch (e) {
        log.e('AuthService not found, cannot proceed with Google sign-in', e);
        Get.snackbar(
          'Google Sign In Failed',
          'Internal error: Authentication service not available. '
              'Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // Use the AuthService for Google sign-in
      log.d('Calling AuthService signInWithGoogle()');
      final userCredential = await authService.signInWithGoogle();

      // If user cancels the sign-in process
      if (userCredential == null) {
        log.d('Google sign-in cancelled by user');
        isLoading.value = false;
        return;
      }

      log
        ..i('Google sign-in successful for user: ${userCredential.user?.uid}')
        // Check if user has a role
        ..d('Checking if user has a role after Google sign-in');

      final userModel = await authService.getUserFromFirebase();
      log.d(
        'User model from Firebase after Google sign-in: ${userModel?.toMap()}',
      );

      // Navigate based on role
      if (userModel?.userType == null) {
        log.d(
          'User has no role after Google sign-in, navigating to role selection',
        );
        await Get.offAllNamed<dynamic>(Routes.roleSelection);
      } else {
        log.d(
          'User has role after Google sign-in: ${userModel?.userType}, navigating to dashboard',
        );
        await Get.offAllNamed<dynamic>(Routes.dashboard);
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      log.e('Firebase Auth Exception during Google sign-in', e, stackTrace);

      // Handle specific error codes
      if (e.code == 'google-sign-in-configuration-error') {
        Get.snackbar(
          'Configuration Error',
          'Google Sign-In is not properly configured. Please contact support.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Google Sign In Failed',
          e.message ??
              'An error occurred during Google sign in. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      log.e('Error during Google sign-in', e, stackTrace);
      Get.snackbar(
        'Google Sign In Failed',
        'An error occurred during Google sign in. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      log.d('Google sign-in process completed');
    }
  }

  // Reset sign out loading state
  void resetSignOutLoading() {
    isSignOutLoading.value = false;
    log.d('Sign out loading state reset');
  }

  // Reset all loading states
  void resetAllLoadingStates() {
    isLoading.value = false;
    isResetLoading.value = false;
    isSignOutLoading.value = false;
    log.d('All loading states reset');
  }

  /// Refresh the current user data
  Future<void> refreshUser() async {
    try {
      log.i('Refreshing user data');

      // Reload the current user to get updated profile
      if (_auth.currentUser != null) {
        await _auth.currentUser!.reload();
        // Update the user value to trigger UI updates
        user.value = _auth.currentUser;
        log.d('User data refreshed successfully');

        // Check if email is now verified
        if (user.value?.emailVerified ?? false) {
          log.i('Email is now verified');
          // If we're on the verification success screen, no need to show a snackbar
          if (Get.currentRoute != Routes.verificationSuccess) {
            Get.snackbar(
              'Email Verified',
              'Your email has been successfully verified!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
            );
          }
        }
      } else {
        log.w('Cannot refresh user data: No user is currently logged in');
      }
    } catch (e, stackTrace) {
      log.e('Error refreshing user data', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to refresh user data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Send email verification to current user
  Future<void> sendEmailVerification() async {
    try {
      log.i('Attempting to send email verification');
      isVerificationLoading.value = true;
      verificationSent.value = false;

      // Get the auth service
      AuthService? authService;
      try {
        authService = Get.find<AuthService>();
      } catch (e) {
        log.e(
          'AuthService not found, cannot proceed with email verification',
          e,
        );
        Get.snackbar(
          'Verification Failed',
          'Internal error: Authentication service not available. '
              'Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isVerificationLoading.value = false;
        return;
      }

      // Send verification email
      await authService.sendEmailVerification();

      // Mark as sent
      verificationSent.value = true;

      // Update signup session if we're in the signup flow
      if (currentSignupStep.value == SignupStep.accountCreated) {
        await saveSignupSession(step: SignupStep.verificationSent);
      }

      log.i('Verification email sent successfully');
      Get.snackbar(
        'Email Sent',
        'Verification email has been sent. Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e, stackTrace) {
      log.e('Error sending verification email', e, stackTrace);

      var errorMessage = 'Failed to send verification email. Please try again.';

      // Handle specific Firebase errors
      if (e is FirebaseAuthException) {
        if (e.code == 'too-many-requests') {
          errorMessage = 'Too many requests. Please try again later.';
        }
      }

      Get.snackbar(
        'Verification Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isVerificationLoading.value = false;
    }
  }

  /// Check if email is verified and navigate to success screen if it is
  Future<void> checkEmailVerification() async {
    try {
      log.i('Checking email verification status');

      // Refresh user to get latest verification status
      await refreshUser();

      // Check if email is verified
      if (user.value?.emailVerified ?? false) {
        log.i('Email is verified, navigating to verification success screen');

        // Update signup session if we're in the signup flow
        if (currentSignupStep.value == SignupStep.verificationSent ||
            currentSignupStep.value == SignupStep.accountCreated) {
          await saveSignupSession(step: SignupStep.emailVerified);
        }

        await Get.offAllNamed<dynamic>(Routes.verificationSuccess);
      } else {
        log.i('Email is not verified yet');
        Get.snackbar(
          'Not Verified',
          'Your email is not verified yet. Please check your inbox and click the verification link.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
          colorText: Colors.black,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e, stackTrace) {
      log.e('Error checking email verification', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to check verification status. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Toggle verification banner visibility
  void toggleVerificationBanner() {
    isVerificationBannerVisible.value = !isVerificationBannerVisible.value;
  }

  Future<void> signOut() async {
    try {
      log.i('Attempting to sign out user');
      // Set loading state at the beginning
      isSignOutLoading.value = true;

      // Get the auth service to handle Hive data clearing
      AuthService? authService;
      try {
        authService = Get.find<AuthService>();
      } catch (e) {
        log.e('AuthService not found, cannot proceed with sign out', e);
        Get.snackbar(
          'Sign Out Failed',
          'Internal error: Authentication service not available. '
              'Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        resetAllLoadingStates();
        return;
      }

      // Use the AuthService to sign out which will also clear Hive data
      await authService.signOut();

      // Reset all loading states before navigation
      resetAllLoadingStates();

      log.i('Sign out successful, navigating to login screen');
      await Get.offAllNamed<dynamic>(Routes.login);
    } catch (e, stackTrace) {
      log.e('Error during sign out', e, stackTrace);
      Get.snackbar(
        'Sign Out Failed',
        'An error occurred during sign out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      resetAllLoadingStates();
    }
  }
}
