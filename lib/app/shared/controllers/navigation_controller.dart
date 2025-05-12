import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for managing bottom navigation and app-wide navigation state
class NavigationController extends GetxController {
  // Dependencies
  late final LoggerService _logger;
  late final AuthController _authController;
  late final AuthService _authService;

  // Observable state variables
  final RxInt selectedIndex = 0.obs;
  final RxBool isDrawerOpen = false.obs;
  final RxBool isAnimating = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<UserType?> userRole = Rx<UserType?>(null);

  // We no longer use a shared scaffold key to avoid duplicate key errors
  // Each view should create its own scaffold key

  // List of routes for employee - updated for streamlined navigation
  final List<String> _employeeRoutes = [
    Routes.home, // Discover tab
    Routes.search, // Jobs tab (combines search and saved)
    Routes.applications, // Applications tab
    Routes.profile, // Profile tab
  ];

  // List of routes for employer - updated for streamlined navigation
  final List<String> _employerRoutes = [
    Routes.dashboard, // Dashboard tab
    Routes.jobPosting, // Jobs tab (job posting management)
    Routes.search, // Applicants tab
    Routes
        .companyProfile, // Company tab (combines company profile and settings)
  ];

  // List of routes for admin
  final List<String> _adminRoutes = [
    Routes.dashboard,
    Routes.jobPosting, // Job posting management
    Routes.search, // User management
    Routes.settings, // System settings
    Routes.profile,
  ];

  // Map of route names to tab indices
  final Map<String, int> _routeIndices = {};

  // Get current routes based on user role
  List<String> get _routes {
    if (userRole.value == UserType.employer) {
      return _employerRoutes;
    } else if (userRole.value == UserType.admin) {
      return _adminRoutes;
    } else {
      return _employeeRoutes;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _logger = Get.find<LoggerService>();
    _authController = Get.find<AuthController>();
    _authService = Get.find<AuthService>();
    _logger.i('NavigationController initialized');

    // Load user role
    _loadUserRole();

    // Listen for auth changes
    ever(_authController.user, (_) => _loadUserRole());

    // Initialize route indices map
    _updateRouteIndices();
  }

  /// Public method to force reload user role
  Future<void> reloadUserRole() async {
    _logger.d('NavigationController: Manually reloading user role');
    return _loadUserRole();
  }

  /// Load user role from storage
  Future<void> _loadUserRole() async {
    try {
      _logger.d('NavigationController: Loading user role');
      if (_authController.user.value != null) {
        _logger.d('NavigationController: User is logged in, checking role');

        // First try to get from Firebase (most up-to-date)
        final firebaseUserModel = await _authService.getUserFromFirebase();
        _logger.d(
          'NavigationController: User model from Firebase: ${firebaseUserModel?.toMap()}',
        );

        if (firebaseUserModel != null && firebaseUserModel.userType != null) {
          // Check if the role has changed before updating
          final oldRole = userRole.value;
          final newRole = firebaseUserModel.userType;

          if (oldRole != newRole) {
            _logger.i(
              'NavigationController: User role changed from $oldRole to $newRole',
            );
            userRole.value = newRole;

            // Only update route indices when role actually changes
            _updateRouteIndices();
          } else {
            _logger.d('NavigationController: User role unchanged: $newRole');
          }
          return; // Exit early if we got the role from Firebase
        }

        // Fallback to Hive if Firebase doesn't have the role
        _logger.d('NavigationController: Falling back to Hive for user role');
        final userModel = await _authService.getUserFromHive();
        _logger.d(
          'NavigationController: User model from Hive: ${userModel?.toMap()}',
        );

        if (userModel != null && userModel.userType != null) {
          // Check if the role has changed before updating
          final oldRole = userRole.value;
          final newRole = userModel.userType;

          if (oldRole != newRole) {
            _logger.i(
              'NavigationController: User role changed from $oldRole to $newRole (from Hive)',
            );
            userRole.value = newRole;

            // Only update route indices when role actually changes
            _updateRouteIndices();
          } else {
            _logger.d(
              'NavigationController: User role unchanged: $newRole (from Hive)',
            );
          }
        } else {
          _logger.w(
            'NavigationController: User model not found in storage or has no role',
          );
          if (userRole.value != null) {
            userRole.value = null;
            _updateRouteIndices();
          }
        }
      } else {
        _logger.d('User not logged in, clearing role');
        if (userRole.value != null) {
          userRole.value = null;
          _updateRouteIndices();
        }
      }
    } catch (e) {
      _logger.e('Error loading user role', e);
      userRole.value = null;
    }
  }

  /// Update route indices map based on current role
  void _updateRouteIndices() {
    // Clear the existing map instead of reassigning
    _routeIndices.clear();

    // Add new route indices based on current role
    final routes = _routes;
    for (var i = 0; i < routes.length; i++) {
      _routeIndices[routes[i]] = i;
    }

    _logger.d('Route indices updated for role: ${userRole.value}');
  }

  /// Change the selected tab index and navigate to the corresponding route
  ///
  /// This method safely updates the selectedIndex and navigates to the corresponding route.
  /// It includes additional error handling and logging for better debugging.
  Future<void> changeIndex(int index) async {
    try {
      // Validate the index
      if (index < 0) {
        _logger.w('Invalid navigation index: $index (negative)');
        return;
      }

      // Skip if the index is already selected
      if (index == selectedIndex.value) {
        _logger.d('Navigation index $index is already selected');
        return;
      }

      _logger.i('Changing navigation index to $index');

      // Get current routes based on user role
      final routes = _routes;

      // Validate the index against available routes
      if (index >= routes.length) {
        _logger.w(
          'Invalid navigation index: $index (out of bounds, max: ${routes.length - 1})',
        );
        return;
      }

      // Get the target route
      final targetRoute = routes[index];
      _logger.d('Target route: $targetRoute');

      // Update the index first to ensure UI consistency
      selectedIndex.value = index;

      // Navigate to the corresponding route
      await Get.offAllNamed<dynamic>(targetRoute);

      _logger.i('Navigation completed to index $index (route: $targetRoute)');
    } catch (e, stackTrace) {
      _logger.e('Error changing navigation index to $index', e, stackTrace);
      // Don't rethrow to prevent app crashes from navigation errors
    }
  }

  /// Set the selected index based on the current route
  ///
  /// This method safely updates the selectedIndex value without triggering
  /// setState() during build. It also logs the update for debugging purposes.
  void updateIndexFromRoute(String route) {
    final index = _routeIndices[route];
    if (index != null && index != selectedIndex.value) {
      _logger.d('Updating selectedIndex from route $route to $index');

      // Use WidgetsBinding to ensure the update happens after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check again in case the value changed during the frame
        if (index != selectedIndex.value) {
          selectedIndex.value = index;
          _logger.d('selectedIndex updated to $index');
        }
      });
    }
  }

  /// Open the drawer
  void openDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    if (scaffoldKey.currentState != null &&
        !scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();
      isDrawerOpen.value = true;
    }
  }

  /// Close the drawer
  void closeDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    if (scaffoldKey.currentState != null &&
        scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.closeDrawer();
      isDrawerOpen.value = false;
    }
  }

  /// Toggle the drawer
  void toggleDrawer([GlobalKey<ScaffoldState>? scaffoldKey]) {
    // If no key is provided, we can't toggle the drawer
    if (scaffoldKey == null || scaffoldKey.currentState == null) {
      _logger.w('Cannot toggle drawer: No valid scaffold key provided');
      return;
    }

    if (scaffoldKey.currentState!.isDrawerOpen) {
      closeDrawer(scaffoldKey);
    } else {
      openDrawer(scaffoldKey);
    }
  }

  /// Navigate to a named route with animation
  Future<void> navigateWithAnimation(String route, {Object? arguments}) async {
    isAnimating.value = true;
    await Get.toNamed<dynamic>(route, arguments: arguments);
    isAnimating.value = false;
  }

  /// Navigate to a detail screen while preserving the current tab context
  ///
  /// This method is used for navigating to detail screens (like job details)
  /// without changing the selected tab index. When the user navigates back,
  /// they will return to the same tab they were on.
  Future<void> navigateToDetail(String route, {Object? arguments}) async {
    try {
      _logger.d('Navigating to detail screen: $route');
      // We don't change the selectedIndex here, preserving the current tab context
      await Get.toNamed<dynamic>(route, arguments: arguments);
      _logger.d('Navigation to detail screen completed');
    } catch (e, stackTrace) {
      _logger.e('Error navigating to detail screen: $route', e, stackTrace);
    }
  }

  /// Navigate back from a detail screen
  ///
  /// This method ensures proper navigation back from detail screens,
  /// maintaining the correct tab context.
  void navigateBack() {
    try {
      _logger.d('Navigating back from detail screen');
      // Simply go back without changing the selected index
      Get.back<dynamic>();
    } catch (e, stackTrace) {
      _logger.e('Error navigating back from detail screen', e, stackTrace);
    }
  }
}
