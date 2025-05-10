import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/services/storage_service.dart';
import 'package:next_gen/app/modules/customer_profile/models/customer_profile_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A service for managing customer profiles
class CustomerProfileService extends GetxService {
  /// The Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// The Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// The storage service for uploading profile images
  final StorageService _storageService = Get.find<StorageService>();

  /// The logger service
  final LoggerService _logger = Get.find<LoggerService>();

  /// Get the current user's profile
  Future<CustomerProfileModel?> getCurrentUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _logger.w('No user is currently signed in');
        return null;
      }

      return getProfileByUid(user.uid);
    } catch (e, stackTrace) {
      _logger.e('Error getting current user profile', e, stackTrace);
      return null;
    }
  }

  /// Get a profile by user ID
  Future<CustomerProfileModel?> getProfileByUid(String uid) async {
    try {
      _logger.i('Getting profile for user: $uid');

      final doc =
          await _firestore.collection('customer_profiles').doc(uid).get();

      if (!doc.exists) {
        _logger.w('No profile found for user: $uid');
        return null;
      }

      final profile = CustomerProfileModel.fromFirestore(doc);
      _logger.i('Profile retrieved successfully');

      return profile;
    } catch (e, stackTrace) {
      _logger.e('Error getting profile', e, stackTrace);
      return null;
    }
  }

  /// Create or update a profile
  Future<CustomerProfileModel?> updateProfile({
    required String uid,
    required String name,
    required String email,
    String? photoURL,
    String? jobTitle,
    String? description,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? skills,
    List<Language>? languages,
    File? profileImage,
  }) async {
    try {
      _logger.i('Updating profile for user: $uid');

      // Upload profile image if provided
      var imageUrl = photoURL;
      if (profileImage != null) {
        try {
          imageUrl = await _storageService.uploadProfileImage(
            profileImage,
            uid,
          );
          _logger.i('Profile image uploaded: $imageUrl');
        } catch (e) {
          _logger.e('Error uploading profile image', e);
          // Continue with profile update even if image upload fails
        }
      }

      // Get existing profile or create a new one
      final existingProfile = await getProfileByUid(uid);
      final now = DateTime.now();

      final updatedProfile = (existingProfile ??
              CustomerProfileModel(
                uid: uid,
                name: name,
                email: email,
                createdAt: now,
              ))
          .copyWith(
        name: name,
        email: email,
        photoURL: imageUrl,
        jobTitle: jobTitle,
        description: description,
        workExperience: workExperience,
        education: education,
        skills: skills,
        languages: languages,
        updatedAt: now,
      );

      // Save to Firestore
      await _firestore
          .collection('customer_profiles')
          .doc(uid)
          .set(updatedProfile.toMap());

      _logger.i('Profile updated successfully');

      return updatedProfile;
    } catch (e, stackTrace) {
      _logger.e('Error updating profile', e, stackTrace);
      return null;
    }
  }

  /// Add work experience to a profile
  Future<bool> addWorkExperience({
    required String uid,
    required WorkExperience experience,
  }) async {
    try {
      _logger.i('Adding work experience for user: $uid');

      final profile = await getProfileByUid(uid);
      if (profile == null) {
        _logger.w('No profile found for user: $uid');
        return false;
      }

      final updatedExperiences = [...profile.workExperience, experience];

      await _firestore.collection('customer_profiles').doc(uid).update({
        'workExperience': updatedExperiences.map((e) => e.toMap()).toList(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      _logger.i('Work experience added successfully');
      return true;
    } catch (e, stackTrace) {
      _logger.e('Error adding work experience', e, stackTrace);
      return false;
    }
  }

  /// Add education to a profile
  Future<bool> addEducation({
    required String uid,
    required Education education,
  }) async {
    try {
      _logger.i('Adding education for user: $uid');

      final profile = await getProfileByUid(uid);
      if (profile == null) {
        _logger.w('No profile found for user: $uid');
        return false;
      }

      final updatedEducation = [...profile.education, education];

      await _firestore.collection('customer_profiles').doc(uid).update({
        'education': updatedEducation.map((e) => e.toMap()).toList(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      _logger.i('Education added successfully');
      return true;
    } catch (e, stackTrace) {
      _logger.e('Error adding education', e, stackTrace);
      return false;
    }
  }

  /// Update skills for a profile
  Future<bool> updateSkills({
    required String uid,
    required List<String> skills,
  }) async {
    try {
      _logger.i('Updating skills for user: $uid');

      await _firestore.collection('customer_profiles').doc(uid).update({
        'skills': skills,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      _logger.i('Skills updated successfully');
      return true;
    } catch (e, stackTrace) {
      _logger.e('Error updating skills', e, stackTrace);
      return false;
    }
  }

  /// Update languages for a profile
  Future<bool> updateLanguages({
    required String uid,
    required List<Language> languages,
  }) async {
    try {
      _logger.i('Updating languages for user: $uid');

      await _firestore.collection('customer_profiles').doc(uid).update({
        'languages': languages.map((e) => e.toMap()).toList(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      _logger.i('Languages updated successfully');
      return true;
    } catch (e, stackTrace) {
      _logger.e('Error updating languages', e, stackTrace);
      return false;
    }
  }
}
