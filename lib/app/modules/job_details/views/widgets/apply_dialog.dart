import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/buttons/custom_button.dart';
import 'package:next_gen/ui/components/fields/custom_text_field.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// Dialog for applying to a job
class ApplyDialog extends StatelessWidget {
  /// Creates an apply dialog
  const ApplyDialog({
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog title
              Text(
                'Apply for ${job.title}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 8.h),

              // Dialog subtitle
              Text(
                'Please fill out the form below to apply for this position at ${job.company}.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              SizedBox(height: 24.h),

              // Application form
              Form(
                child: Column(
                  children: [
                    // Name field
                    CustomTextField(
                      controller: controller.nameController,
                      title: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: HeroIcons.user,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Email field
                    CustomTextField(
                      controller: controller.emailController,
                      title: 'Email',
                      hintText: 'Enter your email address',
                      prefixIcon: HeroIcons.envelope,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Phone field
                    CustomTextField(
                      controller: controller.phoneController,
                      title: 'Phone',
                      hintText: 'Enter your phone number',
                      prefixIcon: HeroIcons.phone,
                      textInputType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Cover letter field
                    CustomTextField(
                      controller: controller.coverLetterController,
                      title: 'Cover Letter',
                      hintText:
                          "Tell us why you're a good fit for this position",
                      prefixIcon: HeroIcons.document,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a cover letter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Submit button
                    Obx(() {
                      if (controller.isApplyLoading.value) {
                        return ShimmerWidget(
                          width: double.infinity,
                          height: 56.h,
                        );
                      }

                      return Row(
                        children: [
                          // Cancel button
                          Expanded(
                            child: CustomButton.outline(
                              title: 'Cancel',
                              onTap: () async {
                                Get.back<dynamic>();
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),

                          // Apply button
                          Expanded(
                            child: CustomButton.primary(
                              title: 'Apply',
                              onTap: controller.applyForJob,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
