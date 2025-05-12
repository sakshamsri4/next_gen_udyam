import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/applicant_review/models/applicant_comparison_model.dart';
import 'package:next_gen/app/modules/applicant_review/models/applicant_filter_model.dart';
import 'package:next_gen/app/modules/applicant_review/services/applicant_review_service.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';

import 'package:next_gen/app/modules/job_posting/models/job_post_model.dart';
import 'package:next_gen/app/modules/job_posting/services/job_posting_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the applicant review module
class ApplicantReviewController extends GetxController {
  /// Constructor
  ApplicantReviewController({
    required ApplicantReviewService applicantReviewService,
    required JobPostingService jobPostingService,
    required LoggerService logger,
  })  : _applicantReviewService = applicantReviewService,
        _jobPostingService = jobPostingService,
        _logger = logger;

  final ApplicantReviewService _applicantReviewService;
  final JobPostingService _jobPostingService;
  final LoggerService _logger;
  final ScrollController scrollController = ScrollController();

  // Observable state variables
  final _applications = <ApplicationModel>[].obs;
  final _filteredApplications = <ApplicationModel>[].obs;
  final _selectedApplications = <ApplicationModel>[].obs;
  final _selectedJob = Rx<JobPostModel?>(null);
  final _isLoading = true.obs;
  final _isUpdating = false.obs;
  final _error = ''.obs;
  final _filter = ApplicantFilterModel().obs;
  final _statusCounts = <ApplicationStatus, int>{}.obs;
  final _comparisonMode = false.obs;
  final _comparison = Rx<ApplicantComparisonModel?>(null);

  /// Get all applications
  List<ApplicationModel> get applications => _applications;

  /// Get filtered applications
  List<ApplicationModel> get filteredApplications => _filteredApplications;

  /// Get selected applications
  List<ApplicationModel> get selectedApplications => _selectedApplications;

  /// Get selected job
  JobPostModel? get selectedJob => _selectedJob.value;

  /// Check if loading
  bool get isLoading => _isLoading.value;

  /// Check if updating
  bool get isUpdating => _isUpdating.value;

  /// Get error message
  String get error => _error.value;

  /// Get current filter
  ApplicantFilterModel get filter => _filter.value;

  /// Get status counts
  Map<ApplicationStatus, int> get statusCounts => _statusCounts;

  /// Check if in comparison mode
  bool get comparisonMode => _comparisonMode.value;

  /// Get current comparison
  ApplicantComparisonModel? get comparison => _comparison.value;

  @override
  void onInit() {
    super.onInit();
    _logger.i('ApplicantReviewController initialized');
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Load applications for a job
  Future<void> loadApplicationsForJob(String jobId) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      // Load job details
      final job = await _jobPostingService.getJobPostingById(jobId);
      if (job == null) {
        throw Exception('Job not found');
      }
      _selectedJob.value = job;

      // Update filter with job ID
      _filter.value = _filter.value.copyWith(jobId: jobId);

      // Load applications
      await _loadApplications();
    } catch (e) {
      _logger.e('Error loading applications for job', e);
      _error.value = 'Failed to load applications';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load applications based on current filter
  Future<void> _loadApplications() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      // Get applications
      final applications =
          await _applicantReviewService.getFilteredApplications(_filter.value);
      _applications.assignAll(applications);
      _filteredApplications.assignAll(applications);

      // Calculate status counts
      _calculateStatusCounts();
    } catch (e) {
      _logger.e('Error loading applications', e);
      _error.value = 'Failed to load applications';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Calculate application counts by status
  void _calculateStatusCounts() {
    final counts = <ApplicationStatus, int>{};

    // Initialize counts for all statuses
    for (final status in ApplicationStatus.values) {
      counts[status] = 0;
    }

    // Count applications by status
    for (final application in _applications) {
      counts[application.status] = (counts[application.status] ?? 0) + 1;
    }

    _statusCounts.assignAll(counts);
  }

  /// Update filter and reload applications
  Future<void> updateFilter(ApplicantFilterModel newFilter) async {
    _filter.value = newFilter;
    await _loadApplications();
  }

  /// Set status filter
  Future<void> setStatusFilter(List<ApplicationStatus> statuses) async {
    _filter.value = _filter.value.copyWith(statuses: statuses);
    await _loadApplications();
  }

  /// Toggle selection of an application
  void toggleApplicationSelection(ApplicationModel application) {
    if (_selectedApplications.contains(application)) {
      _selectedApplications.remove(application);
    } else {
      _selectedApplications.add(application);
    }
  }

  /// Clear all selections
  void clearSelections() {
    _selectedApplications.clear();
  }

  /// Update application status
  Future<bool> updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  ) async {
    try {
      _isUpdating.value = true;

      final success = await _applicantReviewService.updateApplicationStatus(
        applicationId,
        status,
      );

      if (success) {
        // Update local application
        final index =
            _applications.indexWhere((app) => app.id == applicationId);
        if (index != -1) {
          final updatedApplication =
              _applications[index].copyWith(status: status);
          _applications[index] = updatedApplication;

          // Update filtered applications
          final filteredIndex = _filteredApplications
              .indexWhere((app) => app.id == applicationId);
          if (filteredIndex != -1) {
            _filteredApplications[filteredIndex] = updatedApplication;
          }

          // Update selected applications
          final selectedIndex = _selectedApplications
              .indexWhere((app) => app.id == applicationId);
          if (selectedIndex != -1) {
            _selectedApplications[selectedIndex] = updatedApplication;
          }

          // Recalculate status counts
          _calculateStatusCounts();
        }

        Get.snackbar(
          'Success',
          'Application status updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update application status',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      return success;
    } catch (e) {
      _logger.e('Error updating application status', e);
      Get.snackbar(
        'Error',
        'Failed to update application status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isUpdating.value = false;
    }
  }

  /// Add feedback to an application
  Future<bool> addFeedback(String applicationId, String feedback) async {
    try {
      _isUpdating.value = true;

      final success = await _applicantReviewService.addFeedback(
        applicationId,
        feedback,
      );

      if (success) {
        // Update local application
        final index =
            _applications.indexWhere((app) => app.id == applicationId);
        if (index != -1) {
          final updatedApplication =
              _applications[index].copyWith(feedback: feedback);
          _applications[index] = updatedApplication;

          // Update filtered applications
          final filteredIndex = _filteredApplications
              .indexWhere((app) => app.id == applicationId);
          if (filteredIndex != -1) {
            _filteredApplications[filteredIndex] = updatedApplication;
          }

          // Update selected applications
          final selectedIndex = _selectedApplications
              .indexWhere((app) => app.id == applicationId);
          if (selectedIndex != -1) {
            _selectedApplications[selectedIndex] = updatedApplication;
          }
        }

        Get.snackbar(
          'Success',
          'Feedback added',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add feedback',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      return success;
    } catch (e) {
      _logger.e('Error adding feedback', e);
      Get.snackbar(
        'Error',
        'Failed to add feedback',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isUpdating.value = false;
    }
  }

  /// Schedule an interview
  Future<bool> scheduleInterview(
    String applicationId,
    DateTime interviewDate,
  ) async {
    try {
      _isUpdating.value = true;

      final success = await _applicantReviewService.scheduleInterview(
        applicationId,
        interviewDate,
      );

      if (success) {
        // Update local application
        final index =
            _applications.indexWhere((app) => app.id == applicationId);
        if (index != -1) {
          final updatedApplication = _applications[index].copyWith(
            interviewDate: interviewDate,
            status: ApplicationStatus.interview,
          );
          _applications[index] = updatedApplication;

          // Update filtered applications
          final filteredIndex = _filteredApplications
              .indexWhere((app) => app.id == applicationId);
          if (filteredIndex != -1) {
            _filteredApplications[filteredIndex] = updatedApplication;
          }

          // Update selected applications
          final selectedIndex = _selectedApplications
              .indexWhere((app) => app.id == applicationId);
          if (selectedIndex != -1) {
            _selectedApplications[selectedIndex] = updatedApplication;
          }

          // Recalculate status counts
          _calculateStatusCounts();
        }

        Get.snackbar(
          'Success',
          'Interview scheduled',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to schedule interview',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      return success;
    } catch (e) {
      _logger.e('Error scheduling interview', e);
      Get.snackbar(
        'Error',
        'Failed to schedule interview',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isUpdating.value = false;
    }
  }

  /// Enter comparison mode
  void enterComparisonMode() {
    if (_selectedApplications.length < 2) {
      Get.snackbar(
        'Error',
        'Select at least 2 applicants to compare',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _comparisonMode.value = true;

    // Create a new comparison
    _comparison.value = ApplicantComparisonModel(
      id: '',
      jobId: _filter.value.jobId,
      applicantIds: _selectedApplications.map((app) => app.id).toList(),
      createdAt: DateTime.now(),
    );
  }

  /// Exit comparison mode
  void exitComparisonMode() {
    _comparisonMode.value = false;
    _comparison.value = null;
  }

  /// Save comparison
  Future<bool> saveComparison() async {
    try {
      if (_comparison.value == null) {
        return false;
      }

      _isUpdating.value = true;

      final savedComparison =
          await _applicantReviewService.saveComparison(_comparison.value!);

      if (savedComparison != null) {
        _comparison.value = savedComparison;

        Get.snackbar(
          'Success',
          'Comparison saved',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to save comparison',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      _logger.e('Error saving comparison', e);
      Get.snackbar(
        'Error',
        'Failed to save comparison',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isUpdating.value = false;
    }
  }

  /// Update applicant rating in comparison
  void updateApplicantRating(String applicantId, int rating) {
    if (_comparison.value == null) {
      return;
    }

    _comparison.value = _comparison.value!.withRating(applicantId, rating);
  }

  /// Update comparison notes
  void updateComparisonNotes(String notes) {
    if (_comparison.value == null) {
      return;
    }

    _comparison.value = _comparison.value!.copyWith(notes: notes);
  }

  /// Refresh applications
  Future<void> refreshApplications() async {
    await _loadApplications();
  }
}
