import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/app/modules/applications/services/applications_service.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the applications module
class ApplicationsController extends GetxController {
  /// Constructor
  ApplicationsController({
    required ApplicationsService applicationsService,
    required LoggerService logger,
    AuthController? authController,
  })  : _applicationsService = applicationsService,
        _logger = logger,
        _authController = authController ?? Get.find<AuthController>();

  final ApplicationsService _applicationsService;
  final LoggerService _logger;
  final AuthController _authController;
  final ScrollController scrollController = ScrollController();

  // Observable state variables
  final _applications = <ApplicationModel>[].obs;
  final _filteredApplications = <ApplicationModel>[].obs;
  final _selectedApplication = Rx<ApplicationModel?>(null);
  final _selectedJob = Rx<JobModel?>(null);
  final _isLoading = true.obs;
  final _isDetailLoading = true.obs;
  final _error = ''.obs;
  final _selectedStatusFilter = Rx<ApplicationStatus?>(null);
  final _statusCounts = <ApplicationStatus, int>{}.obs;

  /// Get all applications
  List<ApplicationModel> get applications => _applications;

  /// Get filtered applications
  List<ApplicationModel> get filteredApplications => _filteredApplications;

  /// Get selected application
  ApplicationModel? get selectedApplication => _selectedApplication.value;

  /// Get selected job
  JobModel? get selectedJob => _selectedJob.value;

  /// Check if loading
  bool get isLoading => _isLoading.value;

  /// Check if detail is loading
  bool get isDetailLoading => _isDetailLoading.value;

  /// Get error message
  String get error => _error.value;

  /// Get selected status filter
  ApplicationStatus? get selectedStatusFilter => _selectedStatusFilter.value;

  /// Get status counts
  Map<ApplicationStatus, int> get statusCounts => _statusCounts;

  @override
  void onInit() {
    super.onInit();
    _loadApplications();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Load all applications for the current user
  Future<void> _loadApplications() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final userId = _authController.user.value?.uid;
      if (userId == null) {
        throw Exception('User ID not available');
      }

      // Get all applications
      final applications =
          await _applicationsService.getUserApplications(userId);
      _applications.assignAll(applications);

      // Apply any existing filter
      _applyStatusFilter();

      // Get application counts by status
      final counts =
          await _applicationsService.getApplicationCountsByStatus(userId);
      _statusCounts.assignAll(counts);
    } catch (e) {
      _logger.e('Error loading applications', e);

      // Check if this is a Firestore index error
      if (e.toString().contains('failed-precondition') &&
          e.toString().contains('index')) {
        _error.value =
            'Missing Firestore index. Please create the required index by clicking the link in the console logs.';
      } else if (e.toString().contains('network')) {
        _error.value =
            'Network error. Please check your internet connection and try again.';
      } else {
        _error.value = 'Failed to load applications. Please try again later.';
      }
    } finally {
      _isLoading.value = false;
    }
  }

  /// Set status filter
  void setStatusFilter(ApplicationStatus? status) {
    _selectedStatusFilter.value = status;
    _applyStatusFilter();
  }

  /// Apply status filter to applications
  void _applyStatusFilter() {
    if (_selectedStatusFilter.value == null) {
      _filteredApplications.assignAll(_applications);
    } else {
      _filteredApplications.assignAll(
        _applications.where((app) => app.status == _selectedStatusFilter.value),
      );
    }
  }

  /// Load application details
  Future<void> loadApplicationDetails(String applicationId) async {
    try {
      _isDetailLoading.value = true;

      // Get application details
      final application =
          await _applicationsService.getApplicationById(applicationId);
      if (application == null) {
        throw Exception('Application not found');
      }
      _selectedApplication.value = application;

      // Get job details
      final job =
          await _applicationsService.getJobForApplication(application.jobId);
      _selectedJob.value = job;
    } catch (e) {
      _logger.e('Error loading application details', e);
      Get.snackbar(
        'Error',
        'Failed to load application details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isDetailLoading.value = false;
    }
  }

  /// Withdraw an application
  Future<void> withdrawApplication(String applicationId) async {
    try {
      _isLoading.value = true;

      final success =
          await _applicationsService.withdrawApplication(applicationId);
      if (success) {
        // Refresh applications list
        await _loadApplications();

        Get.snackbar(
          'Success',
          'Application withdrawn successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate back if on details page
        if (Get.currentRoute.contains('/applications/')) {
          Get.back<dynamic>();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to withdraw application',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _logger.e('Error withdrawing application', e);
      Get.snackbar(
        'Error',
        'Failed to withdraw application',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Navigate to job details
  void navigateToJobDetails(String jobId) {
    Get.toNamed<dynamic>(Routes.jobs, arguments: jobId);
  }

  /// Refresh applications
  Future<void> refreshApplications() async {
    await _loadApplications();
  }
}
