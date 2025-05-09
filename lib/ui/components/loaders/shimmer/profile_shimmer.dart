import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// A shimmer loading effect for profile screens
class ProfileShimmer extends StatelessWidget {
  /// Creates a new profile shimmer
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            height: 200.h,
            color: Colors.grey.shade200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile image
                  ShimmerWidget.circular(
                    width: 80.w,
                    height: 80.h,
                  ),
                  SizedBox(height: 16.h),
                  // Name
                  ShimmerWidget.rectangular(
                    width: 150.w,
                    height: 20.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(height: 8.h),
                  // Subtitle
                  ShimmerWidget.rectangular(
                    width: 100.w,
                    height: 16.h,
                    borderRadius: 4.r,
                  ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                ShimmerWidget.rectangular(
                  width: 120.w,
                  height: 24.h,
                  borderRadius: 4.r,
                ),
                SizedBox(height: 16.h),

                // Section content
                ShimmerWidget.rectangular(
                  width: double.infinity,
                  height: 100.h,
                  borderRadius: 8.r,
                ),
                SizedBox(height: 24.h),

                // Section title
                ShimmerWidget.rectangular(
                  width: 150.w,
                  height: 24.h,
                  borderRadius: 4.r,
                ),
                SizedBox(height: 16.h),

                // List items
                ...List.generate(3, (index) => _buildListItem()),
                SizedBox(height: 24.h),

                // Section title
                ShimmerWidget.rectangular(
                  width: 100.w,
                  height: 24.h,
                  borderRadius: 4.r,
                ),
                SizedBox(height: 16.h),

                // Chips
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(
                    6,
                    (index) => ShimmerWidget.rectangular(
                      width: 80.w,
                      height: 32.h,
                      borderRadius: 16.r,
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

  /// Build a list item shimmer
  Widget _buildListItem() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: ShimmerWidget.rectangular(
        width: double.infinity,
        height: 80.h,
        borderRadius: 8.r,
      ),
    );
  }
}
