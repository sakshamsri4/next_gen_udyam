import 'dart:async';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/models/saved_search_model.dart';
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
  late final TextEditingController searchController;
  late final TextEditingController locationController;

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
  final RxString error = ''.obs;
  final RxString sortOption = 'relevance'.obs;
  final RxInt minSalary = 0.obs;
  final RxInt maxSalary = 150000.obs;
  final RxList<JobModel> searchResults = <JobModel>[].obs;
  final RxList<SearchHistory> searchHistory = <SearchHistory>[].obs;
  final RxList<SavedSearchModel> savedSearches = <SavedSearchModel>[].obs;
  final RxList<String> activeFilters = <String>[].obs;
  final Rx<SearchFilter> filter = SearchFilter().obs;

  // Scroll controller for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _logger.i('SearchController initialized');

    // Initialize text controllers
    searchController = TextEditingController();
    locationController = TextEditingController();

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

    // Add scroll controller listener for pagination
    scrollController.addListener(_scrollListener);

    _logger.d('Added debouncer subscription to _subscriptions list');
  }

  /// Scroll listener for pagination
  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMoreResults();
    }
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
    searchController.dispose();
    locationController.dispose();
    scrollController.dispose();

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
      final saved = await _searchService.getSavedSearches();
      savedSearches.value = saved;
    } catch (e, s) {
      _logger.e('Error loading saved searches', e, s);
    }
  }

  // Track the most recent search request
  int _lastSearchToken = 0;

  // Mutex to prevent concurrent searches
  bool _isSearchInProgress = false;

  /// Perform search
  Future<void> _performSearch({String? query, bool loadMore = false}) async {
    // Don't start a new search if one is already in progress
    if (_isSearchInProgress) {
      _logger.d('Search already in progress, ignoring new request');
      return;
    }

    // Set search in progress flag
    _isSearchInProgress = true;

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
      _isSearchInProgress = false;
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

      // Add a timeout to prevent hanging
      final results = await _searchService.searchJobs(paginatedFilter).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          _logger.w('Search timed out after 15 seconds');
          error.value = 'Search timed out. Please try again.';
          return <JobModel>[];
        },
      );

      // Only update results if this is still the most recent search
      if (_lastSearchToken == localToken) {
        // Clear error if successful
        if (error.value.isNotEmpty) {
          error.value = '';
        }

        if (loadMore) {
          // Only append if we got results
          if (results.isNotEmpty) {
            // Filter out duplicates by ID
            final existingIds = searchResults.map((job) => job.id).toSet();
            final newResults =
                results.where((job) => !existingIds.contains(job.id)).toList();

            if (newResults.isNotEmpty) {
              searchResults.addAll(newResults);
              currentPage.value++;
            }
          }
        } else {
          // Replace results for new search
          searchResults.value = results;

          // If we got results, increment page for next load
          if (results.isNotEmpty) {
            currentPage.value = 2; // Next page will be 2
          }
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
      if (_lastSearchToken == localToken) {
        error.value = 'Error searching for jobs. Please try again.';
      }
    } finally {
      // Only update loading state if this is still the most recent search
      if (_lastSearchToken == localToken) {
        isLoading.value = false;
        update(); // Notify GetBuilder to update UI
      }

      // Reset search in progress flag
      _isSearchInProgress = false;
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
    searchController.clear();
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
    searchController.text = item.query;
    filter.value = filter.value.copyWith(query: item.query);
    _performSearch();
    update(); // Notify GetBuilder to update UI
  }

  /// Perform search with the current query
  Future<void> performSearch(String query) async {
    _logger.d('Performing search with query: $query');
    searchController.text = query;
    filter.value = filter.value.copyWith(query: query);
    await _performSearch();
  }

  /// Refresh search results
  Future<void> refreshSearch() async {
    _logger.d('Refreshing search results');
    currentPage.value = 1;
    await _performSearch();
  }

  /// Toggle save job
  Future<void> toggleSaveJob(JobModel job) async {
    _logger.d('Toggling save job: ${job.id}');
    // This would be implemented with a real save/unsave functionality
    // For now, just show a snackbar
    Get.snackbar(
      'Job Saved',
      'Job "${job.title}" has been saved',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Share job
  void shareJob(JobModel job) {
    _logger.d('Sharing job: ${job.id}');
    // This would be implemented with a real share functionality
    // For now, just show a snackbar
    Get.snackbar(
      'Share Job',
      'Sharing job "${job.title}" is not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Quick apply for job
  Future<void> quickApplyJob(JobModel job) async {
    _logger.d('Quick applying for job: ${job.id}');
    // This would be implemented with a real quick apply functionality
    // For now, just navigate to the job details page
    Get.toNamed<dynamic>('/jobs/details/${job.id}');
  }

  /// Update filter
  void updateFilter({
    String? query,
    String? location,
    String? jobType,
    String? experienceLevel,
    int? minSalary,
    int? maxSalary,
    bool? isRemote,
    String? industry,
    int? postedWithin,
  }) {
    _logger.d('Updating filter');

    // Update filter
    var updatedFilter = filter.value.copyWith(
      query: query,
      location: location,
      minSalary: minSalary,
      maxSalary: maxSalary,
      isRemote: isRemote,
    );

    // Handle job type
    if (jobType != null) {
      updatedFilter = updatedFilter.copyWith(
        jobTypes: jobType.isEmpty ? [] : [jobType],
      );
    }

    // Handle experience
    if (experienceLevel != null) {
      updatedFilter = updatedFilter.copyWith(
        experience: experienceLevel.isEmpty ? [] : [experienceLevel],
      );
    }

    // Handle industry
    if (industry != null) {
      updatedFilter = updatedFilter.copyWith(
        industries: industry.isEmpty ? [] : [industry],
      );
    }

    filter.value = updatedFilter;

    // Update active filters
    _updateActiveFilters();

    // Update location controller if location is provided
    if (location != null) {
      locationController.text = location;
    }
  }

  /// Update active filters based on current filter
  void _updateActiveFilters() {
    final filters = <String>[];

    if (filter.value.query.isNotEmpty) {
      filters.add('"${filter.value.query}"');
    }

    if (filter.value.location.isNotEmpty) {
      filters.add('Location: ${filter.value.location}');
    }

    if (filter.value.jobTypes.isNotEmpty) {
      filters.addAll(filter.value.jobTypes);
    }

    if (filter.value.experience.isNotEmpty) {
      filters.add('Experience: ${filter.value.experience.first}');
    }

    if (filter.value.minSalary > 0 || filter.value.maxSalary < 200000) {
      filters.add(
        'Salary: \$${filter.value.minSalary}-\$${filter.value.maxSalary}',
      );
    }

    if (filter.value.isRemote) {
      filters.add('Remote');
    }

    if (filter.value.industries.isNotEmpty) {
      filters.add('Industry: ${filter.value.industries.first}');
    }

    activeFilters.value = filters;
  }

  /// Apply filters
  Future<void> applyFilters() async {
    _logger.d('Applying filters');
    currentPage.value = 1;
    await _performSearch();
  }

  /// Reset filters
  void resetFilters() {
    _logger.d('Resetting filters');
    filter.value = SearchFilter(query: filter.value.query);
    activeFilters.clear();
    locationController.clear();
    minSalary.value = 0;
    maxSalary.value = 150000;
  }

  /// Remove filter
  void removeFilter(String filterText) {
    _logger.d('Removing filter: $filterText');

    // Remove from active filters
    activeFilters.remove(filterText);

    // Update filter based on the removed filter
    if (filterText.startsWith('"') && filterText.endsWith('"')) {
      // Query filter
      filter.value = filter.value.copyWith(query: '');
      searchController.clear();
    } else if (filterText.startsWith('Location: ')) {
      // Location filter
      filter.value = filter.value.copyWith(location: '');
      locationController.clear();
    } else if (filterText == 'Full-time' ||
        filterText == 'Part-time' ||
        filterText == 'Contract' ||
        filterText == 'Internship' ||
        filterText == 'Temporary') {
      // Job type filter
      filter.value = filter.value.copyWith(jobTypes: []);
    } else if (filterText.startsWith('Experience: ')) {
      // Experience filter
      filter.value = filter.value.copyWith(experience: []);
    } else if (filterText.startsWith('Salary: ')) {
      // Salary filter
      filter.value = filter.value.copyWith(minSalary: 0, maxSalary: 200000);
      minSalary.value = 0;
      maxSalary.value = 150000;
    } else if (filterText == 'Remote') {
      // Remote filter
      filter.value = filter.value.copyWith(isRemote: false);
    } else if (filterText.startsWith('Industry: ')) {
      // Industry filter
      filter.value = filter.value.copyWith(industries: []);
    } else if (filterText == 'Last 24 hours' ||
        filterText == 'Last 7 days' ||
        filterText == 'Last 30 days') {
      // Posted within filter - not directly supported in our model
      // Just refresh the search
    }

    // Update active filters
    _updateActiveFilters();

    // Refresh search results
    _performSearch();
  }

  /// Set sort option
  void setSortOption(String option) {
    _logger.d('Setting sort option: $option');
    sortOption.value = option;
    _performSearch();
  }

  /// Apply saved search
  void applySavedSearch(SavedSearchModel search) {
    _logger.d('Applying saved search: ${search.query}');
    searchController.text = search.query;
    filter.value = search.filter;
    _performSearch();
  }

  /// Delete saved search
  Future<void> deleteSavedSearch(SavedSearchModel search) async {
    _logger.d('Deleting saved search: ${search.id}');
    final success = await _searchService.deleteSavedSearch(search.id);
    if (success) {
      savedSearches.remove(search);
      Get.snackbar(
        'Success',
        'Saved search deleted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to delete saved search',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Save current search
  Future<void> saveCurrentSearch() async {
    _logger.d('Saving current search');

    // Show dialog to get search name
    final name = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Save Search'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Search Name',
            hintText: 'Enter a name for this search',
          ),
          onSubmitted: (value) => Get.back(result: value),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<String>(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(
              result: searchController.text.isNotEmpty
                  ? searchController.text
                  : 'Saved Search',
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) {
      _logger.d('Save search cancelled');
      return;
    }

    // Save the search
    final savedSearch = await _searchService.saveSearch(
      searchController.text,
      filter.value,
    );

    if (savedSearch != null) {
      // Add to saved searches
      savedSearches.add(savedSearch);

      Get.snackbar(
        'Success',
        'Search saved',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to save search',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
