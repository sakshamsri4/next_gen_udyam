import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:next_gen/widgets/neopop_card.dart';
import 'package:next_gen/widgets/neopop_input_field.dart';
import 'package:next_gen/widgets/neopop_loading_indicator.dart';
import 'package:next_gen/widgets/nextgen_logo.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                        // Logo
                        const Center(
                          child: NextGenLogo(
                            size: 120,
                            showTagline: false,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Forgot Password Card
                        NeoPopCard(
                          padding: const EdgeInsets.all(24),
                          borderRadius: 20,
                          elevation: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Instructions
                              Text(
                                'Forgot your password?',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Enter your email address and we'll send you a link "
                                'to reset your password.',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

                              // Email Field
                              Obx(
                                () => NeoPopInputField(
                                  controller: controller.resetEmailController,
                                  labelText: 'Email',
                                  hintText: 'Enter your email',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  errorText:
                                      controller.resetEmailError.value.isEmpty
                                          ? null
                                          : controller.resetEmailError.value,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: controller.validateResetEmail,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Reset Button
                              Obx(
                                () => CustomNeoPopButton.primary(
                                  onTap: controller.isResetButtonEnabled.value
                                      ? controller.resetPassword
                                      : () {},
                                  enabled:
                                      controller.isResetButtonEnabled.value,
                                  shimmer: true,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Obx(
                                      () => controller.isResetLoading.value
                                          ? const NeoPopLoadingIndicator(
                                              color: Colors.white,
                                            )
                                          : const Center(
                                              child: Text(
                                                'SEND RESET LINK',
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
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Back to Login
                        Center(
                          child: TextButton.icon(
                            onPressed: () => Get.back<dynamic>(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: isDarkMode
                                  ? AppTheme.brightElectricBlue
                                  : AppTheme.electricBlue,
                              size: 18,
                            ),
                            label: Text(
                              'Back to Login',
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppTheme.brightElectricBlue
                                    : AppTheme.electricBlue,
                                fontWeight: FontWeight.bold,
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
