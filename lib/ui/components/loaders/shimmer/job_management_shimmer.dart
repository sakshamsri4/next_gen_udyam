import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// A shimmer effect for job management loading state
class JobManagementShimmer extends StatelessWidget {
  /// Creates a job management shimmer
  const JobManagementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildJobCardShimmer(),
        );
      },
    );
  }

  /// Build a job card shimmer
  Widget _buildJobCardShimmer() {
    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // 0.05 opacity
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget.rectangular(
                width: 200.w,
                height: 20.h,
                borderRadius: 4.r,
              ),
              ShimmerWidget.rectangular(
                width: 60.w,
                height: 20.h,
                borderRadius: 12.r,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Job type and location
          Row(
            children: [
              ShimmerWidget.rectangular(
                width: 120.w,
                height: 16.h,
                borderRadius: 4.r,
              ),
              SizedBox(width: 16.w),
              ShimmerWidget.rectangular(
                width: 100.w,
                height: 16.h,
                borderRadius: 4.r,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Posted date and application count
          Row(
            children: [
              ShimmerWidget.rectangular(
                width: 100.w,
                height: 14.h,
                borderRadius: 4.r,
              ),
              SizedBox(width: 16.w),
              ShimmerWidget.rectangular(
                width: 120.w,
                height: 14.h,
                borderRadius: 4.r,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: ShimmerWidget.circular(
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
