import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/company_profile/controllers/company_profile_controller.dart';
import 'package:next_gen/app/modules/company_profile/models/company_profile_model.dart';
import 'package:next_gen/app/modules/job_posting/models/job_post_model.dart';
import 'package:next_gen/app/modules/job_posting/services/job_posting_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for job posting functionality
class JobPostingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Constructor
  JobPostingController({
    JobPostingService? jobPostingService,
    LoggerService? logger,
    CompanyProfileController? companyProfileController,
  })  : _jobPostingService = jobPostingService ?? Get.find<JobPostingService>(),
        _logger = logger ?? Get.find<LoggerService>(),
        _companyProfileController =
            companyProfileController ?? Get.find<CompanyProfileController>();

  final JobPostingService _jobPostingService;
  final LoggerService _logger;
  final CompanyProfileController _companyProfileController;

  // For testing purposes only
  Rx<CompanyProfileModel?>? _testProfile;

  /// Set a test profile for testing purposes
  void setTestProfile(Rx<CompanyProfileModel?> profile) {
    _testProfile = profile;
  }

  // Tab controller for job management
  late TabController tabController;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final salaryController = TextEditingController();
  final requirementsController = TextEditingController();
  final responsibilitiesController = TextEditingController();
  final skillsController = TextEditingController();
  final jobTypeController = TextEditingController();
  final experienceController = TextEditingController();
  final educationController = TextEditingController();
  final industryController = TextEditingController();
  final benefitsController = TextEditingController();

  // Observable state variables
  final _jobs = <JobPostModel>[].obs;
  final _filteredJobs = <JobPostModel>[].obs;
  final _selectedJob = Rx<JobPostModel?>(null);
  final _isLoading = true.obs;
  final _isCreating = false.obs;
  final _isUpdating = false.obs;
  final _error = ''.obs;
  final _selectedStatusFilter = Rx<JobStatus?>(null);
  final _isRemote = false.obs;
  final _applicationDeadline = Rx<DateTime?>(null);
  final _isFeatured = false.obs;
  final _previewMode = false.obs;
  final _currentStep = 0.obs;
  final _statusCounts = <JobStatus, int>{}.obs;

  /// Get all jobs
  List<JobPostModel> get jobs => _jobs;

  /// Get filtered jobs
  List<JobPostModel> get filteredJobs => _filteredJobs;

  /// Get selected job
  JobPostModel? get selectedJob => _selectedJob.value;

  /// Check if loading
  bool get isLoading => _isLoading.value;

  /// Check if creating
  bool get isCreating => _isCreating.value;

  /// Check if updating
  bool get isUpdating => _isUpdating.value;

  /// Get error message
  String get error => _error.value;

  /// Get selected status filter
  JobStatus? get selectedStatusFilter => _selectedStatusFilter.value;

  /// Check if job is remote
  bool get isRemote => _isRemote.value;

  /// Get application deadline
  DateTime? get applicationDeadline => _applicationDeadline.value;

  /// Check if job is featured
  bool get isFeatured => _isFeatured.value;

  /// Check if in preview mode
  bool get previewMode => _previewMode.value;

  /// Get current step in multi-step form
  int get currentStep => _currentStep.value;

  /// Get status counts
  Map<JobStatus, int> get statusCounts => _statusCounts;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    _loadJobs();
  }

  @override
  void onClose() {
    tabController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    salaryController.dispose();
    requirementsController.dispose();
    responsibilitiesController.dispose();
    skillsController.dispose();
    jobTypeController.dispose();
    experienceController.dispose();
    educationController.dispose();
    industryController.dispose();
    benefitsController.dispose();
    super.onClose();
  }

  /// Load all jobs for the current company
  Future<void> _loadJobs() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      // Use test profile if available, otherwise use the real profile
      final profile = _testProfile ?? _companyProfileController.profile;
      final companyId = profile.value?.uid;
      if (companyId == null) {
        throw Exception('Company ID not available');
      }

      // Get all jobs
      final jobs = await _jobPostingService.getCompanyJobPostings(companyId);
      _jobs.assignAll(jobs);

      // Apply any existing filter
      _applyStatusFilter();

      // Get job counts by status
      _calculateStatusCounts();
    } catch (e) {
      _logger.e('Error loading jobs', e);
      _error.value = 'Failed to load jobs';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Calculate job counts by status
  void _calculateStatusCounts() {
    final counts = <JobStatus, int>{};

    // Initialize counts for all statuses
    for (final status in JobStatus.values) {
      counts[status] = 0;
    }

    // Count jobs by status
    for (final job in _jobs) {
      counts[job.status] = (counts[job.status] ?? 0) + 1;
    }

    _statusCounts.assignAll(counts);
  }

  /// Apply status filter to jobs
  void _applyStatusFilter() {
    if (_selectedStatusFilter.value == null) {
      _filteredJobs.assignAll(_jobs);
    } else {
      _filteredJobs.assignAll(
        _jobs
            .where((job) => job.status == _selectedStatusFilter.value)
            .toList(),
      );
    }
  }

  /// Set status filter
  void setStatusFilter(JobStatus? status) {
    _selectedStatusFilter.value = status;
    _applyStatusFilter();
  }

  /// Set remote status
  set isRemote(bool value) {
    _isRemote.value = value;
  }

  /// Set application deadline
  set applicationDeadline(DateTime? date) {
    _applicationDeadline.value = date;
  }

  /// Set featured status
  set isFeatured(bool value) {
    _isFeatured.value = value;
  }

  /// Toggle preview mode
  void togglePreviewMode() {
    _previewMode.value = !_previewMode.value;
  }

  /// Set current step
  set currentStep(int step) {
    _currentStep.value = step;
  }

  /// Next step
  void nextStep() {
    if (_currentStep.value < 3) {
      _currentStep.value++;
    }
  }

  /// Previous step
  void previousStep() {
    if (_currentStep.value > 0) {
      _currentStep.value--;
    }
  }

  /// Create a new job posting
  Future<bool> createJobPosting() async {
    try {
      _isCreating.value = true;

      // Use test profile if available, otherwise use the real profile
      final profile = _testProfile ?? _companyProfileController.profile;
      final companyId = profile.value?.uid;
      if (companyId == null) {
        throw Exception('Company ID not available');
      }

      // Parse salary
      final salary = int.tryParse(salaryController.text) ?? 0;

      // Parse requirements, responsibilities, skills, and benefits
      final requirements = requirementsController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      final responsibilities = responsibilitiesController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      final skills = skillsController.text
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toList();

      final benefits = benefitsController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      // Create job posting
      final job = await _jobPostingService.createJobPosting(
        companyId: companyId,
        title: titleController.text,
        description: descriptionController.text,
        location: locationController.text,
        salary: salary,
        requirements: requirements,
        responsibilities: responsibilities,
        skills: skills,
        jobType: jobTypeController.text,
        experience: experienceController.text,
        education: educationController.text,
        industry: industryController.text,
        isRemote: _isRemote.value,
        applicationDeadline: _applicationDeadline.value,
        benefits: benefits,
        isFeatured: _isFeatured.value,
      );

      if (job != null) {
        // Add to jobs list
        _jobs.insert(0, job);
        _applyStatusFilter();
        _calculateStatusCounts();

        // Clear form
        _clearForm();

        Get.snackbar(
          'Success',
          'Job posting created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        throw Exception('Failed to create job posting');
      }
    } catch (e) {
      _logger.e('Error creating job posting', e);
      Get.snackbar(
        'Error',
        'Failed to create job posting: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isCreating.value = false;
    }
  }

  /// Clear the form
  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    salaryController.clear();
    requirementsController.clear();
    responsibilitiesController.clear();
    skillsController.clear();
    jobTypeController.clear();
    experienceController.clear();
    educationController.clear();
    industryController.clear();
    benefitsController.clear();
    _isRemote.value = false;
    _applicationDeadline.value = null;
    _isFeatured.value = false;
    _currentStep.value = 0;
  }

  /// Load job details for editing
  void loadJobForEditing(JobPostModel job) {
    _selectedJob.value = job;

    // Fill form fields
    titleController.text = job.title;
    descriptionController.text = job.description;
    locationController.text = job.location;
    salaryController.text = job.salary.toString();
    requirementsController.text = job.requirements.join('\n');
    responsibilitiesController.text = job.responsibilities.join('\n');
    skillsController.text = job.skills.join(', ');
    jobTypeController.text = job.jobType;
    experienceController.text = job.experience;
    educationController.text = job.education;
    industryController.text = job.industry;
    benefitsController.text = job.benefits.join('\n');
    _isRemote.value = job.isRemote;
    _applicationDeadline.value = job.applicationDeadline;
    _isFeatured.value = job.isFeatured;
  }

  /// Update a job posting
  Future<bool> updateJobPosting() async {
    try {
      if (_selectedJob.value == null) {
        throw Exception('No job selected for update');
      }

      _isUpdating.value = true;

      // Parse salary
      final salary = int.tryParse(salaryController.text) ?? 0;

      // Parse requirements, responsibilities, skills, and benefits
      final requirements = requirementsController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      final responsibilities = responsibilitiesController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      final skills = skillsController.text
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toList();

      final benefits = benefitsController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      // Update job posting
      final updatedJob = await _jobPostingService.updateJobPosting(
        jobId: _selectedJob.value!.id,
        title: titleController.text,
        description: descriptionController.text,
        location: locationController.text,
        salary: salary,
        requirements: requirements,
        responsibilities: responsibilities,
        skills: skills,
        jobType: jobTypeController.text,
        experience: experienceController.text,
        education: educationController.text,
        industry: industryController.text,
        isRemote: _isRemote.value,
        applicationDeadline: _applicationDeadline.value,
        benefits: benefits,
        isFeatured: _isFeatured.value,
      );

      if (updatedJob != null) {
        // Update in jobs list
        final index = _jobs.indexWhere((job) => job.id == updatedJob.id);
        if (index != -1) {
          _jobs[index] = updatedJob;
        }

        _applyStatusFilter();
        _selectedJob.value = updatedJob;

        Get.snackbar(
          'Success',
          'Job posting updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        throw Exception('Failed to update job posting');
      }
    } catch (e) {
      _logger.e('Error updating job posting', e);
      Get.snackbar(
        'Error',
        'Failed to update job posting: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isUpdating.value = false;
    }
  }

  /// Delete a job posting
  Future<bool> deleteJobPosting(String jobId) async {
    try {
      // Skip confirmation dialog in test mode
      var shouldDelete = true;

      if (!Get.testMode) {
        final result = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Delete Job Posting'),
            content: const Text(
              'Are you sure you want to delete this job posting? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back<bool>(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back<bool>(result: true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

        shouldDelete = result ?? false;
      }

      if (!shouldDelete) {
        return false;
      }

      final success = await _jobPostingService.deleteJobPosting(jobId);

      if (success) {
        // Remove from jobs list
        _jobs.removeWhere((job) => job.id == jobId);
        _applyStatusFilter();
        _calculateStatusCounts();

        // Only show snackbar if not in test mode
        if (!Get.testMode) {
          Get.snackbar(
            'Success',
            'Job posting deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }

        return true;
      } else {
        throw Exception('Failed to delete job posting');
      }
    } catch (e) {
      _logger.e('Error deleting job posting', e);

      // Only show snackbar if not in test mode
      if (!Get.testMode) {
        Get.snackbar(
          'Error',
          'Failed to delete job posting: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      return false;
    }
  }

  /// Update job status
  Future<bool> updateJobStatus(String jobId, JobStatus status) async {
    try {
      final success = await _jobPostingService.updateJobStatus(jobId, status);

      if (success) {
        // Update in jobs list
        final index = _jobs.indexWhere((job) => job.id == jobId);
        if (index != -1) {
          final updatedJob = _jobs[index].copyWith(status: status);
          _jobs[index] = updatedJob;

          // Update selected job if it's the same
          if (_selectedJob.value?.id == jobId) {
            _selectedJob.value = updatedJob;
          }
        }

        _applyStatusFilter();
        _calculateStatusCounts();

        // Only show snackbar if not in test mode
        if (!Get.testMode) {
          Get.snackbar(
            'Success',
            'Job status updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }

        return true;
      } else {
        throw Exception('Failed to update job status');
      }
    } catch (e) {
      _logger.e('Error updating job status', e);

      // Only show snackbar if not in test mode
      if (!Get.testMode) {
        Get.snackbar(
          'Error',
          'Failed to update job status: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      return false;
    }
  }

  /// Duplicate a job posting
  Future<bool> duplicateJobPosting(JobPostModel job) async {
    try {
      _isCreating.value = true;

      final companyId = _companyProfileController.profile.value?.uid;
      if (companyId == null) {
        throw Exception('Company ID not available');
      }

      // Create a new job posting with the same details
      final newJob = await _jobPostingService.createJobPosting(
        companyId: companyId,
        title: '${job.title} (Copy)',
        description: job.description,
        location: job.location,
        salary: job.salary,
        requirements: job.requirements,
        responsibilities: job.responsibilities,
        skills: job.skills,
        jobType: job.jobType,
        experience: job.experience,
        education: job.education,
        industry: job.industry,
        isRemote: job.isRemote,
        applicationDeadline: job.applicationDeadline,
        status: JobStatus.draft, // Set as draft by default
        benefits: job.benefits,
      );

      if (newJob != null) {
        // Add to jobs list
        _jobs.insert(0, newJob);
        _applyStatusFilter();
        _calculateStatusCounts();

        Get.snackbar(
          'Success',
          'Job posting duplicated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        throw Exception('Failed to duplicate job posting');
      }
    } catch (e) {
      _logger.e('Error duplicating job posting', e);
      Get.snackbar(
        'Error',
        'Failed to duplicate job posting: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isCreating.value = false;
    }
  }

  /// Navigate to job details
  void navigateToJobDetails(String jobId) {
    Get.toNamed<dynamic>(Routes.jobs, arguments: jobId);
  }

  /// Navigate to applicants for a job
  void navigateToApplicants(String jobId) {
    Get.toNamed<dynamic>('/job-applicants/$jobId');
  }

  /// Refresh jobs
  Future<void> refreshJobs() async {
    await _loadJobs();
  }
}
