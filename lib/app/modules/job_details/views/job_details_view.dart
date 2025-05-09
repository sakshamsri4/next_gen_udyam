import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/body.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/details_bottom_nav_bar.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/details_sliver_app_bar.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/loaders/shimmer/job_details_shimmer.dart';

/// Job details screen
class JobDetailsView extends GetView<JobDetailsController> {
  /// Creates a job details view
  const JobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: Obx(() {
        // Show error message
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back<dynamic>(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        // Show loading state
        if (controller.isLoading.value || controller.job.value == null) {
          return const JobDetailsShimmer();
        }

        // Show job details
        return Stack(
          children: [
            // Main content
            CustomScrollView(
              slivers: [
                // App bar
                DetailsSliverAppBar(job: controller.job.value!),

                // Body
                const SliverToBoxAdapter(
                  child: JobDetailsBody(),
                ),
              ],
            ),

            // Bottom navigation bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DetailsBottomNavBar(job: controller.job.value!),
            ),
          ],
        );
      }),
    );
  }
}
