import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
import 'package:next_gen/widgets/neopop_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final themeController = ThemeController.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Gen Job Portal'),
        actions: [
          IconButton(
            icon: Obx(
              () => Icon(
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    'Welcome, ${authController.user.value?.displayName ?? 'User'}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 16),
              Text(
                'You have successfully logged in to the Next Gen Job Portal.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomNeoPopButton.primary(
                onTap: () {
                  // TODO: Navigate to job listings
                  Get.snackbar(
                    'Coming Soon',
                    'Job listings feature is under development.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppTheme.electricBlue,
                    colorText: Colors.white,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'Browse Jobs',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomNeoPopButton.secondary(
                onTap: () {
                  // TODO: Navigate to resume upload
                  Get.snackbar(
                    'Coming Soon',
                    'Resume upload feature is under development.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppTheme.lavender,
                    colorText: Colors.white,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'Upload Resume',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomNeoPopButton.flat(
                onTap: authController.signOut,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: AppTheme.coralRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
