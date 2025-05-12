import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Enum for job sorting options
enum JobSortOption {
  /// Sort by newest first (most recently posted)
  newest,

  /// Sort by oldest first (least recently posted)
  oldest,

  /// Sort by salary (highest first)
  salaryHighToLow,

  /// Sort by salary (lowest first)
  salaryLowToHigh,
}

/// Enum for job filtering options
enum JobFilterOption {
  /// Show all jobs
  all,

  /// Show only remote jobs
  remote,

  /// Show only on-site jobs
  onsite,

  /// Show only full-time jobs
  fullTime,

  /// Show only part-time jobs
  partTime,

  /// Show only contract jobs
  contract,
}

/// Controller for the saved jobs screen
class SavedJobsController extends GetxController {
  /// Constructor
  SavedJobsController({
    required JobService jobService,
    required LoggerService logger,
    AuthController? authController,
    NavigationController? navigationController,
  })  : _jobService = jobService,
        _logger = logger,
        _authController = authController ?? Get.find<AuthController>(),
        _navigationController =
            navigationController ?? Get.find<NavigationController>();

  final JobService _jobService;
  final LoggerService _logger;
  final AuthController _authController;
  final NavigationController _navigationController;
  final ScrollController scrollController = ScrollController();

  // Observable state variables
  final _allSavedJobs = <JobModel>[].obs; // All saved jobs (unfiltered)
  final _savedJobs = <JobModel>[].obs; // Filtered and sorted jobs
  final _isLoading = true.obs;
  final _error = ''.obs;
  final _selectedSortOption = Rx<JobSortOption>(JobSortOption.newest);
  final _selectedFilterOption = Rx<JobFilterOption>(JobFilterOption.all);
  final _isFilterMenuOpen = false.obs;

  /// Get saved jobs (filtered and sorted)
  List<JobModel> get savedJobs => _savedJobs;

  /// Check if loading
  bool get isLoading => _isLoading.value;

  /// Get error message
  String get error => _error.value;

  /// Get selected sort option
  JobSortOption get selectedSortOption => _selectedSortOption.value;

  /// Get selected filter option
  JobFilterOption get selectedFilterOption => _selectedFilterOption.value;

  /// Check if filter menu is open
  bool get isFilterMenuOpen => _isFilterMenuOpen.value;

  /// Get all available job types from saved jobs
  List<String> get availableJobTypes {
    return _allSavedJobs.map((job) => job.jobType).toSet().toList()..sort();
  }

  /// Get count of remote jobs
  int get remoteJobsCount => _allSavedJobs.where((job) => job.isRemote).length;

  /// Get count of on-site jobs
  int get onsiteJobsCount => _allSavedJobs.where((job) => !job.isRemote).length;

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

      // Get saved jobs with details
      final jobs = await _jobService.getSavedJobs();

      // Store all jobs and apply filtering/sorting
      _allSavedJobs.assignAll(jobs);
      _applyFilterAndSort();
    } catch (e) {
      _logger.e('Error loading saved jobs', e);
      _error.value = 'Failed to load saved jobs';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Apply filter and sort to saved jobs
  void _applyFilterAndSort() {
    // First apply filter
    final filteredJobs = _filterJobs();

    // Then sort the filtered jobs
    final sortedJobs = _sortJobs(filteredJobs);

    // Update the saved jobs list
    _savedJobs.assignAll(sortedJobs);
  }

  /// Filter jobs based on selected filter option
  List<JobModel> _filterJobs() {
    switch (_selectedFilterOption.value) {
      case JobFilterOption.all:
        return List<JobModel>.from(_allSavedJobs);
      case JobFilterOption.remote:
        return _allSavedJobs.where((job) => job.isRemote).toList();
      case JobFilterOption.onsite:
        return _allSavedJobs.where((job) => !job.isRemote).toList();
      case JobFilterOption.fullTime:
        return _allSavedJobs
            .where((job) => job.jobType.toLowerCase() == 'full-time')
            .toList();
      case JobFilterOption.partTime:
        return _allSavedJobs
            .where((job) => job.jobType.toLowerCase() == 'part-time')
            .toList();
      case JobFilterOption.contract:
        return _allSavedJobs
            .where((job) => job.jobType.toLowerCase() == 'contract')
            .toList();
    }
  }

  /// Sort jobs based on selected sort option
  List<JobModel> _sortJobs(List<JobModel> jobs) {
    final sortedJobs = List<JobModel>.from(jobs);

    switch (_selectedSortOption.value) {
      case JobSortOption.newest:
        sortedJobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));
      case JobSortOption.oldest:
        sortedJobs.sort((a, b) => a.postedDate.compareTo(b.postedDate));
      case JobSortOption.salaryHighToLow:
        sortedJobs.sort((a, b) => b.salary.compareTo(a.salary));
      case JobSortOption.salaryLowToHigh:
        sortedJobs.sort((a, b) => a.salary.compareTo(b.salary));
    }

    return sortedJobs;
  }

  /// Set sort option
  void setSortOption(JobSortOption option) {
    if (_selectedSortOption.value != option) {
      _selectedSortOption.value = option;
      _applyFilterAndSort();
    }
  }

  /// Set filter option
  void setFilterOption(JobFilterOption option) {
    if (_selectedFilterOption.value != option) {
      _selectedFilterOption.value = option;
      _applyFilterAndSort();
    }
  }

  /// Toggle filter menu
  void toggleFilterMenu() {
    _isFilterMenuOpen.value = !_isFilterMenuOpen.value;
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

      // Remove job from both lists
      _allSavedJobs.removeWhere((job) => job.id == jobId);
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
    // Use NavigationController to navigate to job details
    // This preserves the current tab context
    _navigationController.navigateToDetail(Routes.jobs, arguments: jobId);
  }

  /// Navigate to company profile
  void navigateToCompanyProfile(String companyName) {
    // Use NavigationController to navigate to company profile
    // This preserves the current tab context
    _navigationController.navigateToDetail(
      Routes.profile,
      arguments: companyName,
    );
  }
}
