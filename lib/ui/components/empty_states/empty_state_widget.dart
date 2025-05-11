import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lottie/lottie.dart';
import 'package:next_gen/ui/components/buttons/custom_neopop_button.dart';

/// Empty state types for the empty state widget
enum EmptyStateType {
  /// General empty state
  general,

  /// No search results
  noSearchResults,

  /// No saved jobs
  noSavedJobs,

  /// No applications
  noApplications,

  /// No job postings
  noJobPostings,

  /// No applicants
  noApplicants,

  /// No notifications
  noNotifications,
}

/// A reusable empty state widget
class EmptyStateWidget extends StatelessWidget {
  /// Creates an empty state widget
  ///
  /// [title] is the title text
  /// [message] is the description message
  /// [actionButtonText] is the text for the action button
  /// [onActionButtonPressed] is called when the action button is pressed
  /// [emptyStateType] is the type of empty state
  /// [showActionButton] determines if the action button should be shown
  const EmptyStateWidget({
    required this.title,
    required this.message,
    this.actionButtonText,
    this.onActionButtonPressed,
    this.emptyStateType = EmptyStateType.general,
    this.showActionButton = true,
    this.customIcon,
    this.customLottieAsset,
    super.key,
  });

  /// The title text
  final String title;

  /// The description message
  final String message;

  /// The text for the action button
  final String? actionButtonText;

  /// Called when the action button is pressed
  final VoidCallback? onActionButtonPressed;

  /// The type of empty state
  final EmptyStateType emptyStateType;

  /// Whether to show the action button
  final bool showActionButton;

  /// Custom icon to override the default
  final HeroIcons? customIcon;

  /// Custom Lottie animation asset
  final String? customLottieAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show Lottie animation if available, otherwise show icon
            if (customLottieAsset != null || _getLottieAsset() != null)
              LottieBuilder.asset(
                customLottieAsset ?? _getLottieAsset()!,
                height: 150.r,
                width: 150.r,
                fit: BoxFit.contain,
                repeat: true,
              )
            else
              HeroIcon(
                customIcon ?? _getIcon(),
                size: 64.r,
                color: theme.colorScheme.primary.withAlpha(179), // 0.7 * 255
              ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 * 255
              ),
              textAlign: TextAlign.center,
            ),
            if (showActionButton &&
                onActionButtonPressed != null &&
                actionButtonText != null) ...[
              SizedBox(height: 24.h),
              CustomNeoPopButton.primary(
                onTap: onActionButtonPressed,
                child: Text(
                  actionButtonText!,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get the appropriate icon based on the empty state type
  HeroIcons _getIcon() {
    switch (emptyStateType) {
      case EmptyStateType.noSearchResults:
        return HeroIcons.magnifyingGlass;
      case EmptyStateType.noSavedJobs:
        return HeroIcons.heart;
      case EmptyStateType.noApplications:
        return HeroIcons.documentText;
      case EmptyStateType.noJobPostings:
        return HeroIcons.briefcase;
      case EmptyStateType.noApplicants:
        return HeroIcons.users;
      case EmptyStateType.noNotifications:
        return HeroIcons.bell;
      case EmptyStateType.general:
        return HeroIcons.folder;
    }
  }

  /// Get the appropriate Lottie animation asset based on the empty state type
  String? _getLottieAsset() {
    switch (emptyStateType) {
      case EmptyStateType.noSearchResults:
        return 'assets/animations/no_search_results.json';
      case EmptyStateType.noSavedJobs:
        return 'assets/animations/no_saved_jobs.json';
      case EmptyStateType.noApplications:
        return 'assets/animations/no_applications.json';
      case EmptyStateType.noJobPostings:
        return 'assets/animations/no_job_postings.json';
      case EmptyStateType.noApplicants:
        return 'assets/animations/no_applicants.json';
      case EmptyStateType.noNotifications:
        return 'assets/animations/no_notifications.json';
      case EmptyStateType.general:
        return 'assets/animations/empty_box.json';
    }
  }
}
