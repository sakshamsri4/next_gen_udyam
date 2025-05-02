import 'package:get/get.dart';
import 'package:next_gen/app/modules/error/controllers/error_controller.dart';
import 'package:next_gen/core/services/connectivity_service.dart';
import 'package:next_gen/core/services/error_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the Error module
class ErrorBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure LoggerService is registered
    if (!Get.isRegistered<LoggerService>()) {
      Get.put(LoggerService(), permanent: true);
    }

    // Register ConnectivityService if not already registered
    if (!Get.isRegistered<ConnectivityService>()) {
      Get.put(
        ConnectivityService()..init(),
        permanent: true,
      );
    }

    // Register ErrorService if not already registered
    if (!Get.isRegistered<ErrorService>()) {
      Get.put(
        ErrorService()..init(),
        permanent: true,
      );
    }

    // Register ErrorController
    Get.lazyPut<ErrorController>(
      ErrorController.new,
    );
  }
}
