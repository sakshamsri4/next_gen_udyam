import 'package:get/get.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the admin dashboard screen
class AdminDashboardController extends GetxController {
  // Dependencies
  final LoggerService _logger = Get.find<LoggerService>();

  // Observable state variables
  final RxBool isLoading = true.obs;
  final RxList<ModerationItem> moderationQueue = <ModerationItem>[].obs;
  final RxList<UserActivity> recentActivity = <UserActivity>[].obs;
  final RxMap<String, dynamic> systemMetrics = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _logger.i('AdminDashboardController initialized');

    // Load initial data
    loadData();
  }

  /// Load all data for the dashboard
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Load data in parallel for better performance
      await Future.wait<void>([
        _loadModerationQueue(),
        _loadRecentActivity(),
        _loadSystemMetrics(),
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

  /// Load moderation queue
  Future<void> _loadModerationQueue() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 800));

      // Mock data for now
      moderationQueue.value = [
        ModerationItem(
          id: '301',
          type: 'Job Posting',
          title: 'Senior Flutter Developer',
          submittedBy: 'Tech Innovations',
          submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
          status: 'Pending',
          priority: 'High',
        ),
        ModerationItem(
          id: '302',
          type: 'Company Profile',
          title: 'Global Solutions',
          submittedBy: 'Global Solutions',
          submittedAt: DateTime.now().subtract(const Duration(days: 1)),
          status: 'Pending',
          priority: 'Medium',
        ),
        ModerationItem(
          id: '303',
          type: 'User Report',
          title: 'Inappropriate Content',
          submittedBy: 'John Smith',
          submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
          status: 'Pending',
          priority: 'High',
        ),
        ModerationItem(
          id: '304',
          type: 'Job Posting',
          title: 'Mobile App Developer',
          submittedBy: 'Design Masters',
          submittedAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'Pending',
          priority: 'Low',
        ),
      ];
    } catch (e) {
      _logger.e('Error loading moderation queue', e);
      moderationQueue.value = [];
    }
  }

  /// Load recent activity
  Future<void> _loadRecentActivity() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Mock data for now
      recentActivity.value = [
        UserActivity(
          id: '401',
          userId: 'user123',
          userName: 'John Smith',
          userPhoto:
              'https://ui-avatars.com/api/?name=John+Smith&background=4F46E5&color=fff',
          action: 'Created account',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          details: 'New employee account',
        ),
        UserActivity(
          id: '402',
          userId: 'user124',
          userName: 'Tech Innovations',
          userPhoto:
              'https://ui-avatars.com/api/?name=Tech+Innovations&background=059669&color=fff',
          action: 'Posted job',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          details: 'Senior Flutter Developer',
        ),
        UserActivity(
          id: '403',
          userId: 'user125',
          userName: 'Sarah Johnson',
          userPhoto:
              'https://ui-avatars.com/api/?name=Sarah+Johnson&background=4F46E5&color=fff',
          action: 'Applied for job',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          details: 'Mobile App Developer at Global Solutions',
        ),
        UserActivity(
          id: '404',
          userId: 'user126',
          userName: 'Global Solutions',
          userPhoto:
              'https://ui-avatars.com/api/?name=Global+Solutions&background=059669&color=fff',
          action: 'Updated profile',
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          details: 'Company profile updated',
        ),
      ];
    } catch (e) {
      _logger.e('Error loading recent activity', e);
      recentActivity.value = [];
    }
  }

  /// Load system metrics
  Future<void> _loadSystemMetrics() async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 700));

      // Mock data for now
      systemMetrics.value = {
        'totalUsers': 1254,
        'activeUsers': 876,
        'newUsersToday': 42,
        'totalJobs': 328,
        'activeJobs': 215,
        'newJobsToday': 18,
        'totalApplications': 1876,
        'newApplicationsToday': 124,
        'serverLoad': 32, // percentage
        'responseTime': 215, // ms
        'errorRate': 0.5, // percentage
      };
    } catch (e) {
      _logger.e('Error loading system metrics', e);
      systemMetrics.value = {};
    }
  }

  /// Update the status of a moderation item
  Future<void> _updateModerationStatus(String id, String newStatus) async {
    try {
      // TODO(developer): Replace with actual API call
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Update the local state
      final index = moderationQueue.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = moderationQueue[index];
        moderationQueue[index] = item.copyWith(status: newStatus);
      }

      _logger.d('Moderation item $newStatus: $id');
    } catch (e) {
      _logger.e('Error updating moderation item status', e);
    }
  }

  /// Approve a moderation item
  Future<void> approveModerationItem(String id) async {
    await _updateModerationStatus(id, 'Approved');
  }

  /// Reject a moderation item
  Future<void> rejectModerationItem(String id) async {
    await _updateModerationStatus(id, 'Rejected');
  }
}

/// Model class for moderation items
class ModerationItem {
  /// Creates a moderation item
  ModerationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.submittedBy,
    required this.submittedAt,
    required this.status,
    required this.priority,
  });

  /// The ID of the moderation item
  final String id;

  /// The type of the moderation item (Job Posting, Company Profile, User Report)
  final String type;

  /// The title of the moderation item
  final String title;

  /// The user or company who submitted the item
  final String submittedBy;

  /// The timestamp when the item was submitted
  final DateTime submittedAt;

  /// The status of the moderation item (Pending, Approved, Rejected)
  final String status;

  /// The priority of the moderation item (High, Medium, Low)
  final String priority;

  /// Create a copy of this moderation item with the given fields replaced
  ModerationItem copyWith({
    String? id,
    String? type,
    String? title,
    String? submittedBy,
    DateTime? submittedAt,
    String? status,
    String? priority,
  }) {
    return ModerationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      submittedBy: submittedBy ?? this.submittedBy,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }
}

/// Model class for user activity
class UserActivity {
  /// Creates a user activity
  UserActivity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhoto,
    required this.action,
    required this.timestamp,
    required this.details,
  });

  /// The ID of the activity
  final String id;

  /// The ID of the user
  final String userId;

  /// The name of the user
  final String userName;

  /// The photo URL of the user
  final String userPhoto;

  /// The action performed by the user
  final String action;

  /// The timestamp of the activity
  final DateTime timestamp;

  /// Additional details about the activity
  final String details;
}
