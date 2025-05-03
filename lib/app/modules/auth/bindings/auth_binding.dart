import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/services/logger_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Get or register logger service
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : Get.put(serviceLocator<LoggerService>(), permanent: true)
      ..d('AuthBinding: Registering dependencies');

    // Register AuthService if not already registered
    if (!Get.isRegistered<AuthService>()) {
      logger.d('AuthBinding: Registering AuthService');

      // Try to get AuthService from service locator, or create a new instance
      AuthService authService;
      try {
        authService = serviceLocator<AuthService>();
        logger.d('AuthBinding: Got AuthService from service locator');
      } catch (e) {
        // If service locator doesn't have AuthService, create a new instance
        logger.w(
          'AuthService not found in service locator, '
          'creating new instance',
        );
        authService = AuthService();

        // Also register it with the service locator for future use
        try {
          serviceLocator.registerSingleton<AuthService>(authService);
          logger.d('AuthBinding: Registered AuthService with service locator');
        } catch (e) {
          logger.e(
            'Failed to register AuthService with service locator',
            e,
          );
          // Continue even if registration fails
        }
      }

      // Register with GetX
      Get.put<AuthService>(
        authService,
        permanent: true,
      );
    }

    // Use permanent binding to prevent controller disposal issues
    // when navigating between auth screens
    logger.d('AuthBinding: Registering AuthController');
    Get.put<AuthController>(
      AuthController(),
      permanent: true,
    );

    logger.d('AuthBinding: Dependencies registered successfully');
  }
}
