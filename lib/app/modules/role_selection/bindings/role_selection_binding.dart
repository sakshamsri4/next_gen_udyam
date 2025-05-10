import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/role_selection/controllers/role_selection_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Binding for the role selection module
class RoleSelectionBinding extends Bindings {
  @override
  void dependencies() {
    // Get logger service
    final logger = Get.find<LoggerService>();
    logger.i('RoleSelectionBinding: Registering dependencies');

    // Ensure AuthController is registered
    if (!Get.isRegistered<AuthController>()) {
      logger.i('RoleSelectionBinding: Registering AuthController');
      Get.put(AuthController(), permanent: true);
    }

    // Ensure AuthService is registered
    if (!Get.isRegistered<AuthService>()) {
      logger.i('RoleSelectionBinding: Registering AuthService');
      Get.put(AuthService(), permanent: true);
    }

    // Register RoleSelectionController
    logger.i('RoleSelectionBinding: Registering RoleSelectionController');
    Get.lazyPut<RoleSelectionController>(RoleSelectionController.new);
  }
}
