import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:next_gen/widgets/neopop_loading_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AuthController authController;
  late final ThemeController themeController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    themeController = ThemeController.to;

    // Reset sign out loading state when the view is initialized
    authController.resetSignOutLoading();
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () {
                  final userName =
                      authController.user.value?.displayName ?? 'User';
                  return Text(
                    'Welcome, $userName!',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'You have successfully logged in to the Next Gen Job Portal.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomNeoPopButton.primary(
                onTap: () {
                  // TODO(dev): Navigate to job listings
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
                  // TODO(dev): Navigate to resume upload
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
              Obx(() {
                // Use a separate function for the onTap callback
                void handleSignOut() {
                  if (!authController.isSignOutLoading.value) {
                    authController.signOut();
                  }
                }

                return CustomNeoPopButton.flat(
                  onTap: handleSignOut,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: authController.isSignOutLoading.value
                        ? const NeoPopLoadingIndicator(
                            color: AppTheme.coralRed,
                            secondaryColor: Colors.red,
                          )
                        : const Text(
                            'Sign Out',
                            style: TextStyle(
                              color: AppTheme.coralRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
