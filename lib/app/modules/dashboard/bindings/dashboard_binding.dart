import 'package:get/get.dart';

import 'package:next_gen/app/modules/dashboard/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(
      DashboardController(),
      permanent: true,
    );
  }
}
