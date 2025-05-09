import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/app/modules/home/views/widgets/section_header.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';
import 'package:next_gen/ui/components/loaders/shimmer/featured_job_shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// A carousel of featured jobs
class FeaturedJobs extends GetWidget<HomeController> {
  /// Creates a featured jobs carousel
  const FeaturedJobs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.isFeaturedJobsLoading) {
        return Column(
          children: [
            const SectionHeader(title: 'Featured Jobs'),
            SizedBox(height: 16.h),
            const FeaturedJobShimmer(),
          ],
        );
      }

      if (controller.featuredJobsError.isNotEmpty) {
        return Column(
          children: [
            const SectionHeader(title: 'Featured Jobs'),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                controller.featuredJobsError,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      }

      if (controller.featuredJobs.isEmpty) {
        return Column(
          children: [
            const SectionHeader(title: 'Featured Jobs'),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'No featured jobs available',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        );
      }

      return Column(
        children: [
          const SectionHeader(title: 'Featured Jobs'),
          SizedBox(height: 16.h),
          CarouselSlider.builder(
            itemCount: controller.featuredJobs.length,
            itemBuilder: (context, index, realIndex) {
              final job = controller.featuredJobs[index];
              return CustomJobCard(
                isFeatured: true,
                avatar: job.logoUrl ?? '',
                companyName: job.company,
                publishTime: job.postedDate.toIso8601String(),
                jobPosition: job.title,
                workplace: job.isRemote ? 'Remote' : 'On-site',
                employmentType: job.jobType,
                location: job.location,
                actionIcon: HeroIcons.bookmark,
                isSaved: controller.isJobSaved(job.id),
                onAvatarTap: () => Get.toNamed<dynamic>(
                  Routes.profile,
                  arguments: job.company,
                ),
                onTap: () => Get.toNamed<dynamic>(
                  Routes.jobs,
                  arguments: job.id,
                ),
                onActionTap: (isSaved) =>
                    controller.toggleSaveJob(isSaved, job.id),
              );
            },
            options: CarouselOptions(
              height: 170.h,
              viewportFraction: 1,
              onPageChanged: (index, reason) =>
                  controller.updateCarouselIndex(index),
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => AnimatedSmoothIndicator(
              count: controller.featuredJobs.length,
              activeIndex: controller.carouselIndex,
              effect: ScrollingDotsEffect(
                activeDotColor: theme.colorScheme.primary,
                dotColor: const Color(0xffE4E5E7),
                dotHeight: 6.w,
                dotWidth: 6.w,
              ),
            ),
          ),
        ],
      );
    });
  }
}
