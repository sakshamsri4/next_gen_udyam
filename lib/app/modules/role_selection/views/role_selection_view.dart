import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/widgets/auth_progress_indicator.dart';
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
                        // Progress indicator
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: AuthProgressIndicator(
                            currentStep: AuthStep.roleSelection,
                          ),
                        ),
                        SizedBox(height: 16.h),

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
                              color:
                                  const Color(0xFF2563EB), // Blue for employee
                              illustration: 'assets/images/employee_role.png',
                              features: [
                                'Discover personalized job recommendations',
                                'Search and save interesting jobs',
                                'Track application status',
                                'Build and manage your professional profile',
                                'Get insights about your industry',
                              ],
                            ),

                            // Employer role card
                            _buildRoleCard(
                              context,
                              title: 'Employer',
                              description:
                                  'Post jobs, manage applications, and find talent',
                              icon: HeroIcons.buildingOffice2,
                              role: UserType.employer,
                              color:
                                  const Color(0xFF059669), // Green for employer
                              illustration: 'assets/images/employer_role.png',
                              features: [
                                'Post and manage job listings',
                                'Review and filter applicants',
                                'Track hiring metrics and analytics',
                                'Build your company profile',
                                'Connect with potential candidates',
                              ],
                            ),

                            // Admin role card
                            _buildRoleCard(
                              context,
                              title: 'Admin',
                              description:
                                  'Manage users, jobs, and system settings',
                              icon: HeroIcons.wrenchScrewdriver,
                              role: UserType.admin,
                              color:
                                  const Color(0xFF4F46E5), // Indigo for admin
                              illustration: 'assets/images/admin_role.png',
                              features: [
                                'Manage users and permissions',
                                'Moderate job postings and content',
                                'Configure system settings',
                                'View platform analytics',
                                'Handle user support requests',
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 48.h),

                        // Continue button
                        Obx(() {
                          // Get role-specific color
                          var buttonColor = theme.colorScheme.primary;
                          if (controller.selectedRole.value ==
                              UserType.employee) {
                            buttonColor = const Color(0xFF2563EB); // Blue
                          } else if (controller.selectedRole.value ==
                              UserType.employer) {
                            buttonColor = const Color(0xFF059669); // Green
                          } else if (controller.selectedRole.value ==
                              UserType.admin) {
                            buttonColor = const Color(0xFF4F46E5); // Indigo
                          }

                          return Column(
                            children: [
                              CustomNeoPopButton(
                                color: buttonColor,
                                onTap: controller.isContinueEnabled
                                    ? () {
                                        // Add haptic feedback
                                        HapticFeedback.mediumImpact();
                                        controller.continueWithRole();
                                      }
                                    : () {},
                                enabled: controller.isContinueEnabled,
                                shimmer: true, // Add shimmer effect
                                depth:
                                    10, // Increase depth for better 3D effect
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
                                          'CONTINUE WITH ${_getRoleName(controller.selectedRole.value)}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          );
                        }),
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

  /// Helper method to get a readable role name
  String _getRoleName(UserType? role) {
    if (role == null) return 'SELECTED ROLE';

    switch (role) {
      case UserType.employee:
        return 'EMPLOYEE';
      case UserType.employer:
        return 'EMPLOYER';
      case UserType.admin:
        return 'ADMIN';
    }
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String description,
    required HeroIcons icon,
    required UserType role,
    Color? color,
    String? illustration,
    List<String>? features,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Use the provided color or fall back to the theme's primary color
    final roleColor = color ?? theme.colorScheme.primary;

    return Obx(() {
      final isSelected = controller.selectedRole.value == role;

      return AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: NeoPopCard(
          color: isSelected
              ? roleColor
              : isDarkMode
                  ? theme.colorScheme.surface
                  : Colors.white,
          borderColor: isSelected ? Colors.white : roleColor.withAlpha(100),
          width: 320.w,
          onTap: () {
            // Add haptic feedback
            HapticFeedback.mediumImpact();
            // Set the role directly
            controller.setRole(role);
          },
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Illustration or Icon
                // Use icon instead of illustration for now
                Container(
                  width: 80.w,
                  height: 80.w,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withAlpha((0.2 * 255).toInt())
                        : roleColor.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: HeroIcon(
                      icon,
                      size: 48.w,
                      color: isSelected ? Colors.white : roleColor,
                    ),
                  ),
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

                // Features list
                if (features != null && features.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withAlpha((0.1 * 255).toInt())
                          : roleColor.withAlpha((0.05 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final feature in features)
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16.w,
                                  color: isSelected ? Colors.white : roleColor,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? Colors.white.withAlpha(204)
                                          : theme.colorScheme.onSurface
                                              .withAlpha(179),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],

                // Selected indicator
                if (isSelected) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'SELECTED',
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
