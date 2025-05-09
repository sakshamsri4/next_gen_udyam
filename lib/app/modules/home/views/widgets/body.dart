import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/app/modules/home/views/widgets/chips_list.dart';
import 'package:next_gen/app/modules/home/views/widgets/featured_jobs.dart';
import 'package:next_gen/app/modules/home/views/widgets/recent_jobs.dart';

/// The body of the home screen
class Body extends GetWidget<HomeController> {
  /// Creates the body of the home screen
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: SingleChildScrollView(
        controller: controller.homeScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            const ChipsList(),
            SizedBox(height: 16.h),
            const FeaturedJobs(),
            SizedBox(height: 16.h),
            const RecentJobs(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
