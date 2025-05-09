import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/app/modules/home/views/widgets/section_header.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';
import 'package:next_gen/ui/components/loaders/custom_lottie.dart';
import 'package:next_gen/ui/components/loaders/shimmer/recent_jobs_shimmer.dart';

/// A list of recent jobs
class RecentJobs extends GetWidget<HomeController> {
  /// Creates a recent jobs list
  const RecentJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Recent Jobs',
          actionTitle: 'See All',
          onActionTap: () => Get.toNamed<dynamic>(Routes.search),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.isRecentJobsLoading) {
            return const RecentJobsShimmer();
          }

          if (controller.recentJobsError.isNotEmpty) {
            return Center(
              child: Text(
                controller.recentJobsError,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (controller.recentJobs.isEmpty) {
            return CustomLottie(
              title: 'No jobs found with this category',
              asset: 'assets/empty.json',
              assetHeight: 200.h,
              padding: EdgeInsets.zero,
            );
          }

          return ListView.builder(
            itemCount: controller.recentJobs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final job = controller.recentJobs[index];
              return CustomJobCard(
                avatar: job.logoUrl ?? '',
                companyName: job.company,
                publishTime: job.postedDate.toIso8601String(),
                jobPosition: job.title,
                workplace: job.isRemote ? 'Remote' : 'On-site',
                location: job.location,
                employmentType: job.jobType,
                actionIcon: HeroIcons.bookmark,
                isSaved: controller.isJobSaved(job.id),
                description: job.description,
                onTap: () => Get.toNamed<dynamic>(
                  Routes.jobs,
                  arguments: job.id,
                ),
                onAvatarTap: () => Get.toNamed<dynamic>(
                  Routes.profile,
                  arguments: job.company,
                ),
                onActionTap: (isSaved) =>
                    controller.toggleSaveJob(isSaved, job.id),
              );
            },
          );
        }),
      ],
    );
  }
}
