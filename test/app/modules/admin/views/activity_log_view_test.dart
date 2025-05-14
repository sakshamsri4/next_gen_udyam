import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:next_gen/app/modules/admin/controllers/activity_log_controller.dart';
import 'package:next_gen/app/modules/admin/views/activity_log_view.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

import 'activity_log_view_test.mocks.dart';

@GenerateMocks([LoggerService])

// Create a mock implementation of NavigationController for testing
class MockNavigationController extends GetxController
    implements NavigationController {
  // Reactive variables
  @override
  final RxInt selectedIndex = 0.obs;

  @override
  final RxBool isDrawerOpen = false.obs;

  @override
  final RxBool isAnimating = false.obs;

  @override
  final RxBool isLoading = false.obs;

  @override
  final Rx<UserType?> userRole = Rx<UserType?>(UserType.admin);

  // Implement required methods
  @override
  Future<void> changeIndex(int index) async {
    selectedIndex.value = index;
  }

  @override
  void updateIndexFromRoute(String route) {}

  @override
  void openDrawer(GlobalKey<ScaffoldState>? scaffoldKey) {}

  @override
  void closeDrawer(GlobalKey<ScaffoldState>? scaffoldKey) {}

  @override
  void toggleDrawer([GlobalKey<ScaffoldState>? scaffoldKey]) {}

  @override
  Future<void> navigateWithAnimation(String route, {Object? arguments}) async {}

  @override
  Future<void> navigateToDetail(String route, {Object? arguments}) async {}

  @override
  void navigateBack() {}

  @override
  Future<void> reloadUserRole() async {}
}

// Create a mock implementation of ActivityLogController for testing
class MockActivityLogController extends GetxController
    implements ActivityLogController {
  MockActivityLogController({required this.loggerService});
  // Reactive variables
  @override
  final RxBool isLoading = false.obs;

  @override
  final RxList<ActivityLogItem> activityLogs = <ActivityLogItem>[].obs;

  @override
  final RxList<ActivityLogItem> filteredLogs = <ActivityLogItem>[].obs;

  @override
  final RxString searchQuery = ''.obs;

  @override
  final RxString dateFilter = 'All Time'.obs;

  @override
  final RxString activityTypeFilter = 'All Types'.obs;

  // Track method calls for testing
  String lastSearchQuery = '';
  String lastDateFilter = '';
  String lastActivityTypeFilter = '';

  @override
  final LoggerService loggerService;

  @override
  void updateSearchQuery(String query) {
    lastSearchQuery = query;
    searchQuery.value = query;
  }

  @override
  void updateDateFilter(String filter) {
    lastDateFilter = filter;
    dateFilter.value = filter;
  }

  @override
  void updateActivityTypeFilter(String filter) {
    lastActivityTypeFilter = filter;
    activityTypeFilter.value = filter;
  }

  @override
  void filterLogs() {}

  @override
  Future<void> loadActivityLogs() async {}

  @override
  Future<void> refreshLogs() async {}
}

void main() {
  late MockActivityLogController controller;
  late MockLoggerService mockLoggerService;

  setUp(() {
    mockLoggerService = MockLoggerService();
    controller = MockActivityLogController(loggerService: mockLoggerService);

    // Create a mock NavigationController
    final mockNavigationController = MockNavigationController();

    // Register the mocks and set up test mode
    Get
      ..put<LoggerService>(mockLoggerService)
      ..put<ActivityLogController>(controller, permanent: true)
      ..put<NavigationController>(mockNavigationController, permanent: true)
      ..testMode = true;
  });

  tearDown(Get.reset);

  testWidgets('ActivityLogView shows loading state when isLoading is true',
      (WidgetTester tester) async {
    // Arrange
    controller.isLoading.value = true;

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: ActivityLogView(),
      ),
    );

    // Assert
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ShimmerWidget), findsWidgets);
  });

  testWidgets('ActivityLogView shows empty state when no logs are available',
      (WidgetTester tester) async {
    // Arrange
    controller.isLoading.value = false;
    controller.activityLogs.clear();
    controller.filteredLogs.clear();

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: ActivityLogView(),
      ),
    );

    // Assert
    expect(find.text('No activity logs found'), findsOneWidget);
    expect(
      find.text('Try adjusting your filters to see more results.'),
      findsOneWidget,
    );
  });

  testWidgets('ActivityLogView shows logs when available',
      (WidgetTester tester) async {
    // Arrange
    controller.isLoading.value = false;

    // Add test data
    final testLogs = [
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

    controller.activityLogs.assignAll(testLogs);
    controller.filteredLogs.assignAll(testLogs);

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: ActivityLogView(),
      ),
    );

    // Assert
    expect(find.text('John Smith'), findsOneWidget);
    expect(find.text('Tech Innovations'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Job Posting'), findsOneWidget);
    expect(find.text('Logged in from Chrome on macOS'), findsOneWidget);
    expect(
      find.text('Posted a new job: Senior Flutter Developer'),
      findsOneWidget,
    );
  });

  testWidgets('ActivityLogView search field updates search query',
      (WidgetTester tester) async {
    // Arrange
    controller.isLoading.value = false;
    controller.activityLogs.clear();
    controller.filteredLogs.clear();
    controller.searchQuery.value = '';
    controller.lastSearchQuery = '';

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: ActivityLogView(),
      ),
    );

    // Find the search field and enter text
    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'test search');

    // Assert
    expect(controller.lastSearchQuery, equals('test search'));
  });

  testWidgets('ActivityLogView date filter dropdown updates date filter',
      (WidgetTester tester) async {
    // Arrange
    controller.isLoading.value = false;
    controller.activityLogs.clear();
    controller.filteredLogs.clear();
    controller.dateFilter.value = 'All Time';
    controller.lastDateFilter = '';

    // Act
    await tester.pumpWidget(
      const GetMaterialApp(
        home: ActivityLogView(),
      ),
    );

    // Find and tap the date filter dropdown
    final dateFilterDropdown =
        find.byType(DropdownButtonFormField<String>).first;
    await tester.tap(dateFilterDropdown);
    await tester.pumpAndSettle();

    // Select 'Today' option
    await tester.tap(find.text('Today').last);
    await tester.pumpAndSettle();

    // Assert
    expect(controller.lastDateFilter, equals('Today'));
  });
}
