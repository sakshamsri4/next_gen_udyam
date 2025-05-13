import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/firebase_storage_service.dart';
import 'package:next_gen/app/modules/company_profile/controllers/company_profile_controller.dart';
import 'package:next_gen/app/modules/company_profile/services/company_profile_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the company profile module
class CompanyProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('CompanyProfileBinding: Registering dependencies');

    // Make sure AuthController is registered
    if (!Get.isRegistered<AuthController>()) {
      logger.d('CompanyProfileBinding: Registering AuthController');
      Get.put<AuthController>(
        AuthController(),
        permanent: true,
      );
    }

    // Make sure FirebaseStorageService is registered
    if (!Get.isRegistered<FirebaseStorageService>()) {
      logger.d('CompanyProfileBinding: Registering FirebaseStorageService');
      Get.put<FirebaseStorageService>(
        FirebaseStorageService(),
        permanent: true,
      );
    }

    // Register the company profile service and controller
    logger.d('CompanyProfileBinding: Registering CompanyProfileService');
    Get.lazyPut<CompanyProfileService>(CompanyProfileService.new);

    logger.d('CompanyProfileBinding: Registering CompanyProfileController');
    Get.lazyPut<CompanyProfileController>(CompanyProfileController.new);

    logger.d('CompanyProfileBinding: Dependencies registered successfully');
  }
}
