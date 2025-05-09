import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/company_profile/controllers/company_profile_controller.dart';
import 'package:next_gen/app/modules/company_profile/models/company_profile_model.dart';
import 'package:next_gen/ui/components/buttons/custom_neopop_button.dart';
import 'package:next_gen/ui/components/inputs/neopop_input_field.dart';

/// A dialog for editing a company profile
class EditCompanyDialog extends StatefulWidget {
  /// Creates a new edit company dialog
  const EditCompanyDialog({
    required this.profile,
    super.key,
  });

  /// The company profile to edit
  final CompanyProfileModel profile;

  @override
  State<EditCompanyDialog> createState() => _EditCompanyDialogState();
}

class _EditCompanyDialogState extends State<EditCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _websiteController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _industryController;
  late final TextEditingController _locationController;
  late final TextEditingController _sizeController;
  late final TextEditingController _foundedController;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _websiteController = TextEditingController(text: widget.profile.website);
    _descriptionController =
        TextEditingController(text: widget.profile.description);
    _industryController = TextEditingController(text: widget.profile.industry);
    _locationController = TextEditingController(text: widget.profile.location);
    _sizeController = TextEditingController(text: widget.profile.size);
    _foundedController = TextEditingController(
      text: widget.profile.founded?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _industryController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _foundedController.dispose();
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
                  'Edit Company Profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24.h),

                // Company Logo Picker
                _buildCompanyLogoPicker(theme),
                SizedBox(height: 24.h),

                // Name Field
                NeoPopInputField(
                  controller: _nameController,
                  labelText: 'Company Name',
                  hintText: 'Enter your company name',
                  errorText: _nameController.text.isEmpty
                      ? 'Please enter your company name'
                      : null,
                ),
                SizedBox(height: 16.h),

                // Website Field
                NeoPopInputField(
                  controller: _websiteController,
                  labelText: 'Website',
                  hintText: 'e.g. www.example.com',
                ),
                SizedBox(height: 16.h),

                // Industry Field
                NeoPopInputField(
                  controller: _industryController,
                  labelText: 'Industry',
                  hintText: 'e.g. Technology',
                ),
                SizedBox(height: 16.h),

                // Location Field
                NeoPopInputField(
                  controller: _locationController,
                  labelText: 'Location',
                  hintText: 'e.g. New York, NY',
                ),
                SizedBox(height: 16.h),

                // Size Field
                NeoPopInputField(
                  controller: _sizeController,
                  labelText: 'Company Size',
                  hintText: 'e.g. 1-10 employees',
                ),
                SizedBox(height: 16.h),

                // Founded Field
                NeoPopInputField(
                  controller: _foundedController,
                  labelText: 'Founded Year',
                  hintText: 'e.g. 2020',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),

                // Description Field
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'About Company',
                    hintText: 'Tell us about your company',
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
                        onTap: _isLoading ? null : _saveCompanyProfile,
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

  /// Build the company logo picker
  Widget _buildCompanyLogoPicker(ThemeData theme) {
    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: Stack(
        children: [
          // Company Logo
          CircleAvatar(
            radius: 60.r,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _getCompanyLogo(),
            child: _getCompanyLogoPlaceholder(theme),
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

  /// Get the company logo
  ImageProvider? _getCompanyLogo() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (widget.profile.logoURL != null &&
        widget.profile.logoURL!.isNotEmpty) {
      return NetworkImage(widget.profile.logoURL!);
    }
    return null;
  }

  /// Get the company logo placeholder
  Widget? _getCompanyLogoPlaceholder(ThemeData theme) {
    if (_selectedImage != null ||
        (widget.profile.logoURL != null &&
            widget.profile.logoURL!.isNotEmpty)) {
      return null;
    }
    return Icon(
      Icons.business,
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
                (widget.profile.logoURL != null &&
                    widget.profile.logoURL!.isNotEmpty))
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Logo'),
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
    // TODO(dev): Implement image picking from camera or gallery
    // For now, we'll just show a snackbar
    Get.snackbar(
      'Coming Soon',
      'Image picking will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Save the company profile
  Future<void> _saveCompanyProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final controller = Get.find<CompanyProfileController>();

        // Set the selected image
        if (_selectedImage != null) {
          controller.setSelectedImage(_selectedImage!);
        }

        // Parse founded year
        int? founded;
        if (_foundedController.text.isNotEmpty) {
          founded = int.tryParse(_foundedController.text.trim());
        }

        // Update the profile
        await controller.updateProfile(
          name: _nameController.text.trim(),
          website: _websiteController.text.trim(),
          description: _descriptionController.text.trim(),
          industry: _industryController.text.trim(),
          location: _locationController.text.trim(),
          size: _sizeController.text.trim(),
          founded: founded,
        );

        Get.back<void>();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update company profile: $e',
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
