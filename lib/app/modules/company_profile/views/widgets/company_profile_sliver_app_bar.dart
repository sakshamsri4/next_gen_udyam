import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/company_profile/controllers/company_profile_controller.dart';
import 'package:next_gen/app/modules/company_profile/models/company_profile_model.dart';
import 'package:next_gen/app/modules/company_profile/views/widgets/edit_company_dialog.dart';
import 'package:next_gen/ui/components/avatars/custom_avatar.dart';

/// A sliver app bar for the company profile
class CompanyProfileSliverAppBar extends GetView<CompanyProfileController> {
  /// Creates a new company profile sliver app bar
  const CompanyProfileSliverAppBar({
    required this.profile,
    super.key,
  });

  /// The company profile
  final CompanyProfileModel profile;

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

                // Company logo
                CustomAvatar(
                  imageUrl: profile.logoURL ?? '',
                  height: 80.h,
                  width: 80.w,
                  placeholderText: profile.name[0].toUpperCase(),
                ),

                SizedBox(height: 8.h),

                // Company name
                Text(
                  profile.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4.h),

                // Company location
                if (profile.location != null && profile.location!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroIcon(
                        HeroIcons.mapPin,
                        color: Colors.white.withAlpha(230), // 0.9 opacity
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        profile.location!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlpha(230), // 0.9 opacity
                        ),
                      ),
                    ],
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
          onPressed: () => _showEditCompanyDialog(context),
          tooltip: 'Edit Company Profile',
        ),
      ],
    );
  }

  /// Show the edit company dialog
  void _showEditCompanyDialog(BuildContext context) {
    Get.dialog<void>(
      EditCompanyDialog(profile: profile),
      barrierDismissible: false,
    );
  }
}
