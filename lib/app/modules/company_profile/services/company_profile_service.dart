import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/services/storage_service.dart';
import 'package:next_gen/app/modules/company_profile/models/company_profile_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A service for managing company profiles
class CompanyProfileService extends GetxService {
  /// The Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// The Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// The storage service for uploading company logos
  late final StorageService _storageService;

  /// The logger service
  late final LoggerService _logger;

  @override
  void onInit() {
    _storageService = Get.find<StorageService>();
    _logger = Get.find<LoggerService>();
    super.onInit();
  }

  /// Get the current user's company profile
  Future<CompanyProfileModel?> getCurrentCompanyProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _logger.w('No user is currently signed in');
        return null;
      }

      return getCompanyProfileByUid(user.uid);
    } catch (e, stackTrace) {
      _logger.e('Error getting current company profile', e, stackTrace);
      return null;
    }
  }

  /// Get a company profile by user ID
  Future<CompanyProfileModel?> getCompanyProfileByUid(String uid) async {
    try {
      _logger.i('Getting company profile for user: $uid');

      final doc =
          await _firestore.collection('company_profiles').doc(uid).get();

      if (!doc.exists) {
        _logger.w('No company profile found for user: $uid');
        return null;
      }

      final profile = CompanyProfileModel.fromFirestore(doc);
      _logger.i('Company profile retrieved successfully');

      return profile;
    } catch (e, stackTrace) {
      _logger.e('Error getting company profile', e, stackTrace);
      return null;
    }
  }

  /// Get a company profile by name
  Future<CompanyProfileModel?> getCompanyProfileByName(String name) async {
    try {
      _logger.i('Getting company profile by name: $name');

      final querySnapshot = await _firestore
          .collection('company_profiles')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _logger.w('No company profile found with name: $name');
        return null;
      }

      final profile =
          CompanyProfileModel.fromFirestore(querySnapshot.docs.first);
      _logger.i('Company profile retrieved successfully');

      return profile;
    } catch (e, stackTrace) {
      _logger.e('Error getting company profile by name', e, stackTrace);
      return null;
    }
  }

  /// Create or update a company profile
  ///
  /// Only specified fields will be updated, allowing for partial updates
  Future<CompanyProfileModel?> updateCompanyProfile({
    required String uid,
    String? name,
    String? email,
    String? logoURL,
    String? website,
    String? description,
    String? industry,
    String? location,
    String? size,
    int? founded,
    Map<String, String>? socialLinks,
    File? logoImage,
  }) async {
    try {
      _logger.i('Updating company profile for user: $uid');

      // Upload logo image if provided
      var imageUrl = logoURL;
      if (logoImage != null) {
        try {
          imageUrl = await _storageService.uploadProfileImage(
            logoImage,
            uid,
          );
          _logger.i('Company logo uploaded: $imageUrl');
        } catch (e, stackTrace) {
          _logger.e('Error uploading company logo', e, stackTrace);
          // Continue with profile update even if image upload fails
        }
      }

      // Get existing profile or create a new one
      final existingProfile = await getCompanyProfileByUid(uid);
      final now = DateTime.now();

      // If no existing profile and required fields are missing, we can't create a new one
      if (existingProfile == null && (name == null || email == null)) {
        _logger.e('Cannot create new profile without name and email');
        throw Exception('Name and email are required to create a new profile');
      }

      final updatedProfile = (existingProfile ??
              CompanyProfileModel(
                uid: uid,
                name: name!, // Safe to use ! here because of the check above
                email: email!, // Safe to use ! here because of the check above
                createdAt: now,
              ))
          .copyWith(
        name: name ?? existingProfile?.name,
        email: email ?? existingProfile?.email,
        logoURL: imageUrl,
        website: website,
        description: description,
        industry: industry,
        location: location,
        size: size,
        founded: founded,
        socialLinks: socialLinks,
        updatedAt: now,
      );
      // Save to Firestore
      await _firestore.collection('company_profiles').doc(uid).set(
            updatedProfile.toMap(),
            SetOptions(merge: true),
          );

      _logger.i('Company profile updated successfully');

      return updatedProfile;
    } catch (e, stackTrace) {
      _logger.e('Error updating company profile', e, stackTrace);
      return null;
    }
  }

  /// Get all jobs posted by a company
  ///
  /// Note: This query requires a composite index on 'companyId' and 'postedDate'
  /// If you encounter a FirebaseException about missing indexes, you need to create
  /// this index in the Firebase console or follow the link in the error message.
  Future<List<Map<String, dynamic>>> getCompanyJobs(String companyUid) async {
    try {
      _logger.i('Getting jobs for company: $companyUid');

      // This query requires a composite index on 'companyId' and 'postedDate'
      final querySnapshot = await _firestore
          .collection('jobs')
          .where('companyId', isEqualTo: companyUid)
          .orderBy('postedDate', descending: true)
          .get();

      final jobs = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      _logger.i('Retrieved ${jobs.length} jobs for company');
      return jobs;
    } catch (e, stackTrace) {
      // Check if this is a missing index error
      if (e.toString().contains('FAILED_PRECONDITION') &&
          e.toString().contains('index')) {
        _logger.e(
          'Missing Firestore index for company jobs query. '
          'Please create a composite index on "companyId" and "postedDate".',
          e,
          stackTrace,
        );
        // Return empty list but with a special error message that can be shown to the user
        return [];
      } else {
        _logger.e('Error getting company jobs', e, stackTrace);
        return [];
      }
    }
  }
}
