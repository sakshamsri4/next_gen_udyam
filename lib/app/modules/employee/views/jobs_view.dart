import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/employee/controllers/jobs_controller.dart';
import 'package:next_gen/app/modules/employee/views/widgets/simple_filter_modal.dart';
import 'package:next_gen/app/modules/search/models/job_model.dart';
import 'package:next_gen/app/modules/search/views/widgets/job_card.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Jobs view for employee users
///
/// This screen combines search and saved jobs functionality in a single tab
/// with segmented views. It allows users to search for jobs and access their
/// saved jobs in one place.
class JobsView extends GetView<JobsController> {
  /// Creates a jobs view
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleBasedLayout(
      title: 'Jobs',
      body: Column(
        children: [
          // Segmented control for switching between Search and Saved
          _buildSegmentedControl(context),

          // Main content area
          Expanded(
            child: Obx(
              () => controller.currentTab.value == 0
                  ? _buildSearchTab(context)
                  : _buildSavedTab(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Build segmented control for tab switching
  Widget _buildSegmentedControl(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: _buildSegmentButton(
                  context: context,
                  title: 'Search',
                  icon: HeroIcons.magnifyingGlass,
                  isSelected: controller.currentTab.value == 0,
                  onTap: () => controller.setCurrentTab(0),
                ),
              ),
              Expanded(
                child: _buildSegmentButton(
                  context: context,
                  title: 'Saved',
                  icon: HeroIcons.bookmark,
                  isSelected: controller.currentTab.value == 1,
                  onTap: () => controller.setCurrentTab(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a segment button
  Widget _buildSegmentButton({
    required BuildContext context,
    required String title,
    required HeroIcons icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? RoleThemes.employeePrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              icon,
              color:
                  isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build search tab content
  Widget _buildSearchTab(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: 'Search jobs, companies, or keywords',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterModal(context),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) => controller.searchJobs(value),
          ),
        ),

        // Active filters
        Obx(
          () => controller.activeFilters.isNotEmpty
              ? _buildActiveFilters(context)
              : const SizedBox.shrink(),
        ),

        // Search results
        Expanded(
          child: Obx(() {
            if (controller.isSearching.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.searchResults.isEmpty) {
              return _buildEmptyState(
                context,
                'No jobs found',
                'Try adjusting your search or filters',
              );
            }

            return _buildJobsList(context, controller.searchResults);
          }),
        ),
      ],
    );
  }

  /// Build saved tab content
  Widget _buildSavedTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSaved.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.savedJobs.isEmpty) {
        return _buildEmptyState(
          context,
          'No saved jobs',
          'Jobs you save will appear here',
        );
      }

      return _buildJobsList(context, controller.savedJobs);
    });
  }

  /// Build active filters chips
  Widget _buildActiveFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.activeFilters.map((filter) {
          return Chip(
            label: Text(filter),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () => controller.removeFilter(filter),
            backgroundColor:
                const Color(0x192563EB), // 10% opacity of employeePrimary
            labelStyle: const TextStyle(color: RoleThemes.employeePrimary),
          );
        }).toList(),
      ),
    );
  }

  /// Build jobs list
  Widget _buildJobsList(BuildContext context, List<JobModel> jobs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return JobCard(
          job: job,
          onTap: () => controller.viewJobDetails(job),
          onSave: () => controller.toggleSaveJob(job),
        );
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Show filter modal
  void _showFilterModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SimpleFilterModal(
          onApply: (Map<String, dynamic> filters) {
            controller.applyFilters(filters);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
