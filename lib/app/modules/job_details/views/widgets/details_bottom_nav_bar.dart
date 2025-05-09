import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/apply_dialog.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/buttons/custom_button.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// Bottom navigation bar for job details
class DetailsBottomNavBar extends StatelessWidget {
  /// Creates a details bottom navigation bar
  const DetailsBottomNavBar({
    required this.job,
    super.key,
  });

  /// The job model
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobDetailsController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          // Show loading state
          if (controller.isLoading.value) {
            return ShimmerWidget(
              width: double.infinity,
              height: 56.h,
            );
          }

          // Show applied state
          if (controller.hasUserApplied.value) {
            return CustomButton(
              title: 'Already Applied',
              onTap: () async {},
              backgroundColor: Colors.grey,
              height: 56.h,
            );
          }

          // Show apply button
          return CustomButton.primary(
            title: 'Apply Now',
            onTap: () async {
              // Show application dialog
              Get.dialog<dynamic>(
                ApplyDialog(job: job),
              );
            },
          );
        }),
      ),
    );
  }
}
