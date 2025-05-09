import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/saved_jobs/controllers/saved_jobs_controller.dart';
import 'package:next_gen/app/shared/widgets/bottom_navigation_bar.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';
import 'package:next_gen/ui/components/loaders/custom_lottie.dart';
import 'package:next_gen/ui/components/loaders/shimmer/saved_jobs_shimmer.dart';

/// Saved jobs screen
class SavedJobsView extends GetView<SavedJobsController> {
  /// Creates a saved jobs view
  const SavedJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
      ),
      bottomNavigationBar: const CustomAnimatedBottomNavBar(),
      body: RefreshIndicator(
        onRefresh: controller.refreshSavedJobs,
        child: Obx(() {
          if (controller.isLoading) {
            return const SavedJobsShimmer();
          }

          if (controller.error.isNotEmpty) {
            return _buildErrorState(theme, controller.error);
          }

          if (controller.savedJobs.isEmpty) {
            return _buildEmptyState(theme);
          }

          return _buildSavedJobsList(theme, isDarkMode);
        }),
      ),
    );
  }

  /// Build the saved jobs list
  Widget _buildSavedJobsList(ThemeData theme, bool isDarkMode) {
    return ListView.builder(
      controller: controller.scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: controller.savedJobs.length,
      itemBuilder: (context, index) {
        final job = controller.savedJobs[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: CustomJobCard(
            avatar: job.logoUrl ?? '',
            companyName: job.company,
            publishTime: job.postedDate.toIso8601String(),
            jobPosition: job.title,
            workplace: job.isRemote ? 'Remote' : 'On-site',
            location: job.location,
            employmentType: job.jobType,
            actionIcon: HeroIcons.bookmark,
            isSaved: true, // Always true in saved jobs screen
            description: job.description,
            onTap: () => controller.navigateToJobDetails(job.id),
            onAvatarTap: () => controller.navigateToCompanyProfile(job.company),
            onActionTap: ({required bool isLiked}) async {
              await controller.unsaveJob(job.id);
              return false; // Return false to indicate it's now unsaved
            },
          ),
        );
      },
    );
  }

  /// Build the empty state
  Widget _buildEmptyState(ThemeData theme) {
    return CustomLottie(
      title: 'No saved jobs yet',
      description: 'Jobs you save will appear here',
      asset: 'assets/empty.json',
      assetHeight: 200.h,
      onTryAgain: () => Get.back<dynamic>(),
    );
  }

  /// Build the error state
  Widget _buildErrorState(ThemeData theme, String errorMessage) {
    return CustomLottie(
      title: 'Something went wrong',
      description: errorMessage,
      asset: 'assets/error.json',
      assetHeight: 200.h,
      onTryAgain: controller.refreshSavedJobs,
    );
  }
}
