import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';

/// A bottom navigation bar that adapts to the user's role
class RoleBasedBottomNav extends StatelessWidget {
  /// Creates a role-based bottom navigation bar
  const RoleBasedBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationController = Get.find<NavigationController>();

    return Obx(() {
      final selectedIndex = navigationController.selectedIndex.value;
      final userRole = navigationController.userRole.value;

      // Define navigation items based on user role
      final items =
          userRole == UserType.employer ? _employerNavItems : _employeeNavItems;

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
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                items.length,
                (index) => _buildNavItem(
                  context,
                  items[index],
                  index,
                  selectedIndex,
                  navigationController,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(
    BuildContext context,
    _NavItem item,
    int index,
    int selectedIndex,
    NavigationController controller,
  ) {
    final theme = Theme.of(context);
    final isSelected = index == selectedIndex;

    return InkWell(
      onTap: () => controller.changeIndex(index),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha(26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroIcon(
              item.icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withAlpha(179),
              size: 24.r,
            ),
            SizedBox(height: 4.h),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12.sp,
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
