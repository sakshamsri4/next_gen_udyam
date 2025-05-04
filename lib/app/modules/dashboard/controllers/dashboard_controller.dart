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

  /// Load dashboard data including automobile sector job statistics
  /// and recent activity
  Future<void> _loadDashboardData() async {
    _logger.i('Loading automobile sector dashboard data');
    isLoading.value = true;
    update(); // Notify GetBuilder to update UI

    try {
      // Simulate network delay
      await Future<void>.delayed(const Duration(seconds: 2));

      // Load mock automobile sector job statistics
      jobStatistics.value = [
        JobStatistic(
          title: 'Available Positions',
          value: 156,
          change: 12,
          isPositive: true,
          color: const Color(0xFF4CAF50),
          icon: Icons.work,
        ),
        JobStatistic(
          title: 'Avg. Salary (K)',
          value: 85,
          change: 5,
          isPositive: true,
          color: const Color(0xFF2196F3),
          icon: Icons.attach_money,
          unit: 'USD',
        ),
        JobStatistic(
          title: 'Top Manufacturers',
          value: 24,
          change: 3,
          isPositive: true,
          color: const Color(0xFFFF9800),
          icon: Icons.business,
          unit: 'companies',
        ),
        JobStatistic(
          title: 'Skills in Demand',
          value: 18,
          change: 4,
          isPositive: true,
          color: const Color(0xFF9C27B0),
          icon: Icons.trending_up,
          unit: 'skills',
        ),
      ];

      // Load mock recent activity for automobile sector
      recentActivity.value = [
        ActivityItem(
          title: 'Application Submitted',
          description: 'Automotive Engineer at Tesla',
          time: DateTime.now().subtract(const Duration(hours: 2)),
          icon: Icons.send,
          color: const Color(0xFF4CAF50),
        ),
        ActivityItem(
          title: 'Interview Scheduled',
          description: 'Mechanical Design at Toyota',
          time: DateTime.now().subtract(const Duration(days: 1)),
          icon: Icons.calendar_today,
          color: const Color(0xFF2196F3),
        ),
        ActivityItem(
          title: 'New Job Posted',
          description: 'Electric Vehicle Specialist at Rivian',
          time: DateTime.now().subtract(const Duration(days: 2)),
          icon: Icons.work,
          color: const Color(0xFF9C27B0),
        ),
        ActivityItem(
          title: 'Offer Received',
          description: 'Automotive Software Engineer at BMW',
          time: DateTime.now().subtract(const Duration(days: 4)),
          icon: Icons.check_circle,
          color: const Color(0xFFFF9800),
        ),
      ];

      _logger.i('Dashboard data loaded successfully');
    } catch (e, s) {
      _logger.e('Error loading dashboard data', e, s);
    } finally {
      isLoading.value = false;
      update(); // Notify GetBuilder to update UI
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
    update(); // Notify GetBuilder to update UI

    try {
      await _authController.signOut();
      _logger.i('User signed out successfully');
    } catch (e, s) {
      _logger.e('Error signing out', e, s);
    } finally {
      isSignOutLoading.value = false;
      update(); // Notify GetBuilder to update UI
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
    required this.icon,
    this.unit = 'jobs',
  });
  final String title;
  final int value;
  final int change;
  final bool isPositive;
  final Color color;
  final IconData icon;
  final String unit;
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
