import 'package:get/get.dart';
import 'package:next_gen/app/modules/job_posting/controllers/job_posting_controller.dart';
import 'package:next_gen/app/modules/job_posting/services/job_posting_service.dart';

/// Binding for job posting module
class JobPostingBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies
    Get
      ..lazyPut<JobPostingService>(JobPostingService.new)
      ..lazyPut<JobPostingController>(JobPostingController.new);
  }
}
