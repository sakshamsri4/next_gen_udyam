import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A card for displaying applicant information
class ApplicantCard extends StatelessWidget {
  /// Creates an applicant card
  ///
  /// [application] is the application to display
  /// [isSelected] indicates if the card is selected
  /// [onSelect] is called when the card is selected
  /// [onViewDetails] is called when the view details button is tapped
  /// [onStatusChange] is called when the status is changed
  /// [onScheduleInterview] is called when the schedule interview button is tapped
  /// [onSendMessage] is called when the send message button is tapped
  const ApplicantCard({
    required this.application,
    this.isSelected = false,
    this.onSelect,
    this.onViewDetails,
    this.onStatusChange,
    this.onScheduleInterview,
    this.onSendMessage,
    super.key,
  });

  /// The application to display
  final ApplicationModel application;

  /// Whether the card is selected
  final bool isSelected;

  /// Called when the card is selected
  final VoidCallback? onSelect;

  /// Called when the view details button is tapped
  final VoidCallback? onViewDetails;

  /// Called when the status is changed
  final void Function(ApplicationStatus)? onStatusChange;

  /// Called when the schedule interview button is tapped
  final VoidCallback? onScheduleInterview;

  /// Called when the send message button is tapped
  final VoidCallback? onSendMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Define employer green color
    const primaryColor = RoleThemes.employerPrimary;

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 3,
      shadowColor: primaryColor.withAlpha(40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isSelected ? primaryColor : primaryColor.withAlpha(26),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Applicant name and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Selection indicator
                      if (onSelect != null)
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) => onSelect?.call(),
                          activeColor: primaryColor,
                        ),

                      // Applicant avatar
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: primaryColor.withAlpha(30),
                        child: Text(
                          application.name.isNotEmpty
                              ? application.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Applicant name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              application.name.isNotEmpty
                                  ? application.name
                                  : 'Unnamed Applicant',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              application.email,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _buildStatusBadge(application.status, theme),
                ],
              ),
              SizedBox(height: 16.h),

              // Application details
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: RoleThemes.employerPrimary.withAlpha(10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Applied date
                        _buildDetailItem(
                          icon: HeroIcons.calendar,
                          label: 'Applied',
                          value: DateFormat('MMM d, yyyy')
                              .format(application.appliedAt),
                          theme: theme,
                        ),
                        SizedBox(width: 16.w),

                        // Resume
                        _buildDetailItem(
                          icon: HeroIcons.document,
                          label: 'Resume',
                          value: application.resumeUrl != null
                              ? 'Available'
                              : 'Not available',
                          theme: theme,
                        ),
                        SizedBox(width: 16.w),

                        // Interview date
                        if (application.interviewDate != null)
                          _buildDetailItem(
                            icon: HeroIcons.userGroup,
                            label: 'Interview',
                            value: DateFormat('MMM d, yyyy')
                                .format(application.interviewDate!),
                            theme: theme,
                          )
                        else
                          _buildDetailItem(
                            icon: HeroIcons.clock,
                            label: 'Time in Stage',
                            value: _getTimeInStage(
                              application.appliedAt,
                              application.lastUpdated,
                            ),
                            theme: theme,
                          ),
                      ],
                    ),
                    if (application.feedback != null &&
                        application.feedback!.isNotEmpty) ...[
                      Divider(
                        height: 24.h,
                        color: theme.dividerColor.withAlpha(128),
                      ),
                      Row(
                        children: [
                          HeroIcon(
                            HeroIcons.chatBubbleBottomCenterText,
                            size: 16.r,
                            color: RoleThemes.employerPrimary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Feedback:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: RoleThemes.employerPrimary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              application.feedback!,
                              style: theme.textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Cover letter preview
              if (application.coverLetter.isNotEmpty) ...[
                Text(
                  'Cover Letter',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  application.coverLetter.length > 100
                      ? '${application.coverLetter.substring(0, 100)}...'
                      : application.coverLetter,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
              ],

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Send message button
                  if (onSendMessage != null)
                    _buildActionButton(
                      icon: HeroIcons.envelope,
                      tooltip: 'Send Message',
                      onPressed: onSendMessage!,
                      theme: theme,
                    ),
                  SizedBox(width: 8.w),

                  // Schedule interview button
                  if (onScheduleInterview != null)
                    _buildActionButton(
                      icon: HeroIcons.calendar,
                      tooltip: 'Schedule Interview',
                      onPressed: onScheduleInterview!,
                      theme: theme,
                    ),
                  SizedBox(width: 8.w),

                  // Status change button
                  if (onStatusChange != null)
                    _buildStatusChangeButton(theme, isDarkMode),
                  SizedBox(width: 8.w),

                  // View details button
                  if (onViewDetails != null)
                    _buildActionButton(
                      icon: HeroIcons.eye,
                      tooltip: 'View Details',
                      onPressed: onViewDetails!,
                      theme: theme,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a detail item
  Widget _buildDetailItem({
    required HeroIcons icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HeroIcon(
                icon,
                size: 16.r,
                color: RoleThemes.employerPrimary,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withAlpha(179),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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

  /// Build a status badge
  Widget _buildStatusBadge(ApplicationStatus status, ThemeData theme) {
    Color color;
    String text;

    switch (status) {
      case ApplicationStatus.pending:
        color = Colors.blue;
        text = 'Pending';
      case ApplicationStatus.reviewed:
        color = Colors.orange;
        text = 'Reviewed';
      case ApplicationStatus.shortlisted:
        color = Colors.purple;
        text = 'Shortlisted';
      case ApplicationStatus.interview:
        color = Colors.indigo;
        text = 'Interview';
      case ApplicationStatus.offered:
        color = Colors.green;
        text = 'Offered';
      case ApplicationStatus.hired:
        color = Colors.teal;
        text = 'Hired';
      case ApplicationStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
      case ApplicationStatus.withdrawn:
        color = Colors.grey;
        text = 'Withdrawn';
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

  /// Build a status change button
  Widget _buildStatusChangeButton(ThemeData theme, bool isDarkMode) {
    return PopupMenuButton<ApplicationStatus>(
      icon: HeroIcon(
        HeroIcons.adjustmentsHorizontal,
        size: 20.r,
        color: RoleThemes.employerPrimary,
      ),
      tooltip: 'Change Status',
      onSelected: onStatusChange,
      itemBuilder: (context) => [
        _buildPopupMenuItem(
          value: ApplicationStatus.reviewed,
          text: 'Mark as Reviewed',
          icon: HeroIcons.check,
          color: Colors.orange,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
        _buildPopupMenuItem(
          value: ApplicationStatus.shortlisted,
          text: 'Shortlist',
          icon: HeroIcons.star,
          color: Colors.purple,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
        _buildPopupMenuItem(
          value: ApplicationStatus.interview,
          text: 'Schedule Interview',
          icon: HeroIcons.calendar,
          color: Colors.indigo,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
        _buildPopupMenuItem(
          value: ApplicationStatus.offered,
          text: 'Make Offer',
          icon: HeroIcons.documentCheck,
          color: Colors.green,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
        _buildPopupMenuItem(
          value: ApplicationStatus.hired,
          text: 'Mark as Hired',
          icon: HeroIcons.checkBadge,
          color: Colors.teal,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
        _buildPopupMenuItem(
          value: ApplicationStatus.rejected,
          text: 'Reject',
          icon: HeroIcons.xMark,
          color: Colors.red,
          theme: theme,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  /// Calculate time in current stage
  String _getTimeInStage(DateTime startDate, DateTime? lastUpdated) {
    final now = DateTime.now();
    final date = lastUpdated ?? startDate;
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    }
  }

  /// Build a popup menu item
  PopupMenuItem<ApplicationStatus> _buildPopupMenuItem({
    required ApplicationStatus value,
    required String text,
    required HeroIcons icon,
    required Color color,
    required ThemeData theme,
    required bool isDarkMode,
  }) {
    return PopupMenuItem<ApplicationStatus>(
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
}
