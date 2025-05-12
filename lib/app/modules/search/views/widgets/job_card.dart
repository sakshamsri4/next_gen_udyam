import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/utils/date_formatter.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A card widget for displaying job information
class JobCard extends StatelessWidget {
  /// Constructor
  const JobCard({
    required this.job,
    required this.onTap,
    this.onSave,
    this.onShare,
    this.onQuickApply,
    this.matchPercentage,
    this.showQuickActions = true,
    super.key,
  });

  /// Job data
  final JobModel job;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  /// Callback when the save button is tapped
  final VoidCallback? onSave;

  /// Callback when the share button is tapped
  final VoidCallback? onShare;

  /// Callback when the quick apply button is tapped
  final VoidCallback? onQuickApply;

  /// Match percentage (0-100)
  final int? matchPercentage;

  /// Whether to show quick actions
  final bool showQuickActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat =
        NumberFormat.currency(symbol: r'$', decimalDigits: 0);

    // Define employee blue color
    const employeeBlue = RoleThemes.employeePrimary;
    final employeeLightBlue = employeeBlue.withAlpha(26); // 0.1 * 255 = 26

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeoPopCard(
        color: theme.cardColor,
        parentColor: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            // Main card content
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job title and match percentage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: employeeBlue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (matchPercentage != null)
                          _buildMatchPercentage(matchPercentage!, theme),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Salary
                    Text(
                      '${currencyFormat.format(job.salary)}/year',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: employeeBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Company and location
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.buildingUser,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            job.company,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.locationDot,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          job.location,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Job type and date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: employeeLightBlue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            job.jobType,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: employeeBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Posted ${_formatDate(job.postedDate)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick actions
            if (showQuickActions)
              _buildQuickActions(theme, employeeBlue, employeeLightBlue),
          ],
        ),
      ),
    );
  }

  /// Build match percentage indicator
  Widget _buildMatchPercentage(int percentage, ThemeData theme) {
    // Define colors based on percentage
    Color color;
    if (percentage >= 80) {
      color = Colors.green;
    } else if (percentage >= 60) {
      color = Colors.orange;
    } else {
      color = Colors.grey;
    }

    return Tooltip(
      message: 'Match: $percentage% based on your profile',
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withAlpha(26),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 3,
            ),
            Text(
              '$percentage%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build quick actions bar
  Widget _buildQuickActions(
    ThemeData theme,
    Color employeeBlue,
    Color employeeLightBlue,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: employeeLightBlue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Save button
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.bookmark,
              size: 16,
            ),
            color: employeeBlue,
            onPressed: onSave ??
                () {
                  Get.snackbar(
                    'Job Saved',
                    'This job has been saved to your favorites',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: employeeBlue,
                    colorText: Colors.white,
                  );
                },
            tooltip: 'Save Job',
          ),

          // Quick apply button
          TextButton.icon(
            icon: const Icon(
              FontAwesomeIcons.bolt,
              size: 14,
            ),
            label: const Text('Quick Apply'),
            style: TextButton.styleFrom(
              foregroundColor: employeeBlue,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onQuickApply ??
                () {
                  Get.snackbar(
                    'Quick Apply',
                    'Your profile has been submitted for this job',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: employeeBlue,
                    colorText: Colors.white,
                  );
                },
          ),

          // Share button
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.share,
              size: 16,
            ),
            color: employeeBlue,
            onPressed: onShare ??
                () {
                  Get.snackbar(
                    'Share Job',
                    'Sharing options will appear here',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: employeeBlue,
                    colorText: Colors.white,
                  );
                },
            tooltip: 'Share Job',
          ),
        ],
      ),
    );
  }

  /// Format date as relative time
  String _formatDate(DateTime date) {
    return DateFormatter.formatRelativeTime(date);
  }
}

/// A NeoPOP card widget
class NeoPopCard extends StatelessWidget {
  /// Constructor
  const NeoPopCard({
    required this.child,
    this.color,
    this.depth = 2,
    this.parentColor,
    super.key,
  });

  /// Child widget
  final Widget child;

  /// Card color
  final Color? color;

  /// Card depth
  final double depth;

  /// Parent color
  final Color? parentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardColor;
    // parentColor is used for future implementation of nested cards
    // ignore: unused_local_variable
    final backgroundColor = parentColor ?? theme.scaffoldBackgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Bottom shadow
          BoxShadow(
            color: Colors.black.withAlpha(26), // 0.1 * 255 = 26
            offset: Offset(0, depth),
            blurRadius: depth * 2,
          ),
          // Right shadow
          BoxShadow(
            color: Colors.black.withAlpha(26), // 0.1 * 255 = 26
            offset: Offset(depth, 0),
            blurRadius: depth * 2,
          ),
          // Highlight
          BoxShadow(
            color: Colors.white.withAlpha(26), // 0.1 * 255 = 26
            offset: const Offset(-1, -1),
            blurRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.white.withAlpha(26), // 0.1 * 255 = 26
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}
