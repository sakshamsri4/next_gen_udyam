import 'package:get/get.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for managing bottom navigation and app-wide navigation state
class NavigationController extends GetxController {
  // Dependencies
  late final LoggerService _logger;

  // Observable state variables
  final RxInt selectedIndex = 0.obs;

  // List of routes corresponding to each tab
  final List<String> _routes = [
    Routes.dashboard,
    Routes.jobs,
    Routes.resume,
    Routes.profile,
  ];

  @override
  void onInit() {
    super.onInit();
    _logger = Get.find<LoggerService>();
    _logger.i('NavigationController initialized');
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
    final index = _routes.indexOf(route);
    if (index != -1) {
      selectedIndex.value = index;
    }
  }
}
