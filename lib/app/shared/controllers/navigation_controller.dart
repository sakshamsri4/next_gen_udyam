import 'dart:async';

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
  // Use nullable types with getters to safely handle initialization
  LoggerService? _loggerInstance;
  AuthController? _authControllerInstance;
  AuthService? _authServiceInstance;

  // Safe getters for dependencies
  LoggerService get _logger {
    if (_loggerInstance == null) {
      try {
        _loggerInstance = Get.find<LoggerService>();
      } catch (e) {
        debugPrint('Error finding LoggerService: $e');
        // Create a fallback logger if needed
        _loggerInstance = LoggerService();
      }
    }
    return _loggerInstance!;
  }

  AuthController get _authController {
    if (_authControllerInstance == null) {
      try {
        _authControllerInstance = Get.find<AuthController>();
      } catch (e) {
        debugPrint('Error finding AuthController: $e');
        // Don't create a fallback here as it could cause more issues
        throw Exception('AuthController not found: $e');
      }
    }
    return _authControllerInstance!;
  }

  AuthService get _authService {
    if (_authServiceInstance == null) {
      try {
        _authServiceInstance = Get.find<AuthService>();
      } catch (e) {
        debugPrint('Error finding AuthService: $e');
        // Don't create a fallback here as it could cause more issues
        throw Exception('AuthService not found: $e');
      }
    }
    return _authServiceInstance!;
  }

  // Observable state variables
  final RxInt selectedIndex = 0.obs;
  final RxBool isDrawerOpen = false.obs;
  final RxBool isAnimating = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<UserType?> userRole = Rx<UserType?>(null);

  // Debounce variables to prevent rapid navigation requests
  DateTime? _lastNavigationRequest;
  int? _lastRequestedIndex;
  // Reduced debounce time to improve responsiveness while still preventing double-taps
  static const _debounceTime = Duration(milliseconds: 300);

  // We no longer use a shared scaffold key to avoid duplicate key errors
  // Each view should create its own scaffold key

  // List of routes for employee - updated for streamlined navigation
  // These routes must match the order of tabs in EmployeeBottomNav
  final List<String> _employeeRoutes = [
    Routes.home, // Discover tab (index 0)
    Routes.search, // Jobs tab (index 1)
    Routes.applications, // Applications tab (index 2)
    Routes.profile, // Profile tab (index 3)
  ];

  // List of routes for employer - updated for streamlined navigation
  // These routes must match the order of tabs in EmployerBottomNav
  final List<String> _employerRoutes = [
    Routes.dashboard, // Dashboard tab (index 0)
    Routes.jobPosting, // Jobs tab (index 1)
    Routes.search, // Applicants tab (index 2)
    Routes.companyProfile, // Company tab (index 3)
  ];

  // List of routes for admin
  // These routes must match the order of tabs in AdminSideNav
  final List<String> _adminRoutes = [
    Routes.dashboard, // Dashboard (index 0)
    Routes.jobPosting, // Job posting management (index 1)
    Routes.search, // User management (index 2)
    Routes.settings, // System settings (index 3)
    Routes.profile, // Profile (index 4)
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

    // The getters will handle finding or creating the services
    // We just need to access them to trigger initialization
    _logger.i('NavigationController initializing');

    try {
      // Load user role
      _loadUserRole();

      // Listen for auth changes
      ever(_authController.user, (_) => _loadUserRole());

      // Initialize route indices map
      _updateRouteIndices();

      _logger.i('NavigationController initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Error during NavigationController initialization: $e');
      _logger.e(
        'Error during NavigationController initialization',
        e,
        stackTrace,
      );
    }
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
  /// It includes comprehensive error handling and logging for better debugging.
  ///
  /// Improvements:
  /// - Better timeout handling with more reliable detection
  /// - More robust error recovery
  /// - Cleaner retry logic
  /// - Better state management during navigation
  /// - Debounce mechanism to prevent rapid navigation requests
  Future<void> changeIndex(int index) async {
    // Check for debounce - prevent rapid navigation requests to the same index
    final now = DateTime.now();
    if (_lastNavigationRequest != null &&
        _lastRequestedIndex == index &&
        now.difference(_lastNavigationRequest!) < _debounceTime) {
      _logger.w(
        'Debouncing navigation request to index $index (too soon after previous request)',
      );
      return;
    }

    // Update debounce tracking
    _lastNavigationRequest = now;
    _lastRequestedIndex = index;

    // Prevent multiple simultaneous navigation attempts
    if (isLoading.value) {
      _logger.w(
        'Navigation already in progress, ignoring request to change to index $index',
      );

      // Force reset the loading state if it's been stuck for too long
      final now = DateTime.now();
      if (_lastNavigationRequest != null &&
          now.difference(_lastNavigationRequest!) >
              const Duration(seconds: 3)) {
        _logger.w('Navigation appears stuck, resetting loading state');
        isLoading.value = false;
        // Continue with the navigation
      } else {
        return;
      }
    }

    // Set loading state to indicate navigation is in progress
    isLoading.value = true;

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

      // Use a more reliable approach to handle navigation with timeouts
      final navigationSuccessful = await _navigateWithRetries(targetRoute);

      if (!navigationSuccessful) {
        _logger.w('Navigation to $targetRoute failed after retries');
        await _attemptRecoveryNavigation(index, routes);
      } else {
        _logger.i('Navigation completed to index $index (route: $targetRoute)');
      }
    } catch (e, stackTrace) {
      _logger.e('Error changing navigation index to $index', e, stackTrace);
      // Don't rethrow to prevent app crashes from navigation errors
    } finally {
      // Always reset loading state when done, regardless of success or failure
      isLoading.value = false;

      // Schedule a safety check to ensure loading state is reset after a delay
      // This helps recover from edge cases where the loading state might get stuck
      Future.delayed(const Duration(milliseconds: 500), () {
        if (isLoading.value) {
          _logger.w('Loading state still true after navigation, forcing reset');
          isLoading.value = false;
        }
      });
    }
  }

  /// Attempt to navigate to a route with retries
  ///
  /// This method handles the actual navigation with timeout and retry logic.
  /// It returns true if navigation was successful, false otherwise.
  Future<bool> _navigateWithRetries(String targetRoute) async {
    var navigateResult = false;
    var retryCount = 0;
    const maxRetries = 2;
    const timeout = Duration(
      seconds: 5,
    ); // Increased timeout to allow more time for profile loading

    // Create a completer to handle the timeout more reliably
    final completer = Completer<bool>();

    while (!navigateResult && retryCount <= maxRetries) {
      try {
        if (retryCount > 0) {
          _logger.i(
            'Retrying navigation to $targetRoute (attempt ${retryCount + 1}/${maxRetries + 1})',
          );
        }

        // Set up a timeout timer
        final timer = Timer(timeout, () {
          if (!completer.isCompleted) {
            _logger.w('Navigation timeout for route: $targetRoute');
            completer.complete(false);
          }
        });

        try {
          // Attempt navigation
          final result = await Get.offAllNamed<dynamic>(targetRoute);

          // Cancel the timer if navigation completes
          timer.cancel();

          // If we get here without an exception, navigation was successful
          navigateResult = result != null;

          if (navigateResult) {
            if (!completer.isCompleted) {
              completer.complete(true);
            }
            break;
          } else {
            _logger
                .w('Navigation returned null result for route: $targetRoute');
          }
        } catch (navError, navStackTrace) {
          // Cancel the timer if navigation throws an exception
          timer.cancel();

          _logger.e(
            'Error during navigation to route: $targetRoute (attempt ${retryCount + 1}/${maxRetries + 1})',
            navError,
            navStackTrace,
          );
        }

        // Increment retry count
        retryCount++;

        // If we've reached max retries, break out of the loop
        if (retryCount > maxRetries) {
          if (!completer.isCompleted) {
            _logger.w('Max retries reached for navigation to $targetRoute');
            completer.complete(false);
          }
          break;
        }

        // Wait a moment before retrying
        await Future<void>.delayed(const Duration(milliseconds: 300));
      } catch (e, stackTrace) {
        _logger.e('Unexpected error during navigation retry', e, stackTrace);
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        break;
      }
    }

    // If the completer hasn't completed yet, complete it with the current result
    if (!completer.isCompleted) {
      completer.complete(navigateResult);
    }

    return completer.future;
  }

  /// Attempt recovery navigation when the primary navigation fails
  ///
  /// This method tries to navigate to a fallback route to recover from navigation failures.
  Future<void> _attemptRecoveryNavigation(
    int index,
    List<String> routes,
  ) async {
    // Try to recover by going to the previous tab if possible
    if (index > 0 && index < routes.length) {
      try {
        final previousIndex = index - 1;
        final previousRoute = routes[previousIndex];
        _logger.i(
          'Attempting to recover by navigating to previous tab: $previousRoute',
        );

        // Update the index to the previous tab
        selectedIndex.value = previousIndex;

        // Navigate to the previous tab
        await Get.offAllNamed<dynamic>(previousRoute);
        _logger.i('Recovered by navigating to previous tab');
        return;
      } catch (recoveryError) {
        _logger.e(
          'Failed to recover by navigating to previous tab',
          recoveryError,
        );
      }
    }

    // If we can't go to the previous tab or it failed, try the home route
    try {
      _logger.i('Attempting to recover by navigating to home route');
      selectedIndex.value = 0; // Home is usually at index 0
      await Get.offAllNamed<dynamic>(Routes.home);
      _logger.i('Recovered by navigating to home route');
    } catch (homeRecoveryError) {
      _logger.e(
        'Failed to recover from navigation error',
        homeRecoveryError,
      );

      // Last resort: try to reset the navigation state
      try {
        _logger.i('Last resort: Attempting to reset navigation state');
        Get.reset();
        await Get.offAllNamed<dynamic>(Routes.home);
        _logger.i('Successfully reset navigation state');
      } catch (resetError) {
        _logger.e('Failed to reset navigation state', resetError);
      }
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
