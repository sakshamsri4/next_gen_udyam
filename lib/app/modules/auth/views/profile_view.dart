import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/core/theme/app_theme.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null
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
                user.email,
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
                  padding: const EdgeInsets.all(16.0),
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
                          '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
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
                color: AppTheme.primaryColor,
                onTapUp: () {
                  // TODO: Implement edit profile functionality
                  Get.snackbar(
                    'Coming Soon',
                    'Edit profile functionality will be available soon!',
                    snackPosition: SnackPosition.BOTTOM,
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
            ],
          ),
        );
      }),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    Get.dialog(
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
