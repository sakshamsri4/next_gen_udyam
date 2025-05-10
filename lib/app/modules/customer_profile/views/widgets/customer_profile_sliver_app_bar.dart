import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/customer_profile/controllers/customer_profile_controller.dart';
import 'package:next_gen/app/modules/customer_profile/models/customer_profile_model.dart';
import 'package:next_gen/app/modules/customer_profile/views/widgets/edit_profile_dialog.dart';
import 'package:next_gen/ui/components/avatars/custom_avatar.dart';

/// A sliver app bar for the customer profile
class CustomerProfileSliverAppBar extends GetView<CustomerProfileController> {
  /// Creates a new customer profile sliver app bar
  const CustomerProfileSliverAppBar({
    required this.profile,
    super.key,
  });

  /// The customer profile
  final CustomerProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withAlpha(204), // 0.8 opacity
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),

                // Profile image
                CustomAvatar(
                  imageUrl: profile.photoURL ?? '',
                  height: 80.h,
                  width: 80.w,
                  placeholderText: profile.name[0].toUpperCase(),
                ),

                SizedBox(height: 8.h),

                // Name
                Text(
                  profile.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4.h),

                // Job title
                if (profile.jobTitle != null && profile.jobTitle!.isNotEmpty)
                  Text(
                    profile.jobTitle!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withAlpha(230), // 0.9 opacity
                    ),
                  ),
              ],
            ),
          ),
        ),
        titlePadding: EdgeInsets.zero,
      ),
      leading: IconButton(
        icon: const HeroIcon(HeroIcons.arrowLeft),
        onPressed: () => Get.back<void>(),
      ),
      actions: [
        // Edit profile button
        IconButton(
          icon: const HeroIcon(HeroIcons.pencilSquare),
          onPressed: () => _showEditProfileDialog(context),
          tooltip: 'Edit Profile',
        ),
      ],
    );
  }

  /// Show the edit profile dialog
  void _showEditProfileDialog(BuildContext context) {
    Get.dialog<void>(
      EditProfileDialog(profile: profile),
      barrierDismissible: false,
    );
  }
}
