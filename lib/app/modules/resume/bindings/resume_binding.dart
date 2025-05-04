import 'package:get/get.dart';
import 'package:next_gen/app/modules/resume/controllers/resume_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the Resume module
class ResumeBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('ResumeBinding: Registering dependencies');

    // Register ResumeController
    Get.put<ResumeController>(
      ResumeController(),
      permanent: true,
    );

    logger.d('ResumeBinding: Dependencies registered successfully');
  }
}
