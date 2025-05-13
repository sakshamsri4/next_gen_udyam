import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/views/widgets/edit_profile_dialog.dart';
import 'package:next_gen/app/modules/auth/views/widgets/profile_completion_indicator.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/mixins/keep_alive_mixin.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Profile view for displaying and editing user profile information
///
/// This view uses GetViewKeepAliveMixin to preserve state when switching tabs.
class ProfileView extends GetView<AuthController>
    with GetViewKeepAliveMixin<AuthController> {
  /// Creates a profile view
  ProfileView({super.key});

  // Get the navigation controller
  late final NavigationController navigationController;

  // Logger for debugging
  late final LoggerService _logger;

  // Initialize logger
  void _initLogger() {
    try {
      _logger = Get.find<LoggerService>();
    } catch (e) {
      debugPrint('Error finding LoggerService: $e');
      _logger = LoggerService();
      Get.put(_logger, permanent: true);
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    // Initialize logger
    _initLogger();
    _logger.i('ProfileView: Building profile view');

    // Initialize the navigation controller
    try {
      if (!Get.isRegistered<NavigationController>()) {
        _logger.d(
          'ProfileView: NavigationController not registered, registering now',
        );
        navigationController = Get.put(NavigationController(), permanent: true);
      } else {
        _logger.d('ProfileView: Found existing NavigationController');
        navigationController = Get.find<NavigationController>();
      }
    } catch (e) {
      _logger.e('ProfileView: Error initializing NavigationController', e);
      // Create a fallback controller
      navigationController = NavigationController();
      Get.put(navigationController, permanent: true);
    }

    // Ensure the navigation index is set correctly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logger.d(
        'ProfileView: Updating navigation index for route ${Routes.profile}',
      );
      navigationController.updateIndexFromRoute(Routes.profile);
    });

    // Check if AuthController is properly initialized
    _logger
      ..d(
        'ProfileView: AuthController loading state: ${controller.isLoading.value}',
      )
      ..d(
        'ProfileView: AuthController user: ${controller.user.value?.uid ?? 'null'}',
      );

    // Ensure the user data is loaded
    if (controller.isLoading.value) {
      _logger.i('ProfileView: AuthController is loading, refreshing user data');
      controller.refreshUser();
    }

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
      bottomNavigationBar: const UnifiedBottomNav(),
      body: Obx(() {
        _logger.d(
          'ProfileView: Rendering body, isLoading: ${controller.isLoading.value}',
        );

        if (controller.isLoading.value) {
          _logger.i('ProfileView: Showing loading indicator');
          // Add a timeout to force refresh if loading takes too long
          Future.delayed(const Duration(seconds: 5), () {
            if (controller.isLoading.value) {
              _logger.w('ProfileView: Loading timeout, forcing refresh');
              controller.refreshUser();
            }
          });
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;
        _logger.d('ProfileView: User value: ${user?.uid ?? 'null'}');

        if (user == null) {
          _logger.w('ProfileView: User is null, showing error message');
          // Try to recover by refreshing the user
          Future.delayed(const Duration(seconds: 1), () {
            _logger.i('ProfileView: Attempting to recover by refreshing user');
            controller.refreshUser();
          });
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

              // Profile Completion Indicator
              const ProfileCompletionIndicator(),

              const SizedBox(height: 24),

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

  /// Show logout confirmation dialog
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
