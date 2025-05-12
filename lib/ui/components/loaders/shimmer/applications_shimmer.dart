import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading effect for applications view
class ApplicationsShimmer extends StatelessWidget {
  /// Constructor
  const ApplicationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter tabs shimmer
            _buildFilterTabsShimmer(),
            SizedBox(height: 24.h),

            // Application cards shimmer
            ...List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildApplicationCardShimmer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build filter tabs shimmer
  Widget _buildFilterTabsShimmer() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5,
          (index) => Container(
            margin: EdgeInsets.only(right: 8.w),
            width: 100.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ),
    );
  }

  /// Build application card shimmer
  Widget _buildApplicationCardShimmer() {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200.w,
                  height: 20.h,
                  color: Colors.white,
                ),
                Container(
                  width: 80.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Company
            Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.h,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 150.w,
                  height: 16.h,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Date
            Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.h,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 120.w,
                  height: 16.h,
                  color: Colors.white,
                ),
              ],
            ),

            // Divider
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Container(
                width: double.infinity,
                height: 1.h,
                color: Colors.white,
              ),
            ),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 100.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 100.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
