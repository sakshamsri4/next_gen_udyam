import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A bottom navigation bar specifically designed for employee users
///
/// This widget uses a StatefulWidget approach to properly manage state and avoid
/// reactive state management issues. It listens to the NavigationController's
/// selectedIndex and rebuilds only when that value changes.
/// The color scheme is blue-themed to visually indicate the employee role.
///
/// Features a streamlined 4-tab structure:
/// - Discover: Home feed and recommendations (Routes.home)
/// - Jobs: Search and saved jobs (Routes.search)
/// - Applications: Track ongoing applications (Routes.applications)
/// - Profile: User profile and settings (Routes.profile)
class EmployeeBottomNav extends StatefulWidget {
  /// Creates an employee-specific bottom navigation bar
  const EmployeeBottomNav({super.key});

  @override
  State<EmployeeBottomNav> createState() => _EmployeeBottomNavState();
}

class _EmployeeBottomNavState extends State<EmployeeBottomNav> {
  // Controllers
  NavigationController? _navigationController;
  LoggerService? _logger;

  // Local state variables to avoid direct .value access in build
  int _selectedIndex = 0;

  // Workers to listen for changes
  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    // Dispose of all workers
    for (final worker in _workers) {
      worker.dispose();
    }
    super.dispose();
  }

  /// Initialize controllers and set up listeners
  void _initControllers() {
    try {
      // Try to get the navigation controller
      _navigationController = Get.find<NavigationController>();

      // Try to get the logger service
      try {
        _logger = Get.find<LoggerService>();
      } catch (e) {
        debugPrint('LoggerService not available: $e');
      }

      // Initialize local state from controller
      _selectedIndex = _navigationController!.selectedIndex.value;

      // Set up worker to listen for changes
      _workers.add(
        ever(_navigationController!.selectedIndex, (index) {
          if (mounted) {
            setState(() {
              _selectedIndex = index;
            });
          }
        }),
      );

      _logger?.d('EmployeeBottomNav initialized successfully');
    } catch (e) {
      debugPrint('Error initializing EmployeeBottomNav: $e');

      // Try to log the error if LoggerService is available
      try {
        Get.find<LoggerService>().e('Error initializing EmployeeBottomNav', e);
      } catch (_) {
        // Silently ignore if LoggerService is not available
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If navigation controller is not available, return empty container
    if (_navigationController == null) {
      return const SizedBox.shrink();
    }

    // Define the employee-specific colors
    const primaryColor = Color(0xFF2563EB); // Blue primary color
    const primaryLightColor =
        Color(0xFF93C5FD); // Light blue for inactive items
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1F2937) // Dark blue-gray for dark mode
        : Colors.white;

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
                isSelected: _selectedIndex == 0,
                primaryColor: primaryColor,
                primaryLightColor: primaryLightColor,
              ),
              _buildNavItem(
                context,
                icon: HeroIcons.briefcase,
                label: 'Jobs',
                index: 1,
                isSelected: _selectedIndex == 1,
                primaryColor: primaryColor,
                primaryLightColor: primaryLightColor,
              ),
              _buildNavItem(
                context,
                icon: HeroIcons.documentText,
                label: 'Applications',
                index: 2,
                isSelected: _selectedIndex == 2,
                primaryColor: primaryColor,
                primaryLightColor: primaryLightColor,
              ),
              _buildNavItem(
                context,
                icon: HeroIcons.user,
                label: 'Profile',
                index: 3,
                isSelected: _selectedIndex == 3,
                primaryColor: primaryColor,
                primaryLightColor: primaryLightColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a navigation item
  ///
  /// This method is pure - it doesn't depend on any observable variables
  /// making it more efficient and less prone to rebuild issues.
  Widget _buildNavItem(
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required int index,
    required bool isSelected,
    required Color primaryColor,
    required Color primaryLightColor,
  }) {
    return InkWell(
      onTap: () {
        if (_navigationController != null &&
            !_navigationController!.isLoading.value) {
          _navigationController?.changeIndex(index);
        }
      },
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
