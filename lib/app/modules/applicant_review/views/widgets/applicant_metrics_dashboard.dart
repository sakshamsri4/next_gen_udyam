import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/app/modules/job_posting/models/job_post_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A dashboard for displaying applicant metrics
class ApplicantMetricsDashboard extends StatelessWidget {
  /// Creates an applicant metrics dashboard
  ///
  /// [job] is the job posting
  /// [applications] is the list of applications
  /// [statusCounts] is a map of application status counts
  /// [onFilterByStatus] is called when a status filter is selected
  const ApplicantMetricsDashboard({
    required this.job,
    required this.applications,
    required this.statusCounts,
    this.onFilterByStatus,
    super.key,
  });

  /// The job posting
  final JobPostModel job;

  /// The list of applications
  final List<ApplicationModel> applications;

  /// Map of application status counts
  final Map<ApplicationStatus, int> statusCounts;

  /// Called when a status filter is selected
  final void Function(List<ApplicationStatus>)? onFilterByStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    const primaryColor = RoleThemes.employerPrimary;

    // Calculate metrics
    final totalApplications = applications.length;
    final pendingCount = statusCounts[ApplicationStatus.pending] ?? 0;
    final reviewedCount = statusCounts[ApplicationStatus.reviewed] ?? 0;
    final shortlistedCount = statusCounts[ApplicationStatus.shortlisted] ?? 0;
    final interviewCount = statusCounts[ApplicationStatus.interview] ?? 0;
    final offeredCount = statusCounts[ApplicationStatus.offered] ?? 0;
    final hiredCount = statusCounts[ApplicationStatus.hired] ?? 0;
    final rejectedCount = statusCounts[ApplicationStatus.rejected] ?? 0;
    final withdrawnCount = statusCounts[ApplicationStatus.withdrawn] ?? 0;

    // Calculate conversion rates
    final shortlistRate = totalApplications > 0
        ? (shortlistedCount / totalApplications * 100).toStringAsFixed(1)
        : '0.0';
    final interviewRate = shortlistedCount > 0
        ? (interviewCount / shortlistedCount * 100).toStringAsFixed(1)
        : '0.0';
    final offerRate = interviewCount > 0
        ? (offeredCount / interviewCount * 100).toStringAsFixed(1)
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
          // Job title and application count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${job.location}${job.isRemote ? ' (Remote)' : ''}',
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    HeroIcon(
                      HeroIcons.users,
                      size: 16.r,
                      color: primaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$totalApplications Applications',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Status metrics
          Text(
            'Application Status',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusMetric(
                  label: 'Pending',
                  count: pendingCount,
                  total: totalApplications,
                  color: Colors.blue,
                  icon: HeroIcons.clock,
                  theme: theme,
                  onTap: () =>
                      onFilterByStatus?.call([ApplicationStatus.pending]),
                ),
                _buildStatusMetric(
                  label: 'Reviewed',
                  count: reviewedCount,
                  total: totalApplications,
                  color: Colors.orange,
                  icon: HeroIcons.check,
                  theme: theme,
                  onTap: () =>
                      onFilterByStatus?.call([ApplicationStatus.reviewed]),
                ),
                _buildStatusMetric(
                  label: 'Shortlisted',
                  count: shortlistedCount,
                  total: totalApplications,
                  color: Colors.purple,
                  icon: HeroIcons.star,
                  theme: theme,
                  onTap: () =>
                      onFilterByStatus?.call([ApplicationStatus.shortlisted]),
                ),
                _buildStatusMetric(
                  label: 'Interview',
                  count: interviewCount,
                  total: totalApplications,
                  color: Colors.indigo,
                  icon: HeroIcons.userGroup,
                  theme: theme,
                  onTap: () =>
                      onFilterByStatus?.call([ApplicationStatus.interview]),
                ),
                _buildStatusMetric(
                  label: 'Offered',
                  count: offeredCount,
                  total: totalApplications,
                  color: Colors.green,
                  icon: HeroIcons.documentCheck,
                  theme: theme,
                  onTap: () =>
                      onFilterByStatus?.call([ApplicationStatus.offered]),
                ),
                _buildStatusMetric(
                  label: 'Hired',
                  count: hiredCount,
                  total: totalApplications,
                  color: Colors.teal,
                  icon: HeroIcons.checkBadge,
                  theme: theme,
                  onTap: () =>
                      onFilterByStatus?.call([ApplicationStatus.hired]),
                ),
                _buildStatusMetric(
                  label: 'Rejected',
                  count: rejectedCount,
                  total: totalApplications,
                  color: Colors.red,
                  icon: HeroIcons.xMark,
                  theme: theme,
                  onTap: () =>
                      onFilterByStatus?.call([ApplicationStatus.rejected]),
                ),
                _buildStatusMetric(
                  label: 'Withdrawn',
                  count: withdrawnCount,
                  total: totalApplications,
                  color: Colors.grey,
                  icon: HeroIcons.arrowUturnLeft,
                  theme: theme,
                  onTap: () =>
                      onFilterByStatus?.call([ApplicationStatus.withdrawn]),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Conversion metrics
          Text(
            'Conversion Rates',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildConversionMetric(
                label: 'Shortlist Rate',
                value: '$shortlistRate%',
                description: 'Applications → Shortlisted',
                icon: HeroIcons.star,
                color: Colors.purple,
                theme: theme,
              ),
              _buildConversionMetric(
                label: 'Interview Rate',
                value: '$interviewRate%',
                description: 'Shortlisted → Interview',
                icon: HeroIcons.userGroup,
                color: Colors.indigo,
                theme: theme,
              ),
              _buildConversionMetric(
                label: 'Offer Rate',
                value: '$offerRate%',
                description: 'Interview → Offered',
                icon: HeroIcons.documentCheck,
                color: Colors.green,
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a status metric
  Widget _buildStatusMetric({
    required String label,
    required int count,
    required int total,
    required Color color,
    required HeroIcons icon,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    final percentage = total > 0 ? (count / total * 100) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
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
              count.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(2.r),
            ),
            SizedBox(height: 4.h),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a conversion metric
  Widget _buildConversionMetric({
    required String label,
    required String value,
    required String description,
    required HeroIcons icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroIcon(
                  icon,
                  size: 16.r,
                  color: color,
                ),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withAlpha(179),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
