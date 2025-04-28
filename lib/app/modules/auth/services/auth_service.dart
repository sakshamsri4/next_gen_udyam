import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';

class AuthService {
  // Factory constructor
  factory AuthService() => _instance;
  // Private constructor
  AuthService._internal();

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await credential.user?.sendEmailVerification();

      // Save user to Hive
      if (credential.user != null) {
        await _saveUserToHive(UserModel.fromFirebaseUser(credential.user!));
      }

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user to Hive
      if (credential.user != null) {
        await _saveUserToHive(UserModel.fromFirebaseUser(credential.user!));
      }

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in flow
      }

      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Save user to Hive
      if (userCredential.user != null) {
        await _saveUserToHive(UserModel.fromFirebaseUser(userCredential.user!));
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _clearUserFromHive();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Save user to Hive
  Future<void> _saveUserToHive(UserModel user) async {
    try {
      final box = await Hive.openBox<UserModel>(_userBoxName);
      await box.put('current_user', user);
    } catch (e) {
      debugPrint('Error saving user to Hive: $e');
    }
  }

  // Get user from Hive
  Future<UserModel?> getUserFromHive() async {
    try {
      final box = await Hive.openBox<UserModel>(_userBoxName);
      return box.get('current_user');
    } catch (e) {
      debugPrint('Error getting user from Hive: $e');
      return null;
    }
  }

  // Clear user from Hive
  Future<void> _clearUserFromHive() async {
    try {
      final box = await Hive.openBox<UserModel>(_userBoxName);
      await box.delete('current_user');
    } catch (e) {
      debugPrint('Error clearing user from Hive: $e');
    }
  }
}
