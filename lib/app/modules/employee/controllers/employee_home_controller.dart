import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the employee home screen
class EmployeeHomeController extends GetxController {
  // Dependencies
  final LoggerService _logger = Get.find<LoggerService>();

  // Observable state variables
  final RxBool isLoading = true.obs;
  final RxList<JobModel> recommendedJobs = <JobModel>[].obs;
  final RxList<JobModel> recentlyViewedJobs = <JobModel>[].obs;
  final RxList<ApplicationUpdate> applicationUpdates =
      <ApplicationUpdate>[].obs;
  final RxSet<String> savedJobIds = <String>{}.obs;

  // Additional properties for DiscoverView
  final RxString userName = 'User'.obs;

  // Alias for applicationUpdates to match DiscoverView
  List<ApplicationUpdate> get applications => applicationUpdates;

  @override
  void onInit() {
    super.onInit();
    _logger.i('EmployeeHomeController initialized');

    // Load initial data
    loadData();
  }

  /// Load all data for the home screen
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Load data in parallel for better performance
      await Future.wait<void>([
        _loadRecommendedJobs(),
        _loadRecentlyViewedJobs(),
        _loadApplicationUpdates(),
        _loadSavedJobs(),
      ]);

      _logger.d('Home screen data loaded successfully');
    } catch (e) {
      _logger.e('Error loading home screen data', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    _logger.d('Refreshing home screen data');
    return loadData();
  }

  /// Load recommended jobs
  Future<void> _loadRecommendedJobs() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 800));

      // Mock data for now
      recommendedJobs.value = [
        JobModel(
          id: '1',
          title: 'Senior Flutter Developer',
          company: 'Tech Innovations',
          location: 'New York, NY',
          salary: 120000,
          description:
              'We are looking for a Senior Flutter Developer to join our team and help build our next-generation mobile applications.',
          postedDate: DateTime.now().subtract(const Duration(days: 2)),
          isRemote: true,
          logoUrl:
              'https://ui-avatars.com/api/?name=Tech+Innovations&background=0D8ABC&color=fff',
        ),
        JobModel(
          id: '2',
          title: 'Mobile App Developer',
          company: 'Global Solutions',
          location: 'San Francisco, CA',
          salary: 110000,
          description:
              'Join our team to develop cutting-edge mobile applications for our global client base.',
          postedDate: DateTime.now().subtract(const Duration(days: 3)),
          logoUrl:
              'https://ui-avatars.com/api/?name=Global+Solutions&background=2563EB&color=fff',
        ),
        JobModel(
          id: '3',
          title: 'Flutter UI/UX Developer',
          company: 'Design Masters',
          location: 'Remote',
          salary: 95000,
          description:
              'Looking for a Flutter developer with strong UI/UX skills to create beautiful and functional mobile applications.',
          postedDate: DateTime.now().subtract(const Duration(days: 1)),
          isRemote: true,
          jobType: 'Contract',
          logoUrl:
              'https://ui-avatars.com/api/?name=Design+Masters&background=9333EA&color=fff',
        ),
      ];
    } catch (e) {
      _logger.e('Error loading recommended jobs', e);
      recommendedJobs.value = [];
    }
  }

  /// Load recently viewed jobs
  Future<void> _loadRecentlyViewedJobs() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Mock data for now
      recentlyViewedJobs.value = [
        JobModel(
          id: '4',
          title: 'Lead Mobile Developer',
          company: 'Startup Innovators',
          location: 'Austin, TX',
          salary: 130000,
          description:
              'Lead our mobile development team and help shape the future of our products.',
          postedDate: DateTime.now().subtract(const Duration(days: 4)),
          logoUrl:
              'https://ui-avatars.com/api/?name=Startup+Innovators&background=059669&color=fff',
        ),
        JobModel(
          id: '5',
          title: 'Flutter Consultant',
          company: 'Tech Consulting Group',
          location: 'Remote',
          salary: 100000,
          description:
              'Work with our clients to deliver high-quality Flutter applications.',
          postedDate: DateTime.now().subtract(const Duration(days: 5)),
          isRemote: true,
          jobType: 'Contract',
          logoUrl:
              'https://ui-avatars.com/api/?name=Tech+Consulting&background=0D9488&color=fff',
        ),
      ];
    } catch (e) {
      _logger.e('Error loading recently viewed jobs', e);
      recentlyViewedJobs.value = [];
    }
  }

  /// Load application updates
  Future<void> _loadApplicationUpdates() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 700));

      // Mock data for now
      applicationUpdates.value = [
        ApplicationUpdate(
          applicationId: '101',
          jobId: '1',
          jobTitle: 'Senior Flutter Developer',
          companyName: 'Tech Innovations',
          status: 'Reviewed',
          message:
              'Your application has been reviewed. We would like to schedule an interview.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ApplicationUpdate(
          applicationId: '102',
          jobId: '2',
          jobTitle: 'Mobile App Developer',
          companyName: 'Global Solutions',
          status: 'Interview',
          message: 'Interview scheduled for next Tuesday at 2:00 PM.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    } catch (e) {
      _logger.e('Error loading application updates', e);
      applicationUpdates.value = [];
    }
  }

  /// Load saved jobs
  Future<void> _loadSavedJobs() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Mock data for now
      savedJobIds.addAll({'2', '5'});
    } catch (e) {
      _logger.e('Error loading saved jobs', e);
      savedJobIds.clear();
    }
  }

  /// Toggle save/unsave a job
  Future<bool> toggleSaveJob(String jobId) async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (savedJobIds.contains(jobId)) {
        savedJobIds.remove(jobId);
        _logger.d('Job unsaved: $jobId');
        return false;
      } else {
        savedJobIds.add(jobId);
        _logger.d('Job saved: $jobId');
        return true;
      }
    } catch (e) {
      _logger.e('Error toggling save job', e);
      return savedJobIds.contains(jobId);
    }
  }

  /// Check if a job is saved
  bool isJobSaved(String jobId) {
    return savedJobIds.contains(jobId);
  }
}

/// Model class for application updates
class ApplicationUpdate {
  /// Creates an application update
  ApplicationUpdate({
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.message,
    required this.timestamp,
  });

  /// The ID of the application
  final String applicationId;

  /// The ID of the job
  final String jobId;

  /// The title of the job
  final String jobTitle;

  /// The name of the company
  final String companyName;

  /// The status of the application (Reviewed, Interview, Offer, Rejected)
  final String status;

  /// The message describing the update
  final String message;

  /// The timestamp of the update
  final DateTime timestamp;
}
