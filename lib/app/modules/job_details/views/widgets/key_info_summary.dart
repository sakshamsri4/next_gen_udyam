import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Key information summary for job details
class KeyInfoSummary extends StatelessWidget {
  /// Creates a key information summary
  const KeyInfoSummary({
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
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color:
            RoleThemes.employeePrimary.withAlpha(13), // 0.05 * 255 = 12.75 ≈ 13
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: RoleThemes.employeePrimary.withAlpha(51), // 0.2 * 255 = 51
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 16.h),

          // Grid of key information
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: [
              // Salary
              _buildInfoItem(
                context,
                icon: HeroIcons.currencyDollar,
                title: 'Salary',
                value: currencyFormat.format(job.salary),
              ),

              // Job Type
              _buildInfoItem(
                context,
                icon: HeroIcons.briefcase,
                title: 'Job Type',
                value: job.jobType,
              ),

              // Location
              _buildInfoItem(
                context,
                icon: HeroIcons.mapPin,
                title: 'Location',
                value: job.isRemote ? 'Remote' : job.location,
              ),

              // Experience
              _buildInfoItem(
                context,
                icon: HeroIcons.academicCap,
                title: 'Experience',
                value: job.experience,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build an information item
  Widget _buildInfoItem(
    BuildContext context, {
    required HeroIcons icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SizedBox(
      width: 150.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroIcon(
            icon,
            size: 20.w,
            color: RoleThemes.employeePrimary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
