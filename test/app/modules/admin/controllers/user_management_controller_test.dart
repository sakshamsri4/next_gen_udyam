import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/admin/controllers/user_management_controller.dart';
import 'package:next_gen/app/modules/admin/models/user_filter_model.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/services/logger_service.dart';

import '../../../../test_helpers.dart';
import 'user_management_controller_test.mocks.dart';

@GenerateMocks([LoggerService])
void main() {
  late UserManagementController controller;
  late MockLoggerService mockLoggerService;

  setUpAll(() async {
    await setupControllerTest();
  });

  setUp(() {
    mockLoggerService = MockLoggerService();

    // Register the mock logger service
    Get.put<LoggerService>(mockLoggerService);

    // Create the controller
    controller = UserManagementController(
      loggerService: mockLoggerService,
    );
  });

  tearDown(Get.reset);

  group('UserManagementController', () {
    test('initial values are set correctly', () {
      expect(controller.isLoading.value, false);
      expect(controller.users.isEmpty, true);
      expect(controller.selectedUser.value, null);
      expect(controller.filter.value.searchQuery, '');
      expect(controller.filter.value.userTypes.isEmpty, true);
      expect(controller.filter.value.isVerified, null);
      expect(controller.activityLogs.isEmpty, true);
      expect(controller.totalUsers.value, 0);
      expect(controller.activeUsers.value, 0);
      expect(controller.newUsers.value, 0);
    });

    test('loadUsers sets isLoading to false when complete', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      // Act
      await controller.loadUsers();

      // Assert
      expect(controller.isLoading.value, false);
    });

    test('updateFilter updates filter and reloads users', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      final newFilter = UserFilterModel(
        searchQuery: 'test',
        userTypes: [UserType.employee],
        isVerified: true,
      );

      // Act
      await controller.updateFilter(newFilter);

      // Assert
      expect(controller.filter.value.searchQuery, 'test');
      expect(controller.filter.value.userTypes, [UserType.employee]);
      expect(controller.filter.value.isVerified, true);
      expect(controller.isLoading.value, false);
    });

    test('resetFilter resets filter to default values', () async {
      // Arrange
      when(mockLoggerService.i(any)).thenReturn(null);
      when(mockLoggerService.d(any)).thenReturn(null);
      when(mockLoggerService.e(any, any, any)).thenReturn(null);

      // First set a non-default filter
      await controller.updateFilter(
        UserFilterModel(
          searchQuery: 'test',
          userTypes: [UserType.employee],
          isVerified: true,
        ),
      );

      // Act
      await controller.resetFilter();

      // Assert
      expect(controller.filter.value.searchQuery, '');
      expect(controller.filter.value.userTypes.isEmpty, true);
      expect(controller.filter.value.isVerified, null);
      expect(controller.isLoading.value, false);
    });

    // Note: We're skipping tests that require Firestore mocking
    // as they would require more complex setup
  });
}
