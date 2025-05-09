import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/similar_job_card.dart';
import 'package:next_gen/app/routes/app_pages.dart';

/// Similar jobs section for job details
class SimilarJobs extends StatelessWidget {
  /// Creates a similar jobs section
  const SimilarJobs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobDetailsController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Similar Jobs',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed<dynamic>(Routes.jobs),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    HeroIcon(
                      HeroIcons.chevronRight,
                      size: 16.w,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Similar jobs list
          Obx(() {
            final similarJobs = controller.similarJobs;

            if (similarJobs.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    'No similar jobs found',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similarJobs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final job = similarJobs[index];
                  return SimilarJobCard(
                    job: job,
                    onTap: () => Get.offAndToNamed<dynamic>(
                      Routes.jobs,
                      arguments: job.id,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
