import 'package:get/get.dart';
import 'package:next_gen/app/modules/company_profile/controllers/company_profile_controller.dart';
import 'package:next_gen/app/modules/company_profile/services/company_profile_service.dart';
import 'package:next_gen/app/modules/job_posting/controllers/job_posting_controller.dart';
import 'package:next_gen/app/modules/job_posting/services/job_posting_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for job posting module
class JobPostingBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('JobPostingBinding: Registering dependencies');

    // Register JobPostingService
    Get.put<JobPostingService>(JobPostingService());

    // Register CompanyProfileService and CompanyProfileController
    // Use Get.put instead of Get.lazyPut to ensure they are created immediately
    logger.d('JobPostingBinding: Registering CompanyProfileService');
    if (!Get.isRegistered<CompanyProfileService>()) {
      Get.put<CompanyProfileService>(CompanyProfileService(), permanent: true);
    }

    logger.d('JobPostingBinding: Registering CompanyProfileController');
    if (!Get.isRegistered<CompanyProfileController>()) {
      Get.put<CompanyProfileController>(
        CompanyProfileController(),
        permanent: true,
      );
    }

    // Register JobPostingController after its dependencies
    logger.d('JobPostingBinding: Registering JobPostingController');
    Get.put<JobPostingController>(JobPostingController());

    logger.d('JobPostingBinding: Dependencies registered successfully');
  }
}
