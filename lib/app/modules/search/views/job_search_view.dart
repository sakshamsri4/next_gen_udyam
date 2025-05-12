import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/search/controllers/search_controller.dart'
    as app_search;
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/views/widgets/advanced_filter_modal.dart';
import 'package:next_gen/app/modules/search/views/widgets/job_card.dart';
import 'package:next_gen/app/modules/search/views/widgets/saved_search_item.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/buttons/cred_button.dart';
import 'package:next_gen/ui/components/fields/custom_text_field.dart';
import 'package:next_gen/ui/components/loaders/shimmer/recent_jobs_shimmer.dart';

/// Advanced job search view with filters and saved searches
class JobSearchView extends GetView<app_search.SearchController> {
  /// Creates a job search view
  const JobSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return RoleBasedLayout(
      title: 'Job Search',
      body: Column(
        children: [
          // Search bar with filters
          _buildSearchBar(context),

          // Main content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }

              if (controller.error.value.isNotEmpty) {
                return _buildErrorState(theme, controller.error.value);
              }

              if (controller.searchResults.isEmpty) {
                return _buildEmptyState(theme, isDarkMode);
              }

              return _buildSearchResults(theme, isDarkMode);
            }),
          ),
        ],
      ),
    );
  }

  /// Build search bar with filters
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Search field with save button
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: controller.searchController,
                  hintText: 'Search jobs, companies, or skills',
                  isSearchBar: true,
                  prefixIcon: HeroIcons.magnifyingGlass,
                  suffixIcon: HeroIcons.adjustmentsHorizontal,
                  onSuffixTap: () => _showAdvancedFilterModal(context),
                  onFieldSubmitted: (value) => controller.performSearch(value),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: () => controller.saveCurrentSearch(),
                icon: const HeroIcon(HeroIcons.bookmark),
                tooltip: 'Save this search',
                color: RoleThemes.employeePrimary,
              ),
            ],
          ),

          // Active filters
          Obx(() {
            if (controller.activeFilters.isEmpty) {
              return const SizedBox.shrink();
            }

            return _buildActiveFilters(context);
          }),

          // Saved searches
          Obx(() {
            if (controller.savedSearches.isEmpty) {
              return const SizedBox.shrink();
            }

            return _buildSavedSearches(context);
          }),
        ],
      ),
    );
  }

  /// Build active filters
  Widget _buildActiveFilters(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.activeFilters.length,
        itemBuilder: (context, index) {
          final filter = controller.activeFilters[index];
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Chip(
              label: Text(filter),
              deleteIcon: const HeroIcon(HeroIcons.xMark, size: 16),
              onDeleted: () => controller.removeFilter(filter),
              backgroundColor: const Color(0xFFE6F0FF), // Light blue
              labelStyle: TextStyle(
                color: RoleThemes.employeePrimary,
                fontSize: 12.sp,
              ),
              deleteIconColor: RoleThemes.employeePrimary,
            ),
          );
        },
      ),
    );
  }

  /// Build saved searches
  Widget _buildSavedSearches(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.savedSearches.length,
        itemBuilder: (context, index) {
          final search = controller.savedSearches[index];
          return SavedSearchItem(
            search: search,
            onTap: () => controller.applySavedSearch(search),
            onDelete: () => controller.deleteSavedSearch(search),
          );
        },
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const RecentJobsShimmer();
  }

  /// Build error state
  Widget _buildErrorState(ThemeData theme, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HeroIcon(
            HeroIcons.exclamationTriangle,
            size: 64,
            color: Colors.orange,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          CredButton(
            title: 'Try Again',
            onTap: () async => controller.refreshSearch(),
            backgroundColor: RoleThemes.employeePrimary,
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(ThemeData theme, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeroIcon(
            HeroIcons.magnifyingGlass,
            size: 64.w,
            color: isDarkMode ? Colors.white54 : Colors.black38,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Results Found',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or filters',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build search results
  Widget _buildSearchResults(ThemeData theme, bool isDarkMode) {
    return Column(
      children: [
        // Results count and sort
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  '${controller.searchResults.length} Results',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildSortDropdown(theme, isDarkMode),
            ],
          ),
        ),

        // Results list
        Expanded(
          child: Obx(
            () => ListView.builder(
              controller: controller.scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount:
                  controller.searchResults.length + 1, // +1 for load more
              itemBuilder: (context, index) {
                // If we're at the end, show load more button or "No more results"
                if (index == controller.searchResults.length) {
                  return _buildLoadMoreButton(theme, isDarkMode);
                }

                // Otherwise, show a job card
                final job = controller.searchResults[index];
                return JobCard(
                  job: job,
                  onTap: () => _onJobTap(job),
                  onSave: () => controller.toggleSaveJob(job),
                  onShare: () => controller.shareJob(job),
                  onQuickApply: () => controller.quickApplyJob(job),
                  matchPercentage: _calculateMatchPercentage(job),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Build sort dropdown
  Widget _buildSortDropdown(ThemeData theme, bool isDarkMode) {
    return Obx(
      () => DropdownButton<String>(
        value: controller.sortOption.value,
        icon: const HeroIcon(HeroIcons.chevronDown, size: 16),
        underline: const SizedBox(),
        style: theme.textTheme.bodyMedium,
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.setSortOption(newValue);
          }
        },
        items: const [
          DropdownMenuItem(
            value: 'relevance',
            child: Text('Relevance'),
          ),
          DropdownMenuItem(
            value: 'date',
            child: Text('Date: Newest'),
          ),
          DropdownMenuItem(
            value: 'salary',
            child: Text('Salary: High to Low'),
          ),
        ],
      ),
    );
  }

  /// Build load more button
  Widget _buildLoadMoreButton(ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Obx(
          () => TextButton(
            onPressed: controller.hasMoreResults.value
                ? controller.loadMoreResults
                : null,
            child: Text(
              controller.hasMoreResults.value ? 'Load More' : 'No More Results',
              style: TextStyle(
                color: controller.hasMoreResults.value
                    ? RoleThemes.employeePrimary
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Show advanced filter modal
  void _showAdvancedFilterModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const AdvancedFilterModal();
      },
    );
  }

  /// Handle job tap
  void _onJobTap(JobModel job) {
    Get.toNamed<dynamic>('/jobs/details/${job.id}');
  }

  /// Calculate match percentage based on profile
  int _calculateMatchPercentage(JobModel job) {
    // This would be implemented with a real algorithm based on user profile
    // For now, return a random percentage between 60 and 100
    return 60 + (job.id.hashCode % 40).abs();
  }
}
