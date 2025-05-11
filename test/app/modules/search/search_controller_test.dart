import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/app/modules/search/controllers/search_controller.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';
import 'package:next_gen/app/modules/search/services/search_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

import '../../../helpers/test_helpers.dart';

// Mock classes
class MockSearchService extends Mock implements SearchService {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockSearchService mockSearchService;
  late MockLoggerService mockLoggerService;
  late SearchController searchController;
  late List<JobModel> testJobs;

  setUp(() {
    // Initialize GetX test mode
    GetTestWidgetHelper.setupGetTest();

    // Create test data
    testJobs = [
      JobModel(
        id: 'job1',
        title: 'Software Engineer',
        company: 'Test Company',
        location: 'New York, NY',
        description: 'This is a test job description',
        salary: 100000,
        postedDate: DateTime.now().subtract(const Duration(days: 7)),
        requirements: ["Bachelor's degree", '3+ years of experience'],
        responsibilities: ['Develop software', 'Fix bugs'],
        skills: ['Flutter', 'Dart', 'Firebase'],
        industry: 'Technology',
      ),
      JobModel(
        id: 'job2',
        title: 'Product Manager',
        company: 'Test Company',
        location: 'San Francisco, CA',
        description: 'This is a test job description',
        salary: 110000,
        postedDate: DateTime.now().subtract(const Duration(days: 5)),
        requirements: ["Bachelor's degree", '3+ years of experience'],
        responsibilities: ['Develop software', 'Fix bugs'],
        skills: ['Flutter', 'Dart', 'Firebase'],
        industry: 'Technology',
      ),
      JobModel(
        id: 'job3',
        title: 'UX Designer',
        company: 'Test Company',
        location: 'Remote',
        description: 'This is a test job description',
        salary: 90000,
        postedDate: DateTime.now().subtract(const Duration(days: 3)),
        requirements: ["Bachelor's degree", '3+ years of experience'],
        responsibilities: ['Develop software', 'Fix bugs'],
        skills: ['Flutter', 'Dart', 'Firebase'],
        industry: 'Technology',
        jobType: 'Part-time',
      ),
    ];

    // Create mocks
    mockSearchService = MockSearchService();
    mockLoggerService = MockLoggerService();

    // Register mocks with GetX
    Get
      ..put<SearchService>(mockSearchService)
      ..put<LoggerService>(mockLoggerService);

    // Set up default mock behavior
    when(() => mockLoggerService.d(any<String>())).thenReturn(null);
    when(() => mockLoggerService.i(any<String>())).thenReturn(null);
    when(
      () => mockLoggerService.e(
        any<String>(),
        any<dynamic>(),
        any<StackTrace?>(),
      ),
    ).thenReturn(null);

    // Create controller
    searchController = Get.put<SearchController>(SearchController());
  });

  tearDown(GetTestWidgetHelper.tearDownGetTest);

  group('Job Search Tests (P0)', () {
    test('SRCH-01: Search for jobs with keywords', () async {
      // Arrange
      const query = 'engineer';
      // Note: We don't need to create a filter here as the controller will do it

      // Mock search results
      when(() => mockSearchService.searchJobs(any<SearchFilter>()))
          .thenAnswer((_) async => [testJobs[0]]);

      // Act
      searchController.searchTextController.text = query;
      searchController.onSearchInputChanged(query);

      // Wait for debouncer
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(searchController.searchResults.length, equals(1));
      expect(searchController.searchResults[0].title, contains('Engineer'));
      expect(searchController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockSearchService.searchJobs(any())).called(1);
    });

    test('SRCH-02: Filter jobs by location', () async {
      // Arrange
      const location = 'New York';
      final filter = SearchFilter(location: location);

      // Mock search results
      when(() => mockSearchService.searchJobs(any()))
          .thenAnswer((_) async => [testJobs[0]]);

      // Act
      searchController.applyFilter(filter);

      // Assert
      expect(searchController.searchResults.length, equals(1));
      expect(searchController.searchResults[0].location, contains('New York'));
      expect(searchController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockSearchService.searchJobs(any())).called(1);
    });

    test('SRCH-09: Test empty search results handling', () async {
      // Arrange
      const query = 'nonexistent job';
      // Note: We don't need to create a filter here as the controller will do it

      // Mock empty search results
      when(() => mockSearchService.searchJobs(any<SearchFilter>()))
          .thenAnswer((_) async => []);

      // Act
      searchController.searchTextController.text = query;
      searchController.onSearchInputChanged(query);

      // Wait for debouncer
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(searchController.searchResults.isEmpty, isTrue);
      expect(searchController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockSearchService.searchJobs(any())).called(1);
    });

    test('SRCH-03: Filter jobs by salary range', () async {
      // Arrange
      const minSalary = 80000;
      const maxSalary = 120000;
      final filter = SearchFilter(minSalary: minSalary, maxSalary: maxSalary);

      // Create test jobs with different salaries
      final midSalaryJob = JobModel(
        id: 'mid',
        title: 'Software Engineer',
        company: 'Test Company',
        location: 'New York, NY',
        description: 'This is a test job description',
        salary: 100000,
        postedDate: DateTime.now().subtract(const Duration(days: 7)),
        requirements: ["Bachelor's degree", '3+ years of experience'],
        responsibilities: ['Develop software', 'Fix bugs'],
        skills: ['Flutter', 'Dart', 'Firebase'],
        industry: 'Technology',
      );

      // Mock search results
      when(() => mockSearchService.searchJobs(any<SearchFilter>()))
          .thenAnswer((_) async => [midSalaryJob]);

      // Act
      searchController.applyFilter(filter);

      // Assert
      expect(searchController.searchResults.length, equals(1));
      expect(searchController.searchResults[0].salary, equals(100000));
      expect(searchController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockSearchService.searchJobs(any())).called(1);
    });

    test('SRCH-04: Filter jobs by job type', () async {
      // Arrange
      final filter = SearchFilter(jobTypes: ['Full-time']);

      // Create test jobs with different job types
      final fullTimeJob = JobModel(
        id: 'full',
        title: 'Software Engineer',
        company: 'Test Company',
        location: 'New York, NY',
        description: 'This is a test job description',
        salary: 100000,
        postedDate: DateTime.now().subtract(const Duration(days: 7)),
        requirements: ["Bachelor's degree", '3+ years of experience'],
        responsibilities: ['Develop software', 'Fix bugs'],
        skills: ['Flutter', 'Dart', 'Firebase'],
        industry: 'Technology',
      );

      // Mock search results
      when(() => mockSearchService.searchJobs(any<SearchFilter>()))
          .thenAnswer((_) async => [fullTimeJob]);

      // Act
      searchController.applyFilter(filter);

      // Assert
      expect(searchController.searchResults.length, equals(1));
      expect(searchController.searchResults[0].jobType, equals('Full-time'));
      expect(searchController.isLoading.value, isFalse);

      // Verify service calls
      verify(() => mockSearchService.searchJobs(any())).called(1);
    });

    test('Search history is saved when performing search', () async {
      // Arrange
      const query = 'developer';

      // Mock search results and history saving
      when(() => mockSearchService.searchJobs(any()))
          .thenAnswer((_) async => [testJobs[0]]);

      when(() => mockSearchService.saveSearchHistory(query))
          .thenAnswer((_) async {});

      // Act
      searchController.searchTextController.text = query;
      searchController.onSearchInputChanged(query);

      // Wait for debouncer
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      // Verify service calls
      verify(() => mockSearchService.searchJobs(any())).called(1);
      verify(() => mockSearchService.saveSearchHistory(query)).called(1);
    });

    test('Search history is loaded on controller ready', () async {
      // Arrange
      final testHistory = [
        SearchHistory(query: 'developer'),
        SearchHistory(query: 'designer'),
      ];

      // Mock getting search history
      when(() => mockSearchService.getSearchHistory())
          .thenAnswer((_) async => testHistory);

      // Act
      searchController.onReady();

      // Assert
      // Verify service calls
      verify(() => mockSearchService.getSearchHistory()).called(1);
    });

    test('Clear search resets filter and results', () async {
      // Arrange
      // First perform a search
      const query = 'engineer';

      // Mock search results
      when(() => mockSearchService.searchJobs(any()))
          .thenAnswer((_) async => [testJobs[0]]);

      searchController.searchTextController.text = query;
      searchController.onSearchInputChanged(query);

      // Wait for debouncer
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Act
      searchController.clearSearch();

      // Assert
      expect(searchController.searchTextController.text, isEmpty);
      expect(searchController.filter.value.query, isEmpty);
      expect(searchController.searchResults.isEmpty, isTrue);
    });
  });
}
