import 'package:get/get.dart';
import 'package:next_gen/app/modules/applications/controllers/applications_controller.dart';
import 'package:next_gen/app/modules/applications/services/applications_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the applications module
class ApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('ApplicationsBinding: Registering dependencies')
      ..d('Registering ApplicationsService')
      ..d('Registering ApplicationsController');

    // Register services
    Get
      ..lazyPut<ApplicationsService>(
        () => ApplicationsService(logger: logger),
      )
      ..lazyPut<ApplicationsController>(
        () => ApplicationsController(
          applicationsService: Get.find<ApplicationsService>(),
          logger: logger,
        ),
      );
  }
}
