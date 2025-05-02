import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// A widget to display error information with NeoPOP styling
class CustomErrorWidget extends StatelessWidget {
  /// Creates a CustomErrorWidget
  const CustomErrorWidget({
    required this.title,
    required this.message,
    this.animationPath = 'assets/animations/error.json',
    this.onRetry,
    this.errorCode,
    this.canGoBack = true,
    super.key,
  });

  /// The title of the error
  final String title;

  /// The error message
  final String message;

  /// The path to the animation file
  final String animationPath;

  /// Callback when retry button is pressed
  final VoidCallback? onRetry;

  /// Optional error code
  final String? errorCode;

  /// Whether the user can go back from this error
  final bool canGoBack;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Get screen size information
        final isTablet = sizingInformation.isTablet;
        final isMobile = sizingInformation.isMobile;

        final animationSize = isMobile
            ? 200.0
            : isTablet
                ? 250.0
                : 300.0;

        final contentPadding = isMobile
            ? const EdgeInsets.all(16)
            : isTablet
                ? const EdgeInsets.all(24)
                : const EdgeInsets.all(32);

        return Center(
          child: SingleChildScrollView(
            padding: contentPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animation
                Lottie.asset(
                  animationPath,
                  width: animationSize,
                  height: animationSize,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.errorColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Message
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                if (errorCode != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Error Code: $errorCode',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (canGoBack)
                      NeoPopButton(
                        color: Colors.grey.shade800,
                        onTapUp: () => Get.back<dynamic>(),
                        border: Border.all(
                          color: Colors.grey.shade600,
                          // Default width is 1
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            'Go Back',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    if (canGoBack && onRetry != null) const SizedBox(width: 16),
                    if (onRetry != null)
                      NeoPopButton(
                        color: AppTheme.primaryColor,
                        onTapUp: onRetry,
                        border: Border.all(
                          color: AppTheme.primaryColorDark,
                          // Default width is 1
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            'Retry',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
