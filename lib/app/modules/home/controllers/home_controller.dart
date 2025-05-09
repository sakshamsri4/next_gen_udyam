import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
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
  }

  /// Load all home screen data
  Future<void> _loadHomeData() async {
    await Future.wait([
      _loadCategories(),
      _loadFeaturedJobs(),
      _loadSavedJobs(),
    ]);

    await _loadRecentJobs();
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
        final userId = _authController.user.value?.uid ?? '';
        if (userId.isNotEmpty) {
          final savedJobs = await _jobService.getSavedJobs(userId);
          _savedJobIds.assignAll(savedJobs);
        }
      }
    } catch (e) {
      _logger.e('Error loading saved jobs', e);
    }
  }

  /// Update selected category
  void updateSelectedCategory(String category) {
    if (_selectedCategory.value != category) {
      selectedCategory = category;
      _loadRecentJobs();
    }
  }

  /// Set selected category
  set selectedCategory(String value) => _selectedCategory.value = value;

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
        );
        return isSaved;
      }

      final userId = _authController.user.value?.uid ?? '';
      if (userId.isEmpty) return isSaved;

      final result = await _jobService.toggleSaveJob(
        userId: userId,
        jobId: jobId,
        isSaved: isSaved,
      );

      // Update local saved jobs list
      if (result) {
        _savedJobIds.add(jobId);
      } else {
        _savedJobIds.remove(jobId);
      }

      return result;
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
}
