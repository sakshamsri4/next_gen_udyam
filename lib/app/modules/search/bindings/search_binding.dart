import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/controllers/search_controller.dart';
import 'package:next_gen/app/modules/search/services/search_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the Search module
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('SearchBinding: Registering dependencies');

    // Register SearchService if not already registered
    if (!Get.isRegistered<SearchService>()) {
      logger.d('SearchBinding: Registering SearchService');
      Get.put<SearchService>(
        SearchService(),
        permanent: true,
      ).init();
    }

    // Register SearchController
    logger.d('SearchBinding: Registering SearchController');
    Get.put<SearchController>(
      SearchController(),
      permanent: true,
    );

    logger.d('SearchBinding: Dependencies registered successfully');
  }
}
