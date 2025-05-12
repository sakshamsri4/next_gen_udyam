import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for admin dashboard
class AdminController extends GetxController {
  final LoggerService _logger = Get.find<LoggerService>();
  final AuthController _authController = Get.find<AuthController>();

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Admin name
  final RxString adminName = ''.obs;

  /// System health metrics
  final RxInt activeUsersCount = 0.obs;
  final RxInt totalJobsCount = 0.obs;
  final RxInt serverUptime = 0.obs;
  final RxDouble errorRate = 0.0.obs;

  /// User growth statistics
  final RxDouble userGrowthRate = 0.0.obs;

  /// Content moderation queue
  final RxList<ModerationItem> moderationItems = <ModerationItem>[].obs;

  /// Activity logs
  final RxList<ActivityLog> activityLogs = <ActivityLog>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAdminName();
    _loadDashboardData();
  }

  /// Load admin name from auth controller
  void _loadAdminName() {
    try {
      final user = _authController.user.value;
      if (user != null && user.displayName != null) {
        adminName.value = user.displayName!;
      } else {
        adminName.value = 'Admin';
      }
    } catch (e) {
      _logger.e('Error loading admin name', e);
      adminName.value = 'Admin';
    }
  }

  /// Load dashboard data
  Future<void> _loadDashboardData() async {
    isLoading.value = true;

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 1));

      // Load mock data
      _loadMockData();
    } catch (e) {
      _logger.e('Error loading dashboard data', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Load mock data for testing
  void _loadMockData() {
    // System health metrics
    activeUsersCount.value = 1245;
    totalJobsCount.value = 567;
    serverUptime.value = 32;
    errorRate.value = 0.05;

    // User growth statistics
    userGrowthRate.value = 12.5;

    // Content moderation queue
    moderationItems.value = [
      ModerationItem(
        id: '1',
        title: 'Job Posting: Senior Developer',
        reason: 'Contains potentially discriminatory language',
        type: 'job',
      ),
      ModerationItem(
        id: '2',
        title: 'User Profile: John Doe',
        reason: 'Reported for inappropriate content',
        type: 'user',
      ),
      ModerationItem(
        id: '3',
        title: 'Company Profile: Tech Solutions',
        reason: 'Verification required',
        type: 'company',
      ),
    ];

    // Activity logs
    activityLogs.value = [
      ActivityLog(
        id: '1',
        message: 'New user registered',
        user: 'john.doe@example.com',
        timeAgo: '5 minutes ago',
        type: 'user',
      ),
      ActivityLog(
        id: '2',
        message: 'Job posting approved',
        user: 'admin@example.com',
        timeAgo: '10 minutes ago',
        type: 'job',
      ),
      ActivityLog(
        id: '3',
        message: 'System backup completed',
        user: 'system',
        timeAgo: '1 hour ago',
        type: 'system',
      ),
      ActivityLog(
        id: '4',
        message: 'Failed login attempt',
        user: 'unknown@example.com',
        timeAgo: '2 hours ago',
        type: 'error',
      ),
    ];
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    return _loadDashboardData();
  }

  /// Navigate to system settings
  void navigateToSystemSettings() {
    Get.toNamed<dynamic>(Routes.settings);
  }

  /// Approve content
  void approveContent(String id) {
    _logger.i('Approving content with ID: $id');
    // Remove from moderation queue
    moderationItems.removeWhere((item) => item.id == id);
    // Add to activity log
    activityLogs.insert(
      0,
      ActivityLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Content approved',
        user: adminName.value,
        timeAgo: 'just now',
        type: 'system',
      ),
    );
  }

  /// Reject content
  void rejectContent(String id) {
    _logger.i('Rejecting content with ID: $id');
    // Remove from moderation queue
    moderationItems.removeWhere((item) => item.id == id);
    // Add to activity log
    activityLogs.insert(
      0,
      ActivityLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Content rejected',
        user: adminName.value,
        timeAgo: 'just now',
        type: 'system',
      ),
    );
  }

  /// View content details
  void viewContentDetails(String id) {
    _logger.i('Viewing content details for ID: $id');
    // Navigate to content details page
    // This would be implemented in a real app
  }

  /// View activity details
  void viewActivityDetails(String id) {
    _logger.i('Viewing activity details for ID: $id');
    // Navigate to activity details page
    // This would be implemented in a real app
  }
}

/// Model class for moderation items
class ModerationItem {
  /// Constructor
  ModerationItem({
    required this.id,
    required this.title,
    required this.reason,
    required this.type,
  });

  /// Item ID
  final String id;

  /// Item title
  final String title;

  /// Reason for moderation
  final String reason;

  /// Item type (job, user, company, etc.)
  final String type;
}

/// Model class for activity logs
class ActivityLog {
  /// Constructor
  ActivityLog({
    required this.id,
    required this.message,
    required this.user,
    required this.timeAgo,
    required this.type,
  });

  /// Log ID
  final String id;

  /// Log message
  final String message;

  /// User who performed the action
  final String user;

  /// Time ago string (e.g. "5 minutes ago")
  final String timeAgo;

  /// Log type (user, job, system, error, etc.)
  final String type;
}
