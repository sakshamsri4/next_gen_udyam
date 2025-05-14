import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/admin/models/user_activity_log_model.dart';
import 'package:next_gen/app/modules/admin/models/user_filter_model.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the user management screen
class UserManagementController extends GetxController {
  /// Constructor
  UserManagementController({
    required this.loggerService,
  });

  /// Logger service
  final LoggerService loggerService;

  /// Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Users list
  final RxList<UserModel> users = <UserModel>[].obs;

  /// Selected user
  final Rx<UserModel?> selectedUser = Rx<UserModel?>(null);

  /// Current filter
  final Rx<UserFilterModel> filter = UserFilterModel().obs;

  /// User activity logs
  final RxList<UserActivityLog> activityLogs = <UserActivityLog>[].obs;

  /// Total users count
  final RxInt totalUsers = 0.obs;

  /// Active users count
  final RxInt activeUsers = 0.obs;

  /// New users count (last 30 days)
  final RxInt newUsers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadUserStats();
  }

  /// Load users from Firestore
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      loggerService.i('Loading users with filter: ${filter.value.searchQuery}');

      // Start with the users collection
      Query query = _firestore.collection('users');

      // Apply filters
      final currentFilter = filter.value;

      // Filter by user type if specified
      if (currentFilter.userTypes.isNotEmpty) {
        final userTypeStrings = currentFilter.userTypes
            .map((type) => type.toString().split('.').last)
            .toList();
        query = query.where('userType', whereIn: userTypeStrings);
      }

      // Filter by verification status if specified
      if (currentFilter.isVerified != null) {
        query =
            query.where('emailVerified', isEqualTo: currentFilter.isVerified);
      }

      // Apply date range filter if specified
      if (currentFilter.dateRange != null) {
        query = query
            .where(
              'createdAt',
              isGreaterThanOrEqualTo:
                  currentFilter.dateRange!.start.toIso8601String(),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo:
                  currentFilter.dateRange!.end.toIso8601String(),
            );
      }

      // Apply sorting
      switch (currentFilter.sortBy) {
        case UserSortOption.newest:
          query = query.orderBy('createdAt', descending: true);
        case UserSortOption.oldest:
          query = query.orderBy('createdAt', descending: false);
        case UserSortOption.nameAsc:
          query = query.orderBy('displayName', descending: false);
        case UserSortOption.nameDesc:
          query = query.orderBy('displayName', descending: true);
      }

      // Execute the query
      final snapshot = await query.get();
      final usersList = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();

      // Apply search filter (client-side for flexibility)
      if (currentFilter.searchQuery.isNotEmpty) {
        final searchLower = currentFilter.searchQuery.toLowerCase();
        users.value = usersList.where((user) {
          return (user.displayName?.toLowerCase().contains(searchLower) ??
                  false) ||
              user.email.toLowerCase().contains(searchLower);
        }).toList();
      } else {
        users.value = usersList;
      }

      loggerService.d('Loaded ${users.length} users');
    } catch (e, stackTrace) {
      loggerService.e('Error loading users', e, stackTrace);
      users.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Load user statistics
  Future<void> loadUserStats() async {
    try {
      // Get total users count
      final totalSnapshot = await _firestore.collection('users').count().get();
      totalUsers.value = totalSnapshot.count ?? 0;

      // Get active users (users who logged in within the last 7 days)
      // This would require a lastLoginAt field in the user document
      // For now, we'll use a mock value
      activeUsers.value = (totalUsers.value * 0.7).round();

      // Get new users (registered in the last 30 days)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final newUsersSnapshot = await _firestore
          .collection('users')
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: thirtyDaysAgo.toIso8601String(),
          )
          .count()
          .get();
      newUsers.value = newUsersSnapshot.count ?? 0;
    } catch (e, stackTrace) {
      loggerService.e('Error loading user stats', e, stackTrace);
    }
  }

  /// Update user filter and reload users
  Future<void> updateFilter(UserFilterModel newFilter) async {
    filter.value = newFilter;
    await loadUsers();
  }

  /// Reset filter to default values
  Future<void> resetFilter() async {
    filter.value = UserFilterModel();
    await loadUsers();
  }

  /// Update user role
  Future<void> updateUserRole(String userId, UserType newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'userType': newRole.toString().split('.').last,
      });

      // Update the user in the list
      final index = users.indexWhere((user) => user.uid == userId);
      if (index != -1) {
        final updatedUser = users[index].copyWith(userType: newRole);
        users[index] = updatedUser;

        // Update selected user if it's the same
        if (selectedUser.value?.uid == userId) {
          selectedUser.value = updatedUser;
        }
      }

      loggerService.i(
        'Updated user role: $userId to ${newRole.toString().split('.').last}',
      );
    } catch (e, stackTrace) {
      loggerService.e('Error updating user role', e, stackTrace);
      rethrow;
    }
  }

  /// Load user activity logs
  Future<void> loadUserActivityLogs(String userId) async {
    try {
      // In a real app, this would fetch from Firestore
      // For now, we'll use mock data
      await Future<void>.delayed(const Duration(milliseconds: 500));

      activityLogs.value = [
        UserActivityLog(
          id: '1',
          userId: userId,
          action: 'Login',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          details: {'message': 'Logged in from Chrome on macOS'},
        ),
        UserActivityLog(
          id: '2',
          userId: userId,
          action: 'Profile Update',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          details: {'message': 'Updated profile information'},
        ),
        UserActivityLog(
          id: '3',
          userId: userId,
          action: 'Job Application',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          details: {
            'message':
                'Applied for Senior Flutter Developer at Tech Innovations',
          },
        ),
      ];
    } catch (e, stackTrace) {
      loggerService.e('Error loading user activity logs', e, stackTrace);
      activityLogs.value = [];
    }
  }

  /// Select a user to view details
  void selectUser(UserModel user) {
    selectedUser.value = user;
    loadUserActivityLogs(user.uid);
  }

  /// Clear selected user
  void clearSelectedUser() {
    selectedUser.value = null;
    activityLogs.clear();
  }
}
