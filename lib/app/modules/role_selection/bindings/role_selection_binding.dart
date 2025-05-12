import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/role_selection/controllers/role_selection_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the role selection module
class RoleSelectionBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }

    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }

    // Register RoleSelectionController
    Get.lazyPut<RoleSelectionController>(RoleSelectionController.new);

    // Log registrations
    Get.find<LoggerService>()
      ..i('RoleSelectionBinding: Dependencies registered')
      ..i('RoleSelectionController registered');
  }
}
