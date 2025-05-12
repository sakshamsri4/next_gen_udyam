import 'dart:async';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';
import 'package:next_gen/app/modules/search/services/search_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the Search module
class SearchController extends GetxController {
  /// Constructor
  SearchController({
    LoggerService? logger,
  }) : _logger = logger ?? Get.find<LoggerService>();

  // Dependencies
  final LoggerService _logger;
  late SearchService _searchService;

  // Text controllers
  late final TextEditingController searchTextController;

  // Debouncer for search
  late final Debouncer<String> _searchDebouncer;

  // Stream subscriptions
  final List<StreamSubscription<dynamic>> _subscriptions =
      <StreamSubscription<dynamic>>[];

  // Observable state variables
  final RxBool isLoading = false.obs;
  final RxBool isFilterVisible = false.obs;
  final RxBool hasMoreResults = true.obs;
  final RxInt currentPage = 1.obs;
  final RxInt resultsPerPage = 10.obs;
  final RxList<JobModel> searchResults = <JobModel>[].obs;
  final RxList<SearchHistory> searchHistory = <SearchHistory>[].obs;
  final RxList<SearchFilter> savedSearches = <SearchFilter>[].obs;
  final Rx<SearchFilter> filter = SearchFilter().obs;

  @override
  void onInit() {
    super.onInit();
    _logger.i('SearchController initialized');

    // Initialize text controller
    searchTextController = TextEditingController();

    // Initialize debouncer
    _searchDebouncer = Debouncer<String>(
      const Duration(milliseconds: 500),
      initialValue: '',
    );

    // Initialize search service
    _initSearchService();

    // Listen to debouncer and store the subscription
    _subscriptions.add(
      _searchDebouncer.values.listen((query) {
        if (query.isNotEmpty) {
          _performSearch(query: query);
        }
      }),
    );

    _logger.d('Added debouncer subscription to _subscriptions list');
  }

  @override
  void onReady() {
    super.onReady();
    // Load search history and saved searches
    _loadSearchHistory();
    _loadSavedSearches();
  }

  @override
  void onClose() {
    // Dispose resources
    searchTextController.dispose();

    // Cancel all stream subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _logger.d('Cancelled all stream subscriptions');

    super.onClose();
  }

  /// Initialize search service
  Future<void> _initSearchService() async {
    try {
      // Try to find the search service
      _searchService = Get.find<SearchService>();
      _logger.d('SearchService found');
    } catch (e) {
      // If not found, create a new instance
      _logger.d('SearchService not found, creating new instance');
      _searchService = await Get.put(SearchService()).init();
    }
  }

  /// Load search history
  Future<void> _loadSearchHistory() async {
    _logger.d('Loading search history');
    try {
      final history = await _searchService.getSearchHistory();
      searchHistory.value = history;
    } catch (e, s) {
      _logger.e('Error loading search history', e, s);
    }
  }

  /// Load saved searches
  Future<void> _loadSavedSearches() async {
    _logger.d('Loading saved searches');
    try {
      // Saved searches will be implemented in a future update
      // final saved = await _searchService.getSavedSearches();
      // savedSearches.value = saved;

      // Mock data for now
      savedSearches.value = [
        SearchFilter(
          query: 'Software Engineer',
          location: 'San Francisco',
          jobTypes: ['Full-time'],
          isRemote: true,
        ),
        SearchFilter(
          query: 'Product Manager',
          location: 'New York',
          minSalary: 100000,
          maxSalary: 150000,
        ),
        SearchFilter(
          query: 'UX Designer',
          location: 'Remote',
          jobTypes: ['Contract', 'Full-time'],
          isRemote: true,
        ),
      ];
    } catch (e, s) {
      _logger.e('Error loading saved searches', e, s);
    }
  }

  // Track the most recent search request
  int _lastSearchToken = 0;

  /// Perform search
  Future<void> _performSearch({String? query, bool loadMore = false}) async {
    // Generate a unique token for this search request
    final currentToken = DateTime.now().microsecondsSinceEpoch;
    final localToken = currentToken;
    _lastSearchToken = currentToken;

    // Reset pagination if this is a new search
    if (!loadMore) {
      currentPage.value = 1;
      hasMoreResults.value = true;
      // Clear existing results for new search
      if (searchResults.isNotEmpty) {
        searchResults.clear();
      }
    }

    // Don't load more if we already know there are no more results
    if (loadMore && !hasMoreResults.value) {
      _logger.d('No more results to load');
      return;
    }

    _logger.i('Performing search with query: ${query ?? filter.value.query} '
        '(token: $localToken, page: ${currentPage.value})');
    isLoading.value = true;
    update(); // Notify GetBuilder to update UI

    try {
      // Update filter with query if provided
      if (query != null && query != filter.value.query) {
        filter.value = filter.value.copyWith(query: query);
      }

      // Create a paginated filter by adding page and limit
      final paginatedFilter = filter.value.copyWith(
        page: currentPage.value,
        limit: resultsPerPage.value,
      );

      // Perform search with pagination
      final results = await _searchService.searchJobs(paginatedFilter);

      // Only update results if this is still the most recent search
      if (_lastSearchToken == localToken) {
        if (loadMore) {
          // Append results for pagination
          searchResults.addAll(results);
        } else {
          // Replace results for new search
          searchResults.value = results;
        }

        // Check if we have more results
        hasMoreResults.value = results.length >= resultsPerPage.value;

        _logger.d(
            'Search results updated: hasMoreResults=${hasMoreResults.value}, '
            'resultsCount=${results.length}, resultsPerPage=${resultsPerPage.value}, '
            'token=$localToken, page=${currentPage.value}');
      } else {
        _logger.d('Search results discarded - newer search exists '
            '(token: $localToken, latest: $_lastSearchToken)');
      }
    } catch (e, s) {
      _logger.e('Error performing search', e, s);
    } finally {
      // Only update loading state if this is still the most recent search
      if (_lastSearchToken == localToken) {
        isLoading.value = false;
        update(); // Notify GetBuilder to update UI
      }
    }
  }

  /// Handle search input
  void onSearchInputChanged(String value) {
    _logger.d('Search input changed: $value');
    _searchDebouncer.value = value;
  }

  /// Clear search
  void clearSearch() {
    _logger.d('Clearing search');
    searchTextController.clear();
    filter.value = SearchFilter();
    searchResults.clear();
    update(); // Notify GetBuilder to update UI
  }

  /// Toggle filter visibility
  void toggleFilter() {
    _logger.d('Toggling filter visibility');
    isFilterVisible.value = !isFilterVisible.value;
    update(); // Notify GetBuilder to update UI
  }

  /// Apply filter
  void applyFilter(SearchFilter newFilter) {
    _logger.d('Applying filter: ${newFilter.toJson()}');
    filter.value = newFilter;
    isFilterVisible.value = false;
    _performSearch();
    update(); // Notify GetBuilder to update UI
  }

  /// Reset filter
  void resetFilter() {
    _logger.d('Resetting filter');
    filter.value = SearchFilter(query: filter.value.query);
    update(); // Notify GetBuilder to update UI
  }

  /// Load more search results (pagination)
  Future<void> loadMoreResults() async {
    _logger.d('Loading more results (page: ${currentPage.value})');

    // Don't load more if we're already loading or there are no more results
    if (isLoading.value || !hasMoreResults.value) {
      _logger.d(
        'Skipping load more: isLoading=${isLoading.value}, hasMoreResults=${hasMoreResults.value}',
      );
      return;
    }

    // Perform search with loadMore=true to append results
    await _performSearch(loadMore: true);
  }

  /// Clear search history
  Future<void> clearSearchHistory() async {
    _logger.d('Clearing search history');
    try {
      await _searchService.clearSearchHistory();
      searchHistory.clear();
      update(); // Notify GetBuilder to update UI
    } catch (e, s) {
      _logger.e('Error clearing search history', e, s);
    }
  }

  /// Delete search history item
  Future<void> deleteSearchHistoryItem(int index) async {
    _logger.d('Deleting search history item at index $index');
    try {
      await _searchService.deleteSearchHistoryItem(index);
      searchHistory.removeAt(index);
      update(); // Notify GetBuilder to update UI
    } catch (e, s) {
      _logger.e('Error deleting search history item', e, s);
    }
  }

  /// Use search history item
  void useSearchHistoryItem(SearchHistory item) {
    _logger.d('Using search history item: ${item.query}');
    searchTextController.text = item.query;
    filter.value = filter.value.copyWith(query: item.query);
    _performSearch();
    update(); // Notify GetBuilder to update UI
  }
}
