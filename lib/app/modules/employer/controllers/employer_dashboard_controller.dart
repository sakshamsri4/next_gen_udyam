import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the employer dashboard screen
class EmployerDashboardController extends GetxController {
  // Dependencies
  final LoggerService _logger = Get.find<LoggerService>();

  // Observable state variables
  final RxBool isLoading = true.obs;
  final RxList<JobModel> activeJobs = <JobModel>[].obs;
  final RxList<ApplicantUpdate> recentApplicants = <ApplicantUpdate>[].obs;
  final RxMap<String, dynamic> metrics = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _logger.i('EmployerDashboardController initialized');

    // Load initial data
    loadData();
  }

  /// Load all data for the dashboard
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Load data in parallel for better performance
      await Future.wait([
        _loadActiveJobs(),
        _loadRecentApplicants(),
        _loadMetrics(),
      ]);

      _logger.d('Dashboard data loaded successfully');
    } catch (e) {
      _logger.e('Error loading dashboard data', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    _logger.d('Refreshing dashboard data');
    return loadData();
  }

  /// Load active jobs
  Future<void> _loadActiveJobs() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 800));

      // Mock data for now
      activeJobs.value = [
        JobModel(
          id: '101',
          title: 'Senior Flutter Developer',
          company: 'Your Company',
          location: 'New York, NY',
          salary: 120000,
          description:
              'We are looking for a Senior Flutter Developer to join our team and help build our next-generation mobile applications.',
          postedDate: DateTime.now().subtract(const Duration(days: 5)),
          isRemote: true,
          logoUrl:
              'https://ui-avatars.com/api/?name=Your+Company&background=059669&color=fff',
        ),
        JobModel(
          id: '102',
          title: 'Mobile App Developer',
          company: 'Your Company',
          location: 'San Francisco, CA',
          salary: 110000,
          description:
              'Join our team to develop cutting-edge mobile applications for our global client base.',
          postedDate: DateTime.now().subtract(const Duration(days: 10)),
          logoUrl:
              'https://ui-avatars.com/api/?name=Your+Company&background=059669&color=fff',
        ),
        JobModel(
          id: '103',
          title: 'Flutter UI/UX Developer',
          company: 'Your Company',
          location: 'Remote',
          salary: 95000,
          description:
              'Looking for a Flutter developer with strong UI/UX skills to create beautiful and functional mobile applications.',
          postedDate: DateTime.now().subtract(const Duration(days: 3)),
          isRemote: true,
          jobType: 'Contract',
          logoUrl:
              'https://ui-avatars.com/api/?name=Your+Company&background=059669&color=fff',
        ),
      ];
    } catch (e) {
      _logger.e('Error loading active jobs', e);
      activeJobs.value = [];
    }
  }

  /// Load recent applicants
  Future<void> _loadRecentApplicants() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Mock data for now
      recentApplicants.value = [
        ApplicantUpdate(
          applicantId: '201',
          jobId: '101',
          jobTitle: 'Senior Flutter Developer',
          applicantName: 'John Smith',
          applicantPhoto:
              'https://ui-avatars.com/api/?name=John+Smith&background=2563EB&color=fff',
          status: 'New',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ApplicantUpdate(
          applicantId: '202',
          jobId: '102',
          jobTitle: 'Mobile App Developer',
          applicantName: 'Sarah Johnson',
          applicantPhoto:
              'https://ui-avatars.com/api/?name=Sarah+Johnson&background=2563EB&color=fff',
          status: 'Reviewed',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ApplicantUpdate(
          applicantId: '203',
          jobId: '101',
          jobTitle: 'Senior Flutter Developer',
          applicantName: 'Michael Brown',
          applicantPhoto:
              'https://ui-avatars.com/api/?name=Michael+Brown&background=2563EB&color=fff',
          status: 'Interview',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
    } catch (e) {
      _logger.e('Error loading recent applicants', e);
      recentApplicants.value = [];
    }
  }

  /// Load dashboard metrics
  Future<void> _loadMetrics() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 700));

      // Mock data for now
      metrics.value = {
        'totalJobs': 5,
        'activeJobs': 3,
        'totalApplicants': 27,
        'newApplicants': 8,
        'interviewsScheduled': 4,
        'offersSent': 1,
        'viewsToday': 156,
        'applicationsToday': 12,
        'conversionRate': 7.7, // percentage
      };
    } catch (e) {
      _logger.e('Error loading metrics', e);
      metrics.value = {};
    }
  }

  /// Get company name
  String getCompanyName() {
    return 'Your Company';
  }
}

/// Model class for applicant updates
class ApplicantUpdate {
  /// Creates an applicant update
  ApplicantUpdate({
    required this.applicantId,
    required this.jobId,
    required this.jobTitle,
    required this.applicantName,
    required this.applicantPhoto,
    required this.status,
    required this.timestamp,
  });

  /// The ID of the applicant
  final String applicantId;

  /// The ID of the job
  final String jobId;

  /// The title of the job
  final String jobTitle;

  /// The name of the applicant
  final String applicantName;

  /// The photo URL of the applicant
  final String applicantPhoto;

  /// The status of the application (New, Reviewed, Interview, Offer, Rejected)
  final String status;

  /// The timestamp of the update
  final DateTime timestamp;
}
