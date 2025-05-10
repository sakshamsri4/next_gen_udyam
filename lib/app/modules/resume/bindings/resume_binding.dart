import 'package:get/get.dart';
import 'package:next_gen/app/modules/resume/controllers/resume_controller.dart';
import 'package:next_gen/app/modules/resume/services/resume_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the Resume module
class ResumeBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(LoggerService(), permanent: true)
      ..d('ResumeBinding: Registering dependencies')
      ..d('Registering ResumeService')
      ..d('Registering ResumeController');

    // Register services
    Get
      ..lazyPut<ResumeService>(
        () => ResumeService(logger: logger),
      )
      ..put<ResumeController>(
        ResumeController(
          resumeService: Get.find<ResumeService>(),
          logger: logger,
        ),
        permanent: true,
      );
  }
}
