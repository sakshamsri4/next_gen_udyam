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

      // Create a reference to the file location
      final extension = file.path.split('.').last;
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

  /// Delete a file from Firebase Storage
  ///
  /// [url] is the URL of the file to delete
  Future<void> deleteFile(String url) async {
    try {
      _logger.i('Deleting file: $url');

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
}
