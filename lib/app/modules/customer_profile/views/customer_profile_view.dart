import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/customer_profile/controllers/customer_profile_controller.dart';
import 'package:next_gen/app/modules/customer_profile/views/widgets/customer_profile_sliver_app_bar.dart';
import 'package:next_gen/app/modules/customer_profile/views/widgets/profile_completeness_indicator.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/ui/components/loaders/shimmer/profile_shimmer.dart';

/// The customer profile view
class CustomerProfileView extends GetView<CustomerProfileController> {
  /// Creates a new customer profile view
  const CustomerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const UnifiedBottomNav(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ProfileShimmer();
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return Center(
            child: Text(
              'Profile not found',
              style: theme.textTheme.titleLarge,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: CustomScrollView(
            slivers: [
              // Profile header with app bar
              CustomerProfileSliverAppBar(profile: profile),

              // Profile content
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Completeness Indicator
                        const ProfileCompletenessIndicator(),

                        SizedBox(height: 16.h),

                        // About Me section
                        if (profile.description != null &&
                            profile.description!.isNotEmpty)
                          _buildAboutMeSection(theme, profile.description!),

                        SizedBox(height: 16.h),

                        // Work Experience section
                        if (profile.workExperience.isNotEmpty)
                          _buildSimpleSection(
                            theme,
                            'Work Experience',
                            'Add your work experience to showcase your professional background.',
                          ),

                        SizedBox(height: 16.h),

                        // Education section
                        if (profile.education.isNotEmpty)
                          _buildSimpleSection(
                            theme,
                            'Education',
                            'Add your educational background to highlight your qualifications.',
                          ),

                        SizedBox(height: 16.h),

                        // Skills section
                        _buildSkillsSection(theme, profile.skills),

                        SizedBox(height: 16.h),

                        // Languages section
                        if (profile.languages.isNotEmpty)
                          _buildSimpleSection(
                            theme,
                            'Languages',
                            'Add languages you speak to highlight your communication abilities.',
                          ),

                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Build the About Me section
  Widget _buildAboutMeSection(ThemeData theme, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          description,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  /// Build a simple section with title and description
  Widget _buildSimpleSection(
    ThemeData theme,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: 16.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Show dialog to add content
                      Get.snackbar(
                        'Coming Soon',
                        'This feature will be implemented soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Text('Add ${title.toLowerCase()}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build the skills section
  Widget _buildSkillsSection(ThemeData theme, List<String> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (skills.isEmpty)
                  Text(
                    'Add your skills to showcase your expertise.',
                    style: theme.textTheme.bodyLarge,
                  )
                else
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: const Color(0xFFE6F0FF), // Light blue
                      );
                    }).toList(),
                  ),
                SizedBox(height: 16.h),
                Center(
                  child: ElevatedButton(
                    onPressed: controller.navigateToSkillsAssessment,
                    child: const Text('Assess your skills'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
