import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';

/// A custom animated bottom navigation bar with NeoPOP styling
class CustomAnimatedBottomNavBar extends GetView<NavigationController> {
  const CustomAnimatedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      return Container(
        height: 70,
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51), // 0.2 * 255 = 51
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: FontAwesomeIcons.house,
              label: 'Home',
              index: 0,
            ),
            _buildNavItem(
              context,
              icon: FontAwesomeIcons.magnifyingGlass,
              label: 'Search',
              index: 1,
            ),
            _buildNavItem(
              context,
              icon: FontAwesomeIcons.fileLines,
              label: 'Resume',
              index: 2,
            ),
            _buildNavItem(
              context,
              icon: FontAwesomeIcons.user,
              label: 'Profile',
              index: 3,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final theme = Theme.of(context);
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  top: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with effect when selected
            if (isSelected)
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 22,
              )
            else
              Icon(
                icon,
                color: theme.colorScheme.onSurface
                    .withAlpha(153), // 0.6 * 255 = 153
                size: 20,
              ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface
                        .withAlpha(153), // 0.6 * 255 = 153
              ),
            ),
          ],
        ),
      ),
    );
  }
}
