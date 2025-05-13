import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/search/controllers/search_controller.dart'
    as app_search;
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/views/widgets/filter_modal.dart';
import 'package:next_gen/app/modules/search/views/widgets/job_card.dart';
import 'package:next_gen/app/modules/search/views/widgets/search_history_item.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

/// View for the Search module
class SearchView extends StatefulWidget {
  /// Constructor
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final app_search.SearchController controller;
  late final NavigationController navigationController;

  // Create a unique scaffold key for this view
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Get the controllers
    controller = Get.find<app_search.SearchController>();

    // Get or register NavigationController
    if (Get.isRegistered<NavigationController>()) {
      navigationController = Get.find<NavigationController>();
    } else {
      navigationController = Get.put(NavigationController(), permanent: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Use a safer approach to update the selected index
    // Schedule the update for after the current build phase is complete
    // This prevents setState() called during build errors
    if (navigationController.selectedIndex.value != 1) {
      // Use Future.microtask to schedule the update after the current build phase
      Future.microtask(() {
        // Only update if we're still on this page (widget is still mounted)
        if (mounted) {
          navigationController.changeIndex(1);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Job Search'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.bars3),
          onPressed: () => navigationController.toggleDrawer(_scaffoldKey),
        ),
        actions: [
          // Filter button
          IconButton(
            icon: const Icon(FontAwesomeIcons.sliders),
            onPressed: controller.toggleFilter,
            tooltip: 'Filter',
          ),
        ],
      ),
      bottomNavigationBar: const UnifiedBottomNav(),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          // Determine if we're on a mobile device
          final isMobile =
              sizingInformation.deviceScreenType == DeviceScreenType.mobile;

          return Column(
            children: [
              // Search bar
              _buildSearchBar(context, theme, isDarkMode),

              // Main content
              Expanded(
                child: Obx(
                  () => controller.isFilterVisible.value
                      ? _buildFilterView(context, theme, isMobile)
                      : _buildSearchResults(context, theme, isMobile),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build the search bar
  Widget _buildSearchBar(
    BuildContext context,
    ThemeData theme,
    bool isDarkMode,
  ) {
    // Define employee blue color
    const employeeBlue = RoleThemes.employeePrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26), // 0.1 * 255 = 26
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search icon
          const Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: employeeBlue,
            size: 18,
          ),
          const SizedBox(width: 12),

          // Search input
          Expanded(
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchInputChanged,
              decoration: InputDecoration(
                hintText: 'Search for jobs, companies, or keywords...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: employeeBlue.withAlpha(179), // 0.7 * 255 = 179
                ),
                suffixIcon: controller.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.xmark,
                          color: employeeBlue,
                          size: 16,
                        ),
                        onPressed: controller.clearSearch,
                      )
                    : null,
              ),
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: employeeBlue,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the search results view
  Widget _buildSearchResults(
    BuildContext context,
    ThemeData theme,
    bool isMobile,
  ) {
    // IMPORTANT: We're already inside an Obx in the parent widget (line 96),
    // so we don't need another Obx here. Using nested Obx widgets can cause
    // "improper use of GetX" errors.

    // Show loading state
    if (controller.isLoading.value) {
      return _buildLoadingState(isMobile);
    }

    // Show search history if no query and no results
    if (controller.searchController.text.isEmpty &&
        controller.searchResults.isEmpty) {
      return _buildSearchHistory(context, theme);
    }

    // Show empty state if no results
    if (controller.searchResults.isEmpty) {
      return _buildEmptyState(theme);
    }

    // Show search results
    return _buildResultsList(context, theme, isMobile);
  }

  /// Build the filter view
  Widget _buildFilterView(
    BuildContext context,
    ThemeData theme,
    bool isMobile,
  ) {
    return FilterModal(
      initialFilter: controller.filter.value,
      onApply: controller.applyFilter,
      onReset: controller.resetFilter,
      onCancel: controller.toggleFilter,
    );
  }

  /// Build the loading state
  Widget _buildLoadingState(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          return Shimmer.fromColors(
            baseColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            highlightColor:
                isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: isMobile ? 120 : 150,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build the search history
  Widget _buildSearchHistory(BuildContext context, ThemeData theme) {
    // Define employee blue color
    const employeeBlue = RoleThemes.employeePrimary;

    // IMPORTANT: We're already inside an Obx in the parent widget (line 96),
    // so we don't need another Obx here. Using nested Obx widgets can cause
    // "improper use of GetX" errors.

    if (controller.searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.clockRotateLeft,
              size: 48,
              color: employeeBlue.withAlpha(128), // 0.5 * 255 = 128
            ),
            const SizedBox(height: 16),
            Text(
              'No search history yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: employeeBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your recent searches will appear here',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: employeeBlue,
                ),
              ),
              TextButton.icon(
                icon: const Icon(
                  FontAwesomeIcons.trash,
                  size: 14,
                  color: employeeBlue,
                ),
                label: const Text(
                  'Clear All',
                  style: TextStyle(
                    color: employeeBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: controller.clearSearchHistory,
              ),
            ],
          ),
        ),

        // History list - Expanded gives it a bounded height to prevent overflow
        Expanded(
          child: ListView.builder(
            // Add physics to make sure scrolling works properly
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.searchHistory.length,
            itemBuilder: (context, index) {
              final item = controller.searchHistory[index];
              return SearchHistoryItem(
                item: item,
                onTap: () => controller.useSearchHistoryItem(item),
                onDelete: () => controller.deleteSearchHistoryItem(index),
                accentColor: employeeBlue,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build the empty state
  Widget _buildEmptyState(ThemeData theme) {
    // Define employee blue color
    const employeeBlue = RoleThemes.employeePrimary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 48,
            color: employeeBlue.withAlpha(128), // 0.5 * 255 = 128
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: employeeBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or filters',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          CustomNeoPopButton(
            color: employeeBlue,
            onTap: controller.resetFilter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Text(
                'Reset Filters',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the results list
  Widget _buildResultsList(
    BuildContext context,
    ThemeData theme,
    bool isMobile,
  ) {
    // Define employee blue color
    const employeeBlue = RoleThemes.employeePrimary;

    // Make sure we have a bounded height for the ListView
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count and active filters
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${controller.searchResults.length} results found',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: employeeBlue,
                ),
              ),
              const Spacer(),
              if (controller.filter.value.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.filterCircleXmark,
                    size: 16,
                    color: employeeBlue,
                  ),
                  label: const Text(
                    'Clear Filters',
                    style: TextStyle(
                      color: employeeBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: controller.resetFilter,
                ),
            ],
          ),
        ),

        // Results list - Expanded gives it a bounded height
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // Check if we're at the bottom of the list
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                // Load more results if available
                if (controller.hasMoreResults.value &&
                    !controller.isLoading.value) {
                  controller.loadMoreResults();
                }
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              // Add physics to make sure scrolling works properly
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.searchResults.length +
                  1, // +1 for loading indicator
              itemBuilder: (context, index) {
                // If we're at the end of the list, show a loading indicator
                if (index == controller.searchResults.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(employeeBlue),
                            )
                          : TextButton(
                              // No need for nested Obx here as we're already in a reactive context
                              onPressed: controller.hasMoreResults.value
                                  ? controller.loadMoreResults
                                  : null,
                              child: Text(
                                controller.hasMoreResults.value
                                    ? 'Load More'
                                    : 'No More Results',
                                style: TextStyle(
                                  color: controller.hasMoreResults.value
                                      ? employeeBlue
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  );
                }

                // Otherwise, show a job card
                final job = controller.searchResults[index];
                return JobCard(
                  job: job,
                  onTap: () => _onJobTap(job),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Handle job tap
  void _onJobTap(JobModel job) {
    // Use NavigationController to navigate to job details
    // This preserves the current tab context
    navigationController.navigateToDetail('/jobs/details', arguments: job);
  }
}
