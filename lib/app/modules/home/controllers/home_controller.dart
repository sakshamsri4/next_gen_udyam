import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/home/models/application_update.dart';
import 'package:next_gen/app/modules/home/models/job_category.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the home screen
class HomeController extends GetxController {
  /// Constructor
  HomeController({
    JobService? jobService,
    AuthController? authController,
    LoggerService? logger,
  })  : _jobService = jobService ?? JobService(),
        _authController = authController ?? Get.find<AuthController>(),
        _logger = logger ?? Get.find<LoggerService>();

  /// Get instance of HomeController
  static HomeController get to => Get.find();

  final JobService _jobService;
  final AuthController _authController;
  final LoggerService _logger;
  final ScrollController homeScrollController = ScrollController();

  // Featured jobs
  final RxBool _isFeaturedJobsLoading = true.obs;
  final RxList<JobModel> _featuredJobs = <JobModel>[].obs;
  final RxString _featuredJobsError = ''.obs;

  // Recent jobs
  final RxBool _isRecentJobsLoading = true.obs;
  final RxList<JobModel> _recentJobs = <JobModel>[].obs;
  final RxString _recentJobsError = ''.obs;

  // Categories
  final RxBool _isCategoriesLoading = true.obs;
  final RxList<JobCategory> _categories = <JobCategory>[].obs;
  final RxString _categoriesError = ''.obs;
  final RxString _selectedCategory = 'All'.obs;

  // Saved jobs
  final RxList<String> _savedJobIds = <String>[].obs;

  // Carousel indicator
  final RxInt _carouselIndex = 0.obs;

  // Employee home screen data
  final RxString userName = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<JobModel> recommendedJobs = <JobModel>[].obs;
  final RxList<JobModel> recentlyViewedJobs = <JobModel>[].obs;
  final RxList<ApplicationUpdate> applicationUpdates =
      <ApplicationUpdate>[].obs;

  /// Get featured jobs loading state
  bool get isFeaturedJobsLoading => _isFeaturedJobsLoading.value;

  /// Get featured jobs
  List<JobModel> get featuredJobs => _featuredJobs;

  /// Get featured jobs error
  String get featuredJobsError => _featuredJobsError.value;

  /// Get recent jobs loading state
  bool get isRecentJobsLoading => _isRecentJobsLoading.value;

  /// Get recent jobs
  List<JobModel> get recentJobs => _recentJobs;

  /// Get recent jobs error
  String get recentJobsError => _recentJobsError.value;

  /// Get categories loading state
  bool get isCategoriesLoading => _isCategoriesLoading.value;

  /// Get categories
  List<JobCategory> get categories => _categories;

  /// Get categories error
  String get categoriesError => _categoriesError.value;

  /// Get selected category
  String get selectedCategory => _selectedCategory.value;

  /// Get saved job IDs
  List<String> get savedJobIds => _savedJobIds;

  /// Get carousel index
  int get carouselIndex => _carouselIndex.value;

  @override
  void onInit() {
    super.onInit();
    _loadHomeData();
    refreshJobs(); // Load employee home screen data
  }

  @override
  void onClose() {
    homeScrollController.dispose();
    super.onClose();
  }

  /// Load all home screen data
  Future<void> _loadHomeData() async {
    try {
      // Add a timeout to prevent infinite loading
      await Future.wait([
        _loadCategories().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            _logger.w('Categories loading timed out');
            _isCategoriesLoading.value = false;
            _categoriesError.value = 'Loading timed out. Pull to refresh.';
          },
        ),
        _loadFeaturedJobs().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            _logger.w('Featured jobs loading timed out');
            _isFeaturedJobsLoading.value = false;
            _featuredJobsError.value = 'Loading timed out. Pull to refresh.';
          },
        ),
        _loadSavedJobs().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            _logger.w('Saved jobs loading timed out');
          },
        ),
      ]);

      await _loadRecentJobs().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          _logger.w('Recent jobs loading timed out');
          _isRecentJobsLoading.value = false;
          _recentJobsError.value = 'Loading timed out. Pull to refresh.';
        },
      );
    } catch (e) {
      _logger.e('Error loading home data', e);
      // Ensure loading states are reset even if there's an error
      _isCategoriesLoading.value = false;
      _isFeaturedJobsLoading.value = false;
      _isRecentJobsLoading.value = false;
    }
  }

  /// Load featured jobs
  Future<void> _loadFeaturedJobs() async {
    _isFeaturedJobsLoading.value = true;
    _featuredJobsError.value = '';

    try {
      final jobs = await _jobService.getFeaturedJobs();
      _featuredJobs.assignAll(jobs);
    } catch (e) {
      _logger.e('Error loading featured jobs', e);
      _featuredJobsError.value = 'Failed to load featured jobs';
    } finally {
      _isFeaturedJobsLoading.value = false;
    }
  }

  /// Load recent jobs
  Future<void> _loadRecentJobs() async {
    _isRecentJobsLoading.value = true;
    _recentJobsError.value = '';

    try {
      final category =
          _selectedCategory.value == 'All' ? null : _selectedCategory.value;
      final jobs = await _jobService.getRecentJobs(category: category);
      _recentJobs.assignAll(jobs);
    } catch (e) {
      _logger.e('Error loading recent jobs', e);
      _recentJobsError.value = 'Failed to load recent jobs';
    } finally {
      _isRecentJobsLoading.value = false;
    }
  }

  /// Load job categories
  Future<void> _loadCategories() async {
    _isCategoriesLoading.value = true;
    _categoriesError.value = '';

    try {
      final categories = await _jobService.getJobCategories();
      _categories.assignAll(categories);
    } catch (e) {
      _logger.e('Error loading job categories', e);
      _categoriesError.value = 'Failed to load job categories';
    } finally {
      _isCategoriesLoading.value = false;
    }
  }

  /// Load saved jobs
  Future<void> _loadSavedJobs() async {
    try {
      if (_authController.isLoggedIn) {
        // Get saved job IDs
        final savedJobs = await _jobService.getSavedJobs();
        final savedJobIds = savedJobs.map((job) => job.id).toList();
        _savedJobIds.assignAll(savedJobIds);
      }
    } catch (e) {
      _logger.e('Error loading saved jobs', e);
    }
  }

  /// Set selected category and reload jobs if category has changed
  set selectedCategory(String value) {
    if (_selectedCategory.value != value) {
      _selectedCategory.value = value;
      _loadRecentJobs();
    }
  }

  /// Update selected category (for backward compatibility)
  // ignore: use_setters_to_change_properties
  void updateSelectedCategory(String category) {
    selectedCategory = category;
  }

  /// Update carousel index
  set carouselIndex(int value) => _carouselIndex.value = value;

  // Method removed as we're using the setter directly

  /// Check if a job is saved
  bool isJobSaved(String jobId) {
    return _savedJobIds.contains(jobId);
  }

  /// Toggle job saved state
  Future<bool> toggleSaveJob({
    required bool isSaved,
    required String jobId,
  }) async {
    try {
      if (!_authController.isLoggedIn) {
        Get.snackbar(
          'Sign In Required',
          'Please sign in to save jobs',
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(
            onPressed: () => Get.toNamed<dynamic>('/login'),
            child: const Text('Sign In', style: TextStyle(color: Colors.white)),
          ),
        );
        return isSaved;
      }

      final userId = _authController.user.value?.uid ?? '';
      // This check is redundant since isLoggedIn should ensure userId exists
      // but keeping it as a defensive measure

      final result = await _jobService.toggleSaveJob(
        userId: userId,
        jobId: jobId,
        isSaved: isSaved,
      );

      // Update local saved jobs list
      if (result && !isSaved) {
        _savedJobIds.add(jobId);
      } else if (result && isSaved) {
        _savedJobIds.remove(jobId);
      }

      // Return the new saved state based on the operation success
      return result ? !isSaved : isSaved;
    } catch (e) {
      _logger.e('Error toggling job saved state', e);
      Get.snackbar(
        'Error',
        'Failed to ${isSaved ? 'unsave' : 'save'} job',
        snackPosition: SnackPosition.BOTTOM,
      );
      return isSaved;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await _loadHomeData();
  }

  /// Refresh jobs for employee home screen
  Future<void> refreshJobs() async {
    isLoading.value = true;

    try {
      // Load user name
      _loadUserName();

      // Load recommended jobs
      await _loadRecommendedJobs();

      // Load recently viewed jobs
      await _loadRecentlyViewedJobs();

      // Load application updates
      await _loadApplicationUpdates();
    } catch (e) {
      _logger.e('Error refreshing jobs', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Load user name from auth controller
  void _loadUserName() {
    try {
      final user = _authController.user.value;
      if (user != null && user.displayName != null) {
        userName.value = user.displayName!;
      } else {
        userName.value = 'there';
      }
    } catch (e) {
      _logger.e('Error loading user name', e);
      userName.value = 'there';
    }
  }

  /// Load recommended jobs
  Future<void> _loadRecommendedJobs() async {
    try {
      // In a real app, this would use a recommendation algorithm
      // For now, we'll just use the featured jobs
      final jobs = await _jobService.getFeaturedJobs();
      recommendedJobs.assignAll(jobs);
    } catch (e) {
      _logger.e('Error loading recommended jobs', e);
      recommendedJobs.clear();
    }
  }

  /// Load recently viewed jobs
  Future<void> _loadRecentlyViewedJobs() async {
    try {
      // In a real app, this would load from local storage or user history
      // For now, we'll just use the recent jobs
      final jobs = await _jobService.getRecentJobs();
      recentlyViewedJobs.assignAll(jobs);
    } catch (e) {
      _logger.e('Error loading recently viewed jobs', e);
      recentlyViewedJobs.clear();
    }
  }

  /// Load application updates
  Future<void> _loadApplicationUpdates() async {
    try {
      // In a real app, this would load from the user's applications
      // For now, we'll just use mock data
      applicationUpdates.assignAll([
        ApplicationUpdate(
          id: '1',
          jobId: '101',
          jobTitle: 'Senior Developer',
          companyName: 'Tech Solutions',
          status: 'Application Received',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ApplicationUpdate(
          id: '2',
          jobId: '102',
          jobTitle: 'Product Manager',
          companyName: 'Innovate Inc',
          status: 'Interview Scheduled',
          date: DateTime.now().subtract(const Duration(days: 3)),
          message: 'Interview scheduled for next Monday at 10:00 AM',
        ),
        ApplicationUpdate(
          id: '3',
          jobId: '103',
          jobTitle: 'UX Designer',
          companyName: 'Creative Designs',
          status: 'Application Rejected',
          date: DateTime.now().subtract(const Duration(days: 5)),
          message:
              'Thank you for your interest, but we have decided to move forward with other candidates.',
        ),
      ]);
    } catch (e) {
      _logger.e('Error loading application updates', e);
      applicationUpdates.clear();
    }
  }

  /// View job details
  void viewJobDetails(String jobId) {
    Get.toNamed<dynamic>('/jobs/$jobId');
  }

  /// View application details
  void viewApplicationDetails(String applicationId) {
    Get.toNamed<dynamic>('/applications/$applicationId');
  }

  /// Search jobs
  void searchJobs(String query) {
    Get.toNamed<dynamic>('/search', arguments: {'query': query});
  }
}
