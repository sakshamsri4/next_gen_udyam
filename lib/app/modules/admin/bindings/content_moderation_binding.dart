import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/controllers/content_moderation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the content moderation screen
class ContentModerationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContentModerationController>(
      () => ContentModerationController(
        loggerService: Get.find<LoggerService>(),
      ),
    );
  }
}
