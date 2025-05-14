import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

import 'admin_dashboard_controller_test.mocks.dart';

@GenerateMocks([LoggerService])
void main() {
  late AdminDashboardController controller;
  late MockLoggerService mockLoggerService;

  setUp(() {
    mockLoggerService = MockLoggerService();

    // Register the mock logger service
    Get.put<LoggerService>(mockLoggerService);

    // Create the controller
    controller = AdminDashboardController();
  });

  tearDown(Get.reset);

  group('AdminDashboardController', () {
    test('initial values are set correctly', () {
      expect(controller.isLoading.value, true);
      expect(controller.moderationQueue.isEmpty, true);
      expect(controller.recentActivity.isEmpty, true);
      expect(controller.systemMetrics.isEmpty, true);
    });

    test('loadData sets isLoading to false when complete', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any)).thenReturn(null);

      // Act
      await controller.loadData();

      // Assert
      expect(controller.isLoading.value, false);
    });

    test('loadData populates moderationQueue', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any)).thenReturn(null);

      // Act
      await controller.loadData();

      // Assert
      expect(controller.moderationQueue.isNotEmpty, true);
    });

    test('loadData populates recentActivity', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any)).thenReturn(null);

      // Act
      await controller.loadData();

      // Assert
      expect(controller.recentActivity.isNotEmpty, true);
    });

    test('loadData populates systemMetrics', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any)).thenReturn(null);

      // Act
      await controller.loadData();

      // Assert
      expect(controller.systemMetrics.isNotEmpty, true);
    });

    test('refreshData calls loadData', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any)).thenReturn(null);

      // Act
      await controller.refreshData();

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.moderationQueue.isNotEmpty, true);
      expect(controller.recentActivity.isNotEmpty, true);
      expect(controller.systemMetrics.isNotEmpty, true);
    });

    test('approveModerationItem updates item status', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any)).thenReturn(null);

      // Load data first to populate the moderation queue
      await controller.loadData();

      // Get the first item ID
      final itemId = controller.moderationQueue[0].id;

      // Act
      await controller.approveModerationItem(itemId);

      // Assert
      final updatedItem =
          controller.moderationQueue.firstWhere((item) => item.id == itemId);
      expect(updatedItem.status, 'Approved');
    });

    test('rejectModerationItem updates item status', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any)).thenReturn(null);

      // Load data first to populate the moderation queue
      await controller.loadData();

      // Get the first item ID
      final itemId = controller.moderationQueue[0].id;

      // Act
      await controller.rejectModerationItem(itemId);

      // Assert
      final updatedItem =
          controller.moderationQueue.firstWhere((item) => item.id == itemId);
      expect(updatedItem.status, 'Rejected');
    });
  });
}
