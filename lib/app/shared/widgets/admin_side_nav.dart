import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A side navigation drawer specifically designed for admin users
///
/// This widget uses a pure reactive approach with GetX to avoid state management issues.
/// It observes the NavigationController's selectedIndex and rebuilds only when that value changes.
/// The color scheme is indigo-themed to visually indicate the admin role.
class AdminSideNav extends StatelessWidget {
  /// Creates an admin-specific side navigation drawer
  const AdminSideNav({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define the admin-specific colors
    const primaryColor = Color(0xFF4F46E5); // Indigo primary color
    const primaryLightColor =
        Color(0xFFA5B4FC); // Light indigo for inactive items
    final backgroundColor = theme.brightness == Brightness.dark
        ? const Color(0xFF111827) // Dark cool gray for dark mode
        : Colors.white;
    const headerColor = primaryColor;

    // Get the navigation controller
    late final NavigationController navigationController;
    try {
      navigationController = Get.find<NavigationController>();
    } catch (e) {
      // Handle the case where NavigationController is not found
      debugPrint('Error finding NavigationController: $e');

      // Try to log the error if LoggerService is available
      try {
        Get.find<LoggerService>().e('Error finding NavigationController', e);
      } catch (_) {
        // Silently ignore if LoggerService is not available
      }

      // Return an empty container if we can't find the controller
      return const SizedBox.shrink();
    }

    // Get the auth controller for user info
    AuthController? authController;
    try {
      authController = Get.find<AuthController>();
    } catch (e) {
      // Handle the case where AuthController is not found
      debugPrint('Error finding AuthController: $e');
    }

    // Use Obx to observe the selectedIndex
    return Obx(() {
      // Get the current selected index from the controller
      final selectedIndex = navigationController.selectedIndex.value;

      return Drawer(
        backgroundColor: backgroundColor,
        elevation: 2,
        child: Column(
          children: [
            // Admin header with user info if available
            _buildHeader(context, authController, headerColor),

            // Navigation items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildNavItem(
                    context,
                    icon: HeroIcons.home,
                    label: 'Dashboard',
                    index: 0,
                    isSelected: selectedIndex == 0,
                    navigationController: navigationController,
                    primaryColor: primaryColor,
                    primaryLightColor: primaryLightColor,
                  ),
                  _buildNavItem(
                    context,
                    icon: HeroIcons.users,
                    label: 'User Management',
                    index: 1,
                    isSelected: selectedIndex == 1,
                    navigationController: navigationController,
                    primaryColor: primaryColor,
                    primaryLightColor: primaryLightColor,
                  ),
                  _buildNavItem(
                    context,
                    icon: HeroIcons.shieldCheck,
                    label: 'Content Moderation',
                    index: 2,
                    isSelected: selectedIndex == 2,
                    navigationController: navigationController,
                    primaryColor: primaryColor,
                    primaryLightColor: primaryLightColor,
                  ),
                  _buildNavItem(
                    context,
                    icon: HeroIcons.cog6Tooth,
                    label: 'System Config',
                    index: 3,
                    isSelected: selectedIndex == 3,
                    navigationController: navigationController,
                    primaryColor: primaryColor,
                    primaryLightColor: primaryLightColor,
                  ),
                  _buildNavItem(
                    context,
                    icon: HeroIcons.user,
                    label: 'Profile',
                    index: 4,
                    isSelected: selectedIndex == 4,
                    navigationController: navigationController,
                    primaryColor: primaryColor,
                    primaryLightColor: primaryLightColor,
                  ),

                  // Divider before logout
                  const Divider(height: 32, thickness: 1),

                  // Logout option
                  if (authController != null)
                    _buildLogoutItem(
                      context,
                      authController: authController,
                      primaryColor: primaryColor,
                    ),
                ],
              ),
            ),

            // Admin badge at the bottom
            _buildAdminBadge(context, primaryColor),
          ],
        ),
      );
    });
  }

  /// Build the header with user info
  Widget _buildHeader(
    BuildContext context,
    AuthController? authController,
    Color headerColor,
  ) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: headerColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              // App logo or icon
              Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 12),
              Text(
                'Admin Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // User info if available
          if (authController != null)
            Obx(() {
              final user = authController.user.value;
              if (user != null) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withAlpha(51),
                      child: Text(
                        user.displayName?.isNotEmpty ?? false
                            ? user.displayName![0].toUpperCase()
                            : 'A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.displayName ?? 'Admin User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user.email ?? '',
                            style: TextStyle(
                              color: Colors.white.withAlpha(204),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        ],
      ),
    );
  }

  /// Build a navigation item
  Widget _buildNavItem(
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required int index,
    required bool isSelected,
    required NavigationController navigationController,
    required Color primaryColor,
    required Color primaryLightColor,
  }) {
    return ListTile(
      leading: HeroIcon(
        icon,
        color: isSelected ? primaryColor : primaryLightColor,
        size: 24,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primaryColor : primaryLightColor,
        ),
      ),
      selected: isSelected,
      selectedTileColor: primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        navigationController.changeIndex(index);
        // Close the drawer if on mobile
        if (Get.width < 1200) {
          Get.back<void>();
        }
      },
    );
  }

  /// Build the logout item
  Widget _buildLogoutItem(
    BuildContext context, {
    required AuthController? authController,
    required Color primaryColor,
  }) {
    return ListTile(
      leading: HeroIcon(
        HeroIcons.arrowRightOnRectangle,
        color: primaryColor.withAlpha(204),
        size: 24,
      ),
      title: Text(
        'Logout',
        style: TextStyle(
          color: primaryColor.withAlpha(204),
        ),
      ),
      onTap: () async {
        // Show confirmation dialog
        final confirm = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Get.back<bool>(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back<bool>(result: true),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        );

        if ((confirm ?? false) && authController != null) {
          await authController.signOut();
        }
      },
    );
  }

  /// Build the admin badge at the bottom
  Widget _buildAdminBadge(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user,
            size: 16,
            color: primaryColor.withAlpha(153),
          ),
          const SizedBox(width: 4),
          Text(
            'Admin Access',
            style: TextStyle(
              fontSize: 12,
              color: primaryColor.withAlpha(153),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
