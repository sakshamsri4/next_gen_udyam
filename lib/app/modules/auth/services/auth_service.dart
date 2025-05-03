import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/di/service_locator.dart';
// Analytics service commented out for now, will be implemented later
// import 'package:next_gen/core/services/analytics_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

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
    // Initialize dependencies
    _logger = serviceLocator<LoggerService>();
    _storageService = serviceLocator<StorageService>();
    // Analytics service commented out for now, will be implemented later
    // _analyticsService = serviceLocator<AnalyticsService>();

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

    _logger.i('AuthService initialized');
  }

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();

  // Changed from final to late so it can be mocked in tests
  late FirebaseAuth _auth = FirebaseAuth.instance;
  late GoogleSignIn _googleSignIn;
  late final LoggerService _logger;
  late final StorageService _storageService;
  // Analytics service commented out for now, will be implemented later
  // late final AnalyticsService _analyticsService;

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
    _logger.i('Attempting to register user with email: $email');
    try {
      // Analytics service commented out for now, will be implemented later
      // await _analyticsService.logSignUp(method: 'email');

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.i('User registered successfully: ${credential.user?.uid}');

      // Send email verification
      await credential.user?.sendEmailVerification();
      _logger.i('Verification email sent to: $email');

      // Save user to storage
      if (credential.user != null) {
        await _saveUserToHive(UserModel.fromFirebaseUser(credential.user!));
        _logger.d('User data saved to local storage');
      }

      return credential;
    } catch (e, stackTrace) {
      _logger.e('Registration failed for email: $email', e, stackTrace);
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    _logger.i('Attempting to sign in user with email: $email');
    try {
      // Analytics service commented out for now, will be implemented later
      // await _analyticsService.logLogin(method: 'email');

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.i('User signed in successfully: ${credential.user?.uid}');

      // Save user to storage
      if (credential.user != null) {
        await _saveUserToHive(UserModel.fromFirebaseUser(credential.user!));
        _logger.d('User data saved to local storage');
      }

      return credential;
    } catch (e, stackTrace) {
      _logger.e('Sign in failed for email: $email', e, stackTrace);
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    _logger.i('Attempting to sign in with Google');
    try {
      // Analytics service commented out for now, will be implemented later
      // await _analyticsService.logLogin(method: 'google');

      if (kIsWeb) {
        _logger.d('Using web-specific Google sign-in flow');
        // For web, use Firebase's built-in Google auth provider
        // This avoids the need for a client ID in the web app
        final googleProvider = GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');

        // Sign in with popup
        final userCredential = await _auth.signInWithPopup(googleProvider);
        _logger.i(
          'User signed in with Google successfully:'
          ' ${userCredential.user?.uid}',
        );

        // Save user to storage
        if (userCredential.user != null) {
          await _saveUserToHive(
            UserModel.fromFirebaseUser(userCredential.user!),
          );
          _logger.d('User data saved to local storage');
        }

        return userCredential;
      } else {
        _logger.d('Using mobile-specific Google sign-in flow');
        try {
          // For mobile platforms, use the GoogleSignIn package
          // Trigger the authentication flow
          final googleUser = await _googleSignIn.signIn();

          if (googleUser == null) {
            _logger.w('Google sign-in canceled by user');
            return null; // User canceled the sign-in flow
          }

          _logger.d('Google sign-in successful, obtaining auth details');
          // Obtain the auth details from the request
          final googleAuth = await googleUser.authentication;

          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Sign in to Firebase with the Google credential
          final userCredential = await _auth.signInWithCredential(credential);
          _logger.i(
            'User signed in with Google successfully:'
            ' ${userCredential.user?.uid}',
          );

          // Save user to storage
          if (userCredential.user != null) {
            await _saveUserToHive(
              UserModel.fromFirebaseUser(userCredential.user!),
            );
            _logger.d('User data saved to local storage');
          }

          return userCredential;
        } catch (e, stackTrace) {
          // Handle specific Google Sign-In errors
          if (e is PlatformException) {
            final errorMessage = e.message ?? '';
            if (e.code == 'sign_in_failed' && errorMessage.contains('10:')) {
              _logger.e(
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
      _logger.e('Error signing in with Google', e, stackTrace);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _logger.i('Attempting to sign out user');
    try {
      // Analytics service commented out for now, will be implemented later
      // await _analyticsService.logEvent(name: 'logout');

      await _googleSignIn.signOut();
      await _auth.signOut();
      await _clearUserFromHive();
      _logger.i('User signed out successfully');
    } catch (e, stackTrace) {
      _logger.e('Error signing out user', e, stackTrace);
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    _logger.i('Attempting to send password reset email to: $email');
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _logger.i('Password reset email sent successfully to: $email');

      // Analytics service commented out for now, will be implemented later
      // await _analyticsService.logEvent(
      //   name: 'password_reset_email',
      //   parameters: {'email': email},
      // );
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to send password reset email to: $email',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  // Send email verification to current user
  Future<void> sendEmailVerification() async {
    _logger.i('Attempting to send email verification');
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        _logger.i('Verification email sent successfully to: ${user.email}');

        // Analytics service commented out for now, will be implemented later
        // await _analyticsService.logEvent(
        //   name: 'email_verification_sent',
        //   parameters: {'email': user.email},
        // );
      } else {
        throw Exception('No user logged in');
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to send verification email', e, stackTrace);
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    _logger.i('Attempting to update user profile');
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Track profile update event
        final updatedFields = <String, dynamic>{};

        if (displayName != null) {
          await user.updateDisplayName(displayName);
          _logger.d('Display name updated to: $displayName');
          updatedFields['display_name'] = true;
        }

        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
          _logger.d('Photo URL updated to: $photoURL');
          updatedFields['photo_url'] = true;
        }

        // Reload user to get updated profile
        await user.reload();

        // Update user in storage
        if (_auth.currentUser != null) {
          await _saveUserToHive(UserModel.fromFirebaseUser(_auth.currentUser!));
          _logger.d('Updated user data saved to local storage');
        }

        // Analytics service commented out for now, will be implemented later
        // await _analyticsService.logProfileUpdate(
        //   updatedFields: updatedFields,
        // );

        _logger.i('User profile updated successfully');
      } else {
        throw Exception('No user logged in');
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to update user profile', e, stackTrace);
      rethrow;
    }
  }

  // Get current Firebase user as UserModel
  Future<UserModel?> getUserFromFirebase() async {
    _logger.d('Getting current user from Firebase');
    final user = _auth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  // Get user-friendly error message from FirebaseAuthException
  String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      // Analytics service commented out for now, will be implemented later
      // _analyticsService.logEvent(
      //   name: 'auth_error',
      //   parameters: {
      //     'error_code': error.code,
      //     'error_message': error.message ?? 'No message',
      //   },
      // );

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
        case 'google-sign-in-configuration-error':
          return 'Google Sign-In is not properly configured. '
              'Please contact support.';
        default:
          return 'Unknown error occurred: ${error.message}';
      }
    }
    return 'An unexpected error occurred. Please try again later.';
  }

  // Save user to storage
  Future<void> _saveUserToHive(UserModel user) async {
    _logger.d('Saving user to local storage: ${user.uid}');
    try {
      await _storageService.saveUser(user);
      _logger.d('User saved to local storage successfully');

      // Analytics service commented out for now, will be implemented later
      // await _analyticsService.setUserId(user.uid);
      // await _analyticsService.setUserProperty(
      //   name: 'email_verified',
      //   value: user.emailVerified.toString(),
      // );
    } catch (e, stackTrace) {
      _logger.e('Error saving user to local storage', e, stackTrace);
    }
  }

  // Get user from storage
  Future<UserModel?> getUserFromHive() async {
    _logger.d('Retrieving user from local storage');
    try {
      final user = _storageService.getUser();
      if (user != null) {
        _logger.d('User retrieved from local storage: ${user.uid}');
      } else {
        _logger.d('No user found in local storage');
      }
      return user;
    } catch (e, stackTrace) {
      _logger.e('Error retrieving user from local storage', e, stackTrace);
      return null;
    }
  }

  // Restore Firebase session from storage
  Future<User?> restoreUserSession() async {
    _logger.i('Attempting to restore user session from storage');

    try {
      // If Firebase already has a user, no need to restore
      if (_auth.currentUser != null) {
        _logger.d('User already logged in via Firebase, no need to restore');

        // Analytics service commented out for now, will be implemented later
        // await _analyticsService.setUserId(_auth.currentUser!.uid);

        return _auth.currentUser;
      }

      // Try to get user from storage
      final persistedUser = await getUserFromHive();

      if (persistedUser != null) {
        _logger.i('Found persisted user in storage: ${persistedUser.uid}');

        try {
          // Since we can't directly sign in without credentials,
          // we'll try to use Firebase's persistence mechanism
          // The token might still be valid in Firebase's internal storage

          // Wait for Firebase to initialize and check auth state
          await Future<void>.delayed(const Duration(milliseconds: 500));

          // Check if Firebase has automatically restored the session
          if (_auth.currentUser != null) {
            _logger.i(
              'Firebase automatically restored session for user: '
              '${_auth.currentUser!.uid}',
            );

            // Analytics service commented out for now, will be implemented later
            // await _analyticsService.setUserId(
            //   _auth.currentUser!.uid,
            // );

            return _auth.currentUser;
          }

          // If we reach here, Firebase couldn't automatically restore
          // the session. This means the token is expired or invalid
          _logger.w(
            'Firebase could not automatically restore session, '
            'user needs to login again',
          );

          // Clear the persisted user since we couldn't restore the session
          await _clearUserFromHive();
          return null;
        } catch (e, stackTrace) {
          _logger.e('Error restoring Firebase session', e, stackTrace);
          // Clear the persisted user since we couldn't restore the session
          await _clearUserFromHive();
          return null;
        }
      } else {
        _logger.d('No persisted user found in storage');
        return null;
      }
    } catch (e, stackTrace) {
      _logger.e('Error checking for persisted login', e, stackTrace);
      return null;
    }
  }

  // Clear user from storage
  Future<void> _clearUserFromHive() async {
    _logger.d('Clearing user from local storage');
    try {
      await _storageService.deleteUser();
      _logger.d('User cleared from local storage successfully');

      // Analytics service commented out for now, will be implemented later
      // await _analyticsService.setUserId(null);
    } catch (e, stackTrace) {
      _logger.e('Error clearing user from local storage', e, stackTrace);
    }
  }
}
