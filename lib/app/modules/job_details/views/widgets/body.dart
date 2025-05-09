import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/about_the_employer.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/header.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/similar_jobs.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Body widget for job details
class JobDetailsBody extends StatelessWidget {
  /// Creates a job details body
  const JobDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobDetailsController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Obx(() {
      final job = controller.job.value;

      if (job == null) {
        return const SizedBox.shrink();
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job header
            JobDetailsHeader(job: job),

            // Divider
            Divider(
              color: isDarkMode
                  ? Colors.white.withAlpha(30)
                  : Colors.black.withAlpha(30),
            ),

            // Job description
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description title
                  Text(
                    'Job Description',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Description text
                  Text(
                    job.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Requirements section
            if (job.requirements.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Requirements title
                    Text(
                      'Requirements',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Requirements list
                    ...job.requirements.map((requirement) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6.h),
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppTheme.electricBlue
                                    : AppTheme.electricBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                requirement,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            // Responsibilities section
            if (job.responsibilities.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Responsibilities title
                    Text(
                      'Responsibilities',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Responsibilities list
                    ...job.responsibilities.map((responsibility) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6.h),
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppTheme.neonGreen
                                    : AppTheme.neonGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                responsibility,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            // Benefits section
            if (job.benefits.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Benefits title
                    Text(
                      'Benefits',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Benefits list
                    ...job.benefits.map((benefit) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6.h),
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppTheme.neonPink
                                    : AppTheme.neonPink,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                benefit,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            // About the employer section
            AboutTheEmployer(job: job),

            // Similar jobs section
            const SimilarJobs(),

            // Bottom padding for nav bar
            SizedBox(height: 80.h),
          ],
        ),
      );
    });
  }
}
