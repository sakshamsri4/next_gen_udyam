import 'package:get/get.dart';
import 'package:next_gen/app/modules/company_profile/controllers/company_profile_controller.dart';
import 'package:next_gen/app/modules/company_profile/services/company_profile_service.dart';

/// Binding for the company profile module
class CompanyProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Register the company profile service and controller
    Get
      ..lazyPut<CompanyProfileService>(CompanyProfileService.new)
      ..lazyPut<CompanyProfileController>(CompanyProfileController.new);
  }
}
