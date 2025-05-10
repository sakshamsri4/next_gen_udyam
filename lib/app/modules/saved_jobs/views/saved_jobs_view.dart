import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/saved_jobs/controllers/saved_jobs_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/bottom_navigation_bar.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
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
    final navigationController = Get.find<NavigationController>();

    return Scaffold(
      key: navigationController.scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.bars3),
          onPressed: navigationController.toggleDrawer,
        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we're on a tablet or larger device
        final isTabletOrLarger = constraints.maxWidth >= 600;

        if (isTabletOrLarger) {
          // Grid view for tablet and larger screens
          return GridView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth > 900 ? 3 : 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: controller.savedJobs.length,
            itemBuilder: (context, index) {
              final job = controller.savedJobs[index];
              return CustomJobCard(
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
                onAvatarTap: () =>
                    controller.navigateToCompanyProfile(job.company),
                onActionTap: ({required bool isLiked}) async {
                  await controller.unsaveJob(job.id);
                  return false; // Return false to indicate it's now unsaved
                },
              );
            },
          );
        } else {
          // List view for mobile screens
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
                  onAvatarTap: () =>
                      controller.navigateToCompanyProfile(job.company),
                  onActionTap: ({required bool isLiked}) async {
                    await controller.unsaveJob(job.id);
                    return false; // Return false to indicate it's now unsaved
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  /// Build the empty state
  Widget _buildEmptyState(ThemeData theme) {
    return CustomLottie(
      title: 'No saved jobs yet',
      description:
          'Jobs you save will appear here. Tap the bookmark icon on any job to save it for later.',
      asset: 'assets/empty.json',
      assetHeight: 200.h,
      titleStyle: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
      descriptionStyle: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
        height: 1.5,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      onTryAgain: () => Get.toNamed<dynamic>(Routes.search),
    );
  }

  /// Build the error state
  Widget _buildErrorState(ThemeData theme, String errorMessage) {
    return CustomLottie(
      title: 'Something went wrong',
      description: errorMessage,
      asset: 'assets/error.json',
      assetHeight: 200.h,
      titleStyle: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.error,
      ),
      descriptionStyle: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
        height: 1.5,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      onTryAgain: controller.refreshSavedJobs,
    );
  }
}
