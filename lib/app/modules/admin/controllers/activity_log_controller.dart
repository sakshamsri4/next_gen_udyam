import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the activity log screen
class ActivityLogController extends GetxController {
  /// Constructor with optional Firestore parameter for testing
  ActivityLogController({
    required this.loggerService,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Logger service
  final LoggerService loggerService;

  /// Firestore instance
  final FirebaseFirestore _firestore;

  /// Loading state
  final RxBool isLoading = false.obs;

  /// All activity logs
  final RxList<ActivityLogItem> activityLogs = <ActivityLogItem>[].obs;

  /// Filtered activity logs
  final RxList<ActivityLogItem> filteredLogs = <ActivityLogItem>[].obs;

  /// Search query
  final RxString searchQuery = ''.obs;

  /// Date filter
  final RxString dateFilter = 'All Time'.obs;

  /// Activity type filter
  final RxString activityTypeFilter = 'All Types'.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivityLogs();

    // Set up reaction for filtering logs when any filter changes
    ever(searchQuery, (_) => filterLogs());
    ever(dateFilter, (_) => filterLogs());
    ever(activityTypeFilter, (_) => filterLogs());
  }

  /// Load activity logs from Firestore
  Future<void> loadActivityLogs() async {
    try {
      isLoading.value = true;
      loggerService.i('Loading activity logs');

      // TODO(developer): Replace with actual Firestore query
      // For now, we'll use mock data
      await Future<void>.delayed(const Duration(milliseconds: 800));

      // Mock data
      activityLogs.value = [
        ActivityLogItem(
          id: '1',
          userName: 'John Smith',
          userId: 'user123',
          action: 'Login',
          details: 'Logged in from Chrome on macOS',
          timestamp: '2 hours ago',
          dateTime: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ActivityLogItem(
          id: '2',
          userName: 'Tech Innovations',
          userId: 'company456',
          action: 'Job Posting',
          details: 'Posted a new job: Senior Flutter Developer',
          timestamp: '5 hours ago',
          dateTime: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ActivityLogItem(
          id: '3',
          userName: 'Sarah Johnson',
          userId: 'user789',
          action: 'Profile Update',
          details: 'Updated profile information and resume',
          timestamp: '1 day ago',
          dateTime: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ActivityLogItem(
          id: '4',
          userName: 'Admin User',
          userId: 'admin123',
          action: 'System',
          details: 'System backup completed successfully',
          timestamp: '2 days ago',
          dateTime: DateTime.now().subtract(const Duration(days: 2)),
        ),
        ActivityLogItem(
          id: '5',
          userName: 'Global Solutions',
          userId: 'company789',
          action: 'Job Posting',
          details: 'Updated job posting: UI/UX Designer',
          timestamp: '3 days ago',
          dateTime: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ActivityLogItem(
          id: '6',
          userName: 'Michael Brown',
          userId: 'user456',
          action: 'Job Application',
          details: 'Applied for Mobile App Developer at Design Masters',
          timestamp: '4 days ago',
          dateTime: DateTime.now().subtract(const Duration(days: 4)),
        ),
        ActivityLogItem(
          id: '7',
          userName: 'Admin User',
          userId: 'admin123',
          action: 'System',
          details: 'Approved company verification for Tech Innovations',
          timestamp: '5 days ago',
          dateTime: DateTime.now().subtract(const Duration(days: 5)),
        ),
        ActivityLogItem(
          id: '8',
          userName: 'Jessica Lee',
          userId: 'user321',
          action: 'Login',
          details: 'Failed login attempt from unknown device',
          timestamp: '6 days ago',
          dateTime: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ];

      // Initialize filtered logs with all logs
      filteredLogs.value = activityLogs;

      loggerService.d('Loaded ${activityLogs.length} activity logs');
    } catch (e, stackTrace) {
      loggerService.e('Error loading activity logs', e, stackTrace);
      activityLogs.value = [];
      filteredLogs.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Update search query and filter logs
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Update date filter and filter logs
  void updateDateFilter(String filter) {
    dateFilter.value = filter;
  }

  /// Update activity type filter and filter logs
  void updateActivityTypeFilter(String filter) {
    activityTypeFilter.value = filter;
  }

  /// Filter logs based on current filters
  void filterLogs() {
    // Start with all logs
    List<ActivityLogItem> filtered = activityLogs;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((log) {
        return log.userName.toLowerCase().contains(query) ||
            log.details.toLowerCase().contains(query) ||
            log.action.toLowerCase().contains(query);
      }).toList();
    }

    // Apply date filter
    if (dateFilter.value != 'All Time') {
      final now = DateTime.now();
      DateTime? startDate;

      switch (dateFilter.value) {
        case 'Today':
          startDate = DateTime(now.year, now.month, now.day);
        case 'Last 7 Days':
          startDate = now.subtract(const Duration(days: 7));
        case 'Last 30 Days':
          startDate = now.subtract(const Duration(days: 30));
        // Custom date range would be handled differently
      }

      if (startDate != null) {
        filtered = filtered.where((log) {
          return log.dateTime.isAfter(startDate!);
        }).toList();
      }
    }

    // Apply activity type filter
    if (activityTypeFilter.value != 'All Types') {
      filtered = filtered.where((log) {
        return log.action == activityTypeFilter.value;
      }).toList();
    }

    // Update filtered logs
    filteredLogs.value = filtered;
    loggerService.d(
      'Filtered logs: ${filteredLogs.length} of ${activityLogs.length}',
    );
  }

  /// Refresh activity logs
  Future<void> refreshLogs() async {
    return loadActivityLogs();
  }
}

/// Model class for activity log items in the UI
class ActivityLogItem {
  /// Creates an activity log item
  ActivityLogItem({
    required this.id,
    required this.userName,
    required this.userId,
    required this.action,
    required this.details,
    required this.timestamp,
    required this.dateTime,
  });

  /// The ID of the activity log
  final String id;

  /// The name of the user who performed the action
  final String userName;

  /// The ID of the user who performed the action
  final String userId;

  /// The action performed
  final String action;

  /// Details about the action
  final String details;

  /// Human-readable timestamp (e.g., "2 hours ago")
  final String timestamp;

  /// Actual date and time for filtering
  final DateTime dateTime;
}
