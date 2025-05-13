import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applicant_review/controllers/applicant_review_controller.dart';
import 'package:next_gen/app/modules/applicant_review/models/applicant_filter_model.dart';
import 'package:next_gen/app/modules/applicant_review/views/applicant_comparison_view.dart';
import 'package:next_gen/app/modules/applicant_review/views/widgets/applicant_card.dart';
import 'package:next_gen/app/modules/applicant_review/views/widgets/applicant_filter_modal.dart';
import 'package:next_gen/app/modules/applicant_review/views/widgets/applicant_metrics_dashboard.dart';
import 'package:next_gen/app/modules/applicant_review/views/widgets/communication_tools.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/empty_state.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A view for reviewing applicants
class ApplicantReviewView extends GetView<ApplicantReviewController> {
  /// Creates an applicant review view
  const ApplicantReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Review'),
        actions: [
          // Filter button
          IconButton(
            icon: const HeroIcon(HeroIcons.funnel),
            tooltip: 'Filter',
            onPressed: () => _showFilterModal(context),
          ),

          // Sort button
          IconButton(
            icon: const HeroIcon(HeroIcons.arrowsUpDown),
            tooltip: 'Sort',
            onPressed: () => _showSortOptions(context),
          ),

          // Compare button
          Obx(() {
            final selectedCount = controller.selectedApplications.length;
            return IconButton(
              icon: Badge(
                isLabelVisible: selectedCount > 0,
                label: Text(selectedCount.toString()),
                child: const HeroIcon(HeroIcons.rectangleGroup),
              ),
              tooltip: 'Compare Selected',
              onPressed: selectedCount >= 2
                  ? () => controller.enterComparisonMode()
                  : () => Get.snackbar(
                        'Select Applicants',
                        'Select at least 2 applicants to compare',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      ),
            );
          }),
        ],
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const UnifiedBottomNav(),
      floatingActionButton: Obx(() {
        final selectedCount = controller.selectedApplications.length;
        if (selectedCount == 0) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: () => _showBatchActions(context),
          backgroundColor: primaryColor,
          icon: const HeroIcon(
            HeroIcons.adjustmentsHorizontal,
            color: Colors.white,
          ),
          label: Text('Batch Actions ($selectedCount)'),
        );
      }),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error}',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshApplications(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.comparisonMode) {
          return const ApplicantComparisonView();
        }

        if (controller.applications.isEmpty) {
          return const EmptyState(
            icon: HeroIcons.users,
            title: 'No Applications',
            description: 'There are no applications for this job yet.',
          );
        }

        if (controller.filteredApplications.isEmpty) {
          return EmptyState(
            icon: HeroIcons.funnel,
            title: 'No Matching Applications',
            description: 'No applications match your current filters.',
            buttonText: 'Clear Filters',
            onButtonPressed: () => controller.updateFilter(
              ApplicantFilterModel(
                jobId: controller.filter.jobId,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshApplications(),
          color: primaryColor,
          child: Column(
            children: [
              // Metrics dashboard
              if (controller.selectedJob != null)
                ApplicantMetricsDashboard(
                  job: controller.selectedJob!,
                  applications: controller.applications,
                  statusCounts: controller.statusCounts,
                  onFilterByStatus: (statuses) =>
                      controller.setStatusFilter(statuses),
                ),

              // Filter chips
              if (controller.filter.isNotEmpty) _buildActiveFilters(theme),

              // Applicant list
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.filteredApplications.length,
                  itemBuilder: (context, index) {
                    final application = controller.filteredApplications[index];
                    final isSelected =
                        controller.selectedApplications.contains(application);

                    return ApplicantCard(
                      application: application,
                      isSelected: isSelected,
                      onSelect: () =>
                          controller.toggleApplicationSelection(application),
                      onViewDetails: () => _showApplicationDetails(
                        context,
                        application,
                      ),
                      onStatusChange: (status) =>
                          controller.updateApplicationStatus(
                        application.id,
                        status,
                      ),
                      onScheduleInterview: () => _showInterviewScheduler(
                        context,
                        application,
                      ),
                      onSendMessage: () => _showCommunicationTools(
                        context,
                        application,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Build active filters display
  Widget _buildActiveFilters(ThemeData theme) {
    const primaryColor = RoleThemes.employerPrimary;
    final filter = controller.filter;
    final chips = <Widget>[];

    // Add name filter
    if (filter.name.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          label: 'Name: ${filter.name}',
          onRemove: () => controller.updateFilter(
            filter.copyWith(name: ''),
          ),
          theme: theme,
        ),
      );
    }

    // Add skills filter
    if (filter.skills.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          label: 'Skills: ${filter.skills.join(', ')}',
          onRemove: () => controller.updateFilter(
            filter.copyWith(skills: []),
          ),
          theme: theme,
        ),
      );
    }

    // Add experience filter
    if (filter.experience.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          label: 'Experience: ${filter.experience.join(', ')}',
          onRemove: () => controller.updateFilter(
            filter.copyWith(experience: []),
          ),
          theme: theme,
        ),
      );
    }

    // Add education filter
    if (filter.education.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          label: 'Education: ${filter.education.join(', ')}',
          onRemove: () => controller.updateFilter(
            filter.copyWith(education: []),
          ),
          theme: theme,
        ),
      );
    }

    // Add status filter
    if (filter.statuses.isNotEmpty) {
      final statusNames = filter.statuses.map(_getStatusText).join(', ');
      chips.add(
        _buildFilterChip(
          label: 'Status: $statusNames',
          onRemove: () => controller.updateFilter(
            filter.copyWith(statuses: []),
          ),
          theme: theme,
        ),
      );
    }

    // Add date range filter
    if (filter.applicationDateStart != null ||
        filter.applicationDateEnd != null) {
      final dateFormat = DateFormat('MMM d, yyyy');
      final startDate = filter.applicationDateStart != null
          ? dateFormat.format(filter.applicationDateStart!)
          : 'Any';
      final endDate = filter.applicationDateEnd != null
          ? dateFormat.format(filter.applicationDateEnd!)
          : 'Any';
      chips.add(
        _buildFilterChip(
          label: 'Date: $startDate - $endDate',
          onRemove: () => controller.updateFilter(
            filter.copyWith(),
          ),
          theme: theme,
        ),
      );
    }

    // Add document filters
    if (filter.hasResume) {
      chips.add(
        _buildFilterChip(
          label: 'Has Resume',
          onRemove: () => controller.updateFilter(
            filter.copyWith(hasResume: false),
          ),
          theme: theme,
        ),
      );
    }
    if (filter.hasCoverLetter) {
      chips.add(
        _buildFilterChip(
          label: 'Has Cover Letter',
          onRemove: () => controller.updateFilter(
            filter.copyWith(hasCoverLetter: false),
          ),
          theme: theme,
        ),
      );
    }

    // Add sort filter
    final sortText = _getSortOptionText(filter.sortBy);
    final orderText = filter.sortOrder == ApplicantSortOrder.ascending
        ? 'Ascending'
        : 'Descending';
    chips.add(
      _buildFilterChip(
        label: 'Sort: $sortText ($orderText)',
        onRemove: () => controller.updateFilter(
          filter.copyWith(
            sortBy: ApplicantSortOption.applicationDate,
            sortOrder: ApplicantSortOrder.descending,
          ),
        ),
        theme: theme,
      ),
    );

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => controller.updateFilter(
                  ApplicantFilterModel(jobId: filter.jobId),
                ),
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: chips,
          ),
        ],
      ),
    );
  }

  /// Build a filter chip
  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
    required ThemeData theme,
  }) {
    const primaryColor = RoleThemes.employerPrimary;

    return Chip(
      label: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: primaryColor.withAlpha(20),
      deleteIcon: const HeroIcon(
        HeroIcons.xMark,
        size: 16,
        color: primaryColor,
      ),
      onDeleted: onRemove,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: primaryColor.withAlpha(50),
        ),
      ),
    );
  }

  /// Show filter modal
  void _showFilterModal(BuildContext context) {
    Get.dialog<void>(
      Dialog(
        insetPadding: EdgeInsets.all(16.w),
        child: Container(
          width: 800.w,
          height: 600.h,
          padding: EdgeInsets.zero,
          child: ApplicantFilterModal(
            initialFilter: controller.filter,
            onApply: (filter) => controller.updateFilter(filter),
            onReset: () => controller.updateFilter(
              ApplicantFilterModel(jobId: controller.filter.jobId),
            ),
          ),
        ),
      ),
    );
  }

  /// Show sort options
  void _showSortOptions(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    Get.bottomSheet<void>(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Applications',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            // Sort options
            ...ApplicantSortOption.values.map((option) {
              final isSelected = controller.filter.sortBy == option;
              return ListTile(
                title: Text(_getSortOptionText(option)),
                leading: HeroIcon(
                  _getSortOptionIcon(option),
                  color: isSelected ? primaryColor : null,
                ),
                trailing: isSelected
                    ? HeroIcon(
                        controller.filter.sortOrder ==
                                ApplicantSortOrder.ascending
                            ? HeroIcons.arrowUp
                            : HeroIcons.arrowDown,
                        color: primaryColor,
                      )
                    : null,
                selected: isSelected,
                selectedColor: primaryColor,
                onTap: () {
                  final currentFilter = controller.filter;
                  final newSortOrder = currentFilter.sortBy == option &&
                          currentFilter.sortOrder ==
                              ApplicantSortOrder.ascending
                      ? ApplicantSortOrder.descending
                      : ApplicantSortOrder.ascending;

                  controller.updateFilter(
                    currentFilter.copyWith(
                      sortBy: option,
                      sortOrder: newSortOrder,
                    ),
                  );
                  Get.back<void>();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Show batch actions
  void _showBatchActions(BuildContext context) {
    final theme = Theme.of(context);

    Get.bottomSheet<void>(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Batch Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${controller.selectedApplications.length} applicants selected',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 16.h),

            // Actions
            ListTile(
              title: const Text('Compare Selected'),
              leading: const HeroIcon(HeroIcons.rectangleGroup),
              onTap: () {
                Get.back<void>();
                controller.enterComparisonMode();
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Mark as Reviewed'),
              leading: const HeroIcon(HeroIcons.check),
              onTap: () {
                Get.back<void>();
                _updateBatchStatus(ApplicationStatus.reviewed);
              },
            ),
            ListTile(
              title: const Text('Shortlist Selected'),
              leading: const HeroIcon(HeroIcons.star),
              onTap: () {
                Get.back<void>();
                _updateBatchStatus(ApplicationStatus.shortlisted);
              },
            ),
            ListTile(
              title: const Text('Reject Selected'),
              leading: const HeroIcon(HeroIcons.xMark),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                Get.back<void>();
                _showRejectConfirmation();
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Clear Selection'),
              leading: const HeroIcon(HeroIcons.xCircle),
              onTap: () {
                Get.back<void>();
                controller.clearSelections();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show application details
  void _showApplicationDetails(
    BuildContext context,
    ApplicationModel application,
  ) {
    // TODO(developer): Implement application details view
    Get.snackbar(
      'View Details',
      'Viewing details for ${application.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Show interview scheduler
  void _showInterviewScheduler(
    BuildContext context,
    ApplicationModel application,
  ) {
    final theme = Theme.of(context);

    Get.dialog<void>(
      Dialog(
        insetPadding: EdgeInsets.all(16.w),
        child: Container(
          width: 600.w,
          height: 500.h,
          padding: EdgeInsets.zero,
          child: controller.selectedJob != null
              ? CommunicationTools(
                  application: application,
                  job: controller.selectedJob!,
                  onScheduleInterview: (date, notes) {
                    controller.scheduleInterview(application.id, date);
                  },
                )
              : Center(
                  child: Text(
                    'Job information not available',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
        ),
      ),
    );
  }

  /// Show communication tools
  void _showCommunicationTools(
    BuildContext context,
    ApplicationModel application,
  ) {
    final theme = Theme.of(context);

    Get.dialog<void>(
      Dialog(
        insetPadding: EdgeInsets.all(16.w),
        child: Container(
          width: 600.w,
          height: 500.h,
          padding: EdgeInsets.zero,
          child: controller.selectedJob != null
              ? CommunicationTools(
                  application: application,
                  job: controller.selectedJob!,
                  onSendEmail: (subject, body) {
                    // TODO(developer): Implement email sending
                    Get.snackbar(
                      'Email Sent',
                      'Email sent to ${application.name}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  onScheduleInterview: (date, notes) {
                    controller.scheduleInterview(application.id, date);
                  },
                )
              : Center(
                  child: Text(
                    'Job information not available',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
        ),
      ),
    );
  }

  /// Show reject confirmation
  void _showRejectConfirmation() {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Reject Selected Applicants'),
        content: Text(
          'Are you sure you want to reject ${controller.selectedApplications.length} applicants? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back<void>();
              _updateBatchStatus(ApplicationStatus.rejected);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  /// Update batch status
  Future<void> _updateBatchStatus(ApplicationStatus status) async {
    final applications =
        List<ApplicationModel>.from(controller.selectedApplications);

    for (final application in applications) {
      await controller.updateApplicationStatus(application.id, status);
    }

    controller.clearSelections();

    Get.snackbar(
      'Status Updated',
      'Updated ${applications.length} applicants to ${_getStatusText(status)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  /// Get text for a status
  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.reviewed:
        return 'Reviewed';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offered:
        return 'Offered';
      case ApplicationStatus.hired:
        return 'Hired';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  /// Get text for a sort option
  String _getSortOptionText(ApplicantSortOption option) {
    switch (option) {
      case ApplicantSortOption.applicationDate:
        return 'Application Date';
      case ApplicantSortOption.name:
        return 'Name';
      case ApplicantSortOption.status:
        return 'Status';
      case ApplicantSortOption.matchScore:
        return 'Match Score';
    }
  }

  /// Get icon for a sort option
  HeroIcons _getSortOptionIcon(ApplicantSortOption option) {
    switch (option) {
      case ApplicantSortOption.applicationDate:
        return HeroIcons.calendar;
      case ApplicantSortOption.name:
        return HeroIcons.user;
      case ApplicantSortOption.status:
        return HeroIcons.adjustmentsHorizontal;
      case ApplicantSortOption.matchScore:
        return HeroIcons.star;
    }
  }
}
