import 'package:get/get.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';
import 'package:next_gen/app/modules/saved_jobs/controllers/saved_jobs_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the saved jobs module
class SavedJobsBinding extends Bindings {
  @override
  void dependencies() {
    // Inject dependencies
    Get.lazyPut<SavedJobsController>(
      () => SavedJobsController(
        jobService: Get.find<JobService>(),
        logger: Get.find<LoggerService>(),
      ),
    );
  }
}
