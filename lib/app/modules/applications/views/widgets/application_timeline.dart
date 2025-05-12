import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Application timeline widget
class ApplicationTimeline extends StatelessWidget {
  /// Creates an application timeline
  const ApplicationTimeline({
    required this.application,
    super.key,
  });

  /// The application model
  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get timeline steps
    final timelineSteps = _getTimelineSteps(application);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Timeline',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),

          // Timeline steps
          for (int i = 0; i < timelineSteps.length; i++)
            _buildTimelineStep(
              context,
              step: timelineSteps[i],
              isFirst: i == 0,
              isLast: i == timelineSteps.length - 1,
              isDarkMode: isDarkMode,
              timelineSteps: timelineSteps,
            ),
        ],
      ),
    );
  }

  /// Build a timeline step
  Widget _buildTimelineStep(
    BuildContext context, {
    required TimelineStep step,
    required bool isFirst,
    required bool isLast,
    required bool isDarkMode,
    required List<TimelineStep> timelineSteps,
  }) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 24.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Line above dot (not for first step)
                if (!isFirst)
                  Positioned(
                    top: 0,
                    bottom: 12.h,
                    child: Container(
                      width: 2.w,
                      color: step.isCompleted
                          ? step.color
                          : isDarkMode
                              ? Colors.white24
                              : Colors.black12,
                    ),
                  ),

                // Line below dot (not for last step)
                if (!isLast)
                  Positioned(
                    top: 12.h,
                    bottom: 0,
                    child: Container(
                      width: 2.w,
                      color: step.isCompleted &&
                              timelineSteps[timelineSteps.indexOf(step) + 1]
                                  .isCompleted
                          ? timelineSteps[timelineSteps.indexOf(step) + 1].color
                          : isDarkMode
                              ? Colors.white24
                              : Colors.black12,
                    ),
                  ),

                // Dot
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: step.isCompleted ? step.color : Colors.transparent,
                    border: Border.all(
                      color: step.isCompleted
                          ? step.color
                          : isDarkMode
                              ? Colors.white38
                              : Colors.black26,
                      width: 2.w,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Step content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step title and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      step.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: step.isCompleted
                            ? step.color
                            : isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                      ),
                    ),
                    if (step.date != null)
                      Text(
                        DateFormat('MMM d, yyyy').format(step.date!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDarkMode ? Colors.white54 : Colors.black45,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Step description
                if (step.description != null)
                  Text(
                    step.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get timeline steps based on application status
  List<TimelineStep> _getTimelineSteps(ApplicationModel application) {
    // Initialize with Applied and Reviewed steps
    final steps = <TimelineStep>[
      // Applied step (always completed)
      TimelineStep(
        title: 'Applied',
        description: 'Your application has been submitted successfully.',
        date: application.appliedAt,
        isCompleted: true,
        color: RoleThemes.employeePrimary,
        icon: HeroIcons.paperAirplane,
      ),
      // Reviewed step
      TimelineStep(
        title: 'Reviewed',
        description:
            application.status.index >= ApplicationStatus.reviewed.index
                ? 'Your application has been reviewed by the employer.'
                : 'Waiting for the employer to review your application.',
        date: application.status.index >= ApplicationStatus.reviewed.index
            ? application.lastUpdated
            : null,
        isCompleted:
            application.status.index >= ApplicationStatus.reviewed.index,
        color: Colors.purple,
        icon: HeroIcons.documentCheck,
      ),
    ];

    // Shortlisted step
    if (application.status.index >= ApplicationStatus.shortlisted.index) {
      steps.add(
        TimelineStep(
          title: 'Shortlisted',
          description:
              'Your application has been shortlisted for further consideration.',
          date: application.lastUpdated,
          isCompleted: true,
          color: Colors.orange,
          icon: HeroIcons.star,
        ),
      );
    }

    // Interview step
    if (application.status.index >= ApplicationStatus.interview.index) {
      steps.add(
        TimelineStep(
          title: 'Interview',
          description: application.interviewDate != null
              ? 'Interview scheduled for ${DateFormat('MMM d, yyyy').format(application.interviewDate!)}'
              : 'You have been selected for an interview.',
          date: application.lastUpdated,
          isCompleted: true,
          color: Colors.teal,
          icon: HeroIcons.userGroup,
        ),
      );
    }

    // Offered step
    if (application.status.index >= ApplicationStatus.offered.index) {
      steps.add(
        TimelineStep(
          title: 'Offer',
          description: 'Congratulations! You have received a job offer.',
          date: application.lastUpdated,
          isCompleted: true,
          color: Colors.green,
          icon: HeroIcons.documentText,
        ),
      );
    }

    // Hired step
    if (application.status == ApplicationStatus.hired) {
      steps.add(
        TimelineStep(
          title: 'Hired',
          description:
              'Congratulations! You have been hired for this position.',
          date: application.lastUpdated,
          isCompleted: true,
          color: RoleThemes.employeePrimary,
          icon: HeroIcons.checkBadge,
        ),
      );
    }

    // Rejected step
    if (application.status == ApplicationStatus.rejected) {
      steps.add(
        TimelineStep(
          title: 'Rejected',
          description: application.feedback ??
              'Your application was not selected for this position.',
          date: application.lastUpdated,
          isCompleted: true,
          color: Colors.red,
          icon: HeroIcons.xMark,
        ),
      );
    }

    // Withdrawn step
    if (application.status == ApplicationStatus.withdrawn) {
      steps.add(
        TimelineStep(
          title: 'Withdrawn',
          description: 'You have withdrawn your application for this position.',
          date: application.lastUpdated,
          isCompleted: true,
          color: Colors.grey,
          icon: HeroIcons.arrowUturnLeft,
        ),
      );
    }

    return steps;
  }
}

/// Timeline step model
class TimelineStep {
  /// Creates a timeline step
  TimelineStep({
    required this.title,
    required this.isCompleted,
    required this.color,
    required this.icon,
    this.description,
    this.date,
  });

  /// Step title
  final String title;

  /// Step description
  final String? description;

  /// Step date
  final DateTime? date;

  /// Whether the step is completed
  final bool isCompleted;

  /// Step color
  final Color color;

  /// Step icon
  final HeroIcons icon;
}
