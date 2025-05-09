import 'package:get/get.dart';

import 'package:next_gen/app/modules/showcase/controllers/showcase_controller.dart';

class ShowcaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowcaseController>(
      ShowcaseController.new,
    );
  }
}
