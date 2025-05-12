import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/body.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/details_bottom_nav_bar.dart';
import 'package:next_gen/app/modules/job_details/views/widgets/details_sliver_app_bar.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/ui/components/loaders/shimmer/job_details_shimmer.dart';

/// Job details screen
class JobDetailsView extends GetView<JobDetailsController> {
  /// Creates a job details view
  const JobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get logger service
    final logger = Get.find<LoggerService>()
      ..d('JobDetailsView: Building view');

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Start a timer to force exit loading state if it takes too long
    Future.delayed(const Duration(seconds: 5), () {
      if (controller.isLoading.value) {
        logger.w('JobDetailsView: Force exiting loading state after timeout');
        controller.isLoading.value = false;
        if (controller.job.value == null) {
          controller.errorMessage.value =
              'Loading timed out. Please try again.';
        }
      }
    });

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Job Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Use NavigationController to go back properly
            Get.find<NavigationController>().navigateBack();
          },
        ),
      ),
      body: Obx(() {
        logger.d(
            'JobDetailsView: Rebuilding with isLoading=${controller.isLoading.value}, '
            'hasError=${controller.errorMessage.isNotEmpty}, '
            'hasJob=${controller.job.value != null}');

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
                  onPressed: () =>
                      Get.find<NavigationController>().navigateBack(),
                  child: const Text('Go Back'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Try to reload if we have a job ID
                    final jobId = Get.arguments as String?;
                    if (jobId != null) {
                      controller.errorMessage.value = '';
                      controller.loadJobDetails(jobId);
                    }
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Show loading state with a timeout
        if (controller.isLoading.value) {
          return Stack(
            children: [
              const JobDetailsShimmer(),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Force exit loading state
                      controller.isLoading.value = false;
                      controller.errorMessage.value =
                          'Loading cancelled by user';
                    },
                    child: const Text('Cancel Loading'),
                  ),
                ),
              ),
            ],
          );
        }

        // Check if job data is available
        if (controller.job.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Job data not available',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () =>
                      Get.find<NavigationController>().navigateBack(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        // Show job details
        return Scaffold(
          backgroundColor:
              isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
          body: CustomScrollView(
            slivers: [
              // App bar
              DetailsSliverAppBar(job: controller.job.value!),

              // Body
              const SliverToBoxAdapter(
                child: JobDetailsBody(),
              ),
            ],
          ),
          bottomNavigationBar: DetailsBottomNavBar(job: controller.job.value!),
        );
      }),
    );
  }
}
