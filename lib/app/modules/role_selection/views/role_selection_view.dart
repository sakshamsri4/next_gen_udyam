import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/role_selection/controllers/role_selection_controller.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:next_gen/widgets/neopop_card.dart';
import 'package:next_gen/widgets/neopop_loading_indicator.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Role selection screen shown after signup
class RoleSelectionView extends GetView<RoleSelectionController> {
  /// Creates a role selection view
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          final isMobile =
              sizingInformation.deviceScreenType == DeviceScreenType.mobile;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [
                        theme.colorScheme.surface,
                        theme.colorScheme.surface,
                      ]
                    : [
                        theme.colorScheme.surface,
                        theme.colorScheme.surface,
                      ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 24.w : 32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header
                        Text(
                          'Choose Your Role',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Select how you want to use the app',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(179),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 48.h),

                        // Role selection cards
                        Wrap(
                          spacing: 24.w,
                          runSpacing: 24.h,
                          alignment: WrapAlignment.center,
                          children: [
                            // Employee role card
                            _buildRoleCard(
                              context,
                              title: 'Job Seeker',
                              description:
                                  'Find jobs, apply, and manage your applications',
                              icon: HeroIcons.briefcase,
                              role: UserType.employee,
                            ),

                            // Employer role card
                            _buildRoleCard(
                              context,
                              title: 'Employer',
                              description:
                                  'Post jobs, manage applications, and find talent',
                              icon: HeroIcons.buildingOffice2,
                              role: UserType.employer,
                            ),
                          ],
                        ),
                        SizedBox(height: 48.h),

                        // Continue button
                        Obx(
                          () => CustomNeoPopButton.primary(
                            onTap: controller.isContinueEnabled
                                ? () => controller.continueWithRole()
                                : () {},
                            enabled: controller.isContinueEnabled,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 32.w,
                                vertical: 16.h,
                              ),
                              child: controller.isLoading.value
                                  ? const NeoPopLoadingIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'CONTINUE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String description,
    required HeroIcons icon,
    required UserType role,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Obx(() {
      final isSelected = controller.selectedRole.value == role;

      return GestureDetector(
        onTap: () => controller.setRole(role),
        child: NeoPopCard(
          color: isSelected
              ? theme.colorScheme.primary
              : isDarkMode
                  ? theme.colorScheme.surface
                  : Colors.white,
          width: 280.w,
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                HeroIcon(
                  icon,
                  size: 48.w,
                  color: isSelected ? Colors.white : theme.colorScheme.primary,
                ),
                SizedBox(height: 16.h),

                // Title
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isSelected ? Colors.white : theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),

                // Description
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white.withAlpha(204)
                        : theme.colorScheme.onSurface.withAlpha(179),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
