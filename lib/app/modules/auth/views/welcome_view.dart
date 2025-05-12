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

/// Welcome screen shown after successful signup
class WelcomeView extends GetView<AuthController> {
  /// Creates a welcome view
  const WelcomeView({super.key});

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
                            currentStep: AuthStep.verification,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Animation
                        Lottie.asset(
                          'assets/animations/welcome.json',
                          height: 180,
                          fit: BoxFit.contain,
                          repeat: false,
                          onLoaded: (composition) {
                            // Optional: Add any animation completion logic here
                          },
                        ),
                        const SizedBox(height: 24),

                        // Welcome Text
                        Text(
                          'Welcome, $displayName!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your account has been created successfully. '
                          "Let's set up your profile to get started.",
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Email Verification Notice
                        if (user != null && !user.emailVerified)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  Colors.amber.withAlpha(51), // 0.2 * 255 = 51
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Please verify your email',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "We've sent a verification email to ${user.email}. "
                                  'Please check your inbox and verify your email address.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: () =>
                                      controller.sendEmailVerification(),
                                  icon: const Icon(Icons.refresh),
                                  label:
                                      const Text('Resend verification email'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.amber.shade800,
                                  ),
                                ),
                              ],
                            ),
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
