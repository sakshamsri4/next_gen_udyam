import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:next_gen/widgets/neopop_card.dart';
import 'package:next_gen/widgets/neopop_input_field.dart';
import 'package:next_gen/widgets/neopop_loading_indicator.dart';
import 'package:next_gen/widgets/nextgen_logo.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          // Responsive layout adjustments can be made based on device type
          // Currently using the same layout for all device types

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

                        // Signup Card
                        NeoPopCard(
                          padding: const EdgeInsets.all(24),
                          borderRadius: 20,
                          elevation: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Title
                              Text(
                                'Create Account',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Join us and start your journey',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

                              // Name Field
                              Obx(
                                () => NeoPopInputField(
                                  controller: controller.nameController,
                                  labelText: 'Full Name',
                                  hintText: 'Enter your full name',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  errorText: controller.nameError.value.isEmpty
                                      ? null
                                      : controller.nameError.value,
                                  keyboardType: TextInputType.name,
                                  onChanged: controller.validateName,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Email Field
                              Obx(
                                () => NeoPopInputField(
                                  controller: controller.emailController,
                                  labelText: 'Email',
                                  hintText: 'Enter your email',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  errorText: controller.emailError.value.isEmpty
                                      ? null
                                      : controller.emailError.value,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: controller.validateEmail,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Password Field
                              Obx(
                                () => NeoPopInputField(
                                  controller: controller.passwordController,
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                  ),
                                  errorText:
                                      controller.passwordError.value.isEmpty
                                          ? null
                                          : controller.passwordError.value,
                                  obscureText:
                                      !controller.isPasswordVisible.value,
                                  onChanged: controller.validatePassword,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Confirm Password Field
                              Obx(
                                () => NeoPopInputField(
                                  controller:
                                      controller.confirmPasswordController,
                                  labelText: 'Confirm Password',
                                  hintText: 'Confirm your password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isConfirmPasswordVisible.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: controller
                                        .toggleConfirmPasswordVisibility,
                                  ),
                                  errorText: controller
                                          .confirmPasswordError.value.isEmpty
                                      ? null
                                      : controller.confirmPasswordError.value,
                                  obscureText: !controller
                                      .isConfirmPasswordVisible.value,
                                  onChanged: controller.validateConfirmPassword,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Sign Up Button
                              Obx(
                                () => CustomNeoPopButton.primary(
                                  onTap: controller.isSignupButtonEnabled.value
                                      ? controller.signup
                                      : () {},
                                  enabled:
                                      controller.isSignupButtonEnabled.value,
                                  shimmer: true,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Obx(
                                      () => controller.isLoading.value
                                          ? const NeoPopLoadingIndicator(
                                              color: Colors.white,
                                            )
                                          : const Center(
                                              child: Text(
                                                'CREATE ACCOUNT',
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

                        const SizedBox(height: 32),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDarkMode
                                    ? AppTheme.darkSurface3
                                    : AppTheme.slateGray.withAlpha(100),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? AppTheme.slateGray
                                      : AppTheme.slateGray,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDarkMode
                                    ? AppTheme.darkSurface3
                                    : AppTheme.slateGray.withAlpha(100),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Google Sign Up Button
                        Obx(
                          () => CustomNeoPopButton.flat(
                            onTap: controller.isLoading.value
                                ? () {}
                                : () => controller.signInWithGoogle(),
                            color: isDarkMode
                                ? AppTheme.darkSurface2
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: controller.isLoading.value
                                  ? const NeoPopLoadingIndicator(
                                      color: Colors.red,
                                      secondaryColor: AppTheme.coralRed,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.google,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Sign up with Google',
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? AppTheme.offWhite
                                                : Colors.black87,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Sign In Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppTheme.offWhite
                                    : AppTheme.navyBlue,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed<dynamic>(Routes.login),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? AppTheme.brightElectricBlue
                                      : AppTheme.electricBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
