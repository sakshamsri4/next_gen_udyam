import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/interview_management/models/interview_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Interview details widget
class InterviewDetails extends StatelessWidget {
  /// Constructor
  const InterviewDetails({
    required this.interview,
    this.onClose,
    this.onReschedule,
    this.onCancel,
    this.onAddFeedback,
    super.key,
  });

  /// Interview data
  final InterviewModel interview;

  /// Called when the close button is tapped
  final VoidCallback? onClose;

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

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26), // 0.1 * 255 ≈ 26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Interview Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              if (onClose != null)
                IconButton(
                  onPressed: onClose,
                  icon: HeroIcon(
                    HeroIcons.xMark,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),

          // Job title and status
          Row(
            children: [
              Expanded(
                child: Text(
                  interview.jobTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _buildStatusBadge(context, interview.status),
            ],
          ),
          SizedBox(height: 16.h),

          // Candidate info
          _buildSectionTitle(context, 'Candidate'),
          SizedBox(height: 8.h),
          _buildInfoRow(
            context,
            HeroIcons.user,
            'Name',
            interview.candidateName,
          ),
          SizedBox(height: 16.h),

          // Interview info
          _buildSectionTitle(context, 'Interview Details'),
          SizedBox(height: 8.h),
          _buildInfoRow(
            context,
            HeroIcons.calendar,
            'Date',
            DateFormat('EEEE, MMMM d, yyyy').format(interview.scheduledDate),
          ),
          SizedBox(height: 4.h),
          _buildInfoRow(
            context,
            HeroIcons.clock,
            'Time',
            DateFormat('h:mm a').format(interview.scheduledDate),
          ),
          SizedBox(height: 4.h),
          _buildInfoRow(
            context,
            HeroIcons.clock,
            'Duration',
            '${interview.duration} minutes',
          ),
          SizedBox(height: 4.h),
          _buildInfoRow(
            context,
            _getInterviewTypeIcon(interview.type),
            'Type',
            _getInterviewTypeText(interview.type),
          ),
          SizedBox(height: 4.h),

          // Location or link
          if (interview.location != null)
            _buildInfoRow(
              context,
              HeroIcons.buildingOffice2,
              'Location',
              interview.location!,
            ),
          if (interview.videoLink != null)
            _buildInfoRow(
              context,
              HeroIcons.link,
              'Video Link',
              interview.videoLink!,
              isLink: true,
            ),
          if (interview.phoneNumber != null)
            _buildInfoRow(
              context,
              HeroIcons.phone,
              'Phone',
              interview.phoneNumber!,
            ),
          SizedBox(height: 16.h),

          // Interviewers
          if (interview.interviewerNames.isNotEmpty) ...[
            _buildSectionTitle(context, 'Interviewers'),
            SizedBox(height: 8.h),
            ...interview.interviewerNames.map((name) {
              return Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: _buildInfoRow(
                  context,
                  HeroIcons.userCircle,
                  '',
                  name,
                ),
              );
            }),
            SizedBox(height: 16.h),
          ],

          // Preparation resources
          if (interview.preparationResources.isNotEmpty) ...[
            _buildSectionTitle(context, 'Preparation Resources'),
            SizedBox(height: 8.h),
            ...interview.preparationResources.map((resource) {
              return Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: _buildInfoRow(
                  context,
                  HeroIcons.documentText,
                  '',
                  resource,
                ),
              );
            }),
            SizedBox(height: 16.h),
          ],

          // Questions
          if (interview.questions.isNotEmpty) ...[
            _buildSectionTitle(context, 'Interview Questions'),
            SizedBox(height: 8.h),
            ...interview.questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}.',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(question),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 16.h),
          ],

          // Notes
          if (interview.notes != null && interview.notes!.isNotEmpty) ...[
            _buildSectionTitle(context, 'Notes'),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(interview.notes!),
            ),
            SizedBox(height: 16.h),
          ],

          // Feedback
          if (interview.feedback != null && interview.feedback!.isNotEmpty) ...[
            _buildSectionTitle(context, 'Feedback'),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(interview.feedback!),
            ),
            SizedBox(height: 16.h),
          ],

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Add feedback button (for completed interviews)
              if (interview.status == InterviewStatus.completed &&
                  onAddFeedback != null &&
                  (interview.feedback == null || interview.feedback!.isEmpty))
                ElevatedButton.icon(
                  onPressed: onAddFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  icon: const HeroIcon(
                    HeroIcons.chatBubbleBottomCenterText,
                    color: Colors.white,
                  ),
                  label: const Text('Add Feedback'),
                ),

              // Reschedule button (for upcoming interviews)
              if (_canReschedule(interview) && onReschedule != null) ...[
                if (onAddFeedback != null &&
                    interview.status == InterviewStatus.completed &&
                    (interview.feedback == null || interview.feedback!.isEmpty))
                  SizedBox(width: 8.w),
                ElevatedButton.icon(
                  onPressed: onReschedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  icon: const HeroIcon(
                    HeroIcons.calendar,
                    color: Colors.white,
                  ),
                  label: const Text('Reschedule'),
                ),
              ],

              // Cancel button (for upcoming interviews)
              if (_canCancel(interview) && onCancel != null) ...[
                SizedBox(width: 8.w),
                ElevatedButton.icon(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: const HeroIcon(
                    HeroIcons.xMark,
                    color: Colors.white,
                  ),
                  label: const Text('Cancel'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Build section title
  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(
    BuildContext context,
    HeroIcons icon,
    String label,
    String value, {
    bool isLink = false,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    const primaryColor = RoleThemes.employerPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroIcon(
          icon,
          size: 16.w,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        SizedBox(width: 8.w),
        if (label.isNotEmpty) ...[
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
        Expanded(
          child: isLink
              ? Text(
                  value,
                  style: const TextStyle(
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                )
              : Text(value),
        ),
      ],
    );
  }

  /// Build status badge
  Widget _buildStatusBadge(BuildContext context, InterviewStatus status) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26), // 0.1 * 255 ≈ 26,
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
