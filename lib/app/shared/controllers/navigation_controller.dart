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
  final Rx<UserType?> userRole = Rx<UserType?>(null);

  // We no longer use a shared scaffold key to avoid duplicate key errors
  // Each view should create its own scaffold key

  // List of routes for employee
  final List<String> _employeeRoutes = [
    Routes.home,
    Routes.search,
    Routes.savedJobs,
    Routes.applications,
    Routes.profile,
  ];

  // List of routes for employer
  final List<String> _employerRoutes = [
    Routes.dashboard,
    Routes.jobPosting, // Job posting management
    Routes.search, // Applicants search
    Routes.companyProfile,
    Routes.profile,
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

  /// Load user role from storage
  Future<void> _loadUserRole() async {
    try {
      if (_authController.isLoggedIn) {
        final userModel = await _authService.getUserFromHive();
        if (userModel != null) {
          // Check if the role has changed before updating
          final oldRole = userRole.value;
          final newRole = userModel.userType;

          if (oldRole != newRole) {
            _logger.i('User role changed from $oldRole to $newRole');
            userRole.value = newRole;

            // Only update route indices when role actually changes
            _updateRouteIndices();
          } else {
            _logger.d('User role unchanged: $newRole');
          }
        } else {
          _logger.w('User model not found in storage');
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
  void changeIndex(int index) {
    if (index == selectedIndex.value) return;

    _logger.i('Changing navigation index to $index');
    selectedIndex.value = index;

    // Get current routes based on user role
    final routes = _routes;

    // Navigate to the corresponding route
    if (index < routes.length) {
      Get.offAllNamed<dynamic>(routes[index]);
    }
  }

  /// Set the selected index based on the current route
  void updateIndexFromRoute(String route) {
    final index = _routeIndices[route];
    if (index != null) {
      selectedIndex.value = index;
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
}
