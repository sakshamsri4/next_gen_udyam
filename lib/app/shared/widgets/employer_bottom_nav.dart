import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A bottom navigation bar specifically designed for employer users
///
/// This widget uses a StatefulWidget approach to properly manage state and avoid
/// reactive state management issues. It listens to the NavigationController's
/// selectedIndex and rebuilds only when that value changes.
/// The color scheme is green-themed to visually indicate the employer role.
///
/// Features a streamlined 4-tab structure:
/// - Dashboard: Overview with key metrics and quick actions (Routes.dashboard)
/// - Jobs: Manage job postings with status filters (Routes.jobPosting)
/// - Applicants: Review and manage all applications (Routes.search)
/// - Company: Company profile and settings combined (Routes.companyProfile)
class EmployerBottomNav extends StatefulWidget {
  /// Creates an employer-specific bottom navigation bar
  const EmployerBottomNav({super.key});

  @override
  State<EmployerBottomNav> createState() => _EmployerBottomNavState();
}

class _EmployerBottomNavState extends State<EmployerBottomNav> {
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

      _logger?.d('EmployerBottomNav initialized successfully');
    } catch (e) {
      debugPrint('Error initializing EmployerBottomNav: $e');

      // Try to log the error if LoggerService is available
      try {
        Get.find<LoggerService>().e('Error initializing EmployerBottomNav', e);
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

    // Define the employer-specific colors
    const primaryColor = Color(0xFF059669); // Green primary color
    const primaryLightColor =
        Color(0xFF6EE7B7); // Light green for inactive items
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E293B) // Dark warm gray for dark mode
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
                label: 'Dashboard',
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
                icon: HeroIcons.users,
                label: 'Applicants',
                index: 2,
                isSelected: _selectedIndex == 2,
                primaryColor: primaryColor,
                primaryLightColor: primaryLightColor,
              ),
              _buildNavItem(
                context,
                icon: HeroIcons.buildingOffice2,
                label: 'Company',
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
