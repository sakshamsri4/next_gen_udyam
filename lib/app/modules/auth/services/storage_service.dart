import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A service for handling file storage operations
class StorageService extends GetxService {
  /// The Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// The logger service
  final LoggerService _logger = Get.find<LoggerService>();

  /// Upload a profile image to Firebase Storage
  ///
  /// [file] is the image file to upload
  /// [userId] is the ID of the user
  ///
  /// Returns the download URL of the uploaded image
  Future<String> uploadProfileImage(File file, String userId) async {
    try {
      _logger.i('Uploading profile image for user: $userId');

      // Validate file type
      final extension = file.path.split('.').last.toLowerCase();
      final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
      if (!validExtensions.contains(extension)) {
        throw Exception(
          'Invalid file type. Only ${validExtensions.join(", ")} are allowed.',
        );
      }

      // Validate file size (max 5MB)
      final fileSize = await file.length();
      const maxSize = 5 * 1024 * 1024; // 5MB
      if (fileSize > maxSize) {
        throw Exception('File too large. Maximum size is 5MB.');
      }

      // Delete old profile images first
      await _deleteOldProfileImages(userId);

      // Create a reference to the file location
      final fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final ref = _storage.ref().child('profile_images/$userId/$fileName');

      // Upload the file
      final uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      final snapshot = await uploadTask;

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _logger.i('Profile image uploaded successfully: $downloadUrl');

      return downloadUrl;
    } catch (e, stackTrace) {
      _logger.e('Error uploading profile image', e, stackTrace);
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /// Deletes old profile images for a user
  ///
  /// [userId] is the ID of the user
  Future<void> _deleteOldProfileImages(String userId) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId');
      final result = await ref.listAll();

      final deletionFutures = result.items.map((item) => item.delete());
      await Future.wait(deletionFutures);

      _logger.i(
        'Deleted ${result.items.length} old profile images for user: $userId',
      );
    } catch (e, stackTrace) {
      _logger.w('Error deleting old profile images', e, stackTrace);
      // Continue with the upload even if cleanup fails
    }
  }

  /// Delete a file from Firebase Storage
  ///
  /// [url] is the URL of the file to delete
  Future<void> deleteFile(String url) async {
    try {
      _logger.i('Deleting file: $url');

      // Basic URL validation
      if (url.isEmpty ||
          !url.startsWith('https://firebasestorage.googleapis.com')) {
        throw Exception('Invalid Firebase Storage URL');
      }

      // Create a reference to the file
      final ref = _storage.refFromURL(url);

      // Delete the file
      await ref.delete();

      _logger.i('File deleted successfully');
    } catch (e, stackTrace) {
      _logger.e('Error deleting file', e, stackTrace);
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Replaces a user's profile image and deletes the old one
  ///
  /// [file] is the new image file to upload
  /// [userId] is the ID of the user
  /// [oldImageUrl] is the URL of the previous profile image (optional)
  ///
  /// Returns the download URL of the uploaded image
  Future<String> replaceProfileImage(
    File file,
    String userId, [
    String? oldImageUrl,
  ]) async {
    // Upload the new image
    final newImageUrl = await uploadProfileImage(file, userId);

    // Delete the old image if it exists
    if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
      try {
        await deleteFile(oldImageUrl);
      } catch (e) {
        // Log but don't fail if old image deletion fails
        _logger.w('Failed to delete old profile image: $e');
      }
    }

    return newImageUrl;
  }
}
