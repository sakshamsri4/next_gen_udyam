import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/company_profile/controllers/company_profile_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';
import 'package:next_gen/ui/components/loaders/shimmer/job_list_shimmer.dart';

/// The Jobs tab for the company profile
class JobsTab extends GetView<CompanyProfileController> {
  /// Creates a new Jobs tab
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.isJobsLoading.value) {
        return const JobListShimmer();
      }

      if (controller.jobs.isEmpty) {
        return _buildEmptyState(theme);
      }

      return ListView.builder(
        padding: EdgeInsets.all(16.r),
        itemCount: controller.jobs.length,
        itemBuilder: (context, index) {
          final job = controller.jobs[index];
          final jobId = job['id']?.toString() ?? '';
          final jobTitle = job['title']?.toString() ?? '';
          final jobLocation = job['location']?.toString() ?? '';
          final jobType = job['jobType']?.toString() ?? '';
          final jobDescription = job['description']?.toString() ?? '';
          final isRemote = job['isRemote'] == true;
          final postedDate = job['postedDate'] is int
              ? (job['postedDate'] as int)
              : DateTime.now().millisecondsSinceEpoch;

          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: CustomJobCard(
              avatar: controller.profile.value?.logoURL ?? '',
              companyName: controller.profile.value?.name ?? '',
              publishTime: DateTime.fromMillisecondsSinceEpoch(postedDate)
                  .toIso8601String(),
              jobPosition: jobTitle,
              workplace: isRemote ? 'Remote' : 'On-site',
              location: jobLocation,
              employmentType: jobType,
              actionIcon: HeroIcons.bookmark,
              description: jobDescription,
              onTap: () => Get.toNamed<dynamic>(
                Routes.jobs,
                arguments: jobId,
              ),
              onAvatarTap: () {},
              onActionTap: ({required bool isLiked}) =>
                  Future<bool?>.value(false),
            ),
          );
        },
      );
    });
  }

  /// Build the empty state
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64.r,
              color: theme.colorScheme.primary.withAlpha(128),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Jobs Posted',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "This company hasn't posted any jobs yet.",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(179),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
