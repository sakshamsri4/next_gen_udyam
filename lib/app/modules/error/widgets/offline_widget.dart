import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/core/services/connectivity_service.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// A widget to display when the app is offline
class OfflineWidget extends StatelessWidget {
  /// Creates an OfflineWidget
  const OfflineWidget({
    this.title = 'No Internet Connection',
    this.message = 'Please check your internet connection and try again.',
    this.animationPath = 'assets/animations/no_internet.json',
    this.onRetry,
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

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

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
                const SizedBox(height: 32),

                // Retry button
                NeoPopButton(
                  color: AppTheme.primaryColor,
                  onTapUp: () {
                    if (onRetry != null) {
                      onRetry!();
                    } else {
                      connectivityService.checkConnection();
                    }
                  },
                  border: Border.all(
                    color: AppTheme.primaryColorDark,
                    // Default width is 1
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      'Retry',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
