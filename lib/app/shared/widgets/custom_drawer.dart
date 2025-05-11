import 'package:firebase_auth/firebase_auth.dart';
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
  late final AuthController _authController;
  late final NavigationController _navigationController;

  // Store the values locally to avoid accessing .value in build method
  UserType? _userRole;
  int _selectedIndex = 0;
  User? _user;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    try {
      // Initialize controllers
      _authController = Get.find<AuthController>();
      _navigationController = Get.find<NavigationController>();

      // Initialize local values
      _userRole = _navigationController.userRole.value;
      _selectedIndex = _navigationController.selectedIndex.value;
      _user = _authController.user.value;
      _isLoggedIn = _authController.isLoggedIn;

      // Set up listeners to update local values when the observables change
      ever(_navigationController.userRole, (value) {
        if (mounted) {
          setState(() {
            _userRole = value;
          });
        }
      });

      ever(_navigationController.selectedIndex, (value) {
        if (mounted) {
          setState(() {
            _selectedIndex = value;
          });
        }
      });

      ever(_authController.user, (value) {
        if (mounted) {
          setState(() {
            _user = value;
            _isLoggedIn = value != null;
          });
        }
      });
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
            _buildHeader(context),

            const Divider(),

            // Navigation items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Show different navigation items based on user role
                  // Using local state variable _userRole instead of accessing .value directly
                  _buildNavigationItems(context),

                  const Divider(),

                  // Additional menu items
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.gear,
                    title: 'Settings',
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.settings);
                      Get.back<void>();
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.circleQuestion,
                    title: 'Help & Support',
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.support);
                      Get.back<void>();
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.circleInfo,
                    title: 'About',
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.about);
                      Get.back<void>();
                    },
                  ),
                ],
              ),
            ),

            // Logout button at the bottom - using local state variable _isLoggedIn
            if (_isLoggedIn) _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  // Build the header section with user info
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

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

          // User avatar - using local state variable _user
          if (_user != null)
            CustomAvatar(
              imageUrl: _user?.photoURL ?? '',
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

          // User name - using local state variable _user
          if (_user != null)
            Text(
              _user?.displayName ?? 'User',
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

          // User email - using local state variable _user
          if (_user != null)
            Text(
              _user?.email ?? '',
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
    // Using local state variable _userRole instead of accessing .value directly
    if (_userRole == UserType.employer) {
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
            isSelected: _selectedIndex == 0,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.briefcase,
            title: 'Manage Jobs',
            onTap: () {
              _navigationController.changeIndex(1);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 1,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.users,
            title: 'Applicants',
            onTap: () {
              _navigationController.changeIndex(2);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 2,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.buildingUser,
            title: 'Company Profile',
            onTap: () {
              _navigationController.changeIndex(3);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 3,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.user,
            title: 'Profile',
            onTap: () {
              _navigationController.changeIndex(4);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 4,
          ),
        ],
      );
    } else if (_userRole == UserType.admin) {
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
            isSelected: _selectedIndex == 0,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.briefcase,
            title: 'Manage Jobs',
            onTap: () {
              _navigationController.changeIndex(1);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 1,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.users,
            title: 'Manage Users',
            onTap: () {
              _navigationController.changeIndex(2);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 2,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.gear,
            title: 'System Settings',
            onTap: () {
              _navigationController.changeIndex(3);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 3,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.user,
            title: 'Profile',
            onTap: () {
              _navigationController.changeIndex(4);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 4,
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
            isSelected: _selectedIndex == 0,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.magnifyingGlass,
            title: 'Search',
            onTap: () {
              _navigationController.changeIndex(1);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 1,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.bookmark,
            title: 'Saved Jobs',
            onTap: () {
              _navigationController.changeIndex(2);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 2,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.fileCircleCheck,
            title: 'My Applications',
            onTap: () {
              _navigationController.changeIndex(3);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 3,
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.user,
            title: 'Profile',
            onTap: () {
              _navigationController.changeIndex(4);
              Get.back<void>();
            },
            isSelected: _selectedIndex == 4,
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
