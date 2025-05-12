import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/interview_management/models/interview_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Interview card widget
class InterviewCard extends StatelessWidget {
  /// Constructor
  const InterviewCard({
    required this.interview,
    required this.onTap,
    this.onReschedule,
    this.onCancel,
    this.onAddFeedback,
    super.key,
  });

  /// Interview data
  final InterviewModel interview;

  /// Called when the card is tapped
  final VoidCallback onTap;

  /// Called when the reschedule button is tapped
  final VoidCallback? onReschedule;

  /// Called when the cancel button is tapped
  final VoidCallback? onCancel;

  /// Called when the add feedback button is tapped
  final VoidCallback? onAddFeedback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    const primaryColor = RoleThemes.employerPrimary;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: _getBorderColor(interview.status),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      interview.jobTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _buildStatusBadge(context, interview.status),
                ],
              ),
              SizedBox(height: 8.h),

              // Candidate name
              Row(
                children: [
                  HeroIcon(
                    HeroIcons.user,
                    size: 16.w,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    interview.candidateName,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Date and time
              Row(
                children: [
                  HeroIcon(
                    HeroIcons.calendar,
                    size: 16.w,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a')
                        .format(interview.scheduledDate),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Interview type and duration
              Row(
                children: [
                  HeroIcon(
                    _getInterviewTypeIcon(interview.type),
                    size: 16.w,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${_getInterviewTypeText(interview.type)} • ${interview.duration} min',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Add feedback button (for completed interviews)
                  if (interview.status == InterviewStatus.completed &&
                      onAddFeedback != null &&
                      (interview.feedback == null ||
                          interview.feedback!.isEmpty))
                    TextButton.icon(
                      onPressed: onAddFeedback,
                      icon: HeroIcon(
                        HeroIcons.chatBubbleBottomCenterText,
                        size: 16.w,
                        color: primaryColor,
                      ),
                      label: const Text(
                        'Add Feedback',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),

                  // Reschedule button (for upcoming interviews)
                  if (_canReschedule(interview) && onReschedule != null)
                    TextButton.icon(
                      onPressed: onReschedule,
                      icon: HeroIcon(
                        HeroIcons.calendar,
                        size: 16.w,
                        color: Colors.orange,
                      ),
                      label: const Text(
                        'Reschedule',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),

                  // Cancel button (for upcoming interviews)
                  if (_canCancel(interview) && onCancel != null)
                    TextButton.icon(
                      onPressed: onCancel,
                      icon: HeroIcon(
                        HeroIcons.xMark,
                        size: 16.w,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
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
  Widget _buildStatusBadge(BuildContext context, InterviewStatus status) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  /// Get status color
  Color _getStatusColor(InterviewStatus status) {
    switch (status) {
      case InterviewStatus.scheduled:
        return Colors.blue;
      case InterviewStatus.confirmed:
        return Colors.green;
      case InterviewStatus.completed:
        return Colors.purple;
      case InterviewStatus.canceled:
        return Colors.red;
      case InterviewStatus.rescheduled:
        return Colors.orange;
    }
  }

  /// Get status text
  String _getStatusText(InterviewStatus status) {
    switch (status) {
      case InterviewStatus.scheduled:
        return 'Scheduled';
      case InterviewStatus.confirmed:
        return 'Confirmed';
      case InterviewStatus.completed:
        return 'Completed';
      case InterviewStatus.canceled:
        return 'Canceled';
      case InterviewStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  /// Get border color
  Color _getBorderColor(InterviewStatus status) {
    return _getStatusColor(status).withOpacity(0.3);
  }

  /// Get interview type icon
  HeroIcons _getInterviewTypeIcon(InterviewType type) {
    switch (type) {
      case InterviewType.phone:
        return HeroIcons.phone;
      case InterviewType.video:
        return HeroIcons.videoCamera;
      case InterviewType.inPerson:
        return HeroIcons.buildingOffice2;
      case InterviewType.technical:
        return HeroIcons.commandLine;
      case InterviewType.cultural:
        return HeroIcons.userGroup;
    }
  }

  /// Get interview type text
  String _getInterviewTypeText(InterviewType type) {
    switch (type) {
      case InterviewType.phone:
        return 'Phone Interview';
      case InterviewType.video:
        return 'Video Interview';
      case InterviewType.inPerson:
        return 'In-Person Interview';
      case InterviewType.technical:
        return 'Technical Interview';
      case InterviewType.cultural:
        return 'Cultural Interview';
    }
  }

  /// Check if interview can be rescheduled
  bool _canReschedule(InterviewModel interview) {
    return interview.scheduledDate.isAfter(DateTime.now()) &&
        interview.status != InterviewStatus.canceled;
  }

  /// Check if interview can be canceled
  bool _canCancel(InterviewModel interview) {
    return interview.scheduledDate.isAfter(DateTime.now()) &&
        interview.status != InterviewStatus.canceled;
  }
}
