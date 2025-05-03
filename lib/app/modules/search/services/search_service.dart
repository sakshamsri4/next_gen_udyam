import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';
import 'package:next_gen/core/services/analytics_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/hive_manager.dart';

/// Box name for search history
const String searchHistoryBoxName = 'searchHistory';

/// Service for handling search operations
class SearchService extends GetxService {
  /// Constructor
  SearchService({
    FirebaseFirestore? firestore,
    HiveManager? hiveManager,
    LoggerService? logger,
    AnalyticsService? analytics,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _hiveManager = hiveManager ?? Get.find<HiveManager>(),
        _logger = logger ?? Get.find<LoggerService>(),
        _analytics = analytics;

  final FirebaseFirestore _firestore;
  final HiveManager _hiveManager;
  final LoggerService _logger;
  final AnalyticsService? _analytics;

  /// Initialize the service
  Future<SearchService> init() async {
    _logger.i('SearchService initialized');
    return this;
  }

  /// Search for jobs
  Future<List<JobModel>> searchJobs(SearchFilter filter) async {
    _logger.i('Searching for jobs with filter: ${filter.toJson()}');

    try {
      // Save search query to history if not empty
      if (filter.query.isNotEmpty) {
        await saveSearchHistory(filter.query);

        // Log search event
        _analytics?.logSearch(searchTerm: filter.query);
      }

      // Start with a base query
      Query query = _firestore.collection('jobs');

      // Apply filters
      if (filter.query.isNotEmpty) {
        // For simplicity, we're just checking if the title contains the query
        // In a real app, you might want to use a more sophisticated search solution
        query = query
            .where('title', isGreaterThanOrEqualTo: filter.query)
            .where('title', isLessThanOrEqualTo: '${filter.query}\\uf8ff');
      }

      if (filter.location.isNotEmpty) {
        query = query.where('location', isEqualTo: filter.location);
      }

      if (filter.minSalary > 0) {
        query = query.where('salary', isGreaterThanOrEqualTo: filter.minSalary);
      }

      if (filter.maxSalary < 1000000) {
        query = query.where('salary', isLessThanOrEqualTo: filter.maxSalary);
      }

      if (filter.jobTypes.isNotEmpty) {
        query = query.where('jobType', whereIn: filter.jobTypes);
      }

      if (filter.isRemote) {
        query = query.where('isRemote', isEqualTo: true);
      }

      // Apply sorting
      switch (filter.sortBy) {
        case SortOption.date:
          query = query.orderBy(
            'postedDate',
            descending: filter.sortOrder == SortOrder.descending,
          );
        case SortOption.salary:
          query = query.orderBy(
            'salary',
            descending: filter.sortOrder == SortOrder.descending,
          );
        case SortOption.company:
          query = query.orderBy(
            'company',
            descending: filter.sortOrder == SortOrder.descending,
          );
        case SortOption.location:
          query = query.orderBy(
            'location',
            descending: filter.sortOrder == SortOrder.descending,
          );
        case SortOption.relevance:
        default:
          // For relevance, we'll just use the default order
          break;
      }

      // Execute the query
      final snapshot = await query.get();

      // Convert to JobModel list
      final jobs = snapshot.docs.map(JobModel.fromFirestore).toList();

      _logger.i('Found ${jobs.length} jobs');
      return jobs;
    } catch (e, s) {
      _logger.e('Error searching for jobs', e, s);
      return [];
    }
  }

  /// Save search query to history
  Future<void> saveSearchHistory(String query) async {
    if (query.isEmpty) return;

    try {
      final history = SearchHistory(query: query);

      // Get the search history box
      final box = await _getSearchHistoryBox();

      // Check if the query already exists
      final existingIndex = box.values.toList().indexWhere(
            (item) => item.query.toLowerCase() == query.toLowerCase(),
          );

      if (existingIndex != -1) {
        // Remove the existing entry
        await box.deleteAt(existingIndex);
      }

      // Add the new entry at the beginning
      await box.add(history);

      // Limit the history to 10 items
      if (box.length > 10) {
        await box.deleteAt(0);
      }

      _logger.d('Saved search history: $query');
    } catch (e, s) {
      _logger.e('Error saving search history', e, s);
    }
  }

  /// Get search history
  Future<List<SearchHistory>> getSearchHistory() async {
    try {
      final box = await _getSearchHistoryBox();
      final history = box.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      _logger.d('Retrieved ${history.length} search history items');
      return history;
    } catch (e, s) {
      _logger.e('Error getting search history', e, s);
      return [];
    }
  }

  /// Clear search history
  Future<void> clearSearchHistory() async {
    try {
      final box = await _getSearchHistoryBox();
      await box.clear();
      _logger.d('Cleared search history');
    } catch (e, s) {
      _logger.e('Error clearing search history', e, s);
    }
  }

  /// Delete a search history item
  Future<void> deleteSearchHistoryItem(int index) async {
    try {
      final box = await _getSearchHistoryBox();
      await box.deleteAt(index);
      _logger.d('Deleted search history item at index $index');
    } catch (e, s) {
      _logger.e('Error deleting search history item', e, s);
    }
  }

  /// Get the search history box
  Future<Box<SearchHistory>> _getSearchHistoryBox() async {
    if (!Hive.isBoxOpen(searchHistoryBoxName)) {
      await Hive.openBox<SearchHistory>(searchHistoryBoxName);
    }
    return Hive.box<SearchHistory>(searchHistoryBoxName);
  }
}
