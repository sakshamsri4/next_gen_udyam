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
    _logger.d('JobDetailsController: onInit');

    // Get job ID from route arguments
    final jobId = Get.arguments as String?;
    if (jobId != null) {
      loadJobDetails(jobId);
    } else {
      isLoading.value = false;
      errorMessage.value = 'Job ID not provided';
      _logger.e('Job ID not provided');
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
      isLoading.value = true;
      errorMessage.value = '';

      // Get job details
      final jobData = await _jobDetailsService.getJobDetails(jobId);
      if (jobData == null) {
        errorMessage.value = 'Job not found';
        return;
      }

      job.value = jobData;

      // Get company details
      final company =
          await _jobDetailsService.getCompanyDetails(jobData.company);
      companyDetails.value = company;

      // Get similar jobs
      final similar = await _jobDetailsService.getSimilarJobs(
        currentJobId: jobId,
        jobType: jobData.jobType,
        industry: jobData.industry,
      );
      similarJobs.value = similar;

      // Check if user has applied and if job is saved
      if (_authController.isLoggedIn) {
        final userId = _authController.user.value?.uid;
        if (userId != null) {
          // Check if user has applied for the job
          hasUserApplied.value = await _jobDetailsService.hasApplied(
            userId: userId,
            jobId: jobId,
          );

          // Check if job is saved
          final jobService = Get.find<JobService>();
          final savedJobs = await jobService.getSavedJobs(userId);
          isJobSaved.value = savedJobs.contains(jobId);
        }
      }
    } catch (e) {
      _logger.e('Error loading job details', e);
      errorMessage.value = 'Failed to load job details';
    } finally {
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
