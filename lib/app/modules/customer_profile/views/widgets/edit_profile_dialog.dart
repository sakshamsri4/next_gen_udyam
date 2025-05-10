import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/customer_profile/controllers/customer_profile_controller.dart';
import 'package:next_gen/app/modules/customer_profile/models/customer_profile_model.dart';
import 'package:next_gen/ui/components/buttons/custom_neopop_button.dart';
import 'package:next_gen/ui/components/inputs/neopop_input_field.dart';

/// A dialog for editing a customer profile
class EditProfileDialog extends StatefulWidget {
  /// Creates a new edit profile dialog
  const EditProfileDialog({
    required this.profile,
    super.key,
  });

  /// The customer profile to edit
  final CustomerProfileModel profile;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _descriptionController;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _jobTitleController = TextEditingController(text: widget.profile.jobTitle);
    _descriptionController =
        TextEditingController(text: widget.profile.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.r),
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
                SizedBox(height: 24.h),

                // Profile Image Picker
                _buildProfileImagePicker(theme),
                SizedBox(height: 24.h),

                // Name Field
                NeoPopInputField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  errorText: _nameController.text.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                SizedBox(height: 16.h),

                // Job Title Field
                NeoPopInputField(
                  controller: _jobTitleController,
                  labelText: 'Job Title',
                  hintText: 'e.g. Software Engineer',
                ),
                SizedBox(height: 16.h),

                // Description Field
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'About Me',
                    hintText: 'Tell us about yourself',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 32.h),

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
                    SizedBox(width: 16.w),
                    // Save Button
                    Expanded(
                      child: CustomNeoPopButton.primary(
                        onTap: _isLoading ? null : _saveProfile,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
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

  /// Build the profile image picker
  Widget _buildProfileImagePicker(ThemeData theme) {
    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: Stack(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 60.r,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _getProfileImage(),
            child: _getProfileImagePlaceholder(theme),
          ),
          // Edit Icon
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get the profile image
  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (widget.profile.photoURL != null &&
        widget.profile.photoURL!.isNotEmpty) {
      return NetworkImage(widget.profile.photoURL!);
    }
    return null;
  }

  /// Get the profile image placeholder
  Widget? _getProfileImagePlaceholder(ThemeData theme) {
    if (_selectedImage != null ||
        (widget.profile.photoURL != null &&
            widget.profile.photoURL!.isNotEmpty)) {
      return null;
    }
    return Icon(
      Icons.person,
      size: 60.r,
      color: Colors.grey.shade800,
    );
  }

  /// Show the image source options
  void _showImageSourceOptions() {
    Get.bottomSheet<void>(
      Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: Get.textTheme.titleLarge,
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back<void>();
                _pickImage('camera');
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back<void>();
                _pickImage('gallery');
              },
            ),
            if (_selectedImage != null ||
                (widget.profile.photoURL != null &&
                    widget.profile.photoURL!.isNotEmpty))
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Photo'),
                onTap: () {
                  Get.back<void>();
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Pick an image from the specified source
  void _pickImage(String source) {
    // TODO(dev): Implement image picking from $source
    // For now, we'll just show a snackbar
    Get.snackbar(
      'Coming Soon',
      'Image picking will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Save the profile
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final controller = Get.find<CustomerProfileController>();

        // Set the selected image
        if (_selectedImage != null) {
          controller.setSelectedImage(_selectedImage!);
        }

        // Update the profile
        await controller.updateProfile(
          name: _nameController.text.trim(),
          jobTitle: _jobTitleController.text.trim(),
          description: _descriptionController.text.trim(),
        );

        Get.back<void>();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update profile: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
