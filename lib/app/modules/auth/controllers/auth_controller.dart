import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

class AuthController extends GetxController {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Use the web client ID from the Firebase console
    clientId:
        '91032840429-5f08hs0aod88lsgknf4i5v6h3lu0cf65.apps.googleusercontent.com',
  );

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
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Button state
  final isLoginButtonEnabled = false.obs;
  final isSignupButtonEnabled = false.obs;
  final isResetButtonEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    resetEmailController.dispose();
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

  // Authentication methods
  Future<void> login() async {
    if (!isLoginButtonEnabled.value) {
      log.d('Login button not enabled, returning');
      return;
    }

    try {
      log.i('Attempting login with email: ${emailController.text.trim()}');
      isLoading.value = true;

      // Log the authentication attempt
      log.d('Calling Firebase signInWithEmailAndPassword');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      log.i('Login successful for user: ${userCredential.user?.uid}');

      // Clear form
      emailController.clear();
      passwordController.clear();

      // Navigate to home
      log.d('Navigating to home screen');
      await Get.offAllNamed(Routes.HOME);
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

  Future<void> signup() async {
    if (!isSignupButtonEnabled.value) {
      log.d('Signup button not enabled, returning');
      return;
    }

    try {
      log.i('Attempting signup with email: ${emailController.text.trim()}');
      isLoading.value = true;

      // Create user
      log.d('Calling Firebase createUserWithEmailAndPassword');
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      log.i('User created with ID: ${userCredential.user?.uid}');

      // Update display name
      log.d('Updating display name for user');
      await userCredential.user?.updateDisplayName(nameController.text.trim());

      // Reload user to get updated profile
      log.d('Reloading user profile');
      await userCredential.user?.reload();

      // Clear form
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Navigate to home
      log.d('Navigating to home screen');
      await Get.offAllNamed(Routes.HOME);

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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
          'Attempting password reset for email: ${resetEmailController.text.trim()}');
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
      Get.back();
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

      // Trigger the Google Sign In process
      log.d('Calling GoogleSignIn.signIn()');
      final googleUser = await _googleSignIn.signIn();

      // If user cancels the sign-in process
      if (googleUser == null) {
        log.d('Google sign-in cancelled by user');
        isLoading.value = false;
        return;
      }

      log.d('Google sign-in successful, getting authentication details');
      // Obtain the auth details from the Google Sign In
      final googleAuth = await googleUser.authentication;

      log.d('Creating Firebase credential with Google auth tokens');
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      log.d('Signing in to Firebase with Google credential');
      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      log.i('Google sign-in successful for user: ${userCredential.user?.uid}');

      // Navigate to home
      log.d('Navigating to home screen');
      await Get.offAllNamed(Routes.HOME);
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

  Future<void> signOut() async {
    try {
      log.i('Attempting to sign out user');
      log.d('Signing out from Firebase');
      await _auth.signOut();

      log.d('Signing out from Google');
      await _googleSignIn.signOut();

      log.i('Sign out successful, navigating to login screen');
      await Get.offAllNamed(Routes.LOGIN);
    } catch (e, stackTrace) {
      log.e('Error during sign out', e, stackTrace);
      Get.snackbar(
        'Sign Out Failed',
        'An error occurred during sign out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
