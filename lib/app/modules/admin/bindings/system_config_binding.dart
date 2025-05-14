import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/controllers/system_config_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the system configuration screen
class SystemConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SystemConfigController>(
      () => SystemConfigController(
        loggerService: Get.find<LoggerService>(),
      ),
    );
  }
}
