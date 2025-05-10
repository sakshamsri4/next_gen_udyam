import 'package:get/get.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/job_details/services/job_details_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the Job Details module
class JobDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('JobDetailsBinding: Registering dependencies');

    // Register JobDetailsService and JobDetailsController
    Get
      ..lazyPut<JobDetailsService>(
        JobDetailsService.new,
      )
      ..lazyPut<JobDetailsController>(
        JobDetailsController.new,
      );

    logger.d('JobDetailsBinding: Dependencies registered successfully');
  }
}
