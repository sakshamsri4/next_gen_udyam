import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/job_posting/controllers/job_posting_controller.dart';
import 'package:next_gen/app/modules/job_posting/models/job_post_model.dart';
import 'package:next_gen/app/modules/job_posting/views/widgets/job_creation_form.dart';
import 'package:next_gen/app/modules/job_posting/views/widgets/job_list_item.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/empty_state.dart';
import 'package:next_gen/app/shared/widgets/role_based_bottom_nav.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/loaders/shimmer/job_management_shimmer.dart';

/// Job posting management view for employers
class JobPostingView extends GetView<JobPostingController> {
  /// Creates a job posting view
  const JobPostingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Jobs',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Add job button
          IconButton(
            icon: const HeroIcon(HeroIcons.plus),
            onPressed: () => _showJobCreationForm(context),
            tooltip: 'Create New Job',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const RoleBasedBottomNav(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showJobCreationForm(context),
        backgroundColor: RoleThemes.employerPrimary,
        icon: const HeroIcon(
          HeroIcons.plus,
          style: HeroIconStyle.solid,
          color: Colors.white,
        ),
        label: const Text('Post Job', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Metrics Dashboard
          _buildMetricsDashboard(theme, isDarkMode),

          // Tab bar
          ColoredBox(
            color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
            child: TabBar(
              controller: controller.tabController,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              labelColor: RoleThemes.employerPrimary,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
              indicatorColor: RoleThemes.employerPrimary,
              tabs: [
                _buildTab('All', null),
                _buildTab('Active', JobStatus.active),
                _buildTab('Paused', JobStatus.paused),
                _buildTab('Drafts', JobStatus.draft),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    controller.setStatusFilter(null);
                  case 1:
                    controller.setStatusFilter(JobStatus.active);
                  case 2:
                    controller.setStatusFilter(JobStatus.paused);
                  case 3:
                    controller.setStatusFilter(JobStatus.draft);
                }
              },
            ),
          ),

          // Job list
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshJobs,
              child: Obx(() {
                if (controller.isLoading) {
                  return const JobManagementShimmer();
                }

                if (controller.error.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const HeroIcon(
                          HeroIcons.exclamationTriangle,
                          size: 64,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.error,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: controller.refreshJobs,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RoleThemes.employerPrimary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredJobs.isEmpty) {
                  return EmptyState(
                    icon: HeroIcons.briefcase,
                    title: 'No Jobs Found',
                    description: controller.selectedStatusFilter == null
                        ? "You haven't posted any jobs yet. Tap the + button to create your first job posting."
                        : 'No jobs with the selected status. Try selecting a different status or create a new job.',
                    buttonText: 'Create Job',
                    onButtonPressed: () => _showJobCreationForm(context),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = controller.filteredJobs[index];
                    return JobListItem(
                      job: job,
                      onEdit: () => _showJobEditForm(context, job),
                      onDelete: () => controller.deleteJobPosting(job.id),
                      onStatusChange: (status) =>
                          controller.updateJobStatus(job.id, status),
                      onDuplicate: () => controller.duplicateJobPosting(job),
                      onViewApplicants: () =>
                          controller.navigateToApplicants(job.id),
                      onViewDetails: () =>
                          controller.navigateToJobDetails(job.id),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a tab with count badge
  Widget _buildTab(String title, JobStatus? status) {
    return Obx(() {
      final count = status == null
          ? controller.jobs.length
          : controller.statusCounts[status] ?? 0;

      return Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            const SizedBox(width: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color:
                    RoleThemes.employerPrimary.withAlpha(51), // 0.2 * 255 = 51
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Show job creation form
  void _showJobCreationForm(BuildContext context) {
    Get.dialog<void>(
      Dialog(
        insetPadding: EdgeInsets.all(16.w),
        child: Container(
          width: 800.w,
          constraints: BoxConstraints(maxHeight: 600.h),
          child: const JobCreationForm(isEditing: false),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Show job edit form
  void _showJobEditForm(BuildContext context, JobPostModel job) {
    controller.loadJobForEditing(job);
    Get.dialog<void>(
      Dialog(
        insetPadding: EdgeInsets.all(16.w),
        child: Container(
          width: 800.w,
          constraints: BoxConstraints(maxHeight: 600.h),
          child: const JobCreationForm(isEditing: true),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Build metrics dashboard
  Widget _buildMetricsDashboard(ThemeData theme, bool isDarkMode) {
    // Define the employer-specific colors
    const primaryColor = RoleThemes.employerPrimary;
    const secondaryColor = Color(0xFFD97706); // Amber secondary color

    return Obx(() {
      if (controller.isLoading) {
        return const SizedBox(height: 120);
      }

      // Calculate metrics
      final totalJobs = controller.jobs.length;
      final activeJobs = controller.statusCounts[JobStatus.active] ?? 0;
      final pausedJobs = controller.statusCounts[JobStatus.paused] ?? 0;
      final draftJobs = controller.statusCounts[JobStatus.draft] ?? 0;

      // Calculate total applications and views
      var totalApplications = 0;
      var totalViews = 0;
      for (final job in controller.jobs) {
        totalApplications += job.applicationCount;
        totalViews += job.viewCount;
      }

      // Calculate conversion rate (applications / views * 100)
      final conversionRate = totalViews > 0
          ? (totalApplications / totalViews * 100).toStringAsFixed(1)
          : '0.0';

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? primaryColor.withAlpha(38) // 0.15 * 255 ≈ 38
              : primaryColor.withAlpha(20), // 0.08 * 255 ≈ 20
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Posting Metrics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _buildMetricItem(
                  icon: HeroIcons.briefcase,
                  label: 'Total Jobs',
                  value: totalJobs.toString(),
                  color: primaryColor,
                  theme: theme,
                ),
                _buildMetricItem(
                  icon: HeroIcons.check,
                  label: 'Active Jobs',
                  value: activeJobs.toString(),
                  color: Colors.green,
                  theme: theme,
                ),
                _buildMetricItem(
                  icon: HeroIcons.pause,
                  label: 'Paused Jobs',
                  value: pausedJobs.toString(),
                  color: Colors.orange,
                  theme: theme,
                ),
                _buildMetricItem(
                  icon: HeroIcons.documentText,
                  label: 'Draft Jobs',
                  value: draftJobs.toString(),
                  color: Colors.grey,
                  theme: theme,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildMetricItem(
                  icon: HeroIcons.users,
                  label: 'Applications',
                  value: totalApplications.toString(),
                  color: secondaryColor,
                  theme: theme,
                ),
                _buildMetricItem(
                  icon: HeroIcons.eye,
                  label: 'Total Views',
                  value: totalViews.toString(),
                  color: Colors.blue,
                  theme: theme,
                ),
                _buildMetricItem(
                  icon: HeroIcons.chartBar,
                  label: 'Conversion',
                  value: '$conversionRate%',
                  color: Colors.purple,
                  theme: theme,
                ),
                _buildMetricItem(
                  icon: HeroIcons.star,
                  label: 'Featured',
                  value: controller.jobs
                      .where((job) => job.isFeatured)
                      .length
                      .toString(),
                  color: Colors.amber,
                  theme: theme,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Build a metric item
  Widget _buildMetricItem({
    required HeroIcons icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color.withAlpha(26), // 0.1 * 255 ≈ 26
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: HeroIcon(
                icon,
                size: 20.r,
                color: color,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color
                  ?.withAlpha(179), // 0.7 * 255 ≈ 179
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
