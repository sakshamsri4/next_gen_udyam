import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/job_posting/models/job_post_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A list item for job postings in the job management screen
class JobListItem extends StatelessWidget {
  /// Creates a job list item
  ///
  /// [job] is the job posting to display
  /// [onEdit] is called when the edit button is tapped
  /// [onDelete] is called when the delete button is tapped
  /// [onStatusChange] is called when the status is changed
  /// [onDuplicate] is called when the duplicate button is tapped
  /// [onViewApplicants] is called when the view applicants button is tapped
  /// [onViewDetails] is called when the view details button is tapped
  const JobListItem({
    required this.job,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
    required this.onDuplicate,
    required this.onViewApplicants,
    required this.onViewDetails,
    super.key,
  });

  /// The job posting to display
  final JobPostModel job;

  /// Called when the edit button is tapped
  final VoidCallback onEdit;

  /// Called when the delete button is tapped
  final VoidCallback onDelete;

  /// Called when the status is changed
  final void Function(JobStatus) onStatusChange;

  /// Called when the duplicate button is tapped
  final VoidCallback onDuplicate;

  /// Called when the view applicants button is tapped
  final VoidCallback onViewApplicants;

  /// Called when the view details button is tapped
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 3,
      shadowColor: RoleThemes.employerPrimary.withAlpha(40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: RoleThemes.employerPrimary.withAlpha(26),
        ),
      ),
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(16.r),
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
                      job.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(job.status, theme),
                ],
              ),
              SizedBox(height: 8.h),

              // Job type and location
              Row(
                children: [
                  HeroIcon(
                    job.isRemote ? HeroIcons.globeAlt : HeroIcons.mapPin,
                    size: 16.r,
                    color: RoleThemes.employerPrimary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    job.isRemote ? 'Remote' : job.location,
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(width: 16.w),
                  HeroIcon(
                    HeroIcons.briefcase,
                    size: 16.r,
                    color: RoleThemes.employerPrimary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    job.jobType,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Posted date and application count
              Row(
                children: [
                  HeroIcon(
                    HeroIcons.calendar,
                    size: 16.r,
                    color: RoleThemes.employerPrimary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Posted: ${DateFormat('MMM d, yyyy').format(job.postedDate)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(width: 16.w),
                  HeroIcon(
                    HeroIcons.users,
                    size: 16.r,
                    color: RoleThemes.employerPrimary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Applications: ${job.applicationCount}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Metrics
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: RoleThemes.employerPrimary.withAlpha(10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetric(
                          icon: HeroIcons.eye,
                          value: job.viewCount.toString(),
                          label: 'Views',
                          theme: theme,
                        ),
                        _buildVerticalDivider(theme),
                        _buildMetric(
                          icon: HeroIcons.users,
                          value: job.applicationCount.toString(),
                          label: 'Applications',
                          theme: theme,
                        ),
                        _buildVerticalDivider(theme),
                        _buildMetric(
                          icon: HeroIcons.chartBar,
                          value: job.viewCount > 0
                              ? '${(job.applicationCount / job.viewCount * 100).toStringAsFixed(1)}%'
                              : '0%',
                          label: 'Conversion',
                          theme: theme,
                        ),
                      ],
                    ),
                    if (job.isFeatured || job.applicationDeadline != null) ...[
                      Divider(
                        height: 24.h,
                        color: theme.dividerColor.withAlpha(128),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (job.isFeatured)
                            _buildMetric(
                              icon: HeroIcons.star,
                              value: 'Featured',
                              label: 'Visibility',
                              theme: theme,
                            ),
                          if (job.applicationDeadline != null) ...[
                            if (job.isFeatured) _buildVerticalDivider(theme),
                            _buildMetric(
                              icon: HeroIcons.clock,
                              value: DateFormat('MMM d')
                                  .format(job.applicationDeadline!),
                              label: 'Deadline',
                              theme: theme,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // View applicants button
                  _buildActionButton(
                    icon: HeroIcons.users,
                    tooltip: 'View Applicants',
                    onPressed: onViewApplicants,
                    theme: theme,
                  ),
                  SizedBox(width: 8.w),

                  // Edit button
                  _buildActionButton(
                    icon: HeroIcons.pencilSquare,
                    tooltip: 'Edit Job',
                    onPressed: onEdit,
                    theme: theme,
                  ),
                  SizedBox(width: 8.w),

                  // Duplicate button
                  _buildActionButton(
                    icon: HeroIcons.documentDuplicate,
                    tooltip: 'Duplicate Job',
                    onPressed: onDuplicate,
                    theme: theme,
                  ),
                  SizedBox(width: 8.w),

                  // Status change button
                  _buildStatusChangeButton(theme, isDarkMode),
                  SizedBox(width: 8.w),

                  // Delete button
                  _buildActionButton(
                    icon: HeroIcons.trash,
                    tooltip: 'Delete Job',
                    onPressed: onDelete,
                    theme: theme,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a status badge
  Widget _buildStatusBadge(JobStatus status, ThemeData theme) {
    Color color;
    String text;

    switch (status) {
      case JobStatus.active:
        color = Colors.green;
        text = 'Active';
      case JobStatus.paused:
        color = Colors.orange;
        text = 'Paused';
      case JobStatus.closed:
        color = Colors.red;
        text = 'Closed';
      case JobStatus.draft:
        color = Colors.grey;
        text = 'Draft';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withAlpha(51), // 0.2 * 255 = 51
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build an action button
  Widget _buildActionButton({
    required HeroIcons icon,
    required String tooltip,
    required VoidCallback onPressed,
    required ThemeData theme,
    Color? color,
  }) {
    return IconButton(
      icon: HeroIcon(
        icon,
        size: 20.r,
        color: color ?? RoleThemes.employerPrimary,
      ),
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: BoxConstraints(
        minWidth: 32.w,
        minHeight: 32.h,
      ),
      padding: EdgeInsets.zero,
      splashRadius: 24.r,
    );
  }

  /// Build a status change button
  Widget _buildStatusChangeButton(ThemeData theme, bool isDarkMode) {
    return PopupMenuButton<JobStatus>(
      icon: HeroIcon(
        HeroIcons.adjustmentsHorizontal,
        size: 20.r,
        color: RoleThemes.employerPrimary,
      ),
      tooltip: 'Change Status',
      onSelected: onStatusChange,
      itemBuilder: (context) => [
        _buildPopupMenuItem(
          value: JobStatus.active,
          text: 'Set as Active',
          icon: HeroIcons.check,
          color: Colors.green,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
        _buildPopupMenuItem(
          value: JobStatus.paused,
          text: 'Set as Paused',
          icon: HeroIcons.pause,
          color: Colors.orange,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
        _buildPopupMenuItem(
          value: JobStatus.closed,
          text: 'Set as Closed',
          icon: HeroIcons.xMark,
          color: Colors.red,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
        _buildPopupMenuItem(
          value: JobStatus.draft,
          text: 'Set as Draft',
          icon: HeroIcons.documentText,
          color: Colors.grey,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  /// Build a popup menu item
  PopupMenuItem<JobStatus> _buildPopupMenuItem({
    required JobStatus value,
    required String text,
    required HeroIcons icon,
    required Color color,
    required ThemeData theme,
    required bool isDarkMode,
  }) {
    return PopupMenuItem<JobStatus>(
      value: value,
      child: Row(
        children: [
          HeroIcon(
            icon,
            size: 20.r,
            color: color,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Build a metric display
  Widget _buildMetric({
    required HeroIcons icon,
    required String value,
    required String label,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        HeroIcon(
          icon,
          size: 18.r,
          color: RoleThemes.employerPrimary,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color
                ?.withAlpha(179), // 0.7 * 255 = 179
          ),
        ),
      ],
    );
  }

  /// Build a vertical divider
  Widget _buildVerticalDivider(ThemeData theme) {
    return Container(
      height: 40.h,
      width: 1,
      color: theme.dividerColor.withAlpha(128), // 0.5 * 255 = 128
    );
  }
}
