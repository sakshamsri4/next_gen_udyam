import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A bottom navigation bar that adapts to the user's role
///
/// This widget uses a pure reactive approach with GetX to avoid state management issues.
/// It observes the NavigationController's selectedIndex and userRole values and
/// rebuilds only when those values change.
class RoleBasedBottomNav extends StatelessWidget {
  /// Creates a role-based bottom navigation bar
  const RoleBasedBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

    // Use a single Obx to observe both selectedIndex and userRole
    return Obx(() {
      // Get the current values from the controller
      final selectedIndex = navigationController.selectedIndex.value;
      final currentRole = navigationController.userRole.value;

      // Define navigation items based on user role
      final List<_NavItem> items;
      if (currentRole == UserType.employer) {
        items = _employerNavItems;
      } else if (currentRole == UserType.admin) {
        items = _adminNavItems;
      } else {
        items = _employeeNavItems;
      }

      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                items.length,
                (index) => _buildNavItem(
                  context,
                  items[index],
                  index,
                  index == selectedIndex,
                  navigationController,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Build a navigation item
  ///
  /// This method is static and pure - it doesn't depend on any instance variables
  /// and doesn't use Obx, making it more efficient and less prone to rebuild issues.
  Widget _buildNavItem(
    BuildContext context,
    _NavItem item,
    int index,
    bool isSelected,
    NavigationController navigationController,
  ) {
    final theme = Theme.of(context);
    final currentRole = navigationController.userRole.value;

    // Get role-specific color
    Color primaryColor;
    if (currentRole == UserType.employee) {
      primaryColor = RoleThemes.employeePrimary;
    } else if (currentRole == UserType.employer) {
      primaryColor = RoleThemes.employerPrimary;
    } else if (currentRole == UserType.admin) {
      primaryColor = RoleThemes.adminPrimary;
    } else {
      primaryColor = theme.colorScheme.primary;
    }

    return InkWell(
      onTap: () => navigationController.changeIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroIcon(
              item.icon,
              color: isSelected
                  ? primaryColor
                  : theme.colorScheme.onSurface.withAlpha(179),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? primaryColor
                    : theme.colorScheme.onSurface.withAlpha(179),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation item model for the bottom nav
class _NavItem {
  /// Creates a navigation item
  const _NavItem({
    required this.icon,
    required this.label,
  });

  /// Icon for the navigation item
  final HeroIcons icon;

  /// Label for the navigation item
  final String label;
}

/// Navigation items for employee
const List<_NavItem> _employeeNavItems = [
  _NavItem(icon: HeroIcons.home, label: 'Home'),
  _NavItem(icon: HeroIcons.magnifyingGlass, label: 'Search'),
  _NavItem(icon: HeroIcons.bookmark, label: 'Saved'),
  _NavItem(icon: HeroIcons.documentText, label: 'Resume'),
  _NavItem(icon: HeroIcons.user, label: 'Profile'),
];

/// Navigation items for employer
const List<_NavItem> _employerNavItems = [
  _NavItem(icon: HeroIcons.home, label: 'Dashboard'),
  _NavItem(icon: HeroIcons.briefcase, label: 'Jobs'),
  _NavItem(icon: HeroIcons.users, label: 'Applicants'),
  _NavItem(icon: HeroIcons.buildingOffice2, label: 'Company'),
  _NavItem(icon: HeroIcons.user, label: 'Profile'),
];

/// Navigation items for admin
const List<_NavItem> _adminNavItems = [
  _NavItem(icon: HeroIcons.home, label: 'Dashboard'),
  _NavItem(icon: HeroIcons.briefcase, label: 'Jobs'),
  _NavItem(icon: HeroIcons.users, label: 'Users'),
  _NavItem(icon: HeroIcons.cog6Tooth, label: 'Settings'),
  _NavItem(icon: HeroIcons.user, label: 'Profile'),
];
