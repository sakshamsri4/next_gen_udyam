import 'package:get/get.dart';
import 'package:next_gen/app/modules/employee/controllers/employee_home_controller.dart';

/// Binding for the employee home screen
class EmployeeHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeHomeController>(EmployeeHomeController.new);
  }
}
