import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/bindings/activity_log_binding.dart';
import 'package:next_gen/app/modules/admin/bindings/admin_dashboard_binding.dart';
import 'package:next_gen/app/modules/admin/bindings/content_moderation_binding.dart';
import 'package:next_gen/app/modules/admin/bindings/system_config_binding.dart';
import 'package:next_gen/app/modules/admin/bindings/user_management_binding.dart';
import 'package:next_gen/app/modules/admin/views/activity_log_view.dart';
import 'package:next_gen/app/modules/admin/views/admin_dashboard_view.dart';
import 'package:next_gen/app/modules/admin/views/content_moderation_view.dart';
import 'package:next_gen/app/modules/admin/views/system_config_view.dart';
import 'package:next_gen/app/modules/admin/views/user_management_view.dart';
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
        GetPage<dynamic>(
          name: Routes.userManagement,
          page: () => const UserManagementView(),
          binding: UserManagementBinding(),
          transition: Transition.fadeIn,
        ),
        GetPage<dynamic>(
          name: Routes.moderation,
          page: () => const ContentModerationView(),
          binding: ContentModerationBinding(),
          transition: Transition.fadeIn,
        ),
        GetPage<dynamic>(
          name: Routes.systemConfig,
          page: () => const SystemConfigView(),
          binding: SystemConfigBinding(),
          transition: Transition.fadeIn,
        ),
        GetPage<dynamic>(
          name: Routes.activityLog,
          page: () => const ActivityLogView(),
          binding: ActivityLogBinding(),
          transition: Transition.fadeIn,
        ),
      ];
}
