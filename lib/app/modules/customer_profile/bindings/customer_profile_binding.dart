import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/firebase_storage_service.dart';
import 'package:next_gen/app/modules/customer_profile/controllers/customer_profile_controller.dart';
import 'package:next_gen/app/modules/customer_profile/services/customer_profile_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the customer profile module
class CustomerProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('CustomerProfileBinding: Registering dependencies');

    // Make sure AuthController is registered
    if (!Get.isRegistered<AuthController>()) {
      logger.d('CustomerProfileBinding: Registering AuthController');
      Get.put<AuthController>(AuthController(), permanent: true);
    }

    // Make sure FirebaseStorageService is registered
    if (!Get.isRegistered<FirebaseStorageService>()) {
      logger.d('CustomerProfileBinding: Registering FirebaseStorageService');
      Get.put<FirebaseStorageService>(
        FirebaseStorageService(),
        permanent: true,
      );
    }

    // Register the customer profile service and controller
    logger.d('CustomerProfileBinding: Registering CustomerProfileService');
    Get.lazyPut<CustomerProfileService>(CustomerProfileService.new);

    logger.d('CustomerProfileBinding: Registering CustomerProfileController');
    Get.lazyPut<CustomerProfileController>(CustomerProfileController.new);

    logger.d('CustomerProfileBinding: Dependencies registered successfully');
  }
}
