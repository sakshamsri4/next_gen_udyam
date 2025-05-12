import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/models/saved_search_model.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';
import 'package:next_gen/core/services/analytics_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/hive_manager.dart';

/// Box name for search history
const String searchHistoryBoxName = 'searchHistory';

/// Box name for saved searches
const String savedSearchesBoxName = 'savedSearches';

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
  // HiveManager is used indirectly through Hive.box calls
  // ignore: unused_field
  final HiveManager _hiveManager;
  final LoggerService _logger;
  final AnalyticsService? _analytics;

  // Get the current user ID (used in multiple methods)
  String? _getCurrentUserId() => Get.find<AuthController>().user.value?.uid;

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

        // Log search event - no need to await analytics
        // ignore: unawaited_futures
        _analytics?.logSearch(searchTerm: filter.query);
      }

      // Start with a base query
      Query query = _firestore.collection('jobs');

      // Apply filters
      if (filter.query.isNotEmpty) {
        // For simplicity, we're just checking if the title contains the query
        // In a real app, you might want to use
        // a more sophisticated search solution
        query = query
            .orderBy('title')
            .startAt([filter.query]).endAt(['${filter.query}\\uf8ff']);
      }

      if (filter.location.isNotEmpty) {
        query = query.where('location', isEqualTo: filter.location);
      }

      // Check if we need to do client-side salary filtering
      final clientSideSalaryFilter = filter.query.isNotEmpty &&
          (filter.minSalary > 0 || filter.maxSalary < 1000000);

      // Only apply server-side salary filters if we're not doing text search
      if (!clientSideSalaryFilter) {
        if (filter.minSalary > 0) {
          query = query.where(
            'salary',
            isGreaterThanOrEqualTo: filter.minSalary,
          );
        }
        if (filter.maxSalary < 1000000) {
          query = query.where(
            'salary',
            isLessThanOrEqualTo: filter.maxSalary,
          );
        }
      }

      // Handle job types filtering
      if (filter.jobTypes.isNotEmpty) {
        // Firestore has a limit of 10 items in a whereIn query
        if (filter.jobTypes.length <= 10) {
          query = query.where('jobType', whereIn: filter.jobTypes);
        } else {
          // If we have more than 10 job types,
          // we need to do client-side filtering
          _logger.d(
            'Too many job types for Firestore query '
            '(${filter.jobTypes.length}), will filter client-side',
          );
          // We'll apply this filter client-side after getting the results
        }
      }

      if (filter.isRemote) {
        query = query.where('isRemote', isEqualTo: true);
      }

      // Apply sorting
      // Only apply sorting if we're not already filtering by title
      // because Firestore requires composite indexes for multiple orderBy
      // clauses
      if (filter.query.isEmpty) {
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
            // For relevance, we'll just use the default order
            break;
        }
      } else if (filter.sortBy != SortOption.relevance) {
        // If we're filtering by title and need sorting, we'll sort the results
        // client-side
        _logger.d(
          'Sorting will be applied client-side due to Firestore query '
          'limitations',
        );
        // We'll apply this sort client-side after getting the results
      }

      // Apply pagination
      if (filter.page > 0 && filter.limit > 0) {
        _logger.d(
          'Applying pagination: page=${filter.page}, limit=${filter.limit}',
        );

        // Calculate the offset
        final offset = (filter.page - 1) * filter.limit;

        // Apply limit to the query
        query = query.limit(filter.limit);

        // If this is not the first page, we need to use startAfter
        if (filter.page > 1 && offset > 0) {
          // For proper pagination, we would need to use startAfter with a document snapshot
          // This is a simplified implementation that uses limit+offset
          // In a real app, you would store the last document of each page
          // and use startAfter with that document
          query = query.limit(offset + filter.limit);
        }
      }

      // Execute the query
      final snapshot = await query.get();

      // Convert to JobModel list
      var jobs = snapshot.docs.map(JobModel.fromFirestore).toList();

      // Handle pagination offset for pages > 1
      if (filter.page > 1 && filter.limit > 0) {
        final offset = (filter.page - 1) * filter.limit;
        if (jobs.length > filter.limit) {
          // Skip the first 'offset' items and take only 'limit' items
          jobs = jobs.skip(offset).take(filter.limit).toList();
        }
      }

      // Apply client-side filtering if needed

      // Apply client-side salary filtering if needed
      if (clientSideSalaryFilter) {
        _logger.d('Applying client-side salary filtering');
        if (filter.minSalary > 0) {
          jobs = jobs.where((job) => job.salary >= filter.minSalary).toList();
        }
        if (filter.maxSalary < 1000000) {
          jobs = jobs.where((job) => job.salary <= filter.maxSalary).toList();
        }
      }

      // Apply client-side job type filtering if needed (more than 10 types)
      if (filter.jobTypes.length > 10) {
        _logger.d('Applying client-side job type filtering');
        jobs =
            jobs.where((job) => filter.jobTypes.contains(job.jobType)).toList();
      }

      // Apply client-side sorting if we have a text search and need sorting
      if (filter.query.isNotEmpty && filter.sortBy != SortOption.relevance) {
        _logger.d('Applying client-side sorting by ${filter.sortBy}');

        final isDescending = filter.sortOrder == SortOrder.descending;

        switch (filter.sortBy) {
          case SortOption.date:
            jobs.sort((a, b) {
              final comparison = a.postedDate.compareTo(b.postedDate);
              return isDescending ? -comparison : comparison;
            });
          case SortOption.salary:
            jobs.sort((a, b) {
              final comparison = a.salary.compareTo(b.salary);
              return isDescending ? -comparison : comparison;
            });
          case SortOption.company:
            jobs.sort((a, b) {
              final comparison = a.company.compareTo(b.company);
              return isDescending ? -comparison : comparison;
            });
          case SortOption.location:
            jobs.sort((a, b) {
              final comparison = a.location.compareTo(b.location);
              return isDescending ? -comparison : comparison;
            });
          case SortOption.relevance:
            // No sorting needed for relevance
            break;
        }
      }

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

  /// Save a search query to saved searches
  Future<SavedSearchModel?> saveSearch(
    String query,
    SearchFilter filter,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        _logger.w('Cannot save search: User not logged in');
        return null;
      }

      // Create a unique ID
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      // Create the saved search model
      final savedSearch = SavedSearchModel(
        id: id,
        userId: userId,
        query: query,
        filter: filter,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('saved_searches')
          .doc(id)
          .set(savedSearch.toMap());

      // Save to local storage
      final box = await _getSavedSearchesBox();
      await box.add(savedSearch);

      _logger.d('Saved search: $query');
      return savedSearch;
    } catch (e, s) {
      _logger.e('Error saving search', e, s);
      return null;
    }
  }

  /// Get saved searches for the current user
  Future<List<SavedSearchModel>> getSavedSearches() async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        _logger.w('Cannot get saved searches: User not logged in');
        return [];
      }

      // Get from Firestore
      final snapshot = await _firestore
          .collection('saved_searches')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final savedSearches =
          snapshot.docs.map(SavedSearchModel.fromFirestore).toList();

      _logger.d('Retrieved ${savedSearches.length} saved searches');
      return savedSearches;
    } catch (e, s) {
      _logger.e('Error getting saved searches', e, s);
      return [];
    }
  }

  /// Delete a saved search
  Future<bool> deleteSavedSearch(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        _logger.w('Cannot delete saved search: User not logged in');
        return false;
      }

      // Delete from Firestore
      await _firestore.collection('saved_searches').doc(id).delete();

      // Delete from local storage
      final box = await _getSavedSearchesBox();
      final index = box.values.toList().indexWhere((item) => item.id == id);
      if (index != -1) {
        await box.deleteAt(index);
      }

      _logger.d('Deleted saved search: $id');
      return true;
    } catch (e, s) {
      _logger.e('Error deleting saved search', e, s);
      return false;
    }
  }

  /// Get the saved searches box
  Future<Box<SavedSearchModel>> _getSavedSearchesBox() async {
    if (!Hive.isBoxOpen(savedSearchesBoxName)) {
      await Hive.openBox<SavedSearchModel>(savedSearchesBoxName);
    }
    return Hive.box<SavedSearchModel>(savedSearchesBoxName);
  }
}
