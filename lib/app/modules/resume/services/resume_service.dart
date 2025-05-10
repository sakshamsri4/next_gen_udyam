import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/resume/models/resume_model.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:path/path.dart' as path;

/// Service for managing resumes
class ResumeService extends GetxService {
  /// Constructor
  ResumeService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    LoggerService? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _logger = logger ?? Get.find<LoggerService>();

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final LoggerService _logger;

  /// Upload a resume file
  Future<ResumeModel> uploadResume({
    required File file,
    required String userId,
    required String name,
    String? description,
    bool isDefault = false,
  }) async {
    try {
      _logger.i('Uploading resume for user: $userId');

      // Validate file type
      final extension =
          path.extension(file.path).toLowerCase().replaceAll('.', '');
      final validExtensions = ['pdf', 'doc', 'docx'];
      if (!validExtensions.contains(extension)) {
        throw Exception(
          'Invalid file type. Only ${validExtensions.join(", ")} are allowed.',
        );
      }

      // Validate file size (max 10MB)
      final fileSize = await file.length();
      const maxSize = 10 * 1024 * 1024; // 10MB
      if (fileSize > maxSize) {
        throw Exception('File too large. Maximum size is 10MB.');
      }

      // Create a reference to the file location
      final fileName =
          'resume_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final ref = _storage.ref().child('resumes/$userId/$fileName');

      // Upload the file
      final uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      final snapshot = await uploadTask;

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _logger.i('Resume uploaded successfully: $downloadUrl');

      // If this is the default resume, update all other resumes to non-default
      if (isDefault) {
        await _updateDefaultStatus(userId);
      }

      // Create resume document in Firestore
      final resumeData = {
        'userId': userId,
        'name': name,
        'fileUrl': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
        'fileSize': fileSize,
        'fileType': extension,
        'isDefault': isDefault,
        'description': description,
      };

      final docRef = await _firestore.collection('resumes').add(resumeData);

      // Get the document with server timestamp
      final doc = await docRef.get();

      return ResumeModel.fromFirestore(doc);
    } catch (e) {
      _logger.e('Error uploading resume', e);
      throw Exception('Failed to upload resume: $e');
    }
  }

  /// Get all resumes for a user
  Future<List<ResumeModel>> getUserResumes(String userId) async {
    try {
      _logger.i('Getting resumes for user: $userId');

      final snapshot = await _firestore
          .collection('resumes')
          .where('userId', isEqualTo: userId)
          .orderBy('uploadedAt', descending: true)
          .get();

      return snapshot.docs.map(ResumeModel.fromFirestore).toList();
    } catch (e) {
      _logger.e('Error getting user resumes', e);
      return [];
    }
  }

  /// Get default resume for a user
  Future<ResumeModel?> getDefaultResume(String userId) async {
    try {
      _logger.i('Getting default resume for user: $userId');

      final snapshot = await _firestore
          .collection('resumes')
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return ResumeModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      _logger.e('Error getting default resume', e);
      return null;
    }
  }

  /// Delete a resume
  Future<bool> deleteResume(String resumeId) async {
    try {
      _logger.i('Deleting resume: $resumeId');

      // Get the resume document
      final doc = await _firestore.collection('resumes').doc(resumeId).get();

      if (!doc.exists) {
        _logger.w('Resume not found: $resumeId');
        return false;
      }

      final data = doc.data()!;
      final fileUrl = data['fileUrl'] as String?;

      // Delete the file from storage if URL exists
      if (fileUrl != null && fileUrl.isNotEmpty) {
        try {
          final ref = _storage.refFromURL(fileUrl);
          await ref.delete();
          _logger.i('Resume file deleted from storage');
        } catch (e) {
          _logger.w('Error deleting resume file from storage', e);
          // Continue with document deletion even if file deletion fails
        }
      }

      // Delete the document
      await _firestore.collection('resumes').doc(resumeId).delete();

      return true;
    } catch (e) {
      _logger.e('Error deleting resume', e);
      return false;
    }
  }

  /// Set a resume as default
  Future<bool> setDefaultResume(String resumeId, String userId) async {
    try {
      _logger.i('Setting resume as default: $resumeId');

      // Update all resumes to non-default
      await _updateDefaultStatus(userId);

      // Set the selected resume as default
      await _firestore.collection('resumes').doc(resumeId).update({
        'isDefault': true,
      });

      return true;
    } catch (e) {
      _logger.e('Error setting default resume', e);
      return false;
    }
  }

  /// Update resume details
  Future<bool> updateResumeDetails({
    required String resumeId,
    String? name,
    String? description,
  }) async {
    try {
      _logger.i('Updating resume details: $resumeId');

      final updates = <String, dynamic>{};

      if (name != null) {
        updates['name'] = name;
      }

      if (description != null) {
        updates['description'] = description;
      }

      if (updates.isEmpty) {
        _logger.w('No updates provided for resume: $resumeId');
        return false;
      }

      await _firestore.collection('resumes').doc(resumeId).update(updates);

      return true;
    } catch (e) {
      _logger.e('Error updating resume details', e);
      return false;
    }
  }

  /// Update all resumes to non-default
  Future<void> _updateDefaultStatus(String userId) async {
    try {
      final batch = _firestore.batch();

      final snapshot = await _firestore
          .collection('resumes')
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .get();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      await batch.commit();
    } catch (e) {
      _logger.e('Error updating default status', e);
      // Continue with setting the new default even if this fails
    }
  }
}
