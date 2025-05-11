import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/job_details/controllers/job_details_controller.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A simplified test view for job details to diagnose loading issues
class TestJobDetailsView extends StatelessWidget {
  /// Creates a test job details view
  const TestJobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    print('TestJobDetailsView: Building view');

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get the controller
    final controller = Get.find<JobDetailsController>();

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Test Job Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back<dynamic>(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Force reload with a test job
              print('Creating test job model');
              final testJob = JobModel(
                id: 'test_job_id',
                title: 'Test Job',
                company: 'Test Company',
                location: 'Test Location',
                description: 'This is a test job description.',
                salary: 50000,
                postedDate: DateTime.now(),
              );
              controller.job.value = testJob;
              controller.isLoading.value = false;
              controller.errorMessage.value = '';
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              // Force exit loading state
              controller.isLoading.value = false;
              controller.errorMessage.value = 'Loading cancelled by user';
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              final statusText = controller.isLoading.value
                  ? 'Loading...'
                  : controller.errorMessage.isNotEmpty
                      ? 'Error: ${controller.errorMessage.value}'
                      : controller.job.value != null
                          ? 'Job loaded: ${controller.job.value!.title}'
                          : 'No job data';

              return Text(
                statusText,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Try to load a job with a test ID
                controller.loadJobDetails('test_job_id');
              },
              child: const Text('Load Test Job'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Cancel loading
                controller.isLoading.value = false;
              },
              child: const Text('Cancel Loading'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.back<dynamic>(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
