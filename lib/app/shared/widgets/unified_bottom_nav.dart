import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A unified bottom navigation bar that adapts to the user's role
///
/// This widget uses a StatefulWidget approach to properly manage state and avoid
/// reactive state management issues. It listens to the NavigationController's
/// selectedIndex and userRole values and rebuilds only when those values change.
///
/// Features:
/// - Role-specific styling (colors, icons)
/// - Consistent navigation structure across roles
/// - Proper state management to avoid rebuild issues
/// - Smooth transitions between states
/// - Safe controller initialization and disposal
/// - Comprehensive error handling
class UnifiedBottomNav extends StatefulWidget {
  /// Creates a unified bottom navigation bar
  const UnifiedBottomNav({super.key});

  @override
  State<UnifiedBottomNav> createState() => _UnifiedBottomNavState();
}

class _UnifiedBottomNavState extends State<UnifiedBottomNav> {
  // Controllers
  NavigationController? _navigationController;
  LoggerService? _logger;

  // Local state variables to avoid direct .value access in build
  int _selectedIndex = 0;
  UserType? _currentRole;

  // Workers to listen for changes
  final List<Worker> _workers = [];

  // Debounce for tap handling
  DateTime? _lastTapTime;
  int? _lastTappedIndex;
  // Reduced debounce time to improve responsiveness while still preventing double-taps
  static const _tapDebounceTime = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    // Dispose of all workers safely
    for (final worker in _workers) {
      try {
        worker.dispose();
      } catch (e) {
        debugPrint('Error disposing worker: $e');
      }
    }
    _workers.clear();
    super.dispose();
  }

  /// Initialize controllers and set up listeners
  void _initControllers() {
    try {
      // Try to get the logger service first for better error logging
      try {
        _logger = Get.find<LoggerService>();
      } catch (e) {
        debugPrint('LoggerService not available: $e');
      }

      // Try to get the navigation controller or create it if not found
      if (Get.isRegistered<NavigationController>()) {
        _navigationController = Get.find<NavigationController>();
        _logger?.d('Found existing NavigationController');
      } else {
        _logger?.w('NavigationController not found, creating a new instance');
        _navigationController = Get.put<NavigationController>(
          NavigationController(),
          permanent: true,
        );
      }

      // Initialize local state from controller with null safety
      if (_navigationController != null) {
        _selectedIndex = _navigationController!.selectedIndex.value;
        _currentRole = _navigationController!.userRole.value;

        // Set up workers to listen for changes using cascade notation
        _workers
          ..add(
            ever(_navigationController!.selectedIndex, (index) {
              if (mounted) {
                setState(() {
                  _selectedIndex = index;
                });
              }
            }),
          )
          ..add(
            ever(_navigationController!.userRole, (role) {
              if (mounted) {
                setState(() {
                  _currentRole = role;
                });
              }
            }),
          );

        _logger?.i('UnifiedBottomNav initialized successfully');
      } else {
        _logger?.e('Failed to initialize NavigationController');
      }
    } catch (e, stackTrace) {
      _logger?.e('Error initializing controllers', e, stackTrace);
      debugPrint('Error initializing controllers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // If navigation controller is not available, return empty container with error logging
    if (_navigationController == null) {
      _logger?.w('Navigation controller is null in UnifiedBottomNav.build');
      return const SizedBox.shrink();
    }

    // If the current role is admin, return empty container (admin uses side nav)
    if (_currentRole == UserType.admin) {
      _logger?.d('Admin role detected, not showing bottom nav');
      return const SizedBox.shrink();
    }

    // If the current role is null, show a placeholder with minimal UI
    if (_currentRole == null) {
      _logger?.w('User role is null in UnifiedBottomNav.build');
      return _buildPlaceholderNav(context);
    }

    try {
      // Define role-specific colors
      final Color primaryColor;
      final Color primaryLightColor;
      final List<_NavItem> items;

      // Set colors and items based on role
      if (_currentRole == UserType.employer) {
        primaryColor = RoleThemes.employerPrimary;
        primaryLightColor = RoleThemes.employerPrimaryLight;
        items = _employerNavItems;
      } else {
        // Default to employee
        primaryColor = RoleThemes.employeePrimary;
        primaryLightColor = RoleThemes.employeePrimaryLight;
        items = _employeeNavItems;
      }

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
              children: List.generate(
                items.length,
                (index) => _buildNavItem(
                  context,
                  items[index],
                  index,
                  index == _selectedIndex,
                  primaryColor,
                  primaryLightColor,
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      _logger?.e('Error building bottom navigation', e, stackTrace);
      return _buildErrorNav(context);
    }
  }

  /// Build a placeholder navigation bar when role is null
  Widget _buildPlaceholderNav(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.brightness == Brightness.dark
        ? const Color(0xFF1F2937)
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4, // Default number of items
              (index) => Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      color:
                          theme.disabledColor.withAlpha(76), // 0.3 * 255 ≈ 76
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            theme.disabledColor.withAlpha(76), // 0.3 * 255 ≈ 76
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build an error navigation bar
  Widget _buildErrorNav(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.brightness == Brightness.dark
        ? const Color(0xFF1F2937)
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Center(
            child: Text(
              'Navigation error. Please restart the app.',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build a navigation item
  ///
  /// This method creates a navigation item with proper error handling and
  /// visual feedback for the user.
  Widget _buildNavItem(
    BuildContext context,
    _NavItem item,
    int index,
    bool isSelected,
    Color primaryColor,
    Color primaryLightColor,
  ) {
    // Safely handle navigation tap with error handling and debounce
    void handleNavTap() {
      try {
        if (_navigationController != null) {
          // Check for debounce to prevent rapid taps
          final now = DateTime.now();
          if (_lastTapTime != null &&
              _lastTappedIndex == index &&
              now.difference(_lastTapTime!) < _tapDebounceTime) {
            _logger?.d(
              'Debouncing tap on navigation item $index (too soon after previous tap)',
            );
            return;
          }

          // Update debounce tracking
          _lastTapTime = now;
          _lastTappedIndex = index;

          // Skip if already selected
          if (index == _selectedIndex) {
            _logger?.d('Navigation item $index is already selected');
            return;
          }

          // Show visual feedback that the tap was registered
          HapticFeedback.lightImpact();

          // Change the index with a slight delay to allow the haptic feedback to complete
          // Also check if the navigation controller is still in a loading state
          Future.delayed(const Duration(milliseconds: 30), () {
            if (_navigationController != null) {
              // Check if navigation is already in progress
              if (_navigationController!.isLoading.value) {
                _logger?.w(
                  'Navigation already in progress, will retry after delay',
                );
                // If navigation is in progress, try again after a short delay
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (_navigationController != null) {
                    // Force reset loading state if it's still true after the delay
                    if (_navigationController!.isLoading.value) {
                      _logger?.w(
                        'Navigation still loading after delay, forcing reset',
                      );
                      _navigationController!.isLoading.value = false;
                    }
                    _navigationController!.changeIndex(index);
                  }
                });
              } else {
                _navigationController!.changeIndex(index);
              }
            }
          });
        } else {
          _logger?.w('Navigation controller is null during tap');
        }
      } catch (e, stackTrace) {
        _logger?.e('Error handling navigation tap', e, stackTrace);
      }
    }

    return InkWell(
      onTap: handleNavTap,
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
              color: isSelected ? primaryColor : primaryLightColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
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
  _NavItem(icon: HeroIcons.home, label: 'Discover'),
  _NavItem(icon: HeroIcons.briefcase, label: 'Jobs'),
  _NavItem(icon: HeroIcons.documentText, label: 'Applications'),
  _NavItem(icon: HeroIcons.user, label: 'Profile'),
];

/// Navigation items for employer
const List<_NavItem> _employerNavItems = [
  _NavItem(icon: HeroIcons.home, label: 'Dashboard'),
  _NavItem(icon: HeroIcons.briefcase, label: 'Jobs'),
  _NavItem(icon: HeroIcons.users, label: 'Applicants'),
  _NavItem(icon: HeroIcons.buildingOffice2, label: 'Company'),
];
