import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/views/widgets/edit_profile_dialog.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_bottom_nav.dart';
import 'package:next_gen/core/theme/app_theme.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final AuthController controller;
  late final NavigationController navigationController;

  @override
  void initState() {
    super.initState();
    // Get the controllers
    controller = Get.find<AuthController>();

    // Get or register NavigationController
    if (Get.isRegistered<NavigationController>()) {
      navigationController = Get.find<NavigationController>();
    } else {
      navigationController = Get.put(NavigationController(), permanent: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update the navigation index after dependencies are resolved
    // This is safer than using initState with a post-frame callback
    navigationController.selectedIndex.value = 4;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      bottomNavigationBar: const RoleBasedBottomNav(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;

        if (user == null) {
          return const Center(
            child: Text('User not found. Please login again.'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey.shade800,
                      )
                    : null,
              ),

              const SizedBox(height: 24),

              // User Name
              Text(
                user.displayName ?? 'User',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // User Email
              Text(
                user.email ?? 'No email available',
                style: theme.textTheme.bodyLarge,
              ),

              const SizedBox(height: 40),

              // Profile Info Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Email Verification Status
                      ListTile(
                        leading: Icon(
                          user.emailVerified
                              ? Icons.verified_user
                              : Icons.warning,
                          color:
                              user.emailVerified ? Colors.green : Colors.orange,
                        ),
                        title: const Text('Email Verification'),
                        subtitle: Text(
                          user.emailVerified
                              ? 'Verified'
                              : 'Not verified - Please check your email',
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),

                      // Account Created Date
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Account Created'),
                        subtitle: Text(
                          user.metadata.creationTime != null
                              ? '${user.metadata.creationTime!.day}/${user.metadata.creationTime!.month}/${user.metadata.creationTime!.year}'
                              : 'Date not available',
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Edit Profile Button
              NeoPopButton(
                color: AppTheme.electricBlue,
                onTapUp: () {
                  // Show edit profile dialog
                  Get.dialog<void>(
                    EditProfileDialog(user: user),
                    barrierDismissible: false,
                  );
                },
                onTapDown: () => {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      'EDIT PROFILE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Enhanced Profile Button
              NeoPopButton(
                color: const Color.fromARGB(204, 0, 122, 255), // 80% opacity
                onTapUp: () {
                  // Navigate to customer profile
                  Get.toNamed<dynamic>(Routes.customerProfile);
                },
                onTapDown: () => {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      'ENHANCED PROFILE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Company Profile Button
              NeoPopButton(
                color: const Color.fromARGB(153, 0, 122, 255), // 60% opacity
                onTapUp: () {
                  // Navigate to company profile
                  Get.toNamed<dynamic>(Routes.companyProfile);
                },
                onTapDown: () => {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      'COMPANY PROFILE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              controller.signOut();
              Get.back<void>();
            },
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}
