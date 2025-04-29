import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/views/signup_view.dart';
import 'package:next_gen/core/theme/app_theme.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parentColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: constraints.maxHeight * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Text(
                    'Next Gen Job Portal',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.slateGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.slateGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.electricBlue,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.slateGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.slateGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.electricBlue,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showForgotPasswordDialog(context),
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  if (controller.errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red.shade900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  NeoPopButton(
                    color: AppTheme.electricBlue,
                    parentColor: parentColor,
                    depth: 8,
                    onTapUp: controller.isLoading.value
                        ? null
                        : () => controller.signInWithEmailAndPassword(),
                    onTapDown: () => {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  NeoPopButton(
                    color: Colors.white,
                    parentColor: parentColor,
                    depth: 5,
                    border: Border.all(color: Colors.grey.shade300),
                    onTapUp: controller.isLoading.value
                        ? null
                        : () => controller.signInWithGoogle(),
                    onTapDown: () => {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.google,
                            size: 20,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Sign in with Google',
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => Get.to<void>(() => const SignupView()),
                        child: Text(
                          'Sign Up',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.electricBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailForReset = controller.emailController.text;

    Get.dialog<void>(
      AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: emailForReset),
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.slateGray),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.slateGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppTheme.electricBlue, width: 2),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => controller.emailController.text = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              controller.resetPassword();
              Get
                ..back<void>()
                ..snackbar(
                  'Password Reset',
                  'If an account exists for ${controller.emailController.text},'
                      ' a reset link has been sent.',
                  snackPosition: SnackPosition.BOTTOM,
                );
            },
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }
}
