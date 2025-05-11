import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A bottom navigation bar that adapts to the user's role
class RoleBasedBottomNav extends StatefulWidget {
  /// Creates a role-based bottom navigation bar
  const RoleBasedBottomNav({super.key});

  @override
  State<RoleBasedBottomNav> createState() => _RoleBasedBottomNavState();
}

class _RoleBasedBottomNavState extends State<RoleBasedBottomNav> {
  late final NavigationController _navigationController;

  // Store the values locally to avoid accessing .value in build method
  int _selectedIndex = 0;
  UserType? _userRole;

  @override
  void initState() {
    super.initState();
    try {
      _navigationController = Get.find<NavigationController>();

      // Initialize local values
      _selectedIndex = _navigationController.selectedIndex.value;
      _userRole = _navigationController.userRole.value;

      // Set up listeners to update local values when the observable changes
      ever(_navigationController.selectedIndex, (value) {
        if (mounted) {
          setState(() {
            _selectedIndex = value;
          });
        }
      });

      ever(_navigationController.userRole, (value) {
        if (mounted) {
          setState(() {
            _userRole = value;
          });
        }
      });
    } catch (e) {
      // Handle initialization errors
      debugPrint('Error initializing RoleBasedBottomNav: $e');

      // Try to log the error if LoggerService is available
      try {
        Get.find<LoggerService>().e('Error initializing RoleBasedBottomNav', e);
      } catch (_) {
        // Silently ignore if LoggerService is not available
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define navigation items based on user role
    final List<_NavItem> items;
    if (_userRole == UserType.employer) {
      items = _employerNavItems;
    } else if (_userRole == UserType.admin) {
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    _NavItem item,
    int index,
  ) {
    final theme = Theme.of(context);
    final isSelected = index == _selectedIndex;

    return InkWell(
      onTap: () => _navigationController.changeIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha(26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroIcon(
              item.icon,
              color: isSelected
                  ? theme.colorScheme.primary
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
                    ? theme.colorScheme.primary
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
