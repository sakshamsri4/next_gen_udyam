import 'package:get/get.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';

/// Binding for the NavigationController
class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NavigationController>(
      NavigationController(),
      permanent: true,
    );
  }
}
