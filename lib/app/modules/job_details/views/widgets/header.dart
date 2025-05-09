import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/cards/custom_tag.dart';

/// Header widget for job details
class JobDetailsHeader extends StatelessWidget {
  /// Creates a job details header
  const JobDetailsHeader({
    required this.job,
    super.key,
  });

  /// The job model
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final currencyFormat =
        NumberFormat.currency(symbol: r'$', decimalDigits: 0);

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job title
          Text(
            job.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 16.h),

          // Job details row
          Row(
            children: [
              // Salary
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.neonGreen.withAlpha(51)
                      : AppTheme.neonGreen.withAlpha(30),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  currencyFormat.format(job.salary),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? AppTheme.brightNeonGreen
                        : AppTheme.neonGreen,
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // Posted date
              Text(
                'Posted ${_formatDate(job.postedDate)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Tags row
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              CustomTag(
                title: job.jobType,
                icon: HeroIcons.briefcase,
                backgroundColor: isDarkMode
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface,
                titleColor: isDarkMode
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.secondary,
              ),
              CustomTag(
                title: job.isRemote ? 'Remote' : 'On-site',
                icon: job.isRemote ? HeroIcons.home : HeroIcons.buildingOffice,
                backgroundColor: isDarkMode
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface,
                titleColor: isDarkMode
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.secondary,
              ),
              CustomTag(
                title: job.location,
                icon: HeroIcons.mapPin,
                backgroundColor: isDarkMode
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface,
                titleColor: isDarkMode
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.secondary,
              ),
              CustomTag(
                title: job.experience,
                icon: HeroIcons.academicCap,
                backgroundColor: isDarkMode
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface,
                titleColor: isDarkMode
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }
}
