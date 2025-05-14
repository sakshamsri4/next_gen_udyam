import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/admin/controllers/activity_log_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';

import 'activity_log_controller_test.mocks.dart';

// Create a mock class for FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

@GenerateMocks([LoggerService])
void main() {
  late ActivityLogController controller;
  late MockLoggerService mockLoggerService;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockLoggerService = MockLoggerService();
    mockFirestore = MockFirebaseFirestore();

    // Register the mock logger service
    Get.put<LoggerService>(mockLoggerService);

    // Create the controller with mock Firestore
    controller = ActivityLogController(
      loggerService: mockLoggerService,
      firestore: mockFirestore,
    );
  });

  tearDown(Get.reset);

  group('ActivityLogController', () {
    test('initial values are set correctly', () {
      expect(controller.isLoading.value, false);
      expect(controller.activityLogs.isEmpty, true);
      expect(controller.filteredLogs.isEmpty, true);
      expect(controller.searchQuery.value, '');
      expect(controller.dateFilter.value, 'All Time');
      expect(controller.activityTypeFilter.value, 'All Types');
    });

    test('loadActivityLogs sets isLoading to false when complete', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      // Act
      await controller.loadActivityLogs();

      // Assert
      expect(controller.isLoading.value, false);
    });

    test('loadActivityLogs populates activityLogs and filteredLogs', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      // Act
      await controller.loadActivityLogs();

      // Assert
      expect(controller.activityLogs.isNotEmpty, true);
      expect(controller.filteredLogs.isNotEmpty, true);
      expect(controller.activityLogs.length, controller.filteredLogs.length);
    });

    test('updateSearchQuery updates searchQuery value', () {
      // Act
      controller.updateSearchQuery('test query');

      // Assert
      expect(controller.searchQuery.value, 'test query');
    });

    test('updateDateFilter updates dateFilter value', () {
      // Act
      controller.updateDateFilter('Today');

      // Assert
      expect(controller.dateFilter.value, 'Today');
    });

    test('updateActivityTypeFilter updates activityTypeFilter value', () {
      // Act
      controller.updateActivityTypeFilter('Login');

      // Assert
      expect(controller.activityTypeFilter.value, 'Login');
    });

    test('filterLogs filters logs by search query', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      // Manually set up some test data with a specific item that contains "login"
      controller.activityLogs.value = [
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
      ];
      controller.filteredLogs.value = controller.activityLogs;

      // Act
      controller.updateSearchQuery('login');
      // Manually call filterLogs since we're not using the real reactive system in tests
      controller.filterLogs();

      // Assert - we know there's only one item with "login" in it
      expect(controller.filteredLogs.length, 1);
      expect(controller.filteredLogs[0].action, 'Login');
    });

    test('filterLogs filters logs by date', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      // Manually set up some test data with items from different dates
      final now = DateTime.now();
      final today =
          DateTime(now.year, now.month, now.day, 2); // Today, 2 hours ago
      final yesterday = now.subtract(const Duration(days: 1)); // Yesterday

      controller.activityLogs.value = [
        ActivityLogItem(
          id: '1',
          userName: 'John Smith',
          userId: 'user123',
          action: 'Login',
          details: 'Logged in from Chrome on macOS',
          timestamp: '2 hours ago',
          dateTime: today,
        ),
        ActivityLogItem(
          id: '2',
          userName: 'Tech Innovations',
          userId: 'company456',
          action: 'Job Posting',
          details: 'Posted a new job: Senior Flutter Developer',
          timestamp: 'Yesterday',
          dateTime: yesterday,
        ),
      ];
      controller.filteredLogs.value = controller.activityLogs;

      // Act
      controller.updateDateFilter('Today');
      // Manually call filterLogs since we're not using the real reactive system in tests
      controller.filterLogs();

      // Assert - we know there's only one item from today
      expect(controller.filteredLogs.length, 1);
      expect(controller.filteredLogs[0].dateTime.day, today.day);
    });

    test('filterLogs filters logs by activity type', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      // Manually set up some test data with a specific item that has Login action
      controller.activityLogs.value = [
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
      ];
      controller.filteredLogs.value = controller.activityLogs;

      // Act
      controller.updateActivityTypeFilter('Login');
      // Manually call filterLogs since we're not using the real reactive system in tests
      controller.filterLogs();

      // Assert - we know there's only one item with Login action
      expect(controller.filteredLogs.length, 1);
      expect(controller.filteredLogs[0].action, 'Login');
    });

    test('refreshLogs calls loadActivityLogs', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      // Act
      await controller.refreshLogs();

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.activityLogs.isNotEmpty, true);
      expect(controller.filteredLogs.isNotEmpty, true);
    });
  });
}
