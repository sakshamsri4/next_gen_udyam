import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applications/controllers/applications_controller.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';

import 'package:next_gen/app/shared/widgets/bottom_navigation_bar.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Application details view
class ApplicationDetailsView extends GetView<ApplicationsController> {
  /// Constructor
  const ApplicationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final applicationId = Get.parameters['id'] ?? '';

    // Load application details
    if (controller.selectedApplication?.id != applicationId) {
      controller.loadApplicationDetails(applicationId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Application Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.arrowLeft),
          onPressed: () => Get.back<void>(),
        ),
      ),
      bottomNavigationBar: const CustomAnimatedBottomNavBar(),
      body: Obx(() {
        if (controller.isDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.selectedApplication == null) {
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
                  'Application Not Found',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The application you are looking for does not exist or has been removed.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back<void>(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return _buildApplicationDetails(
          controller.selectedApplication!,
          controller.selectedJob,
          theme,
          isDarkMode,
        );
      }),
    );
  }

  /// Build application details
  Widget _buildApplicationDetails(
    ApplicationModel application,
    dynamic job,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _buildStatusCard(application, theme),
          SizedBox(height: 24.h),

          // Job details card
          _buildJobDetailsCard(application, job, theme, isDarkMode),
          SizedBox(height: 24.h),

          // Application details card
          _buildApplicationDetailsCard(application, theme),
          SizedBox(height: 24.h),

          // Actions
          _buildActions(application, theme),
        ],
      ),
    );
  }

  /// Build status card
  Widget _buildStatusCard(ApplicationModel application, ThemeData theme) {
    Color color;
    String statusText;
    String description;

    switch (application.status) {
      case ApplicationStatus.pending:
        color = Colors.blue;
        statusText = 'Application Pending';
        description =
            'Your application has been submitted and is awaiting review.';
      case ApplicationStatus.reviewed:
        color = Colors.purple;
        statusText = 'Application Reviewed';
        description = 'Your application has been reviewed by the employer.';
      case ApplicationStatus.shortlisted:
        color = Colors.orange;
        statusText = 'Shortlisted';
        description =
            'Congratulations! You have been shortlisted for this position.';
      case ApplicationStatus.interview:
        color = Colors.teal;
        statusText = 'Interview Scheduled';
        description = application.interviewDate != null
            ? 'You have an interview scheduled on ${DateFormat('MMMM d, yyyy').format(application.interviewDate!)}.'
            : 'You have been selected for an interview. Check your email for details.';
      case ApplicationStatus.offered:
        color = Colors.green;
        statusText = 'Job Offered';
        description = 'Congratulations! You have been offered this position.';
      case ApplicationStatus.hired:
        color = AppTheme.electricBlue;
        statusText = 'Hired';
        description = 'Congratulations! You have been hired for this position.';
      case ApplicationStatus.rejected:
        color = Colors.red;
        statusText = 'Application Rejected';
        description =
            'We regret to inform you that your application was not selected for this position.';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(application.status),
                  color: color,
                  size: 24,
                ),
                SizedBox(width: 12.w),
                Text(
                  statusText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
            if (application.feedback != null &&
                application.feedback!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              const Divider(),
              SizedBox(height: 12.h),
              Text(
                'Feedback:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                application.feedback!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build job details card
  Widget _buildJobDetailsCard(
    ApplicationModel application,
    dynamic jobData,
    ThemeData theme,
    bool isDarkMode,
  ) {
    // Convert dynamic to a Map if it's not null
    final job =
        jobData != null ? Map<String, dynamic>.from(jobData as Map) : null;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            // Job title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeroIcon(
                  HeroIcons.briefcase,
                  size: 20,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Position',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withAlpha(153), // 0.6 * 255 = 153
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        application.jobTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Company
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeroIcon(
                  HeroIcons.buildingOffice2,
                  size: 20,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withAlpha(153), // 0.6 * 255 = 153
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        application.company,
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Show more job details if available
            if (job != null) ...[
              SizedBox(height: 16.h),

              // Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeroIcon(
                    HeroIcons.mapPin,
                    size: 20,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          job['location'] as String? ?? 'Unknown Location',
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Job type
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeroIcon(
                    HeroIcons.clock,
                    size: 20,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Job Type',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          job['jobType'] as String? ?? 'Unknown Type',
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 16.h),

            // View full job button
            Center(
              child: OutlinedButton.icon(
                onPressed: () => controller.navigateToJobDetails(
                  application.jobId,
                ),
                icon: const HeroIcon(
                  HeroIcons.arrowTopRightOnSquare,
                  size: 16,
                ),
                label: const Text('View Full Job Details'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build application details card
  Widget _buildApplicationDetailsCard(
    ApplicationModel application,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            // Applied date
            _buildDetailRow(
              theme,
              icon: HeroIcons.calendar,
              label: 'Applied On',
              value: DateFormat('MMMM d, yyyy').format(application.appliedAt),
            ),
            SizedBox(height: 16.h),

            // Name
            _buildDetailRow(
              theme,
              icon: HeroIcons.user,
              label: 'Name',
              value: application.name,
            ),
            SizedBox(height: 16.h),

            // Email
            _buildDetailRow(
              theme,
              icon: HeroIcons.envelope,
              label: 'Email',
              value: application.email,
            ),
            SizedBox(height: 16.h),

            // Phone
            _buildDetailRow(
              theme,
              icon: HeroIcons.phone,
              label: 'Phone',
              value: application.phone,
            ),

            // Cover letter
            if (application.coverLetter.isNotEmpty) ...[
              SizedBox(height: 16.h),
              const Divider(),
              SizedBox(height: 16.h),
              Text(
                'Cover Letter',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                application.coverLetter,
                style: theme.textTheme.bodyMedium,
              ),
            ],

            // Resume
            if (application.resumeUrl != null) ...[
              SizedBox(height: 16.h),
              const Divider(),
              SizedBox(height: 16.h),
              Text(
                'Resume',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement resume viewing
                  Get.snackbar(
                    'Coming Soon',
                    'Resume viewing will be available soon',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: const HeroIcon(
                  HeroIcons.documentText,
                  size: 16,
                ),
                label: const Text('View Resume'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build detail row
  Widget _buildDetailRow(
    ThemeData theme, {
    required HeroIcons icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroIcon(
          icon,
          size: 20,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build actions
  Widget _buildActions(ApplicationModel application, ThemeData theme) {
    // Only show withdraw button for certain statuses
    final canWithdraw = [
      ApplicationStatus.pending,
      ApplicationStatus.reviewed,
      ApplicationStatus.shortlisted,
    ].contains(application.status);

    if (!canWithdraw) {
      return const SizedBox.shrink();
    }

    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _showWithdrawConfirmation(
          application.id,
          application.jobTitle,
        ),
        icon: const HeroIcon(
          HeroIcons.xMark,
          size: 16,
        ),
        label: const Text('Withdraw Application'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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

  /// Get status icon
  IconData _getStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Icons.hourglass_empty;
      case ApplicationStatus.reviewed:
        return Icons.visibility;
      case ApplicationStatus.shortlisted:
        return Icons.star;
      case ApplicationStatus.interview:
        return Icons.people;
      case ApplicationStatus.offered:
        return Icons.check_circle;
      case ApplicationStatus.hired:
        return Icons.celebration;
      case ApplicationStatus.rejected:
        return Icons.cancel;
    }
  }
}
