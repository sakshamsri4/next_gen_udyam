import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applications/controllers/applications_controller.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/role_based_bottom_nav.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/loaders/custom_lottie.dart';
import 'package:next_gen/ui/components/loaders/shimmer/applications_shimmer.dart';

/// Applications view
class ApplicationsView extends GetView<ApplicationsController> {
  /// Constructor
  const ApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final navigationController = Get.find<NavigationController>();

    // Create a local scaffold key for this view
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'My Applications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.bars3),
          onPressed: () => navigationController.toggleDrawer(scaffoldKey),
        ),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const RoleBasedBottomNav(),
      body: RefreshIndicator(
        onRefresh: controller.refreshApplications,
        child: Obx(() {
          if (controller.isLoading) {
            return _buildLoadingState();
          }

          if (controller.error.isNotEmpty) {
            return _buildErrorState(theme, controller.error);
          }

          if (controller.applications.isEmpty) {
            return _buildEmptyState(theme);
          }

          return _buildApplicationsList(theme, isDarkMode);
        }),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const ApplicationsShimmer();
  }

  /// Build error state
  Widget _buildErrorState(ThemeData theme, String error) {
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
            error,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshApplications,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLottie(
            title: 'No Applications Yet',
            asset: 'assets/animations/empty.json',
            assetHeight: 200.h,
          ),
          const SizedBox(height: 16),
          Text(
            'No Applications Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "You haven't applied to any jobs yet. Start exploring jobs and submit your applications!",
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed<dynamic>('/search'),
            child: const Text('Find Jobs'),
          ),
        ],
      ),
    );
  }

  /// Build applications list
  Widget _buildApplicationsList(ThemeData theme, bool isDarkMode) {
    return Column(
      children: [
        // Status filter tabs
        _buildStatusFilterTabs(theme),

        // Applications list
        Expanded(
          child: ListView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: controller.filteredApplications.length,
            itemBuilder: (context, index) {
              final application = controller.filteredApplications[index];
              return _buildApplicationCard(application, theme, isDarkMode);
            },
          ),
        ),
      ],
    );
  }

  /// Build status filter tabs
  Widget _buildStatusFilterTabs(ThemeData theme) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            const SizedBox(width: 16),
            // All applications tab
            _buildFilterChip(
              theme,
              label: 'All',
              count: controller.applications.length,
              isSelected: controller.selectedStatusFilter == null,
              onTap: () => controller.setStatusFilter(null),
            ),
            const SizedBox(width: 8),
            // Pending tab
            _buildFilterChip(
              theme,
              label: 'Pending',
              count: controller.statusCounts[ApplicationStatus.pending] ?? 0,
              isSelected:
                  controller.selectedStatusFilter == ApplicationStatus.pending,
              onTap: () =>
                  controller.setStatusFilter(ApplicationStatus.pending),
            ),
            const SizedBox(width: 8),
            // Reviewed tab
            _buildFilterChip(
              theme,
              label: 'Reviewed',
              count: controller.statusCounts[ApplicationStatus.reviewed] ?? 0,
              isSelected:
                  controller.selectedStatusFilter == ApplicationStatus.reviewed,
              onTap: () =>
                  controller.setStatusFilter(ApplicationStatus.reviewed),
            ),
            const SizedBox(width: 8),
            // Shortlisted tab
            _buildFilterChip(
              theme,
              label: 'Shortlisted',
              count:
                  controller.statusCounts[ApplicationStatus.shortlisted] ?? 0,
              isSelected: controller.selectedStatusFilter ==
                  ApplicationStatus.shortlisted,
              onTap: () =>
                  controller.setStatusFilter(ApplicationStatus.shortlisted),
            ),
            const SizedBox(width: 8),
            // Interview tab
            _buildFilterChip(
              theme,
              label: 'Interview',
              count: controller.statusCounts[ApplicationStatus.interview] ?? 0,
              isSelected: controller.selectedStatusFilter ==
                  ApplicationStatus.interview,
              onTap: () =>
                  controller.setStatusFilter(ApplicationStatus.interview),
            ),
            const SizedBox(width: 8),
            // Offered tab
            _buildFilterChip(
              theme,
              label: 'Offered',
              count: controller.statusCounts[ApplicationStatus.offered] ?? 0,
              isSelected:
                  controller.selectedStatusFilter == ApplicationStatus.offered,
              onTap: () =>
                  controller.setStatusFilter(ApplicationStatus.offered),
            ),
            const SizedBox(width: 8),
            // Hired tab
            _buildFilterChip(
              theme,
              label: 'Hired',
              count: controller.statusCounts[ApplicationStatus.hired] ?? 0,
              isSelected:
                  controller.selectedStatusFilter == ApplicationStatus.hired,
              onTap: () => controller.setStatusFilter(ApplicationStatus.hired),
            ),
            const SizedBox(width: 8),
            // Rejected tab
            _buildFilterChip(
              theme,
              label: 'Rejected',
              count: controller.statusCounts[ApplicationStatus.rejected] ?? 0,
              isSelected:
                  controller.selectedStatusFilter == ApplicationStatus.rejected,
              onTap: () =>
                  controller.setStatusFilter(ApplicationStatus.rejected),
            ),
            const SizedBox(width: 8),
            // Withdrawn tab
            _buildFilterChip(
              theme,
              label: 'Withdrawn',
              count: controller.statusCounts[ApplicationStatus.withdrawn] ?? 0,
              isSelected: controller.selectedStatusFilter ==
                  ApplicationStatus.withdrawn,
              onTap: () =>
                  controller.setStatusFilter(ApplicationStatus.withdrawn),
            ),
            const SizedBox(width: 16),
          ],
        ),
      );
    });
  }

  /// Build filter chip
  Widget _buildFilterChip(
    ThemeData theme, {
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                        .withAlpha(51) // 0.2 * 255 = 51
                    : theme.colorScheme.primary.withAlpha(25), // 0.1 * 255 = 25
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                count.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build application card
  Widget _buildApplicationCard(
    ApplicationModel application,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () => Get.toNamed<dynamic>(
          '/applications/${application.id}',
        ),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job title and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      application.jobTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(application.status, theme),
                ],
              ),
              const SizedBox(height: 8),

              // Company
              Row(
                children: [
                  const HeroIcon(
                    HeroIcons.buildingOffice2,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    application.company,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Applied date
              Row(
                children: [
                  const HeroIcon(
                    HeroIcons.calendar,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Applied on ${DateFormat('MMM d, yyyy').format(application.appliedAt)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),

              // Divider
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: theme.dividerColor,
                  height: 1,
                ),
              ),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // View job button
                  OutlinedButton.icon(
                    onPressed: () => controller.navigateToJobDetails(
                      application.jobId,
                    ),
                    icon: const HeroIcon(
                      HeroIcons.briefcase,
                      size: 16,
                    ),
                    label: const Text('View Job'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Withdraw button (only for pending applications)
                  if (application.status == ApplicationStatus.pending ||
                      application.status == ApplicationStatus.reviewed ||
                      application.status == ApplicationStatus.shortlisted)
                    ElevatedButton.icon(
                      onPressed: () => _showWithdrawConfirmation(
                        application.id,
                        application.jobTitle,
                      ),
                      icon: const HeroIcon(
                        HeroIcons.xMark,
                        size: 16,
                      ),
                      label: const Text('Withdraw'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build status badge
  Widget _buildStatusBadge(ApplicationStatus status, ThemeData theme) {
    Color color;
    String label;

    switch (status) {
      case ApplicationStatus.pending:
        color = Colors.blue;
        label = 'Pending';
      case ApplicationStatus.reviewed:
        color = Colors.purple;
        label = 'Reviewed';
      case ApplicationStatus.shortlisted:
        color = Colors.orange;
        label = 'Shortlisted';
      case ApplicationStatus.interview:
        color = Colors.teal;
        label = 'Interview';
      case ApplicationStatus.offered:
        color = Colors.green;
        label = 'Offered';
      case ApplicationStatus.hired:
        color = AppTheme.electricBlue;
        label = 'Hired';
      case ApplicationStatus.rejected:
        color = Colors.red;
        label = 'Rejected';
      case ApplicationStatus.withdrawn:
        color = Colors.grey;
        label = 'Withdrawn';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withAlpha(25), // 0.1 * 255 = 25
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Show withdraw confirmation dialog
  void _showWithdrawConfirmation(String applicationId, String jobTitle) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Withdraw Application'),
        content: Text(
          'Are you sure you want to withdraw your application for "$jobTitle"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back<void>();
              controller.withdrawApplication(applicationId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }
}
