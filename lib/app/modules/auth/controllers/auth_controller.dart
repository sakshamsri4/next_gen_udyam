import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Observable variables
  final Rx<User?> firebaseUser = Rx<User?>(null);
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

    // Listen to Firebase auth state changes
    firebaseUser.bindStream(_authService.authStateChanges);

    // Update logged in status when Firebase user changes
    ever(firebaseUser, _setInitialScreen);

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
    isLoading.value = true;
    try {
      final savedUser = await _authService.getUserFromHive();
      if (savedUser != null) {
        user.value = savedUser;
        isLoggedIn.value = true;
      }
    } catch (e) {
      errorMessage.value = 'Error loading user data';
    } finally {
      isLoading.value = false;
    }
  }

  // Set initial screen based on auth state
  void _setInitialScreen(User? user) {
    if (user != null) {
      isLoggedIn.value = true;
      this.user.value = UserModel.fromFirebaseUser(user);
      // Use the actual path string
      Get.offAllNamed<dynamic>('/home');
    } else {
      isLoggedIn.value = false;
      this.user.value = null;
      // Use the actual path string
      Get.offAllNamed<dynamic>('/auth');
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage.value = 'Email and password cannot be empty';
        return;
      }

      await _authService.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Clear form fields
      _clearFormFields();

      // Show success message
      Get.snackbar(
        'Success',
        'Registration successful. Please verify your email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
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

      await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Clear form fields
      _clearFormFields();
    } on FirebaseAuthException catch (e) {
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
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null) {
        // User canceled the sign-in flow
        errorMessage.value = 'Google sign-in was canceled';
      }
    } on FirebaseAuthException catch (e) {
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
      await _authService.signOut();
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

      await _authService.resetPassword(emailController.text.trim());

      // Show success message
      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Firebase Auth errors
  void _handleFirebaseAuthError(FirebaseAuthException e) {
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
