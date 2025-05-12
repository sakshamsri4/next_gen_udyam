import 'package:get/get.dart';
import 'package:next_gen/app/modules/employee/controllers/jobs_controller.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the Jobs module
class JobsBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies
    if (!Get.isRegistered<JobService>()) {
      Get.put(JobService(), permanent: true);
    }

    // Register JobsController
    Get.lazyPut<JobsController>(JobsController.new);

    // Log registrations
    Get.find<LoggerService>()
      ..i('JobsBinding: Dependencies registered')
      ..i('JobsController registered');
  }
}
