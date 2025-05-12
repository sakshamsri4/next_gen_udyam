import 'package:get/get.dart';
import 'package:next_gen/app/modules/employer/controllers/employer_dashboard_controller.dart';

/// Binding for the employer dashboard screen
class EmployerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployerDashboardController>(EmployerDashboardController.new);
  }
}
