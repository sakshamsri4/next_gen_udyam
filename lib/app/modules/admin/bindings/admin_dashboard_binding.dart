import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/controllers/admin_dashboard_controller.dart';

/// Binding for the admin dashboard screen
class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(AdminDashboardController.new);
  }
}
