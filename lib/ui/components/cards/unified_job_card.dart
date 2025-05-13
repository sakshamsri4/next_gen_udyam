import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/utils/date_formatter.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A unified job card component that adapts to different use cases
///
/// This component combines the best features of JobCard and CustomJobCard
/// into a single, flexible implementation that can be used throughout the app.
///
/// Features:
/// - Role-specific styling (employee blue, employer green)
/// - Support for featured/highlighted jobs
/// - Match percentage indicator
/// - Quick actions (save, share, apply)
/// - Responsive layout
/// - Consistent styling
class UnifiedJobCard extends StatelessWidget {
  /// Creates a unified job card with individual properties
  ///
  /// This constructor is useful when you don't have a complete JobModel
  /// but still want to use the unified job card component.
  const UnifiedJobCard({
    required this.avatar,
    required this.companyName,
    required this.jobPosition,
    required this.publishTime,
    required this.workplace,
    required this.location,
    required this.employmentType,
    required this.onTap,
    super.key,
    this.userRole = UserType.employee,
    this.description,
    this.salary,
    this.onSave,
    this.onShare,
    this.onQuickApply,
    this.matchPercentage,
    this.isFeatured = false,
    this.isSaved = false,
    this.showQuickActions = true,
  }) : job = null;

  /// Creates a unified job card from a JobModel
  ///
  /// This constructor is the preferred way to create a job card when
  /// you have a complete JobModel available.
  UnifiedJobCard.fromModel({
    required JobModel jobModel,
    required this.onTap,
    super.key,
    this.userRole = UserType.employee,
    this.onSave,
    this.onShare,
    this.onQuickApply,
    this.matchPercentage,
    this.isFeatured = false,
    this.isSaved = false,
    this.showQuickActions = true,
  })  : job = jobModel,
        avatar = jobModel.logoUrl ?? '',
        companyName = jobModel.company,
        jobPosition = jobModel.title,
        publishTime = jobModel.postedDate,
        workplace = jobModel.isRemote ? 'Remote' : 'On-site',
        location = jobModel.location,
        employmentType = jobModel.jobType,
        description = jobModel.description,
        salary = jobModel.salary;

  /// Job model (if available)
  final JobModel? job;

  /// User role for styling
  final UserType userRole;

  /// Company logo URL
  final String avatar;

  /// Company name
  final String companyName;

  /// Job title/position
  final String jobPosition;

  /// Publication date
  final dynamic publishTime;

  /// Workplace type (e.g., Remote, On-site)
  final String workplace;

  /// Job location
  final String location;

  /// Employment type (e.g., Full-time, Part-time)
  final String employmentType;

  /// Job description
  final String? description;

  /// Job salary
  final int? salary;

  /// Whether this is a featured job
  final bool isFeatured;

  /// Whether this job is saved
  final bool isSaved;

  /// Whether to show quick actions
  final bool showQuickActions;

  /// Match percentage (0-100)
  final int? matchPercentage;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  /// Callback when the save button is tapped
  final Future<bool?> Function({required bool isLiked})? onSave;

  /// Callback when the share button is tapped
  final VoidCallback? onShare;

  /// Callback when the quick apply button is tapped
  final VoidCallback? onQuickApply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get role-specific colors
    final Color primaryColor;
    final Color primaryLightColor;

    if (userRole == UserType.employer) {
      primaryColor = RoleThemes.employerPrimary;
      primaryLightColor = RoleThemes.employerPrimaryLight;
    } else {
      // Default to employee
      primaryColor = RoleThemes.employeePrimary;
      primaryLightColor = RoleThemes.employeePrimaryLight;
    }

    // Format date
    String formattedDate;
    if (publishTime is DateTime) {
      formattedDate = DateFormatter.formatRelativeTime(publishTime as DateTime);
    } else if (publishTime is String) {
      try {
        final datetime = DateTime.parse(publishTime as String);
        formattedDate = DateFormatter.formatStandardDate(datetime);
      } catch (e) {
        formattedDate = 'Unknown date';
      }
    } else if (publishTime is int) {
      final datetime = DateTime.fromMillisecondsSinceEpoch(publishTime as int);
      formattedDate = DateFormatter.formatStandardDate(datetime);
    } else {
      formattedDate = 'Unknown date';
    }

    // Format salary if available
    final String? formattedSalary;
    if (salary != null) {
      final currencyFormat =
          NumberFormat.currency(symbol: r'$', decimalDigits: 0);
      formattedSalary = '${currencyFormat.format(salary)}/year';
    } else {
      formattedSalary = null;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isFeatured ? primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: isFeatured
                  ? primaryColor.withAlpha(38)
                  : Colors.black.withAlpha(13),
              blurRadius: isFeatured ? 10 : 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header with company info
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company info and date
                  Row(
                    children: [
                      // Company logo
                      _buildCompanyLogo(avatar),
                      SizedBox(width: 12.w),
                      // Company name and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: isFeatured
                                    ? Colors.white
                                    : theme.textTheme.titleSmall?.color,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Posted $formattedDate',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isFeatured
                                    ? Colors.white
                                        .withAlpha(204) // 0.8 * 255 = 204
                                    : theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Match percentage if available
                      if (matchPercentage != null)
                        _buildMatchPercentage(matchPercentage!, theme),
                      // Save button
                      if (onSave != null)
                        _buildSaveButton(
                          isSaved,
                          onSave!,
                          isFeatured ? Colors.white : primaryColor,
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Job title
                  Text(
                    jobPosition,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isFeatured ? Colors.white : primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Salary if available
                  if (formattedSalary != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      formattedSalary,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isFeatured ? Colors.white : primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  SizedBox(height: 12.h),
                  // Job details
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildTag(
                        workplace,
                        HeroIcons.buildingOffice2,
                        isFeatured,
                        primaryColor,
                        primaryLightColor,
                        theme,
                      ),
                      _buildTag(
                        employmentType,
                        HeroIcons.briefcase,
                        isFeatured,
                        primaryColor,
                        primaryLightColor,
                        theme,
                      ),
                      _buildTag(
                        location,
                        HeroIcons.mapPin,
                        isFeatured,
                        primaryColor,
                        primaryLightColor,
                        theme,
                      ),
                    ],
                  ),
                  // Description if available
                  if (description != null && !isFeatured) ...[
                    SizedBox(height: 12.h),
                    Text(
                      description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Quick actions
            if (showQuickActions)
              _buildQuickActions(
                theme,
                primaryColor,
                primaryLightColor,
                isFeatured,
              ),
          ],
        ),
      ),
    );
  }

  /// Build company logo
  Widget _buildCompanyLogo(String logoUrl) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: logoUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: HeroIcon(
                      HeroIcons.buildingOffice2,
                      color: Colors.grey[400],
                      size: 24.r,
                    ),
                  );
                },
              ),
            )
          : Center(
              child: HeroIcon(
                HeroIcons.buildingOffice2,
                color: Colors.grey[400],
                size: 24.r,
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
        width: 40.r,
        height: 40.r,
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

  /// Build save button
  Widget _buildSaveButton(
    bool isSaved,
    Future<bool?> Function({required bool isLiked}) onSave,
    Color color,
  ) {
    return IconButton(
      icon: HeroIcon(
        isSaved ? HeroIcons.bookmark : HeroIcons.bookmark,
        color: color,
        size: 24.r,
      ),
      onPressed: () {
        onSave(isLiked: isSaved);
      },
    );
  }

  /// Build tag
  Widget _buildTag(
    String text,
    HeroIcons icon,
    bool isFeatured,
    Color primaryColor,
    Color primaryLightColor,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: isFeatured
            ? Colors.white.withAlpha(51)
            : primaryLightColor, // 0.2 * 255 = 51
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            icon,
            size: 12.r,
            color: isFeatured ? Colors.white : primaryColor,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isFeatured ? Colors.white : primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build quick actions
  Widget _buildQuickActions(
    ThemeData theme,
    Color primaryColor,
    Color primaryLightColor,
    bool isFeatured,
  ) {
    final actionsColor = isFeatured ? Colors.white : primaryColor;
    final backgroundColor = isFeatured
        ? Colors.white.withAlpha(51)
        : primaryLightColor; // 0.2 * 255 = 51

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Quick apply button
          Expanded(
            child: TextButton.icon(
              icon: HeroIcon(
                HeroIcons.bolt,
                size: 16.r,
                color: actionsColor,
              ),
              label: Text(
                'Quick Apply',
                style: TextStyle(
                  color: actionsColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: onQuickApply ??
                  () {
                    Get.snackbar(
                      'Quick Apply',
                      'Your profile has been submitted for this job',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                ),
              ),
            ),
          ),
          // Share button
          IconButton(
            icon: HeroIcon(
              HeroIcons.share,
              size: 20.r,
              color: actionsColor,
            ),
            onPressed: onShare ??
                () {
                  Get.snackbar(
                    'Share Job',
                    'Sharing options will appear here',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
            tooltip: 'Share Job',
          ),
        ],
      ),
    );
  }
}
