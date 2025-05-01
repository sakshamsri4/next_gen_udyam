import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Use permanent binding to prevent controller disposal issues
    // when navigating between auth screens
    Get.put<AuthController>(
      AuthController(),
      permanent: true,

    );
  }
}
