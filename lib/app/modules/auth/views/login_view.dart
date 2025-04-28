import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Logo or App Name
              Text(
                'Next Gen Job Portal',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Email Field
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),

              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 8),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPasswordDialog(context),
                  child: const Text('Forgot Password?'),
                ),
              ),

              const SizedBox(height: 24),

              // Error Message
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

              const SizedBox(height: 24),

              // Login Button
              NeoPopButton(
                color: AppTheme.electricBlue,
                onTapUp: controller.isLoading.value
                    ? null
                    : () => controller.signInWithEmailAndPassword(),
                onTapDown: () => {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // OR Divider
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

              const SizedBox(height: 24),

              // Google Sign In Button
              NeoPopButton(
                color: Colors.white,
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
                      const Icon(
                        Icons.g_mobiledata,
                        size: 24,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sign in with Google',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => Get.to<void>(() => const SignupView()),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
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
              Get.back<void>();
            },
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }
}
