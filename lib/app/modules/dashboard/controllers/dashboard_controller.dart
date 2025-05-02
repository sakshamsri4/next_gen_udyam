import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the Dashboard module
class DashboardController extends GetxController {
  // Dependencies
  late final LoggerService _logger;
  late final AuthController _authController;

  // Observable state variables
  final RxBool isLoading = false.obs;
  final RxBool isSignOutLoading = false.obs;
  final RxList<JobStatistic> jobStatistics = <JobStatistic>[].obs;
  final RxList<ActivityItem> recentActivity = <ActivityItem>[].obs;

  // User information
  Rx<User?> get user => _authController.user;

  @override
  void onInit() {
    super.onInit();
    _logger = Get.find<LoggerService>();
    _logger.i('DashboardController initialized');

    try {
      _authController = Get.find<AuthController>();
    } catch (e) {
      _logger.e('Failed to find AuthController', e);
      _authController = Get.put(AuthController(), permanent: true);
    }

    // Load initial data
    _loadDashboardData();
  }

  /// Load dashboard data including job statistics and recent activity
  Future<void> _loadDashboardData() async {
    _logger.i('Loading dashboard data');
    isLoading.value = true;

    try {
      // Simulate network delay
      await Future<void>.delayed(const Duration(seconds: 2));

      // Load mock job statistics
      jobStatistics.value = [
        JobStatistic(
          title: 'Applications',
          value: 24,
          change: 8,
          isPositive: true,
          color: const Color(0xFF4CAF50),
        ),
        JobStatistic(
          title: 'Interviews',
          value: 5,
          change: 2,
          isPositive: true,
          color: const Color(0xFF2196F3),
        ),
        JobStatistic(
          title: 'Offers',
          value: 2,
          change: 1,
          isPositive: true,
          color: const Color(0xFFFF9800),
        ),
        JobStatistic(
          title: 'Rejections',
          value: 12,
          change: 3,
          isPositive: false,
          color: const Color(0xFFF44336),
        ),
      ];

      // Load mock recent activity
      recentActivity.value = [
        ActivityItem(
          title: 'Application Submitted',
          description: 'Senior Flutter Developer at Google',
          time: DateTime.now().subtract(const Duration(hours: 2)),
          icon: Icons.send,
          color: const Color(0xFF4CAF50),
        ),
        ActivityItem(
          title: 'Interview Scheduled',
          description: 'Technical Interview with Amazon',
          time: DateTime.now().subtract(const Duration(days: 1)),
          icon: Icons.calendar_today,
          color: const Color(0xFF2196F3),
        ),
        ActivityItem(
          title: 'Application Rejected',
          description: 'Junior Developer at Microsoft',
          time: DateTime.now().subtract(const Duration(days: 3)),
          icon: Icons.cancel,
          color: const Color(0xFFF44336),
        ),
        ActivityItem(
          title: 'Offer Received',
          description: 'Mobile Developer at Facebook',
          time: DateTime.now().subtract(const Duration(days: 5)),
          icon: Icons.check_circle,
          color: const Color(0xFFFF9800),
        ),
      ];

      _logger.i('Dashboard data loaded successfully');
    } catch (e, s) {
      _logger.e('Error loading dashboard data', e, s);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    _logger.i('Refreshing dashboard data');
    await _loadDashboardData();
  }

  /// Sign out the current user
  Future<void> signOut() async {
    _logger.i('Signing out user');
    isSignOutLoading.value = true;

    try {
      await _authController.signOut();
      _logger.i('User signed out successfully');
    } catch (e, s) {
      _logger.e('Error signing out', e, s);
    } finally {
      isSignOutLoading.value = false;
    }
  }
}

/// Model class for job statistics
class JobStatistic {
  JobStatistic({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.color,
  });
  final String title;
  final int value;
  final int change;
  final bool isPositive;
  final Color color;
}

/// Model class for recent activity items
class ActivityItem {
  ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
  final String title;
  final String description;
  final DateTime time;
  final IconData icon;
  final Color color;
}
