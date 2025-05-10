import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/app/modules/home/views/widgets/body.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
import 'package:next_gen/ui/components/avatars/custom_avatar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                      backgroundColor: theme.colorScheme.primary.withAlpha(25),
                      child: HeroIcon(
                        HeroIcons.user,
                        color: theme.colorScheme.primary,
                      ),
                    ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Obx(
              () => Icon(
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: theme.colorScheme.onSurface,
              ),
            ),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: const Body(),
    );
  }
}
