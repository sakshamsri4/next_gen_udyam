import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer loading effect for the saved jobs screen
class SavedJobsShimmer extends StatelessWidget {
  /// Creates a saved jobs shimmer
  const SavedJobsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Base color and highlight color for shimmer effect
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 5, // Show 5 shimmer items
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildJobCardShimmer(),
          );
        },
      ),
    );
  }

  /// Build a job card shimmer
  Widget _buildJobCardShimmer() {
    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with avatar and bookmark
          Row(
            children: [
              // Avatar
              Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              // Company name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14.h,
                      width: 120.w,
                      color: Colors.white,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 12.h,
                      width: 80.w,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              // Bookmark icon
              Container(
                width: 24.w,
                height: 24.w,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Job title
          Container(
            height: 16.h,
            width: 200.w,
            color: Colors.white,
          ),
          SizedBox(height: 12.h),
          // Job details row
          Row(
            children: [
              Container(
                height: 12.h,
                width: 60.w,
                color: Colors.white,
              ),
              SizedBox(width: 16.w),
              Container(
                height: 12.h,
                width: 80.w,
                color: Colors.white,
              ),
              SizedBox(width: 16.w),
              Container(
                height: 12.h,
                width: 70.w,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
