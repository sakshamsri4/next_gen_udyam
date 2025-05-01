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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();

    // Reset all loading states when the login view is initialized
    controller.resetAllLoadingStates();
  }

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
                          child: NextGenLogo(),
                        ),
                        const SizedBox(height: 40),

                        // Login Card
                        NeoPopCard(
                          padding: const EdgeInsets.all(24),
                          borderRadius: 20,
                          elevation: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Title
                              Text(
                                'Welcome Back',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to continue your journey',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

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

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Get.toNamed<dynamic>(
                                    Routes.forgotPassword,
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? AppTheme.brightElectricBlue
                                          : AppTheme.electricBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Login Button
                              Obx(
                                () => CustomNeoPopButton.primary(
                                  onTap: controller.isLoginButtonEnabled.value
                                      ? controller.login
                                      : () {},
                                  enabled:
                                      controller.isLoginButtonEnabled.value,
                                  depth: 10,
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
                                                'SIGN IN',
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

                        // Google Sign In Button
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
                                          'Sign in with Google',
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

                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppTheme.offWhite
                                    : AppTheme.navyBlue,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed<dynamic>(Routes.signup),
                              child: Text(
                                'Sign Up',
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
