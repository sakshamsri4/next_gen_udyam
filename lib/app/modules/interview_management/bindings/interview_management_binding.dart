import 'package:get/get.dart';
import 'package:next_gen/app/modules/interview_management/controllers/interview_management_controller.dart';
import 'package:next_gen/app/modules/interview_management/services/interview_management_service.dart';

/// Binding for interview management module
class InterviewManagementBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies
    Get
      ..lazyPut<InterviewManagementService>(InterviewManagementService.new)
      ..lazyPut<InterviewManagementController>(
        InterviewManagementController.new,
      );
  }
}
