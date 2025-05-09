import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// A shimmer loading effect for job lists
class JobListShimmer extends StatelessWidget {
  /// Creates a new job list shimmer
  const JobListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: 5,
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // 0.05 opacity
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Company logo
              ShimmerWidget.circular(
                width: 40.w,
                height: 40.h,
              ),
              SizedBox(width: 12.w),
              // Company name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.rectangular(
                      width: 120.w,
                      height: 16.h,
                      borderRadius: 4.r,
                    ),
                    SizedBox(height: 4.h),
                    ShimmerWidget.rectangular(
                      width: 80.w,
                      height: 12.h,
                      borderRadius: 4.r,
                    ),
                  ],
                ),
              ),
              // Bookmark icon
              ShimmerWidget.circular(
                width: 24.w,
                height: 24.h,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Job title
          ShimmerWidget.rectangular(
            width: 200.w,
            height: 20.h,
            borderRadius: 4.r,
          ),
          SizedBox(height: 8.h),

          // Job details
          Row(
            children: [
              ShimmerWidget.rectangular(
                width: 80.w,
                height: 16.h,
                borderRadius: 4.r,
              ),
              SizedBox(width: 16.w),
              ShimmerWidget.rectangular(
                width: 100.w,
                height: 16.h,
                borderRadius: 4.r,
              ),
              SizedBox(width: 16.w),
              ShimmerWidget.rectangular(
                width: 60.w,
                height: 16.h,
                borderRadius: 4.r,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Job description
          ShimmerWidget.rectangular(
            width: double.infinity,
            height: 40.h,
            borderRadius: 4.r,
          ),
        ],
      ),
    );
  }
}
