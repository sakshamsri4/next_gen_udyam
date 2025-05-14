import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/controllers/activity_log_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the activity log screen
class ActivityLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityLogController>(
      () => ActivityLogController(
        loggerService: Get.find<LoggerService>(),
      ),
    );
  }
}
