import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom tab bar with CRED-style design
class CustomTabBar extends StatelessWidget {
  /// Creates a new CustomTabBar
  const CustomTabBar({
    required this.controller,
    required this.tabs,
    this.onTap,
    this.isScrollable = false,
    super.key,
  });

  /// The tab controller
  final TabController controller;

  /// The tabs to display
  final List<Widget> tabs;

  /// Callback when a tab is tapped
  final ValueChanged<int>? onTap;

  /// Whether the tabs are scrollable
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabBar(
      controller: controller,
      onTap: onTap,
      isScrollable: isScrollable,
      labelStyle: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      labelColor: theme.colorScheme.onPrimary,
      unselectedLabelColor:
          theme.colorScheme.onSurface.withValues(alpha: 179), // 0.7 * 255 ≈ 179
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: theme.colorScheme.primary,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      tabs: tabs,
    );
  }
}

/// A delegate for the sliver persistent header with a tab bar
class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  /// Creates a new SliverTabBarDelegate
  SliverTabBarDelegate(this.tabBar);

  /// The tab bar
  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

/// A custom tab with CRED-style design
class CustomTab extends StatelessWidget {
  /// Creates a new CustomTab
  const CustomTab({
    required this.text,
    this.icon,
    super.key,
  });

  /// The text to display
  final String text;

  /// The icon to display
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18.r),
                  SizedBox(width: 8.w),
                  Text(text),
                ],
              )
            : Text(text),
      ),
    );
  }
}
