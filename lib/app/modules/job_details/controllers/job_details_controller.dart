import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';
import 'package:next_gen/app/modules/job_details/services/job_details_service.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the Job Details screen
class JobDetailsController extends GetxController {
  /// Constructor
  JobDetailsController({
    JobDetailsService? jobDetailsService,
    AuthController? authController,
    LoggerService? logger,
  })  : _jobDetailsService = jobDetailsService ?? Get.find<JobDetailsService>(),
        _authController = authController ?? Get.find<AuthController>(),
        _logger = logger ?? Get.find<LoggerService>();

  final JobDetailsService _jobDetailsService;
  final AuthController _authController;
  final LoggerService _logger;

  // Form controllers for job application
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final coverLetterController = TextEditingController();

  // Observable state variables
  final job = Rx<JobModel?>(null);
  final isLoading = true.obs;
  final isApplyLoading = false.obs;
  final isSaveLoading = false.obs;
  final similarJobs = <JobModel>[].obs;
  final companyDetails = Rx<Map<String, dynamic>?>(null);
  final hasUserApplied = false.obs;
  final isJobSaved = false.obs; // New flag to track if job is saved
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _logger.d('JobDetailsController: onInit with arguments: ${Get.arguments}');

    // Get job ID from route arguments - handle different types
    String? jobId;

    if (Get.arguments is String) {
      // If a string is passed, use it as the job ID
      jobId = Get.arguments as String;
      _logger.d('Job ID received as String: $jobId');
    } else if (Get.arguments is JobModel) {
      // If a JobModel is passed, extract the ID and set the job directly
      final jobModel = Get.arguments as JobModel;
      jobId = jobModel.id;
      job.value = jobModel;
      _logger.d('Job received as JobModel: ${jobModel.title}');
    } else if (Get.arguments is Map<String, dynamic>) {
      // If a Map is passed, try to extract the ID
      final argsMap = Get.arguments as Map<String, dynamic>;
      if (argsMap.containsKey('id')) {
        jobId = argsMap['id'] as String;
        _logger.d('Job ID received from Map: $jobId');
      } else {
        _logger.e('Map arguments do not contain an ID key');
      }
    } else {
      _logger.e('Invalid arguments type: ${Get.arguments?.runtimeType}');
    }

    if (jobId != null && jobId.isNotEmpty) {
      _logger.d('Loading job details for ID: $jobId');
      loadJobDetails(jobId);
    } else {
      isLoading.value = false;
      errorMessage.value = 'Job ID not provided';
      _logger.e('Job ID not provided or empty');

      // Show a snackbar to inform the user
      Get.snackbar(
        'Error',
        'Job ID not provided. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    // Pre-fill form fields if user is logged in
    if (_authController.isLoggedIn) {
      final user = _authController.user.value;
      if (user != null) {
        nameController.text = user.displayName ?? '';
        emailController.text = user.email ?? '';
      }
    }
  }

  @override
  void onClose() {
    // Dispose of text controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    coverLetterController.dispose();
    super.onClose();
  }

  /// Load job details by ID
  Future<void> loadJobDetails(String jobId) async {
    try {
      // Print directly to console for debugging
      print('''
===== DEBUG INFO =====
Loading job details for ID: $jobId
Current loading state: ${isLoading.value}
Current job value: ${job.value?.title ?? 'null'}
=====================
''');

      // Reset state
      isLoading.value = true;
      errorMessage.value = '';

      // Create a timeout for the entire operation
      var operationTimedOut = false;
      Future.delayed(const Duration(seconds: 10), () {
        if (isLoading.value) {
          print('Operation timed out after 10 seconds');
          operationTimedOut = true;
          isLoading.value = false;
          errorMessage.value = 'Operation timed out. Please try again.';
        }
      });

      // Get job details
      print('Fetching job data from service for ID: $jobId');
      final jobData = await _jobDetailsService.getJobDetails(jobId);

      // Check if operation was cancelled due to timeout
      if (operationTimedOut) {
        print('Operation was already cancelled due to timeout');
        return;
      }

      if (jobData == null) {
        print('Job not found with ID: $jobId');
        errorMessage.value = 'Job not found';
        isLoading.value = false;
        return;
      }

      print('Job data received: ${jobData.title}');
      job.value = jobData;

      // Get company details - with error handling
      try {
        print('Fetching company details for: ${jobData.company}');
        final company =
            await _jobDetailsService.getCompanyDetails(jobData.company);
        companyDetails.value = company;
        print('Company details received: ${company != null ? 'yes' : 'no'}');
      } catch (e) {
        print('Error fetching company details: $e');
        // Continue with default company details
        companyDetails.value = {
          'name': jobData.company,
          'description': 'Company information unavailable',
        };
      }

      // Get similar jobs - with error handling
      try {
        print('Fetching similar jobs');
        final similar = await _jobDetailsService.getSimilarJobs(
          currentJobId: jobId,
          jobType: jobData.jobType,
          industry: jobData.industry,
        );
        similarJobs.value = similar;
        print('Similar jobs received: ${similar.length}');
      } catch (e) {
        print('Error fetching similar jobs: $e');
        // Continue with empty similar jobs
        similarJobs.value = [];
      }

      // Check if user has applied and if job is saved
      if (_authController.isLoggedIn) {
        final userId = _authController.user.value?.uid;
        if (userId != null) {
          try {
            print('Checking if user $userId has applied for job $jobId');
            // Check if user has applied for the job
            hasUserApplied.value = await _jobDetailsService.hasApplied(
              userId: userId,
              jobId: jobId,
            );
            print('User has applied: ${hasUserApplied.value}');
          } catch (e) {
            print('Error checking application status: $e');
            // Default to not applied
            hasUserApplied.value = false;
          }

          // Check if job is saved
          try {
            print('Checking if job is saved');
            final jobService = Get.find<JobService>();
            final savedJobs = await jobService.getSavedJobs(userId);
            isJobSaved.value = savedJobs.contains(jobId);
            print('Job is saved: ${isJobSaved.value}');
          } catch (e) {
            print('Error checking saved status: $e');
            // Default to not saved
            isJobSaved.value = false;
          }
        }
      }

      print('Job details loading completed successfully');

      // Force UI update by setting isLoading to false
      isLoading.value = false;
    } catch (e) {
      print('ERROR LOADING JOB DETAILS: $e');
      // Create a dummy job for testing if needed
      if (Get.isRegistered<JobModel>()) {
        try {
          print('Creating fallback job model');
          job.value = JobModel(
            id: jobId,
            title: 'Sample Job (Error Loading)',
            company: 'Unknown Company',
            location: 'Unknown Location',
            description:
                'There was an error loading the job details. Please try again later.',
            salary: 0,
            postedDate: DateTime.now(),
          );
        } catch (modelError) {
          print('Error creating fallback model: $modelError');
        }
      }

      errorMessage.value = 'Failed to load job details: $e';
    } finally {
      print('Setting isLoading to false in finally block');
      isLoading.value = false;
    }
  }

  /// Apply for the job
  Future<void> applyForJob() async {
    if (!_authController.isLoggedIn) {
      Get.snackbar(
        'Sign In Required',
        'Please sign in to apply for jobs',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => Get.toNamed<dynamic>(Routes.login),
          child: const Text('Sign In', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    if (job.value == null) {
      Get.snackbar('Error', 'Job details not available');
      return;
    }

    try {
      isApplyLoading.value = true;

      final userId = _authController.user.value?.uid;
      if (userId == null) {
        throw Exception('User ID not available');
      }

      // Prepare application data
      final applicationData = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'coverLetter': coverLetterController.text,
        'jobTitle': job.value!.title,
        'company': job.value!.company,
      };

      // Submit application
      await _jobDetailsService.applyForJob(
        userId: userId,
        jobId: job.value!.id,
        applicationData: applicationData,
      );

      // Update applied status
      hasUserApplied.value = true;

      // Show success message
      // ignore: cascade_invocations
      Get.back<dynamic>(); // Close application dialog
      // ignore: cascade_invocations
      Get.snackbar(
        'Application Submitted',
        'Your application has been submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _logger.e('Error applying for job', e);
      Get.snackbar(
        'Application Failed',
        'Failed to submit your application. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isApplyLoading.value = false;
    }
  }

  /// Toggle save job status
  Future<void> toggleSaveJob() async {
    if (!_authController.isLoggedIn) {
      Get.snackbar(
        'Sign In Required',
        'Please sign in to save jobs',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => Get.toNamed<dynamic>(Routes.login),
          child: const Text('Sign In', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    if (job.value == null) {
      Get.snackbar('Error', 'Job details not available');
      return;
    }

    try {
      isSaveLoading.value = true;

      final userId = _authController.user.value?.uid;
      if (userId == null) {
        throw Exception('User ID not available');
      }

      // Toggle saved status using the current value from isJobSaved
      // Note: We're reusing the JobService from the home module
      final jobService = Get.find<JobService>();
      final result = await jobService.toggleSaveJob(
        userId: userId,
        jobId: job.value!.id,
        isSaved: isJobSaved.value,
      );

      // Update the saved status
      isJobSaved.value = result;

      // Show success message
      Get.snackbar(
        isJobSaved.value ? 'Job Saved' : 'Job Unsaved',
        isJobSaved.value
            ? 'Job added to your saved jobs'
            : 'Job removed from your saved jobs',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e('Error toggling save job', e);
      Get.snackbar(
        'Action Failed',
        'Failed to update saved status. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaveLoading.value = false;
    }
  }
}
