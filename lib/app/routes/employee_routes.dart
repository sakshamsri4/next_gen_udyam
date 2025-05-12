import 'package:get/get.dart';
import 'package:next_gen/app/modules/applications/bindings/applications_binding.dart';
import 'package:next_gen/app/modules/applications/views/applications_view.dart';
import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/modules/auth/views/profile_view.dart';
import 'package:next_gen/app/modules/employee/bindings/employee_home_binding.dart';
import 'package:next_gen/app/modules/employee/bindings/jobs_binding.dart';
import 'package:next_gen/app/modules/employee/views/discover_view.dart';
import 'package:next_gen/app/modules/employee/views/jobs_view.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/bindings/navigation_binding.dart';

/// Routes specific to employee users
class EmployeeRoutes {
  /// Private constructor to prevent instantiation
  EmployeeRoutes._();

  /// Get all employee-specific routes
  static List<GetPage<dynamic>> get routes => [
        // Discover tab (Home)
        GetPage<dynamic>(
          name: Routes.home,
          page: () => const DiscoverView(),
          binding: EmployeeHomeBinding(),
          bindings: [NavigationBinding()],
          transition: Transition.fadeIn,
        ),

        // Jobs tab (combines Search and Saved)
        GetPage<dynamic>(
          name: Routes.search,
          page: JobsView.new,
          binding: JobsBinding(),
          bindings: [NavigationBinding()],
          transition: Transition.fadeIn,
        ),

        // Applications tab
        GetPage<dynamic>(
          name: Routes.applications,
          page: ApplicationsView.new,
          binding: ApplicationsBinding(),
          bindings: [NavigationBinding()],
          transition: Transition.fadeIn,
        ),

        // Profile tab
        GetPage<dynamic>(
          name: Routes.profile,
          page: () => const ProfileView(),
          binding: AuthBinding(),
          bindings: [NavigationBinding()],
          transition: Transition.fadeIn,
        ),
      ];
}
