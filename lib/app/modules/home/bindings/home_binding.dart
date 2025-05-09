import 'package:get/get.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';

/// Binding for the home module
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register the job service
    Get.lazyPut<JobService>(
      JobService.new,
    );

    // Register the home controller
    Get.lazyPut<HomeController>(
      HomeController.new,
    );
  }
}
