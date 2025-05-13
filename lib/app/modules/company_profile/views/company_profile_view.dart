import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_gen/app/modules/company_profile/controllers/company_profile_controller.dart';
import 'package:next_gen/app/modules/company_profile/views/widgets/about_us_tab.dart';
import 'package:next_gen/app/modules/company_profile/views/widgets/company_profile_sliver_app_bar.dart';
import 'package:next_gen/app/modules/company_profile/views/widgets/jobs_tab.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/ui/components/loaders/shimmer/profile_shimmer.dart';

/// The company profile view
class CompanyProfileView extends GetView<CompanyProfileController> {
  /// Creates a new company profile view
  const CompanyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const UnifiedBottomNav(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ProfileShimmer();
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return Center(
            child: Text(
              'Profile not found',
              style: theme.textTheme.titleLarge,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // Company profile header with app bar
                CompanyProfileSliverAppBar(profile: profile),

                // Tab bar
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: controller.tabController,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      labelColor: theme.colorScheme.onPrimary,
                      unselectedLabelColor: theme.colorScheme.onSurface,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: theme.colorScheme.primary,
                      ),
                      tabs: const [
                        Tab(text: 'About Us'),
                        Tab(text: 'Jobs'),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: controller.tabController,
              children: [
                // About Us tab
                AboutUsTab(profile: profile),

                // Jobs tab
                const JobsTab(),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// A delegate for the sliver persistent header
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
