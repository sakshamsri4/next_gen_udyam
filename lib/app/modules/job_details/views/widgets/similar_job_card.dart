import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A card for displaying similar job information
class SimilarJobCard extends StatelessWidget {
  /// Creates a similar job card
  const SimilarJobCard({
    required this.job,
    required this.onTap,
    super.key,
  });

  /// The job model
  final JobModel job;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final currencyFormat =
        NumberFormat.currency(symbol: r'$', decimalDigits: 0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 0.65.sw,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company logo and name
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  _buildCompanyLogo(job.logoUrl, isDarkMode),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.company,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          job.location,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Job title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                job.title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 8.h),

            // Salary
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.neonGreen.withAlpha(51)
                      : AppTheme.neonGreen.withAlpha(30),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  currencyFormat.format(job.salary),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? AppTheme.brightNeonGreen
                        : AppTheme.neonGreen,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Job type and date
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppTheme.electricBlue.withAlpha(51)
                          : AppTheme.electricBlue.withAlpha(30),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      job.jobType,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppTheme.brightElectricBlue
                            : AppTheme.electricBlue,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(job.postedDate),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(String? logoUrl, bool isDarkMode) {
    if (logoUrl == null || logoUrl.isEmpty) {
      // Fallback to company initial if no logo
      return Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppTheme.electricBlue.withAlpha(51)
              : AppTheme.electricBlue.withAlpha(30),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            job.company.isNotEmpty ? job.company[0].toUpperCase() : 'C',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? AppTheme.brightElectricBlue
                  : AppTheme.electricBlue,
            ),
          ),
        ),
      );
    }

    // Display company logo
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.w),
        child: Image.network(
          logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback on error
            return Center(
              child: Text(
                job.company.isNotEmpty ? job.company[0].toUpperCase() : 'C',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.electricBlue,
                ),
              ),
            );
          },
        ),
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
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}
