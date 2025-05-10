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

  // Global key for the scaffold drawer
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // List of routes for employee
  final List<String> _employeeRoutes = [
    Routes.home,
    Routes.search,
    Routes.savedJobs,
    Routes.resume,
    Routes.profile,
  ];

  // List of routes for employer
  final List<String> _employerRoutes = [
    Routes.dashboard,
    Routes.jobs,
    Routes.search, // Placeholder for applicants screen
    Routes.companyProfile,
    Routes.profile,
  ];

  // Map of route names to tab indices
  late final Map<String, int> _routeIndices;

  // Get current routes based on user role
  List<String> get _routes {
    return userRole.value == UserType.employer
        ? _employerRoutes
        : _employeeRoutes;
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
          userRole.value = userModel.userType;
          _logger.i('User role loaded: ${userRole.value}');

          // Update route indices when role changes
          _updateRouteIndices();
        } else {
          _logger.w('User model not found in storage');
          userRole.value = null;
        }
      } else {
        _logger.d('User not logged in, clearing role');
        userRole.value = null;
      }
    } catch (e) {
      _logger.e('Error loading user role', e);
      userRole.value = null;
    }
  }

  /// Update route indices map based on current role
  void _updateRouteIndices() {
    _routeIndices = {};
    final routes = _routes;
    for (var i = 0; i < routes.length; i++) {
      _routeIndices[routes[i]] = i;
    }
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
  void openDrawer() {
    if (scaffoldKey.currentState != null &&
        !scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();
      isDrawerOpen.value = true;
    }
  }

  /// Close the drawer
  void closeDrawer() {
    if (scaffoldKey.currentState != null &&
        scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.closeDrawer();
      isDrawerOpen.value = false;
    }
  }

  /// Toggle the drawer
  void toggleDrawer() {
    if (scaffoldKey.currentState != null) {
      if (scaffoldKey.currentState!.isDrawerOpen) {
        closeDrawer();
      } else {
        openDrawer();
      }
    }
  }

  /// Navigate to a named route with animation
  Future<void> navigateWithAnimation(String route, {Object? arguments}) async {
    isAnimating.value = true;
    await Get.toNamed<dynamic>(route, arguments: arguments);
    isAnimating.value = false;
  }
}
