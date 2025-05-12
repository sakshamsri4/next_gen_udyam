import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/avatars/custom_avatar.dart';

/// A custom drawer menu with CRED-style design
class CustomDrawer extends StatefulWidget {
  /// Creates a new CustomDrawer
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Controllers
  late final AuthController _authController;
  late final NavigationController _navigationController;
  late final LoggerService? _logger;

  @override
  void initState() {
    super.initState();
    try {
      // Initialize controllers
      _authController = Get.find<AuthController>();
      _navigationController = Get.find<NavigationController>();

      // Try to get logger service
      try {
        _logger = Get.find<LoggerService>();
      } catch (e) {
        debugPrint('LoggerService not available: $e');
        _logger = null;
      }

      _logger?.d('CustomDrawer initialized successfully');
    } catch (e) {
      // Handle initialization errors
      debugPrint('Error initializing CustomDrawer: $e');

      // Try to log the error if LoggerService is available
      try {
        Get.find<LoggerService>().e('Error initializing CustomDrawer', e);
      } catch (_) {
        // Silently ignore if LoggerService is not available
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor:
          isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
      elevation: 0,
      child: SafeArea(
        child: Column(
          children: [
            // Header with user info
            Obx(() => _buildHeader(context)),

            const Divider(),

            // Navigation items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Show different navigation items based on user role
                  // Using Obx for reactive UI updates
                  Obx(() => _buildNavigationItems(context)),

                  const Divider(),

                  // Additional menu items
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.gear,
                    title: 'Settings',
                    onTap: () => _navigateAndClose(Routes.settings),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.circleQuestion,
                    title: 'Help & Support',
                    onTap: () => _navigateAndClose(Routes.support),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.circleInfo,
                    title: 'About',
                    onTap: () => _navigateAndClose(Routes.about),
                  ),
                ],
              ),
            ),

            // Logout button at the bottom - using Obx for reactive UI updates
            Obx(
              () => _authController.isLoggedIn
                  ? _buildLogoutButton(context)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // Build the header section with user info
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    // Get the current user directly from the controller
    final currentUser = _authController.user.value;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const HeroIcon(HeroIcons.xMark),
              onPressed: () => Get.back<void>(),
            ),
          ),

          // User avatar - using controller value directly
          if (currentUser != null)
            CustomAvatar(
              imageUrl: currentUser.photoURL ?? '',
              height: 80,
              width: 80,
            )
          else
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primary.withAlpha(26),
              child: HeroIcon(
                HeroIcons.user,
                color: theme.colorScheme.primary,
                size: 40,
              ),
            ),

          const SizedBox(height: 16),

          // User name - using controller value directly
          if (currentUser != null)
            Text(
              currentUser.displayName ?? 'User',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
          else
            TextButton.icon(
              onPressed: () => Get.toNamed<dynamic>(Routes.login),
              icon: const HeroIcon(HeroIcons.arrowRightOnRectangle),
              label: const Text('Sign In'),
            ),

          // User email - using controller value directly
          if (currentUser != null)
            Text(
              currentUser.email ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(179),
              ),
            ),
        ],
      ),
    );
  }

  // Build navigation items based on user role
  Widget _buildNavigationItems(BuildContext context) {
    // Get values directly from controllers
    final userRole = _navigationController.userRole.value;
    final selectedIndex = _navigationController.selectedIndex.value;

    if (userRole == UserType.employer) {
      // Employer navigation items
      return Column(
        children: [
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.house,
            title: 'Dashboard',
            onTap: () {
              _navigationController.changeIndex(0);
              Get.back<void>();
            },
            isSelected: selectedIndex == 0,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.briefcase,
            title: 'Manage Jobs',
            onTap: () {
              _navigationController.changeIndex(1);
              Get.back<void>();
            },
            isSelected: selectedIndex == 1,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.users,
            title: 'Applicants',
            onTap: () {
              _navigationController.changeIndex(2);
              Get.back<void>();
            },
            isSelected: selectedIndex == 2,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.buildingUser,
            title: 'Company Profile',
            onTap: () {
              _navigationController.changeIndex(3);
              Get.back<void>();
            },
            isSelected: selectedIndex == 3,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.user,
            title: 'Profile',
            onTap: () {
              _navigationController.changeIndex(4);
              Get.back<void>();
            },
            isSelected: selectedIndex == 4,
          ),
          const Divider(),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.chartBar,
            title: 'Analytics',
            onTap: () => _navigateAndClose(Routes.employerAnalytics),
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.calendarCheck,
            title: 'Interviews',
            onTap: () => _navigateAndClose(Routes.interviewManagement),
          ),
        ],
      );
    } else if (userRole == UserType.admin) {
      // Admin navigation items
      return Column(
        children: [
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.house,
            title: 'Dashboard',
            onTap: () {
              _navigationController.changeIndex(0);
              Get.back<void>();
            },
            isSelected: selectedIndex == 0,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.briefcase,
            title: 'Manage Jobs',
            onTap: () {
              _navigationController.changeIndex(1);
              Get.back<void>();
            },
            isSelected: selectedIndex == 1,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.users,
            title: 'Manage Users',
            onTap: () {
              _navigationController.changeIndex(2);
              Get.back<void>();
            },
            isSelected: selectedIndex == 2,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.gear,
            title: 'System Settings',
            onTap: () {
              _navigationController.changeIndex(3);
              Get.back<void>();
            },
            isSelected: selectedIndex == 3,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.user,
            title: 'Profile',
            onTap: () {
              _navigationController.changeIndex(4);
              Get.back<void>();
            },
            isSelected: selectedIndex == 4,
          ),
        ],
      );
    } else {
      // Employee navigation items (default)
      return Column(
        children: [
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.house,
            title: 'Home',
            onTap: () {
              _navigationController.changeIndex(0);
              Get.back<void>();
            },
            isSelected: selectedIndex == 0,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.magnifyingGlass,
            title: 'Search',
            onTap: () {
              _navigationController.changeIndex(1);
              Get.back<void>();
            },
            isSelected: selectedIndex == 1,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.bookmark,
            title: 'Saved Jobs',
            onTap: () {
              _navigationController.changeIndex(2);
              Get.back<void>();
            },
            isSelected: selectedIndex == 2,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.fileCircleCheck,
            title: 'My Applications',
            onTap: () {
              _navigationController.changeIndex(3);
              Get.back<void>();
            },
            isSelected: selectedIndex == 3,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.user,
            title: 'Profile',
            onTap: () {
              _navigationController.changeIndex(4);
              Get.back<void>();
            },
            isSelected: selectedIndex == 4,
          ),
        ],
      );
    }
  }

  // Build a navigation item
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withAlpha(179),
        size: 20,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withAlpha(26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
    );
  }

  // Helper method to navigate to a route and close the drawer
  void _navigateAndClose(String route) {
    // Using a separate function instead of cascade notation
    // because Get.toNamed can return null and cascade would cause issues
    final result = Get.toNamed<dynamic>(route);
    // Only close drawer if navigation was successful
    if (result != null) {
      Get.back<void>();
    } else {
      Get.back<void>();
    }
  }

  // Build the logout button
  Widget _buildLogoutButton(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.rightFromBracket,
          color: theme.colorScheme.error,
          size: 20,
        ),
        title: Text(
          'Logout',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async {
          Get.back<void>();
          await _authController.signOut();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.error.withAlpha(77),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
    );
  }
}
