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

  // Observable state variables
  final RxBool isLoading = false.obs;
  final RxBool isFilterVisible = false.obs;
  final RxList<JobModel> searchResults = <JobModel>[].obs;
  final RxList<SearchHistory> searchHistory = <SearchHistory>[].obs;
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

    // Listen to debouncer
    _searchDebouncer.values.listen((query) {
      if (query.isNotEmpty) {
        _performSearch(query: query);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Load search history
    _loadSearchHistory();
  }

  @override
  void onClose() {
    // Dispose resources
    searchTextController.dispose();
    // No need to close the debouncer as it doesn't have a close method
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

  // Track the most recent search request
  int _lastSearchToken = 0;

  /// Perform search
  Future<void> _performSearch({String? query}) async {
    // Generate a unique token for this search request
    final currentToken = DateTime.now().microsecondsSinceEpoch;
    final localToken = currentToken;
    _lastSearchToken = currentToken;

    _logger.i('Performing search with query: ${query ?? filter.value.query} '
        '(token: $localToken)');
    isLoading.value = true;
    update(); // Notify GetBuilder to update UI

    try {
      // Update filter with query if provided
      if (query != null && query != filter.value.query) {
        filter.value = filter.value.copyWith(query: query);
      }

      // Perform search
      final results = await _searchService.searchJobs(filter.value);

      // Only update results if this is still the most recent search
      if (_lastSearchToken == localToken) {
        searchResults.value = results;
        _logger.d('Search results updated (token: $localToken)');
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
