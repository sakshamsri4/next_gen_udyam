import 'package:get/get.dart';
import 'package:next_gen/app/modules/employer_analytics/controllers/employer_analytics_controller.dart';
import 'package:next_gen/app/modules/employer_analytics/services/employer_analytics_service.dart';

/// Binding for employer analytics module
class EmployerAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies
    Get
      ..lazyPut<EmployerAnalyticsService>(EmployerAnalyticsService.new)
      ..lazyPut<EmployerAnalyticsController>(EmployerAnalyticsController.new);
  }
}
