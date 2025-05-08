import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shimmer_widget.dart';

/// A shimmer effect for job details screen
///
/// This widget displays a shimmer effect for the job details screen
/// while it is loading
class JobDetailsShimmer extends StatelessWidget {
  /// Creates a job details shimmer
  const JobDetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          ShimmerWidget(
            width: double.infinity,
            height: 225.h,
            radius: 0,
          ),
          SizedBox(height: 20.h),
          
          // Job description shimmer
          ShimmerWidget(
            width: double.infinity,
            height: 300.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          
          // About the employer shimmer
          ShimmerWidget(
            width: double.infinity,
            height: 100.h,
            margin: EdgeInsets.all(16.w),
          ),
          
          // Similar jobs title shimmer
          ShimmerWidget(
            width: 200.w,
            height: 20.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          SizedBox(height: 16.h),
          
          // Similar jobs shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      2,
                      (index) => ShimmerWidget(
                        width: 0.65.sw,
                        height: 200.h,
                        margin: EdgeInsets.only(right: 16.w),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
