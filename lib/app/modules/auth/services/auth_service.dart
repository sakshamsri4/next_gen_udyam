import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

class AuthService {
  // Factory constructor
  factory AuthService() => _instance;
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;
  final String _userBoxName = 'user_box';

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

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
