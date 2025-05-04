import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/controllers/search_controller.dart'
    as app_search;
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/views/widgets/filter_modal.dart';
import 'package:next_gen/app/modules/search/views/widgets/job_card.dart';
import 'package:next_gen/app/modules/search/views/widgets/search_history_item.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/bottom_navigation_bar.dart';
import 'package:next_gen/core/theme/app_theme.dart';
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

    // Set the selected index to the Search tab (index 1)
    navigationController.selectedIndex.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Search'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Filter button
          IconButton(
            icon: const Icon(FontAwesomeIcons.sliders),
            onPressed: controller.toggleFilter,
            tooltip: 'Filter',
          ),
        ],
      ),
      bottomNavigationBar: const CustomAnimatedBottomNavBar(),
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
          Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: isDarkMode ? AppTheme.slateGray : AppTheme.navyBlue,
            size: 18,
          ),
          const SizedBox(width: 12),

          // Search input
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              onChanged: controller.onSearchInputChanged,
              decoration: InputDecoration(
                hintText: 'Search for jobs...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: isDarkMode
                      ? AppTheme.slateGray.withAlpha(179) // 0.7 * 255 = 179
                      : AppTheme.slateGray.withAlpha(179),
                ),
              ),
              style: TextStyle(
                color: isDarkMode ? AppTheme.offWhite : AppTheme.navyBlue,
              ),
            ),
          ),

          // Clear button
          if (controller.searchTextController.text.isNotEmpty)
            IconButton(
              icon: const Icon(FontAwesomeIcons.xmark),
              onPressed: controller.clearSearch,
              color: isDarkMode ? AppTheme.slateGray : AppTheme.navyBlue,
              iconSize: 18,
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
    return Obx(() {
      // Show loading state
      if (controller.isLoading.value) {
        return _buildLoadingState(isMobile);
      }

      // Show search history if no query and no results
      if (controller.searchTextController.text.isEmpty &&
          controller.searchResults.isEmpty) {
        return _buildSearchHistory(context, theme);
      }

      // Show empty state if no results
      if (controller.searchResults.isEmpty) {
        return _buildEmptyState(theme);
      }

      // Show search results
      return _buildResultsList(context, theme, isMobile);
    });
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
    return Obx(() {
      if (controller.searchHistory.isEmpty) {
        return Center(
          child: Text(
            'No search history yet',
            style: theme.textTheme.bodyLarge,
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
                  ),
                ),
                TextButton(
                  onPressed: controller.clearSearchHistory,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          // History list
          Expanded(
            child: ListView.builder(
              itemCount: controller.searchHistory.length,
              itemBuilder: (context, index) {
                final item = controller.searchHistory[index];
                return SearchHistoryItem(
                  item: item,
                  onTap: () => controller.useSearchHistoryItem(item),
                  onDelete: () => controller.deleteSearchHistoryItem(index),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  /// Build the empty state
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 48,
            color: theme.colorScheme.primary.withAlpha(128), // 0.5 * 255 = 128
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or filters',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          CustomNeoPopButton(
            color: theme.colorScheme.primary,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${controller.searchResults.length} results found',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final job = controller.searchResults[index];
              return JobCard(
                job: job,
                onTap: () => _onJobTap(job),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Handle job tap
  void _onJobTap(JobModel job) {
    // Navigate to job details
    Get.toNamed<dynamic>('/jobs/details', arguments: job);
  }
}
