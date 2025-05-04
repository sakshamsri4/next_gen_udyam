import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/controllers/search_controller.dart';
import 'package:next_gen/app/modules/search/services/search_service.dart';
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/hive_manager.dart';

/// Binding for the Search module
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('SearchBinding: Registering dependencies');

    // Ensure HiveManager is registered with GetX
    if (!Get.isRegistered<HiveManager>()) {
      logger.d('SearchBinding: Registering HiveManager');
      try {
        // Try to get HiveManager from service locator
        final hiveManager = serviceLocator<HiveManager>();
        Get.put<HiveManager>(hiveManager, permanent: true);
      } catch (e) {
        // If not found in service locator, create a new instance
        logger.w(
          'HiveManager not found in service locator, creating new instance',
        );
        final hiveManager = HiveManager();
        Get.put<HiveManager>(hiveManager, permanent: true);
        // Initialize Hive (this would normally be done by service locator)
        hiveManager.initialize().then((_) {
          logger.d('HiveManager initialized');
        });
      }
    }

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
