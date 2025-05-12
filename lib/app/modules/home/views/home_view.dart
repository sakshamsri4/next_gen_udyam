import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/app/modules/home/views/employee_home_view.dart';
import 'package:next_gen/app/modules/home/views/widgets/body.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_bottom_nav.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
import 'package:next_gen/ui/components/avatars/custom_avatar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;
  late final NavigationController navigationController;

  // Create a unique scaffold key for this view
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Get the controllers
    controller = Get.find<HomeController>();

    // Get or register NavigationController
    if (Get.isRegistered<NavigationController>()) {
      navigationController = Get.find<NavigationController>();
    } else {
      navigationController = Get.put(NavigationController(), permanent: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the selected index to the Home tab (index 0)
    // This is safer than using initState with a direct value assignment
    navigationController.selectedIndex.value = 0;
  }

  /// Get a non-empty photo URL or empty string
  String _getNonEmptyPhotoUrl(AuthController authController) {
    final photoURL = authController.user.value?.photoURL;
    return (photoURL != null && photoURL.isNotEmpty) ? photoURL : '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();
    final themeController = ThemeController.to;

    // Check user role
    return Obx(() {
      final userRole = navigationController.userRole.value;

      // If user is an employee, show the employee home view
      if (userRole == UserType.employee) {
        return const EmployeeHomeView();
      }

      // Otherwise, show the default home view
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme.scaffoldBackgroundColor,
        bottomNavigationBar: const RoleBasedBottomNav(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Job Finder',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 8.w, top: 8.w),
            child: GestureDetector(
              onTap: () {
                // Open drawer or navigate to profile
                Get.toNamed<dynamic>(Routes.profile);
              },
              child: Obx(
                () => authController.isLoggedIn
                    ? CustomAvatar(
                        imageUrl: _getNonEmptyPhotoUrl(authController),
                        height: 46.h,
                      )
                    : CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.primary.withAlpha(25),
                        child: HeroIcon(
                          HeroIcons.user,
                          color: theme.colorScheme.primary,
                        ),
                      ),
              ),
            ),
          ),
          actions: [
            // Debug button for testing job details
            IconButton(
              icon: const Icon(Icons.bug_report),
              tooltip: 'Test Job Details',
              onPressed: () {
                Get.toNamed<dynamic>('${Routes.jobs}/test');
              },
            ),
            IconButton(
              icon: Obx(
                () => Icon(
                  themeController.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onPressed: themeController.toggleTheme,
            ),
          ],
        ),
        body: const Body(),
      );
    });
  }
}
