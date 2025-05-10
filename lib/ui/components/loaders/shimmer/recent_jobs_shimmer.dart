import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// A shimmer effect for recent job cards
///
/// This widget displays a shimmer effect for recent job cards
/// while they are loading
class RecentJobsShimmer extends StatelessWidget {
  /// Creates a recent jobs shimmer
  const RecentJobsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 16.w),
        child: ShimmerWidget(
          width: double.infinity,
          height: 200.h,
        ),
      ),
    );
  }
}
