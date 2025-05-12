import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/applications/controllers/applications_controller.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Application analytics widget
class ApplicationAnalytics extends StatelessWidget {
  /// Creates an application analytics widget
  const ApplicationAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationsController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
              'Application Analytics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            // Application stats
            Obx(() {
              final applications = controller.applications;

              if (applications.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Column(
                      children: [
                        HeroIcon(
                          HeroIcons.chartBar,
                          size: 48.w,
                          color: isDarkMode ? Colors.white38 : Colors.black26,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No application data yet',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isDarkMode ? Colors.white54 : Colors.black45,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Apply to jobs to see your application statistics',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDarkMode ? Colors.white38 : Colors.black38,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Calculate statistics
              final totalApplications = applications.length;
              final reviewedApplications = applications
                  .where(
                    (app) =>
                        app.status.index >= ApplicationStatus.reviewed.index,
                  )
                  .length;
              final shortlistedApplications = applications
                  .where(
                    (app) =>
                        app.status.index >= ApplicationStatus.shortlisted.index,
                  )
                  .length;
              final interviewApplications = applications
                  .where(
                    (app) =>
                        app.status.index >= ApplicationStatus.interview.index,
                  )
                  .length;
              final offeredApplications = applications
                  .where(
                    (app) =>
                        app.status.index >= ApplicationStatus.offered.index,
                  )
                  .length;

              // Calculate rates
              final reviewRate = totalApplications > 0
                  ? (reviewedApplications / totalApplications * 100)
                      .toStringAsFixed(0)
                  : '0';
              final shortlistRate = reviewedApplications > 0
                  ? (shortlistedApplications / reviewedApplications * 100)
                      .toStringAsFixed(0)
                  : '0';
              final interviewRate = shortlistedApplications > 0
                  ? (interviewApplications / shortlistedApplications * 100)
                      .toStringAsFixed(0)
                  : '0';
              final offerRate = interviewApplications > 0
                  ? (offeredApplications / interviewApplications * 100)
                      .toStringAsFixed(0)
                  : '0';

              return Column(
                children: [
                  // Total applications
                  _buildStatRow(
                    context,
                    icon: HeroIcons.documentText,
                    label: 'Total Applications',
                    value: totalApplications.toString(),
                    color: RoleThemes.employeePrimary,
                  ),
                  SizedBox(height: 16.h),

                  // Review rate
                  _buildStatRow(
                    context,
                    icon: HeroIcons.documentCheck,
                    label: 'Review Rate',
                    value: '$reviewRate%',
                    color: Colors.purple,
                  ),
                  SizedBox(height: 16.h),

                  // Shortlist rate
                  _buildStatRow(
                    context,
                    icon: HeroIcons.star,
                    label: 'Shortlist Rate',
                    value: '$shortlistRate%',
                    color: Colors.orange,
                  ),
                  SizedBox(height: 16.h),

                  // Interview rate
                  _buildStatRow(
                    context,
                    icon: HeroIcons.userGroup,
                    label: 'Interview Rate',
                    value: '$interviewRate%',
                    color: Colors.teal,
                  ),
                  SizedBox(height: 16.h),

                  // Offer rate
                  _buildStatRow(
                    context,
                    icon: HeroIcons.trophy,
                    label: 'Offer Rate',
                    value: '$offerRate%',
                    color: Colors.green,
                  ),

                  SizedBox(height: 16.h),
                  const Divider(),
                  SizedBox(height: 16.h),

                  // Tips
                  Text(
                    'Tips to Improve Your Success Rate',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildTipItem(
                    context,
                    'Tailor your resume for each application',
                  ),
                  _buildTipItem(
                    context,
                    'Write a personalized cover letter',
                  ),
                  _buildTipItem(
                    context,
                    'Research the company before applying',
                  ),
                  _buildTipItem(
                    context,
                    'Apply to jobs that match your skills and experience',
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Build a statistic row
  Widget _buildStatRow(
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // Icon
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: HeroIcon(
              icon,
              size: 20.w,
              color: color,
            ),
          ),
        ),
        SizedBox(width: 16.w),

        // Label
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ),

        // Value
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Build a tip item
  Widget _buildTipItem(BuildContext context, String tip) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroIcon(
            HeroIcons.lightBulb,
            size: 16.w,
            color: Colors.amber,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              tip,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
