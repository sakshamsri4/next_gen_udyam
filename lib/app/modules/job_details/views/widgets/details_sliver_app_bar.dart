import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/buttons/custom_save_button.dart';

/// A sliver app bar for the job details screen
class DetailsSliverAppBar extends StatelessWidget {
  /// Creates a details sliver app bar
  const DetailsSliverAppBar({
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

    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      backgroundColor:
          isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
      leading: IconButton(
        icon: HeroIcon(
          HeroIcons.arrowLeft,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () => Get.back<dynamic>(),
      ),
      actions: [
        Obx(() {
          return CustomSaveButton(
            isLiked: controller.isJobSaved.value,
            onTap: controller.isSaveLoading.value
                ? null
                : ({required bool isLiked}) async {
                    await controller.toggleSaveJob();
                    return controller.isJobSaved.value;
                  },
            size: 24.w,
            color: isDarkMode ? Colors.white : Colors.black,
          );
        }),
        SizedBox(width: 16.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [
                      AppTheme.darkSurface,
                      AppTheme.darkBackground,
                    ]
                  : [
                      AppTheme.lightSurface,
                      AppTheme.lightBackground,
                    ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h), // Space for app bar
                _buildCompanyLogo(job.logoUrl, isDarkMode),
                SizedBox(height: 16.h),
                Text(
                  job.company,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(String? logoUrl, bool isDarkMode) {
    if (logoUrl == null || logoUrl.isEmpty) {
      // Fallback to company initial if no logo
      return Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppTheme.electricBlue.withAlpha(51)
              : AppTheme.electricBlue.withAlpha(30),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            job.company.isNotEmpty ? job.company[0].toUpperCase() : 'C',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? AppTheme.brightElectricBlue
                  : AppTheme.electricBlue,
            ),
          ),
        ),
      );
    }

    // Display company logo
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 26), // 0.1 * 255 ≈ 26
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.w),
        child: Image.network(
          logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback on error
            return Center(
              child: Text(
                job.company.isNotEmpty ? job.company[0].toUpperCase() : 'C',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.electricBlue,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
