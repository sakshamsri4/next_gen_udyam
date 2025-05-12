import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/resume/models/resume_model.dart';
import 'package:next_gen/app/modules/resume/services/resume_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/utils/list_extensions.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// Controller for the Resume module
class ResumeController extends GetxController {
  /// Constructor
  ResumeController({
    required ResumeService resumeService,
    required LoggerService logger,
    AuthController? authController,
  })  : _resumeService = resumeService,
        _logger = logger,
        _authController = authController ?? Get.find<AuthController>();

  final ResumeService _resumeService;
  final LoggerService _logger;
  final AuthController _authController;

  // Observable state variables
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxList<ResumeModel> _resumes = <ResumeModel>[].obs;
  final Rx<ResumeModel?> _selectedResume = Rx<ResumeModel?>(null);
  final RxString _uploadProgress = '0%'.obs;
  final RxBool _isEditingResume = false.obs;
  final RxString _resumeName = ''.obs;
  final RxString _resumeDescription = ''.obs;

  /// Get all resumes
  List<ResumeModel> get resumes => _resumes;

  /// Get selected resume
  ResumeModel? get selectedResume => _selectedResume.value;

  /// Get upload progress
  String get uploadProgress => _uploadProgress.value;

  /// Check if editing resume
  bool get isEditingResume => _isEditingResume.value;

  /// Get resume name
  String get resumeName => _resumeName.value;

  /// Get resume description
  String get resumeDescription => _resumeDescription.value;

  @override
  void onInit() {
    super.onInit();
    _logger.i('ResumeController initialized');
    _loadResumes();
  }

  /// Load all resumes for the current user
  Future<void> _loadResumes() async {
    try {
      isLoading.value = true;
      _logger.i('Loading resumes...');

      final userId = _authController.user.value?.uid;
      if (userId == null) {
        throw Exception('User ID not available');
      }

      final resumes = await _resumeService.getUserResumes(userId);
      _resumes.assignAll(resumes);

      // Set the default resume as selected
      final defaultResume = resumes.firstWhereOrNull((r) => r.isDefault);
      _selectedResume.value = defaultResume ?? resumes.safeFirst;

      _logger.i('Loaded ${resumes.length} resumes');
    } catch (e) {
      _logger.e('Error loading resumes', e);
      Get.snackbar(
        'Error',
        'Failed to load resumes. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick and upload a resume file
  Future<void> pickAndUploadResume() async {
    try {
      _logger.i('Picking resume file...');

      // Check if user is authenticated
      final userId = _authController.user.value?.uid;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'You need to be logged in to upload a resume.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // For now, show a snackbar since we don't have file_picker dependency
      Get.snackbar(
        'Coming Soon',
        'Resume upload feature is under development. We need to add file_picker dependency.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.electricBlue,
        colorText: Colors.white,
      );

      // TODO(sakshamsri4): Implement file picking with FilePicker. This requires adding file_picker dependency to pubspec.yaml.

      /*
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        _logger.i('No file selected');
        return;
      }

      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      // Show dialog to get resume name and description
      await _showResumeDetailsDialog(fileName);

      if (_resumeName.value.isEmpty) {
        // User cancelled the dialog
        return;
      }

      // Upload the file
      await _uploadResume(
        file: file,
        name: _resumeName.value,
        description: _resumeDescription.value,
      );
      */
    } catch (e) {
      _logger.e('Error picking or uploading resume', e);
      Get.snackbar(
        'Error',
        'Failed to upload resume: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Upload a resume file
  // This method is currently unused but will be used when file_picker is added
  // ignore: unused_element
  Future<void> _uploadResume({
    required File file,
    required String name,
    String? description,
    bool isDefault = false,
  }) async {
    try {
      isUploading.value = true;
      _uploadProgress.value = '0%';
      _logger.i('Uploading resume: $name');

      // If this is the first resume, make it default
      final shouldBeDefault = _resumes.isEmpty || isDefault;

      // Upload the resume
      final resume = await _resumeService.uploadResume(
        file: file,
        userId: _authController.user.value!.uid,
        name: name,
        description: description,
        isDefault: shouldBeDefault,
      );

      // Add the new resume to the list
      _resumes.insert(0, resume);

      // If this is the default resume, update the selected resume
      if (shouldBeDefault) {
        _selectedResume.value = resume;
      }

      Get.snackbar(
        'Success',
        'Resume uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh the list
      await _loadResumes();
    } catch (e) {
      _logger.e('Error uploading resume', e);
      Get.snackbar(
        'Error',
        'Failed to upload resume: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
      _uploadProgress.value = '0%';
    }
  }

  /// Delete a resume
  Future<void> deleteResume(String resumeId) async {
    try {
      isLoading.value = true;
      _logger.i('Deleting resume: $resumeId');

      final success = await _resumeService.deleteResume(resumeId);
      if (success) {
        // Remove the resume from the list
        _resumes.removeWhere((r) => r.id == resumeId);

        // If the deleted resume was selected, select another one
        if (_selectedResume.value?.id == resumeId) {
          _selectedResume.value = _resumes.safeFirst;
        }

        Get.snackbar(
          'Success',
          'Resume deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete resume',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _logger.e('Error deleting resume', e);
      Get.snackbar(
        'Error',
        'Failed to delete resume: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Set a resume as default
  Future<void> setDefaultResume(String resumeId) async {
    try {
      isLoading.value = true;
      _logger.i('Setting resume as default: $resumeId');

      final userId = _authController.user.value?.uid;
      if (userId == null) {
        throw Exception('User ID not available');
      }

      final success = await _resumeService.setDefaultResume(resumeId, userId);
      if (success) {
        // Refresh the list
        await _loadResumes();

        Get.snackbar(
          'Success',
          'Default resume updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update default resume',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _logger.e('Error setting default resume', e);
      Get.snackbar(
        'Error',
        'Failed to update default resume: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// View a resume
  Future<void> viewResume(String fileUrl) async {
    try {
      _logger.i('Viewing resume: $fileUrl');

      final uri = Uri.parse(fileUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch $fileUrl');
      }
    } catch (e) {
      _logger.e('Error viewing resume', e);
      Get.snackbar(
        'Error',
        'Failed to open resume: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Edit resume details
  Future<void> editResumeDetails(String resumeId) async {
    try {
      _logger.i('Editing resume details: $resumeId');

      // Find the resume
      final resume = _resumes.firstWhereOrNull((r) => r.id == resumeId);
      if (resume == null) {
        throw Exception('Resume not found');
      }

      // Set the current values
      _resumeName.value = resume.name;
      _resumeDescription.value = resume.description ?? '';

      // Show the edit dialog
      _isEditingResume.value = true;
      await _showResumeDetailsDialog(resume.name, isEditing: true);

      if (!_isEditingResume.value) {
        // User cancelled the dialog
        return;
      }

      // Update the resume details
      final success = await _resumeService.updateResumeDetails(
        resumeId: resumeId,
        name: _resumeName.value,
        description: _resumeDescription.value,
      );

      if (success) {
        // Refresh the list
        await _loadResumes();

        Get.snackbar(
          'Success',
          'Resume details updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update resume details',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _logger.e('Error editing resume details', e);
      Get.snackbar(
        'Error',
        'Failed to update resume details: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isEditingResume.value = false;
    }
  }

  /// Show dialog to get resume name and description
  Future<void> _showResumeDetailsDialog(
    String fileName, {
    bool isEditing = false,
  }) async {
    // Set initial values
    if (!isEditing) {
      // For new resume, use the file name without extension as the default name
      final nameWithoutExtension = fileName.split('.').first;
      _resumeName.value = nameWithoutExtension;
      _resumeDescription.value = '';
    }

    final nameController = TextEditingController(text: _resumeName.value);
    final descriptionController =
        TextEditingController(text: _resumeDescription.value);

    await Get.dialog<void>(
      AlertDialog(
        title: Text(isEditing ? 'Edit Resume Details' : 'Resume Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Resume Name',
                hintText: 'Enter a name for your resume',
              ),
              onChanged: (value) => _resumeName.value = value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter a description for your resume',
              ),
              maxLines: 3,
              onChanged: (value) => _resumeDescription.value = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Clear values and close dialog
              _resumeName.value = '';
              _resumeDescription.value = '';
              _isEditingResume.value = false;
              Get.back<void>();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate name
              if (_resumeName.value.trim().isEmpty) {
                Get.snackbar(
                  'Error',
                  'Resume name cannot be empty',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              Get.back<void>();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.electricBlue,
            ),
            child: Text(isEditing ? 'Update' : 'Upload'),
          ),
        ],
      ),
    );
  }

  /// Refresh resumes
  Future<void> refreshResumes() async {
    await _loadResumes();
  }

  /// Navigate to resume view
  void navigateToResumeView() {
    Get.toNamed<dynamic>(Routes.resume);
  }
}
