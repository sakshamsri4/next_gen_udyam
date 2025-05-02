import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

class AuthService {
  // Factory constructor
  factory AuthService() => _instance;

  // Constructor for testing
  @visibleForTesting
  factory AuthService.test({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) {
    final service = AuthService._internal();
    if (firebaseAuth != null) {
      service._auth = firebaseAuth;
    }
    if (googleSignIn != null) {
      service._googleSignIn = googleSignIn;
    }
    return service;
  }

  // Private constructor
  AuthService._internal() {
    // Initialize GoogleSignIn with appropriate configuration
    if (kIsWeb) {
      // For web, we'll disable Google Sign-In for now
      // We'll need to add the client ID in index.html later
      _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );
    } else {
      // For mobile platforms
      _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );
    }
  }

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();

  // Changed from final to late so it can be mocked in tests
  late FirebaseAuth _auth = FirebaseAuth.instance;
  late GoogleSignIn _googleSignIn;
  final String _userBoxName = 'user_box';

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Check if current user has verified email
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
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
  Future<UserCredential> signInWithEmailAndPassword(
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
  Future<UserCredential?> signInWithGoogle() async {
    log.i('Attempting to sign in with Google');
    try {
      if (kIsWeb) {
        log.d('Using web-specific Google sign-in flow');
        // For web, use Firebase's built-in Google auth provider
        // This avoids the need for a client ID in the web app
        final googleProvider = GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');

        // Sign in with popup
        final userCredential = await _auth.signInWithPopup(googleProvider);
        log.i(
          'User signed in with Google successfully:'
          ' ${userCredential.user?.uid}',
        );

        // Save user to Hive
        if (userCredential.user != null) {
          await _saveUserToHive(
            UserModel.fromFirebaseUser(userCredential.user!),
          );
          log.d('User data saved to local storage');
        }

        return userCredential;
      } else {
        log.d('Using mobile-specific Google sign-in flow');
        try {
          // For mobile platforms, use the GoogleSignIn package
          // Trigger the authentication flow
          final googleUser = await _googleSignIn.signIn();

          if (googleUser == null) {
            log.w('Google sign-in canceled by user');
            return null; // User canceled the sign-in flow
          }

          log.d('Google sign-in successful, obtaining auth details');
          // Obtain the auth details from the request
          final googleAuth = await googleUser.authentication;

          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Sign in to Firebase with the Google credential
          final userCredential = await _auth.signInWithCredential(credential);
          log.i(
            'User signed in with Google successfully:'
            ' ${userCredential.user?.uid}',
          );

          // Save user to Hive
          if (userCredential.user != null) {
            await _saveUserToHive(
              UserModel.fromFirebaseUser(userCredential.user!),
            );
            log.d('User data saved to local storage');
          }

          return userCredential;
        } catch (e, stackTrace) {
          // Handle specific Google Sign-In errors
          if (e is PlatformException) {
            final errorMessage = e.message ?? '';
            if (e.code == 'sign_in_failed' && errorMessage.contains('10:')) {
              log.e(
                'Google Sign-In failed with error code 10. This usually '
                'indicates a missing SHA-1 certificate fingerprint in '
                'Firebase console or incorrect package name configuration.',
                e,
                stackTrace,
              );

              // Show a more user-friendly error message
              throw FirebaseAuthException(
                code: 'google-sign-in-configuration-error',
                message: 'Google Sign-In is not properly configured. '
                    'Please contact support.',
              );
            }
          }
          rethrow;
        }
      }
    } catch (e, stackTrace) {
      log.e('Error signing in with Google', e, stackTrace);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    log.i('Attempting to sign out user');
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
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
    if (error is FirebaseAuthException) {
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

  // Restore Firebase session from Hive data
  Future<User?> restoreUserSession() async {
    log.i('Attempting to restore user session from Hive');

    try {
      // If Firebase already has a user, no need to restore
      if (_auth.currentUser != null) {
        log.d('User already logged in via Firebase, no need to restore');
        return _auth.currentUser;
      }

      // Try to get user from Hive
      final persistedUser = await getUserFromHive();

      if (persistedUser != null) {
        log.i('Found persisted user in Hive: ${persistedUser.uid}');

        try {
          // Since we can't directly sign in without credentials,
          // we'll try to use Firebase's persistence mechanism
          // The token might still be valid in Firebase's internal storage

          // Wait for Firebase to initialize and check auth state
          await Future<void>.delayed(const Duration(milliseconds: 500));

          // Check if Firebase has automatically restored the session
          if (_auth.currentUser != null) {
            log.i(
              'Firebase automatically restored session for user: '
              '${_auth.currentUser!.uid}',
            );
            return _auth.currentUser;
          }

          // If we reach here, Firebase couldn't automatically restore
          // the session. This means the token is expired or invalid
          log.w(
            'Firebase could not automatically restore session, '
            'user needs to login again',
          );

          // Clear the persisted user since we couldn't restore the session
          await _clearUserFromHive();
          return null;
        } catch (e, stackTrace) {
          log.e('Error restoring Firebase session', e, stackTrace);
          // Clear the persisted user since we couldn't restore the session
          await _clearUserFromHive();
          return null;
        }
      } else {
        log.d('No persisted user found in Hive');
        return null;
      }
    } catch (e, stackTrace) {
      log.e('Error checking for persisted login', e, stackTrace);
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
