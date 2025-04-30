import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

class AuthService {
  // Factory constructor
  factory AuthService() => _instance;

  // Constructor for testing
  @visibleForTesting
  factory AuthService.test({
    firebase.FirebaseAuth? firebaseAuth,
  }) {
    final service = AuthService._internal();
    if (firebaseAuth != null) {
      service._auth = firebaseAuth;
    }
    return service;
  }

  // Private constructor
  AuthService._internal();

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();

  // Changed from final to late so it can be mocked in tests
  late firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final String _userBoxName = 'user_box';

  // Get current user
  firebase.User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Check if current user has verified email
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Stream of auth changes
  Stream<firebase.User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<firebase.UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    log.i('Attempting to register user with email: $email');
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      log.i('User registered successfully: ${credential.user?.uid}');

      // Send email verification
      await credential.user?.sendEmailVerification();
      log.i('Verification email sent to: $email');

      // Save user to Hive
      if (credential.user != null) {
        await _saveUserToHive(UserModel.fromFirebaseUser(credential.user!));
        log.d('User data saved to local storage');
      }

      return credential;
    } catch (e, stackTrace) {
      log.e('Registration failed for email: $email', e, stackTrace);
      rethrow;
    }
  }

  // Sign in with email and password
  Future<firebase.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    log.i('Attempting to sign in user with email: $email');
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      log.i('User signed in successfully: ${credential.user?.uid}');

      // Save user to Hive
      if (credential.user != null) {
        await _saveUserToHive(UserModel.fromFirebaseUser(credential.user!));
        log.d('User data saved to local storage');
      }

      return credential;
    } catch (e, stackTrace) {
      log.e('Sign in failed for email: $email', e, stackTrace);
      rethrow;
    }
  }

  // Sign in with Google
  Future<firebase.UserCredential?> signInWithGoogle() async {
    log.i('Attempting to sign in with Google');
    try {
      firebase.UserCredential? userCredential;

      // Use Firebase Auth directly with Google provider
      final googleProvider = firebase.GoogleAuthProvider()
        ..addScope('email')
        ..addScope('profile');

      if (kIsWeb) {
        log.d('Using web-specific Google sign-in flow');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        log.d('Using mobile-specific Google sign-in flow');
        userCredential = await _auth.signInWithProvider(googleProvider);
      }

      if (userCredential.user != null) {
        log.i(
          'User signed in with Google successfully:'
          ' ${userCredential.user?.uid}',
        );

        // Save user to Hive
        await _saveUserToHive(
          UserModel.fromFirebaseUser(userCredential.user!),
        );
        log.d('User data saved to local storage');
      }

      return userCredential;
    } catch (e, stackTrace) {
      log.e('Error signing in with Google', e, stackTrace);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    log.i('Attempting to sign out user');
    try {
      // Sign out from Firebase
      await _auth.signOut();
      // Clear local storage
      await _clearUserFromHive();
      log.i('User signed out successfully');
    } catch (e, stackTrace) {
      log.e('Error signing out user', e, stackTrace);
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    log.i('Attempting to send password reset email to: $email');
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log.i('Password reset email sent successfully to: $email');
    } catch (e, stackTrace) {
      log.e('Failed to send password reset email to: $email', e, stackTrace);
      rethrow;
    }
  }

  // Send email verification to current user
  Future<void> sendEmailVerification() async {
    log.i('Attempting to send email verification');
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        log.i('Verification email sent successfully to: ${user.email}');
      } else {
        throw Exception('No user logged in');
      }
    } catch (e, stackTrace) {
      log.e('Failed to send verification email', e, stackTrace);
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    log.i('Attempting to update user profile');
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
          log.d('Display name updated to: $displayName');
        }

        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
          log.d('Photo URL updated to: $photoURL');
        }

        // Reload user to get updated profile
        await user.reload();

        // Update user in Hive
        if (_auth.currentUser != null) {
          await _saveUserToHive(UserModel.fromFirebaseUser(_auth.currentUser!));
          log.d('Updated user data saved to local storage');
        }

        log.i('User profile updated successfully');
      } else {
        throw Exception('No user logged in');
      }
    } catch (e, stackTrace) {
      log.e('Failed to update user profile', e, stackTrace);
      rethrow;
    }
  }

  // Get current Firebase user as UserModel
  Future<UserModel?> getUserFromFirebase() async {
    log.d('Getting current user from Firebase');
    final user = _auth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  // Get user-friendly error message from FirebaseAuthException
  String getErrorMessage(dynamic error) {
    if (error is firebase.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'The email address was not found. Please check and try again.';
        case 'wrong-password':
          return 'The password is incorrect. Please try again.';
        case 'email-already-in-use':
          return 'This email is already in use. '
              'Please use a different email or try to sign in.';
        case 'weak-password':
          return 'The password is too weak. Please use a stronger password.';
        case 'invalid-email':
          return 'The email is invalid. Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'operation-not-allowed':
          return 'This operation is not allowed. Please contact support.';
        default:
          return 'Unknown error occurred: ${error.message}';
      }
    }
    return 'An unexpected error occurred. Please try again later.';
  }

  // Save user to Hive
  Future<void> _saveUserToHive(UserModel user) async {
    log.d('Saving user to local storage: ${user.uid}');
    try {
      // Check if Hive is initialized
      if (!Hive.isBoxOpen(_userBoxName)) {
        log.d('Opening Hive box for user storage');
      }

      final box = await Hive.openBox<UserModel>(_userBoxName);
      await box.put('current_user', user);
      log.d('User saved to local storage successfully');
    } catch (e, stackTrace) {
      if (e.toString().contains('initialize Hive')) {
        log.w(
          'Hive not initialized yet, skipping save to local storage',
          e,
          stackTrace,
        );
      } else {
        log.e('Error saving user to local storage', e, stackTrace);
      }
    }
  }

  // Get user from Hive
  Future<UserModel?> getUserFromHive() async {
    log.d('Retrieving user from local storage');
    try {
      // Check if Hive is initialized
      if (!Hive.isBoxOpen(_userBoxName)) {
        log.d('Opening Hive box for user retrieval');
      }

      final box = await Hive.openBox<UserModel>(_userBoxName);
      final user = box.get('current_user');
      if (user != null) {
        log.d('User retrieved from local storage: ${user.uid}');
      } else {
        log.d('No user found in local storage');
      }
      return user;
    } catch (e, stackTrace) {
      if (e.toString().contains('initialize Hive')) {
        log.w(
          'Hive not initialized yet, skipping retrieval from local storage',
          e,
          stackTrace,
        );
      } else {
        log.e('Error retrieving user from local storage', e, stackTrace);
      }
      return null;
    }
  }

  // Clear user from Hive
  Future<void> _clearUserFromHive() async {
    log.d('Clearing user from local storage');
    try {
      // Check if Hive is initialized
      if (!Hive.isBoxOpen(_userBoxName)) {
        log.d('Opening Hive box for user deletion');
      }

      final box = await Hive.openBox<UserModel>(_userBoxName);
      await box.delete('current_user');
      log.d('User cleared from local storage successfully');
    } catch (e, stackTrace) {
      if (e.toString().contains('initialize Hive')) {
        log.w(
          'Hive not initialized yet, skipping clear from local storage',
          e,
          stackTrace,
        );
      } else {
        log.e('Error clearing user from local storage', e, stackTrace);
      }
    }
  }
}
