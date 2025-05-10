import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// A shimmer effect for featured job cards
///
/// This widget displays a shimmer effect for featured job cards
/// while they are loading
class FeaturedJobShimmer extends StatelessWidget {
  /// Creates a featured job shimmer
  const FeaturedJobShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: ShimmerWidget(
        width: double.infinity,
        height: 170.h,
      ),
    );
  }
}
