import 'package:get/get.dart';
import 'package:next_gen/app/modules/applicant_review/controllers/applicant_review_controller.dart';
import 'package:next_gen/app/modules/applicant_review/services/applicant_review_service.dart';
import 'package:next_gen/app/modules/job_posting/services/job_posting_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the applicant review module
class ApplicantReviewBinding extends Bindings {
  @override
  void dependencies() {
    // Register services if not already registered
    if (!Get.isRegistered<LoggerService>()) {
      Get.lazyPut<LoggerService>(LoggerService.new);
    }

    if (!Get.isRegistered<JobPostingService>()) {
      Get.lazyPut<JobPostingService>(JobPostingService.new);
    }

    // Register applicant review service and controller
    Get
      ..lazyPut<ApplicantReviewService>(ApplicantReviewService.new)
      ..lazyPut(
        () => ApplicantReviewController(
          applicantReviewService: Get.find<ApplicantReviewService>(),
          jobPostingService: Get.find<JobPostingService>(),
          logger: Get.find<LoggerService>(),
        ),
      );
  }
}
