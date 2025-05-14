import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/controllers/user_management_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the user management screen
class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(
      () => UserManagementController(
        loggerService: Get.find<LoggerService>(),
      ),
    );
  }
}
