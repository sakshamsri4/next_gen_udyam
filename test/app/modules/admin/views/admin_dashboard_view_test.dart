import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:next_gen/app/modules/admin/views/admin_dashboard_view.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

import 'admin_dashboard_view_test.mocks.dart';

@GenerateMocks([LoggerService, AdminDashboardController])
void main() {
  late MockAdminDashboardController mockController;
  late MockLoggerService mockLoggerService;

  setUp(() {
    mockLoggerService = MockLoggerService();
    mockController = MockAdminDashboardController();

    // Register the mocks
    Get.put<LoggerService>(mockLoggerService);
    Get.put<AdminDashboardController>(mockController);

    // Set up the routes
    Get.testMode = true;
    Get.addPages([
      GetPage(
        name: Routes.home,
        page: () => const Scaffold(),
      ),
      GetPage(
        name: Routes.userManagement,
        page: () => const Scaffold(),
      ),
      GetPage(
        name: Routes.moderation,
        page: () => const Scaffold(),
      ),
      GetPage(
        name: Routes.systemConfig,
        page: () => const Scaffold(),
      ),
      GetPage(
        name: Routes.activityLog,
        page: () => const Scaffold(),
      ),
    ]);
  });

  tearDown(Get.reset);

  testWidgets('AdminDashboardView shows loading state when isLoading is true',
      (WidgetTester tester) async {
    // Arrange
    when(mockController.isLoading).thenReturn(RxBool(true));
    when(mockController.moderationQueue).thenReturn(RxList<ModerationItem>([]));
    when(mockController.recentActivity).thenReturn(RxList<UserActivity>([]));
    when(mockController.systemMetrics).thenReturn(RxMap<String, dynamic>({}));
    when(mockController.refreshData()).thenAnswer((_) async {});

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: AdminDashboardView(),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AdminDashboardView shows content when isLoading is false',
      (WidgetTester tester) async {
    // Arrange
    when(mockController.isLoading).thenReturn(RxBool(false));
    when(mockController.moderationQueue).thenReturn(RxList<ModerationItem>([]));
    when(mockController.recentActivity).thenReturn(RxList<UserActivity>([]));
    when(mockController.systemMetrics).thenReturn(
      RxMap<String, dynamic>({
        'totalUsers': 1254,
        'activeUsers': 876,
        'newUsersToday': 42,
        'totalJobs': 328,
        'activeJobs': 215,
        'newJobsToday': 18,
        'totalApplications': 1876,
        'newApplicationsToday': 124,
        'serverLoad': 32,
        'responseTime': 215,
        'errorRate': 0.5,
      }),
    );
    when(mockController.refreshData()).thenAnswer((_) async {});

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: AdminDashboardView(),
      ),
    );

    // Assert
    expect(find.text('System Health'), findsOneWidget);
    expect(find.text('Platform Metrics'), findsOneWidget);
    expect(find.text('Moderation Queue'), findsOneWidget);
    expect(find.text('Recent Activity'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
  });

  testWidgets(
      'AdminDashboardView navigates to moderation screen when See All is pressed',
      (WidgetTester tester) async {
    // Arrange
    when(mockController.isLoading).thenReturn(RxBool(false));
    when(mockController.moderationQueue).thenReturn(RxList<ModerationItem>([]));
    when(mockController.recentActivity).thenReturn(RxList<UserActivity>([]));
    when(mockController.systemMetrics).thenReturn(
      RxMap<String, dynamic>({
        'totalUsers': 1254,
        'activeUsers': 876,
        'newUsersToday': 42,
        'totalJobs': 328,
        'activeJobs': 215,
        'newJobsToday': 18,
        'totalApplications': 1876,
        'newApplicationsToday': 124,
        'serverLoad': 32,
        'responseTime': 215,
        'errorRate': 0.5,
      }),
    );
    when(mockController.refreshData()).thenAnswer((_) async {});

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: AdminDashboardView(),
      ),
    );

    // Find and tap the See All button for Moderation Queue
    final seeAllFinder = find.text('See all');
    await tester.tap(seeAllFinder.first);
    await tester.pumpAndSettle();

    // Assert
    expect(Get.currentRoute, Routes.moderation);
  });

  testWidgets(
      'AdminDashboardView navigates to activity log screen when See All is pressed',
      (WidgetTester tester) async {
    // Arrange
    when(mockController.isLoading).thenReturn(RxBool(false));
    when(mockController.moderationQueue).thenReturn(RxList<ModerationItem>([]));
    when(mockController.recentActivity).thenReturn(RxList<UserActivity>([]));
    when(mockController.systemMetrics).thenReturn(
      RxMap<String, dynamic>({
        'totalUsers': 1254,
        'activeUsers': 876,
        'newUsersToday': 42,
        'totalJobs': 328,
        'activeJobs': 215,
        'newJobsToday': 18,
        'totalApplications': 1876,
        'newApplicationsToday': 124,
        'serverLoad': 32,
        'responseTime': 215,
        'errorRate': 0.5,
      }),
    );
    when(mockController.refreshData()).thenAnswer((_) async {});

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: AdminDashboardView(),
      ),
    );

    // Find and tap the See All button for Recent Activity
    final seeAllFinder = find.text('See all');
    await tester.tap(seeAllFinder.at(1));
    await tester.pumpAndSettle();

    // Assert
    expect(Get.currentRoute, Routes.activityLog);
  });
}
