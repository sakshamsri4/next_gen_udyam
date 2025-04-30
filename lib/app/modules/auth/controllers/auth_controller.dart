import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/auth/views/auth_view.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Getter for testing
  AuthService get authService => _authService;

  // Observable variables
  final Rx<firebase.User?> firebaseUser = Rx<firebase.User?>(null);
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    log.i('Initializing AuthController');

    // Listen to Firebase auth state changes
    firebaseUser.bindStream(_authService.authStateChanges);
    log.d('Set up listener for Firebase auth state changes');

    // Update logged in status when Firebase user changes
    ever(firebaseUser, _setInitialScreen);
    log.d('Set up observer for Firebase user changes');

    // Check if user is already logged in from Hive
    _loadUserFromHive();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  // Load user from Hive if available
  Future<void> _loadUserFromHive() async {
    log.d('Loading user from local storage');
    isLoading.value = true;
    try {
      final savedUser = await _authService.getUserFromHive();
      if (savedUser != null) {
        log.i('User loaded from local storage: ${savedUser.uid}');
        user.value = savedUser;
        isLoggedIn.value = true;
      } else {
        log.d('No user found in local storage');
      }
    } catch (e, stackTrace) {
      // Handle Hive initialization error gracefully
      if (e.toString().contains('initialize Hive')) {
        log.w(
          'Hive not initialized yet, skipping local storage check',
          e,
          stackTrace,
        );
      } else {
        log.e('Error loading user from local storage', e, stackTrace);
        errorMessage.value = 'Error loading user data';
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Set initial screen based on auth state
  void _setInitialScreen(firebase.User? user) {
    if (user != null) {
      log.i('User authenticated: ${user.uid}');
      isLoggedIn.value = true;
      this.user.value = UserModel.fromFirebaseUser(user);

      // Only navigate if GetMaterialApp is initialized
      if (Get.isRegistered<GetMaterialController>()) {
        log.d('Navigating to home screen');
        Get.offAll<dynamic>(() => const HomeScreen());
      } else {
        log.d('GetMaterialApp not initialized yet, skipping navigation');
      }
    } else {
      log.i('User not authenticated');
      isLoggedIn.value = false;
      this.user.value = null;

      // Only navigate if GetMaterialApp is initialized
      // and we're not already on the auth page
      if (Get.isRegistered<GetMaterialController>() &&
          Get.currentRoute != '/auth') {
        log.d('Navigating to auth screen');
        Get.offAll<dynamic>(() => const AuthView());
      } else {
        log.d(
          'GetMaterialApp not initialized or already on auth page, '
          'skipping navigation',
        );
      }
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword() async {
    log.i('Attempting to register user with email: ${emailController.text}');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        log.w('Registration failed: Email or password is empty');
        errorMessage.value = 'Email and password cannot be empty';
        return;
      }

      await authService.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      log.i('User registered successfully');

      // Clear form fields
      _clearFormFields();

      // Show success message with awesome snackbar
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Registration successful. Please verify your email.',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    } on firebase.FirebaseAuthException catch (e, stackTrace) {
      log.e('Firebase Auth error during registration', e, stackTrace);
      _handleFirebaseAuthError(e);
    } catch (e, stackTrace) {
      log.e('Unexpected error during registration', e, stackTrace);
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage.value = 'Email and password cannot be empty';
        return;
      }

      await authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Clear form fields
      _clearFormFields();
    } on firebase.FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userCredential = await authService.signInWithGoogle();

      if (userCredential == null) {
        // User canceled the sign-in flow
        errorMessage.value = 'Google sign-in was canceled';
      }
    } on firebase.FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred during Google sign-in';
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    isLoading.value = true;

    try {
      await authService.signOut();
      user.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      errorMessage.value = 'Error signing out';
    } finally {
      isLoading.value = false;
    }
  }

  // Reset password
  Future<void> resetPassword() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (emailController.text.isEmpty) {
        errorMessage.value = 'Email cannot be empty';
        return;
      }

      await authService.resetPassword(emailController.text.trim());

      // Show success message with awesome snackbar
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Password reset email sent. Please check your inbox.',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    } on firebase.FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Firebase Auth errors
  void _handleFirebaseAuthError(firebase.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        errorMessage.value = 'No user found with this email';
      case 'wrong-password':
        errorMessage.value = 'Wrong password';
      case 'email-already-in-use':
        errorMessage.value = 'Email is already in use';
      case 'weak-password':
        errorMessage.value = 'Password is too weak';
      case 'invalid-email':
        errorMessage.value = 'Invalid email format';
      case 'operation-not-allowed':
        errorMessage.value = 'This operation is not allowed';
      case 'account-exists-with-different-credential':
        errorMessage.value =
            'An account already exists with a different sign-in method';
      case 'invalid-credential':
        errorMessage.value = 'The credential is invalid';
      case 'user-disabled':
        errorMessage.value = 'This user account has been disabled';
      default:
        errorMessage.value = 'Authentication error: ${e.message}';
    }
  }

  // Clear form fields
  void _clearFormFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }
}
