import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/auth/services/storage_service.dart';
import 'package:next_gen/app/modules/auth/views/widgets/profile_image_picker.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/ui/components/buttons/custom_neopop_button.dart';
import 'package:next_gen/ui/components/inputs/neopop_input_field.dart';

/// A dialog for editing user profile information
class EditProfileDialog extends StatefulWidget {
  /// Creates an edit profile dialog
  ///
  /// [user] is the current user
  const EditProfileDialog({
    required this.user,
    super.key,
  });

  /// The current user
  final User user;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _nameError;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.user.displayName ?? '');
    _phoneController =
        TextEditingController(text: widget.user.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Title
                Text(
                  'Edit Profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Image Picker
                ProfileImagePicker(
                  currentImageUrl: widget.user.photoURL,
                  onImageSelected: (file) {
                    setState(() {
                      _selectedImage = file;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Name Field
                NeoPopInputField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: _nameError,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    if (_nameError != null) {
                      setState(() {
                        _nameError = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Phone Field (disabled for now)
                NeoPopInputField(
                  controller: _phoneController,
                  labelText: 'Phone Number (Coming Soon)',
                  hintText: 'Enter your phone number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  keyboardType: TextInputType.phone,
                  enabled: false,
                ),
                const SizedBox(height: 32),

                // Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: CustomNeoPopButton.secondary(
                        onTap: () => Get.back<void>(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Save Button
                    Expanded(
                      child: CustomNeoPopButton.primary(
                        onTap: _isLoading ? null : _saveProfile,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'SAVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Validate the form
  bool _validateForm() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Name is required';
      });
      return false;
    }
    return true;
  }

  /// Save the profile
  Future<void> _saveProfile() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Get.find<AuthService>();
      final authController = Get.find<AuthController>();
      final storageService = Get.find<StorageService>();
      final logger = Get.find<LoggerService>();

      // Upload image if selected
      String? photoURL;
      if (_selectedImage != null) {
        try {
          logger.i('Uploading profile image');
          photoURL = await storageService.uploadProfileImage(
            _selectedImage!,
            widget.user.uid,
          );
          logger.i('Profile image uploaded: $photoURL');
        } catch (e) {
          logger.e('Error uploading profile image', e);
          // Continue with profile update even if image upload fails
          Get.snackbar(
            'Warning',
            'Failed to upload profile image, but profile will still be updated.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }

      // Update profile
      await authService.updateUserProfile(
        displayName: _nameController.text.trim(),
        photoURL: photoURL,
      );

      // Refresh user data
      await authController.refreshUser();

      // Show success message and close dialog
      Get
        ..back<void>()
        ..snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
