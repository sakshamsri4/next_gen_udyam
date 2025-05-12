import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A bottom navigation bar specifically designed for employee users
///
/// This widget uses a pure reactive approach with GetX to avoid state management issues.
/// It observes the NavigationController's selectedIndex and rebuilds only when that value changes.
/// The color scheme is blue-themed to visually indicate the employee role.
///
/// Features a streamlined 4-tab structure:
/// - Discover: Home feed and recommendations
/// - Jobs: Search and saved jobs
/// - Applications: Track ongoing applications
/// - Profile: User profile and settings
class EmployeeBottomNav extends StatelessWidget {
  /// Creates an employee-specific bottom navigation bar
  const EmployeeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the employee-specific colors
    const primaryColor = Color(0xFF2563EB); // Blue primary color
    const primaryLightColor =
        Color(0xFF93C5FD); // Light blue for inactive items
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1F2937) // Dark blue-gray for dark mode
        : Colors.white;

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

    // Use Obx to observe the selectedIndex
    return Obx(() {
      // Get the current selected index from the controller
      final selectedIndex = navigationController.selectedIndex.value;

      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
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
              children: [
                _buildNavItem(
                  context,
                  icon: HeroIcons.home,
                  label: 'Discover',
                  index: 0,
                  isSelected: selectedIndex == 0,
                  navigationController: navigationController,
                  primaryColor: primaryColor,
                  primaryLightColor: primaryLightColor,
                ),
                _buildNavItem(
                  context,
                  icon: HeroIcons.briefcase,
                  label: 'Jobs',
                  index: 1,
                  isSelected: selectedIndex == 1,
                  navigationController: navigationController,
                  primaryColor: primaryColor,
                  primaryLightColor: primaryLightColor,
                ),
                _buildNavItem(
                  context,
                  icon: HeroIcons.documentText,
                  label: 'Applications',
                  index: 2,
                  isSelected: selectedIndex == 2,
                  navigationController: navigationController,
                  primaryColor: primaryColor,
                  primaryLightColor: primaryLightColor,
                ),
                _buildNavItem(
                  context,
                  icon: HeroIcons.user,
                  label: 'Profile',
                  index: 3,
                  isSelected: selectedIndex == 3,
                  navigationController: navigationController,
                  primaryColor: primaryColor,
                  primaryLightColor: primaryLightColor,
                ),
              ],
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
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required int index,
    required bool isSelected,
    required NavigationController navigationController,
    required Color primaryColor,
    required Color primaryLightColor,
  }) {
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
              icon,
              color: isSelected ? primaryColor : primaryLightColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : primaryLightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
