import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for managing bottom navigation and app-wide navigation state
class NavigationController extends GetxController {
  // Dependencies
  late final LoggerService _logger;

  // Observable state variables
  final RxInt selectedIndex = 0.obs;
  final RxBool isDrawerOpen = false.obs;
  final RxBool isAnimating = false.obs;

  // Global key for the scaffold drawer
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // List of routes corresponding to each tab
  final List<String> _routes = [
    Routes.dashboard,
    Routes.search,
    Routes.savedJobs,
    Routes.resume,
    Routes.profile,
  ];

  // Map of route names to tab indices
  late final Map<String, int> _routeIndices;

  @override
  void onInit() {
    super.onInit();
    _logger = Get.find<LoggerService>();
    _logger.i('NavigationController initialized');

    // Initialize route indices map
    _routeIndices = {};
    for (var i = 0; i < _routes.length; i++) {
      _routeIndices[_routes[i]] = i;
    }
  }

  /// Change the selected tab index and navigate to the corresponding route
  void changeIndex(int index) {
    if (index == selectedIndex.value) return;

    _logger.i('Changing navigation index to $index');
    selectedIndex.value = index;

    // Navigate to the corresponding route
    if (index < _routes.length) {
      Get.offAllNamed<dynamic>(_routes[index]);
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
