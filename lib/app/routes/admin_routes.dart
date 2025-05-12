import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/bindings/admin_dashboard_binding.dart';
import 'package:next_gen/app/modules/admin/views/admin_dashboard_view.dart';
import 'package:next_gen/app/routes/app_pages.dart';

/// Routes specific to admin users
class AdminRoutes {
  /// Private constructor to prevent instantiation
  AdminRoutes._();

  /// Get all admin-specific routes
  static List<GetPage<dynamic>> get routes => [
        GetPage<dynamic>(
          name: Routes.home,
          page: () => const AdminDashboardView(),
          binding: AdminDashboardBinding(),
          transition: Transition.fadeIn,
        ),
        // TODO(developer): Add more admin-specific routes
        // GetPage(
        //   name: Routes.users,
        //   page: () => const AdminUsersView(),
        //   binding: AdminUsersBinding(),
        //   transition: Transition.fadeIn,
        // ),
        // GetPage(
        //   name: Routes.moderation,
        //   page: () => const AdminModerationView(),
        //   binding: AdminModerationBinding(),
        //   transition: Transition.fadeIn,
        // ),
        // GetPage(
        //   name: Routes.settings,
        //   page: () => const AdminSettingsView(),
        //   binding: AdminSettingsBinding(),
        //   transition: Transition.fadeIn,
        // ),
      ];
}
