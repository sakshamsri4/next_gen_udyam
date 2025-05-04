import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/bottom_navigation_bar.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// View for the Resume module
class ResumeView extends StatefulWidget {
  /// Constructor
  const ResumeView({super.key});

  @override
  State<ResumeView> createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  late final NavigationController navigationController;

  @override
  void initState() {
    super.initState();

    // Get or register NavigationController
    if (Get.isRegistered<NavigationController>()) {
      navigationController = Get.find<NavigationController>();
    } else {
      navigationController = Get.put(NavigationController(), permanent: true);
    }

    // Set the selected index to the Resume tab (index 2)
    navigationController.selectedIndex.value = 2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resume'),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: const CustomAnimatedBottomNavBar(),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          // Determine if we're on a mobile device
          final isMobile =
              sizingInformation.deviceScreenType == DeviceScreenType.mobile;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Resume icon
                  Icon(
                    FontAwesomeIcons.fileLines,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Resume Management',
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Upload and manage your resume to apply for automotive jobs.',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Upload button
                  CustomNeoPopButton.primary(
                    onTap: () {
                      Get.snackbar(
                        'Coming Soon',
                        'Resume upload feature is under development.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppTheme.electricBlue,
                        colorText: Colors.white,
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text(
                        'Upload Resume',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // View resumes button
                  CustomNeoPopButton.secondary(
                    onTap: () {
                      Get.snackbar(
                        'Coming Soon',
                        'Resume management feature is under development.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppTheme.lavender,
                        colorText: Colors.white,
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text(
                        'View My Resumes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
