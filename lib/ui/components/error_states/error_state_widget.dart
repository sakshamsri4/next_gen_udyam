import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lottie/lottie.dart';
import 'package:next_gen/ui/components/buttons/custom_neopop_button.dart';

/// Error types for the error state widget
enum ErrorType {
  /// General error
  general,

  /// Network error
  network,

  /// Server error
  server,

  /// Not found error
  notFound,

  /// Permission error
  permission,

  /// Authentication error
  authentication,
}

/// A reusable error state widget
class ErrorStateWidget extends StatelessWidget {
  /// Creates an error state widget
  ///
  /// [title] is the title text
  /// [message] is the error message
  /// [onRetry] is called when the retry button is pressed
  /// [errorType] is the type of error
  /// [showRetryButton] determines if the retry button should be shown
  const ErrorStateWidget({
    required this.title,
    required this.message,
    this.onRetry,
    this.errorType = ErrorType.general,
    this.showRetryButton = true,
    this.customIcon,
    this.customLottieAsset,
    super.key,
  });

  /// The title text
  final String title;

  /// The error message
  final String message;

  /// Called when the retry button is pressed
  final VoidCallback? onRetry;

  /// The type of error
  final ErrorType errorType;

  /// Whether to show the retry button
  final bool showRetryButton;

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
                color: _getIconColor(theme),
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
            if (showRetryButton && onRetry != null) ...[
              SizedBox(height: 24.h),
              CustomNeoPopButton.primary(
                onTap: onRetry,
                child: Text(
                  'Try Again',
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

  /// Get the appropriate icon based on the error type
  HeroIcons _getIcon() {
    switch (errorType) {
      case ErrorType.network:
        return HeroIcons.noSymbol;
      case ErrorType.server:
        return HeroIcons.serverStack;
      case ErrorType.notFound:
        return HeroIcons.magnifyingGlassCircle;
      case ErrorType.permission:
        return HeroIcons.lockClosed;
      case ErrorType.authentication:
        return HeroIcons.userCircle;
      case ErrorType.general:
        return HeroIcons.exclamationTriangle;
    }
  }

  /// Get the appropriate icon color based on the error type
  Color _getIconColor(ThemeData theme) {
    switch (errorType) {
      case ErrorType.network:
        return Colors.orange;
      case ErrorType.server:
        return Colors.red;
      case ErrorType.notFound:
        return Colors.blue;
      case ErrorType.permission:
        return Colors.red;
      case ErrorType.authentication:
        return theme.colorScheme.primary;
      case ErrorType.general:
        return Colors.orange;
    }
  }

  /// Get the appropriate Lottie animation asset based on the error type
  String? _getLottieAsset() {
    switch (errorType) {
      case ErrorType.network:
        return 'assets/animations/network_error.json';
      case ErrorType.server:
        return 'assets/animations/server_error.json';
      case ErrorType.notFound:
        return 'assets/animations/not_found.json';
      case ErrorType.permission:
        return 'assets/animations/permission_error.json';
      case ErrorType.authentication:
        return 'assets/animations/auth_error.json';
      case ErrorType.general:
        return 'assets/animations/general_error.json';
    }
  }
}
