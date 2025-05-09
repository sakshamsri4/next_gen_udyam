import 'package:get/get.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';

/// Binding for the home module
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies
    Get
      ..lazyPut<JobService>(JobService.new)
      ..lazyPut<HomeController>(HomeController.new);
  }
}
