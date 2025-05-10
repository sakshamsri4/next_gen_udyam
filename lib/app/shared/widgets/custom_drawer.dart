import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/avatars/custom_avatar.dart';

/// A custom drawer menu with CRED-style design
class CustomDrawer extends StatelessWidget {
  /// Creates a new CustomDrawer
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final authController = Get.find<AuthController>();
    final navigationController = Get.find<NavigationController>();

    return Drawer(
      backgroundColor:
          isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
      elevation: 0,
      child: SafeArea(
        child: Column(
          children: [
            // Header with user info
            _buildHeader(context, authController),

            const Divider(),

            // Navigation items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.house,
                    title: 'Home',
                    onTap: () {
                      navigationController.changeIndex(0);
                      Get.back();
                    },
                    isSelected: navigationController.selectedIndex.value == 0,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.magnifyingGlass,
                    title: 'Search',
                    onTap: () {
                      navigationController.changeIndex(1);
                      Get.back();
                    },
                    isSelected: navigationController.selectedIndex.value == 1,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.bookmark,
                    title: 'Saved Jobs',
                    onTap: () {
                      navigationController.changeIndex(2);
                      Get.back();
                    },
                    isSelected: navigationController.selectedIndex.value == 2,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.fileLines,
                    title: 'Resume',
                    onTap: () {
                      navigationController.changeIndex(3);
                      Get.back();
                    },
                    isSelected: navigationController.selectedIndex.value == 3,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.user,
                    title: 'Profile',
                    onTap: () {
                      navigationController.changeIndex(4);
                      Get.back();
                    },
                    isSelected: navigationController.selectedIndex.value == 4,
                  ),

                  const Divider(),

                  // Additional menu items
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.gear,
                    title: 'Settings',
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.settings);
                      Get.back();
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.circleQuestion,
                    title: 'Help & Support',
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.support);
                      Get.back();
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.circleInfo,
                    title: 'About',
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.about);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),

            // Logout button at the bottom
            Obx(() {
              if (authController.isLoggedIn) {
                return _buildLogoutButton(context, authController);
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthController authController) {
    final theme = Theme.of(context);

    return Obx(() {
      final user = authController.user.value;

      return Container(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const HeroIcon(HeroIcons.xMark),
                onPressed: Get.back,
              ),
            ),

            // User avatar
            if (user != null)
              CustomAvatar(
                imageUrl: user.photoURL ?? '',
                height: 80.r,
                width: 80.r,
              )
            else
              CircleAvatar(
                radius: 40.r,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: HeroIcon(
                  HeroIcons.user,
                  color: theme.colorScheme.primary,
                  size: 40.r,
                ),
              ),

            SizedBox(height: 16.h),

            // User name
            if (user != null)
              Text(
                user.displayName ?? 'User',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              TextButton.icon(
                onPressed: () => Get.toNamed<dynamic>(Routes.login),
                icon: const HeroIcon(HeroIcons.arrowRightOnRectangle),
                label: const Text('Sign In'),
              ),

            // User email
            if (user != null)
              Text(
                user.email ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.7),
        size: 20.r,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    AuthController authController,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.rightFromBracket,
          color: theme.colorScheme.error,
          size: 20.r,
        ),
        title: Text(
          'Logout',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async {
          Get.back();
          await authController.signOut();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color: theme.colorScheme.error.withOpacity(0.3),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 4.h,
        ),
      ),
    );
  }
}
