import 'package:get/get.dart';
import 'package:next_gen/app/modules/onboarding/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // First check if the controller already exists
    if (!Get.isRegistered<OnboardingController>()) {
      // Use put with permanent:true to ensure the controller is not recreated
      Get.put<OnboardingController>(
        OnboardingController(),
        permanent: true,
      );
    }
  }
}
