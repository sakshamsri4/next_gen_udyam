import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/home/services/job_service.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the Jobs view
///
/// This controller manages the state for the Jobs view, which combines
/// search and saved jobs functionality in a single tab with segmented views.
class JobsController extends GetxController {
  /// Get instance of JobsController
  static JobsController get to => Get.find();

  // Dependencies
  final JobService _jobService = Get.find<JobService>();
  final LoggerService _logger = Get.find<LoggerService>();

  // Observable state
  final RxInt currentTab = 0.obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoadingSaved = false.obs;
  final RxList<JobModel> searchResults = <JobModel>[].obs;
  final RxList<JobModel> savedJobs = <JobModel>[].obs;
  final RxList<String> activeFilters = <String>[].obs;

  // Controllers
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _logger.i('JobsController initialized');

    // Load saved jobs on init
    loadSavedJobs();

    // Load initial search results
    searchJobs('');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Set the current tab
  void setCurrentTab(int index) {
    // Skip if already on the selected tab
    if (currentTab.value == index) {
      _logger.d('Already on tab $index, skipping');
      return;
    }

    _logger.d('Switching to tab $index');
    currentTab.value = index;

    // Refresh data when switching tabs, but only if the data is empty or stale
    if (index == 0) {
      // Only reload search results if they're empty or it's been a while since the last search
      if (searchResults.isEmpty) {
        _logger.d('Search results empty, loading initial results');
        searchJobs(searchController.text);
      }
    } else {
      // Only reload saved jobs if they're empty or it's been a while since the last load
      if (savedJobs.isEmpty) {
        _logger.d('Saved jobs empty, loading saved jobs');
        loadSavedJobs();
      }
    }
  }

  /// Search for jobs
  Future<void> searchJobs(String query) async {
    try {
      isSearching.value = true;
      _logger.d('Searching for jobs with query: $query');

      // Apply any active filters
      final filters = <String, dynamic>{};
      if (activeFilters.isNotEmpty) {
        // Parse filters (this is a simplified example)
        for (final filter in activeFilters) {
          if (filter.startsWith('Location:')) {
            filters['location'] = filter.replaceAll('Location:', '').trim();
          } else if (filter.startsWith('Type:')) {
            filters['jobType'] = filter.replaceAll('Type:', '').trim();
          }
        }
      }

      final results = await _jobService.searchJobs(query, filters);
      searchResults.assignAll(results);
      _logger.d('Found ${results.length} jobs');
    } catch (e) {
      _logger.e('Error searching for jobs', e);
      Get.snackbar(
        'Error',
        'Failed to search for jobs. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSearching.value = false;
    }
  }

  /// Load saved jobs
  Future<void> loadSavedJobs() async {
    try {
      isLoadingSaved.value = true;
      _logger.d('Loading saved jobs');

      final jobs = await _jobService.getSavedJobs();
      savedJobs.assignAll(jobs);
      _logger.d('Loaded ${jobs.length} saved jobs');
    } catch (e) {
      _logger.e('Error loading saved jobs', e);
      Get.snackbar(
        'Error',
        'Failed to load saved jobs. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingSaved.value = false;
    }
  }

  /// Toggle save/unsave job
  Future<void> toggleSaveJob(JobModel job) async {
    try {
      _logger.d('Toggling save status for job: ${job.id}');

      // Check if job is already saved
      final isSaved = savedJobs.any((savedJob) => savedJob.id == job.id);

      if (isSaved) {
        // Unsave the job
        await _jobService.unsaveJob(job.id);
        savedJobs.removeWhere((savedJob) => savedJob.id == job.id);
        _logger.d('Job unsaved: ${job.id}');

        Get.snackbar(
          'Job Unsaved',
          'Job has been removed from your saved jobs',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Save the job
        await _jobService.saveJob(job);
        savedJobs.add(job);
        _logger.d('Job saved: ${job.id}');

        Get.snackbar(
          'Job Saved',
          'Job has been added to your saved jobs',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      // Update the UI without a full reload
      // This is more efficient than reloading the entire list
      if (currentTab.value == 1) {
        // We've already updated the savedJobs list in memory,
        // so we don't need to reload from the server
        // Just trigger a UI refresh by calling update() on the RxList
        savedJobs.refresh();
      }
    } catch (e) {
      _logger.e('Error toggling save status for job', e);
      Get.snackbar(
        'Error',
        'Failed to update saved status. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// View job details
  void viewJobDetails(JobModel job) {
    _logger.d('Viewing job details: ${job.id}');
    Get.toNamed<dynamic>('/jobs/details', arguments: job);
  }

  /// Apply filters
  void applyFilters(Map<String, dynamic> filters) {
    _logger.d('Applying filters: $filters');

    // Clear existing filters
    activeFilters.clear();

    // Add new filters
    if (filters.containsKey('location') && filters['location'] != null) {
      activeFilters.add('Location: ${filters['location']}');
    }

    if (filters.containsKey('jobType') && filters['jobType'] != null) {
      activeFilters.add('Type: ${filters['jobType']}');
    }

    if (filters.containsKey('salary') && filters['salary'] != null) {
      activeFilters.add('Salary: ${filters['salary']}');
    }

    // Re-run search with filters
    searchJobs(searchController.text);
  }

  /// Remove filter
  void removeFilter(String filter) {
    _logger.d('Removing filter: $filter');
    activeFilters.remove(filter);

    // Re-run search with updated filters
    searchJobs(searchController.text);
  }

  /// Check if a job is saved
  bool isSaved(String jobId) {
    return savedJobs.any((savedJob) => savedJob.id == jobId);
  }
}
