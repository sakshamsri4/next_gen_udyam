import 'package:get/get.dart';
import 'package:next_gen/app/modules/customer_profile/controllers/customer_profile_controller.dart';
import 'package:next_gen/app/modules/customer_profile/services/customer_profile_service.dart';

/// Binding for the customer profile module
class CustomerProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Register the customer profile service and controller
    Get
      ..lazyPut<CustomerProfileService>(CustomerProfileService.new)
      ..lazyPut<CustomerProfileController>(CustomerProfileController.new);
  }
}
