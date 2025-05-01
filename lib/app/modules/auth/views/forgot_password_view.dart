import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/widgets/neopop_button.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Instructions
                      Text(
                        'Forgot your password?',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter your email address and we\'ll send you a link to reset your password.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Email Field
                      Obx(() => TextField(
                            controller: controller.resetEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              errorText:
                                  controller.resetEmailError.value.isEmpty
                                      ? null
                                      : controller.resetEmailError.value,
                            ),
                            onChanged: controller.validateResetEmail,
                          )),

                      const SizedBox(height: 32),

                      // Reset Button
                      Obx(() => CustomNeoPopButton.primary(
                            onTap: controller.isResetButtonEnabled.value
                                ? controller.resetPassword
                                : () {},
                            enabled: controller.isResetButtonEnabled.value,
                            child: Obx(
                              () => controller.isResetLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Send Reset Link',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          )),

                      const SizedBox(height: 16),

                      // Back to Login
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Back to Login'),
                      ),
                    ],
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
