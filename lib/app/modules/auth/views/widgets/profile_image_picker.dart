import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A widget for picking profile images from camera or gallery
class ProfileImagePicker extends StatefulWidget {
  /// Creates a profile image picker
  ///
  /// [currentImageUrl] is the URL of the current profile image
  /// [onImageSelected] is called when a new image is selected
  const ProfileImagePicker({
    required this.onImageSelected,
    super.key,
    this.currentImageUrl,
  });

  /// The URL of the current profile image
  final String? currentImageUrl;

  /// Called when a new image is selected
  final void Function(File) onImageSelected;

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceOptions,
          child: Stack(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _getProfileImage(),
                child: _getProfileImagePlaceholder(theme),
              ),
              // Edit Icon
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.electricBlue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: const HeroIcon(
                    HeroIcons.camera,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to change profile picture',
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                theme.colorScheme.onSurface.withAlpha(153), // 0.6 * 255 = 153
          ),
        ),
      ],
    );
  }

  /// Get the profile image to display
  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (widget.currentImageUrl != null &&
        widget.currentImageUrl!.isNotEmpty) {
      return NetworkImage(widget.currentImageUrl!);
    }
    return null;
  }

  /// Get the placeholder to display when no image is available
  Widget? _getProfileImagePlaceholder(ThemeData theme) {
    if (_selectedImage == null &&
        (widget.currentImageUrl == null || widget.currentImageUrl!.isEmpty)) {
      return Icon(
        Icons.person,
        size: 60,
        color: Colors.grey.shade800,
      );
    }
    return null;
  }

  /// Show options to pick image from camera or gallery
  void _showImageSourceOptions() {
    Get.bottomSheet<void>(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const HeroIcon(HeroIcons.camera),
              title: const Text('Camera'),
              onTap: () {
                Get.back<void>();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const HeroIcon(HeroIcons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Get.back<void>();
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_selectedImage != null || widget.currentImageUrl != null)
              ListTile(
                leading: const HeroIcon(HeroIcons.trash),
                title: const Text('Remove Photo'),
                onTap: () {
                  Get.back<void>();
                  setState(() {
                    _selectedImage = null;
                  });
                  // TODO(profile): Handle removing the current photo
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Pick an image from the specified source
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        widget.onImageSelected(_selectedImage!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
