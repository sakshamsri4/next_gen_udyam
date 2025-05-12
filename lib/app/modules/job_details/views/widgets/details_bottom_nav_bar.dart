import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/apply_dialog.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/buttons/cred_button.dart';
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26), // 0.1 * 255 ≈ 26
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
            return CredButton(
              title: 'Already Applied',
              onTap: () async {},
              backgroundColor: Colors.grey,
              height: 56.h,
            );
          }

          // Show apply button
          return Row(
            children: [
              // Save button
              _buildActionButton(
                icon: Obx(
                  () => HeroIcon(
                    controller.isJobSaved.value
                        ? HeroIcons.heart
                        : HeroIcons.heart,
                    color: RoleThemes.employeePrimary,
                    style: controller.isJobSaved.value
                        ? HeroIconStyle.solid
                        : HeroIconStyle.outline,
                  ),
                ),
                onPressed: controller.toggleSaveJob,
                tooltip:
                    controller.isJobSaved.value ? 'Unsave Job' : 'Save Job',
              ),

              // Share button
              _buildActionButton(
                icon: const HeroIcon(
                  HeroIcons.share,
                  color: RoleThemes.employeePrimary,
                ),
                onPressed: () => _shareJob(context),
                tooltip: 'Share Job',
              ),

              SizedBox(width: 8.w),

              // Apply button
              Expanded(
                child: CredButton(
                  title: 'Apply Now',
                  onTap: () async {
                    // Show application dialog
                    Get.dialog<dynamic>(
                      ApplyDialog(job: job),
                    );
                  },
                  backgroundColor: RoleThemes.employeePrimary,
                  height: 56.h,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// Build an action button
  Widget _buildActionButton({
    required Widget icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      width: 48.h,
      height: 48.h,
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: RoleThemes.employeePrimary.withOpacity(0.3), // 0.3 * 255 ≈ 77
          width: 1.5,
        ),
      ),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: onPressed,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }

  /// Share job
  void _shareJob(BuildContext context) {
    final jobTitle = job.title;
    final companyName = job.company;
    final shareText =
        'Check out this job: $jobTitle at $companyName\n\nApply now on Next Gen Udyam!';
  }
}
