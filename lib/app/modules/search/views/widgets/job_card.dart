import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A card widget for displaying job information
class JobCard extends StatelessWidget {
  /// Constructor
  const JobCard({
    required this.job,
    required this.onTap,
    super.key,
  });

  /// Job data
  final JobModel job;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final currencyFormat =
        NumberFormat.currency(symbol: r'$', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeoPopCard(
        color: theme.cardColor,
        parentColor: theme.scaffoldBackgroundColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job title and salary
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
                    Text(
                      currencyFormat.format(job.salary),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDarkMode
                            ? AppTheme.brightElectricBlue
                            : AppTheme.electricBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Company and location
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.buildingUser,
                      size: 14,
                      color:
                          isDarkMode ? AppTheme.slateGray : AppTheme.slateGray,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        job.company,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppTheme.slateGray
                              : AppTheme.slateGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.locationDot,
                      size: 14,
                      color:
                          isDarkMode ? AppTheme.slateGray : AppTheme.slateGray,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      job.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppTheme.slateGray
                            : AppTheme.slateGray,
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
                        color: isDarkMode
                            ? AppTheme.electricBlue
                                .withAlpha(51) // 0.2 * 255 = 51
                            : AppTheme.electricBlue.withAlpha(51),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        job.jobType,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? AppTheme.brightElectricBlue
                              : AppTheme.electricBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Posted ${_formatDate(job.postedDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppTheme.slateGray
                            : AppTheme.slateGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Format date as relative time
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.isNegative) {
      // Handle future dates
      return DateFormat('MMM d').format(date); // Future date
    } else if (difference.inDays > 7) {
      return DateFormat('MMM d').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} '
          '${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} '
          '${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} '
          '${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
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
