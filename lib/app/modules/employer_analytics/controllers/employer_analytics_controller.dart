import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/employer_analytics/models/analytics_data_model.dart';
import 'package:next_gen/app/modules/employer_analytics/services/employer_analytics_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for employer analytics
class EmployerAnalyticsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Constructor
  EmployerAnalyticsController() {
    _analyticsService = Get.find<EmployerAnalyticsService>();
    _logger = Get.find<LoggerService>();
  }

  late final EmployerAnalyticsService _analyticsService;
  late final LoggerService _logger;
  late TabController tabController;

  // Observable state variables
  final RxBool isLoading = true.obs;
  final RxBool isExporting = false.obs;
  final RxString error = ''.obs;
  final Rx<AnalyticsDataModel?> analyticsData = Rx<AnalyticsDataModel?>(null);
  final RxMap<String, int> applicantFunnel = <String, int>{}.obs;
  final RxList<Map<String, dynamic>> jobPerformance =
      <Map<String, dynamic>>[].obs;
  final RxString selectedPeriod = 'monthly'.obs;

  @override
  void onInit() {
    super.onInit();
    _logger.i('EmployerAnalyticsController initialized');

    // Initialize tab controller
    tabController = TabController(length: 3, vsync: this);

    // Load initial data
    loadData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Load all analytics data
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Load data in parallel for better performance
      await Future.wait([
        _loadAnalyticsData(),
        _loadApplicantFunnel(),
        _loadJobPerformance(),
      ]);

      _logger.d('Analytics data loaded successfully');
    } catch (e) {
      _logger.e('Error loading analytics data', e);
      error.value = 'Failed to load analytics data. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    _logger.d('Refreshing analytics data');
    return loadData();
  }

  /// Change the selected period
  Future<void> changePeriod(String period) async {
    if (selectedPeriod.value != period) {
      selectedPeriod.value = period;
      await loadData();
    }
  }

  /// Export analytics data
  Future<void> exportData() async {
    try {
      if (analyticsData.value == null) {
        Get.snackbar(
          'Error',
          'No data available to export',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isExporting.value = true;

      final filePath =
          await _analyticsService.exportAnalyticsData(analyticsData.value!);

      Get.snackbar(
        'Success',
        'Data exported to $filePath',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _logger.e('Error exporting analytics data', e);
      Get.snackbar(
        'Error',
        'Failed to export data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isExporting.value = false;
    }
  }

  /// Load analytics data
  Future<void> _loadAnalyticsData() async {
    try {
      final data = await _analyticsService.getAnalyticsData(
        selectedPeriod.value,
      );
      analyticsData.value = data;
    } catch (e) {
      _logger.e('Error loading analytics data', e);
      rethrow;
    }
  }

  /// Load applicant funnel data
  Future<void> _loadApplicantFunnel() async {
    try {
      final data = await _analyticsService.getApplicantFunnelData();
      applicantFunnel.value = data;
    } catch (e) {
      _logger.e('Error loading applicant funnel data', e);
      rethrow;
    }
  }

  /// Load job performance data
  Future<void> _loadJobPerformance() async {
    try {
      final data = await _analyticsService.getJobPerformanceData();
      jobPerformance.value = data;
    } catch (e) {
      _logger.e('Error loading job performance data', e);
      rethrow;
    }
  }
}
