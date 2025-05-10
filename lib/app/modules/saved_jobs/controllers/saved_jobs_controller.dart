import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the saved jobs screen
class SavedJobsController extends GetxController {
  /// Constructor
  SavedJobsController({
    required JobService jobService,
    required LoggerService logger,
    AuthController? authController,
  })  : _jobService = jobService,
        _logger = logger,
        _authController = authController ?? Get.find<AuthController>();

  final JobService _jobService;
  final LoggerService _logger;
  final AuthController _authController;
  final ScrollController scrollController = ScrollController();

  // Observable state variables
  final _savedJobs = <JobModel>[].obs;
  final _isLoading = true.obs;
  final _error = ''.obs;

  /// Get saved jobs
  List<JobModel> get savedJobs => _savedJobs;

  /// Check if loading
  bool get isLoading => _isLoading.value;

  /// Get error message
  String get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedJobs();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Load saved jobs
  Future<void> _loadSavedJobs() async {
    if (!_authController.isLoggedIn) {
      _error.value = 'Please sign in to view saved jobs';
      _isLoading.value = false;
      return;
    }

    try {
      _isLoading.value = true;
      _error.value = '';

      final userId = _authController.user.value?.uid;
      if (userId == null) {
        throw Exception('User ID not available');
      }

      // Get saved job IDs
      final savedJobIds = await _jobService.getSavedJobs(userId);

      // Fetch job details for each saved job
      final jobs = <JobModel>[];
      for (final jobId in savedJobIds) {
        try {
          final job = await _jobService.getJobById(jobId);
          if (job != null) {
            jobs.add(job);
          }
        } catch (e) {
          _logger.e('Error fetching job details for job $jobId', e);
          // Continue with other jobs even if one fails
        }
      }

      _savedJobs.assignAll(jobs);
    } catch (e) {
      _logger.e('Error loading saved jobs', e);
      _error.value = 'Failed to load saved jobs';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Unsave a job
  Future<void> unsaveJob(String jobId) async {
    try {
      final userId = _authController.user.value?.uid;
      if (userId == null) {
        throw Exception('User ID not available');
      }

      // Toggle saved status (true means it's currently saved)
      await _jobService.toggleSaveJob(
        userId: userId,
        jobId: jobId,
        isSaved: true,
      );

      // Remove job from the list
      _savedJobs.removeWhere((job) => job.id == jobId);

      // Show success message
      Get.snackbar(
        'Job Unsaved',
        'Job removed from your saved jobs',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e('Error unsaving job', e);
      Get.snackbar(
        'Error',
        'Failed to unsave job',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh saved jobs
  Future<void> refreshSavedJobs() async {
    await _loadSavedJobs();
  }

  /// Navigate to job details
  void navigateToJobDetails(String jobId) {
    Get.toNamed<dynamic>(Routes.jobs, arguments: jobId);
  }

  /// Navigate to company profile
  void navigateToCompanyProfile(String companyName) {
    Get.toNamed<dynamic>(Routes.profile, arguments: companyName);
  }
}
