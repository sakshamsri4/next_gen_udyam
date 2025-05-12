import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/auth/widgets/auth_progress_indicator.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Verification success screen shown after email verification
class VerificationSuccessView extends GetView<AuthController> {
  /// Creates a verification success view
  const VerificationSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final user = controller.user.value;
    final displayName = user?.displayName?.split(' ').first ?? 'there';

    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        AppTheme.deepNavy,
                        AppTheme.navyBlue,
                        AppTheme.darkSurface1,
                      ]
                    : [
                        AppTheme.lightGray,
                        Colors.white,
                        AppTheme.lightGray,
                      ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Progress indicator
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: AuthProgressIndicator(
                            currentStep: AuthStep.roleSelection,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Animation
                        Lottie.asset(
                          'assets/animations/verification_success.json',
                          height: 180,
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                        const SizedBox(height: 24),

                        // Success Text
                        Text(
                          'Email Verified!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Thank you, $displayName! Your email has been successfully verified. '
                          'You now have full access to all features of the app.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Continue Button
                        CustomNeoPopButton.primary(
                          onTap: () async {
                            // Get user model to check if role is selected
                            final authService = Get.find<AuthService>();
                            final userModel =
                                await authService.getUserFromFirebase();

                            // If user has not selected a role, go to role selection
                            if (userModel?.userType == null) {
                              await Get.offAllNamed<dynamic>(
                                Routes.roleSelection,
                              );
                            } else {
                              // Otherwise go to dashboard
                              await Get.offAllNamed<dynamic>(Routes.dashboard);
                            }
                          },
                          shimmer: true,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'CONTINUE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
