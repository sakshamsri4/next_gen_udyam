import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/search/controllers/search_controller.dart'
    as app_search;
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/buttons/cred_button.dart';

/// Employee blue color
const employeeBlue = RoleThemes.employeePrimary;

/// Advanced filter modal for job search
class AdvancedFilterModal extends GetView<app_search.SearchController> {
  /// Creates an advanced filter modal
  const AdvancedFilterModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, theme),

          // Filter options
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Type
                  _buildFilterSection(
                    title: 'Job Type',
                    child: _buildJobTypeFilter(theme, isDarkMode),
                  ),

                  // Location
                  _buildFilterSection(
                    title: 'Location',
                    child: _buildLocationFilter(theme, isDarkMode),
                  ),

                  // Experience Level
                  _buildFilterSection(
                    title: 'Experience Level',
                    child: _buildExperienceFilter(theme, isDarkMode),
                  ),

                  // Salary Range
                  _buildFilterSection(
                    title: 'Salary Range',
                    child: _buildSalaryFilter(theme, isDarkMode),
                  ),

                  // Remote Work
                  _buildFilterSection(
                    title: 'Remote Work',
                    child: _buildRemoteFilter(theme, isDarkMode),
                  ),

                  // Industry
                  _buildFilterSection(
                    title: 'Industry',
                    child: _buildIndustryFilter(theme, isDarkMode),
                  ),

                  // Posted Date
                  _buildFilterSection(
                    title: 'Posted Date',
                    child: _buildPostedDateFilter(theme, isDarkMode),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  /// Build header
  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Advanced Filters',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const HeroIcon(HeroIcons.xMark),
            onPressed: () => Get.back<void>(),
          ),
        ],
      ),
    );
  }

  /// Build filter section
  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child,
        SizedBox(height: 16.h),
        Divider(height: 1.h),
      ],
    );
  }

  /// Build job type filter
  Widget _buildJobTypeFilter(ThemeData theme, bool isDarkMode) {
    return Obx(
      () => Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          _buildFilterChip(
            label: 'Full-time',
            isSelected: controller.filter.value.jobTypes.contains('Full-time'),
            onSelected: (selected) => controller.updateFilter(
              jobType: selected ? 'Full-time' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Part-time',
            isSelected: controller.filter.value.jobTypes.contains('Part-time'),
            onSelected: (selected) => controller.updateFilter(
              jobType: selected ? 'Part-time' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Contract',
            isSelected: controller.filter.value.jobTypes.contains('Contract'),
            onSelected: (selected) => controller.updateFilter(
              jobType: selected ? 'Contract' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Internship',
            isSelected: controller.filter.value.jobTypes.contains('Internship'),
            onSelected: (selected) => controller.updateFilter(
              jobType: selected ? 'Internship' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Temporary',
            isSelected: controller.filter.value.jobTypes.contains('Temporary'),
            onSelected: (selected) => controller.updateFilter(
              jobType: selected ? 'Temporary' : null,
            ),
            theme: theme,
          ),
        ],
      ),
    );
  }

  /// Build location filter
  Widget _buildLocationFilter(ThemeData theme, bool isDarkMode) {
    return Obx(
      () => Column(
        children: [
          TextField(
            controller: controller.locationController,
            decoration: InputDecoration(
              hintText: 'Enter location',
              prefixIcon: const HeroIcon(HeroIcons.mapPin),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onChanged: (value) => controller.updateFilter(location: value),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildFilterChip(
                label: 'New York',
                isSelected: controller.filter.value.location == 'New York',
                onSelected: (selected) => controller.updateFilter(
                  location: selected ? 'New York' : '',
                ),
                theme: theme,
              ),
              _buildFilterChip(
                label: 'San Francisco',
                isSelected: controller.filter.value.location == 'San Francisco',
                onSelected: (selected) => controller.updateFilter(
                  location: selected ? 'San Francisco' : '',
                ),
                theme: theme,
              ),
              _buildFilterChip(
                label: 'London',
                isSelected: controller.filter.value.location == 'London',
                onSelected: (selected) => controller.updateFilter(
                  location: selected ? 'London' : '',
                ),
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build experience filter
  Widget _buildExperienceFilter(ThemeData theme, bool isDarkMode) {
    return Obx(
      () => Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          _buildFilterChip(
            label: 'Entry Level',
            isSelected:
                controller.filter.value.experience.contains('0-1 years'),
            onSelected: (selected) => controller.updateFilter(
              experienceLevel: selected ? '0-1 years' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Mid Level',
            isSelected:
                controller.filter.value.experience.contains('2-5 years'),
            onSelected: (selected) => controller.updateFilter(
              experienceLevel: selected ? '2-5 years' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Senior Level',
            isSelected: controller.filter.value.experience.contains('5+ years'),
            onSelected: (selected) => controller.updateFilter(
              experienceLevel: selected ? '5+ years' : null,
            ),
            theme: theme,
          ),
        ],
      ),
    );
  }

  /// Build salary filter
  Widget _buildSalaryFilter(ThemeData theme, bool isDarkMode) {
    return Obx(
      () => Column(
        children: [
          RangeSlider(
            values: RangeValues(
              controller.minSalary.value.toDouble(),
              controller.maxSalary.value.toDouble(),
            ),
            max: 200000,
            divisions: 20,
            labels: RangeLabels(
              '\$${controller.minSalary.value}',
              '\$${controller.maxSalary.value}',
            ),
            activeColor: employeeBlue,
            inactiveColor: employeeBlue.withAlpha(51), // 0.2 * 255 = 51
            onChanged: (RangeValues values) {
              controller.minSalary.value = values.start.round();
              controller.maxSalary.value = values.end.round();
            },
            onChangeEnd: (RangeValues values) {
              controller.updateFilter(
                minSalary: values.start.round(),
                maxSalary: values.end.round(),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${controller.minSalary.value}'),
                Text('\$${controller.maxSalary.value}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build remote filter
  Widget _buildRemoteFilter(ThemeData theme, bool isDarkMode) {
    return Obx(
      () => Row(
        children: [
          Switch(
            value: controller.filter.value.isRemote,
            onChanged: (value) => controller.updateFilter(isRemote: value),
            activeColor: employeeBlue,
          ),
          SizedBox(width: 8.w),
          Text(
            'Remote Only',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  /// Build industry filter
  Widget _buildIndustryFilter(ThemeData theme, bool isDarkMode) {
    return Obx(
      () => Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          _buildFilterChip(
            label: 'Technology',
            isSelected:
                controller.filter.value.industries.contains('Technology'),
            onSelected: (selected) => controller.updateFilter(
              industry: selected ? 'Technology' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Healthcare',
            isSelected:
                controller.filter.value.industries.contains('Healthcare'),
            onSelected: (selected) => controller.updateFilter(
              industry: selected ? 'Healthcare' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Finance',
            isSelected: controller.filter.value.industries.contains('Finance'),
            onSelected: (selected) => controller.updateFilter(
              industry: selected ? 'Finance' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Education',
            isSelected:
                controller.filter.value.industries.contains('Education'),
            onSelected: (selected) => controller.updateFilter(
              industry: selected ? 'Education' : null,
            ),
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Retail',
            isSelected: controller.filter.value.industries.contains('Retail'),
            onSelected: (selected) => controller.updateFilter(
              industry: selected ? 'Retail' : null,
            ),
            theme: theme,
          ),
        ],
      ),
    );
  }

  /// Build posted date filter
  Widget _buildPostedDateFilter(ThemeData theme, bool isDarkMode) {
    // Since postedWithin is not in the SearchFilter model, we'll use a different approach
    // We'll use the active filters to determine if a date filter is selected
    return Obx(
      () => Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          _buildFilterChip(
            label: 'Last 24 hours',
            isSelected: controller.activeFilters.contains('Last 24 hours'),
            onSelected: (selected) {
              if (selected) {
                controller.activeFilters.add('Last 24 hours');
              } else {
                controller.activeFilters.remove('Last 24 hours');
              }
            },
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Last 7 days',
            isSelected: controller.activeFilters.contains('Last 7 days'),
            onSelected: (selected) {
              if (selected) {
                controller.activeFilters.add('Last 7 days');
              } else {
                controller.activeFilters.remove('Last 7 days');
              }
            },
            theme: theme,
          ),
          _buildFilterChip(
            label: 'Last 30 days',
            isSelected: controller.activeFilters.contains('Last 30 days'),
            onSelected: (selected) {
              if (selected) {
                controller.activeFilters.add('Last 30 days');
              } else {
                controller.activeFilters.remove('Last 30 days');
              }
            },
            theme: theme,
          ),
        ],
      ),
    );
  }

  /// Build filter chip
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required void Function(bool) onSelected,
    required ThemeData theme,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: theme.cardColor,
      selectedColor: employeeBlue.withAlpha(51), // 0.2 * 255 = 51
      checkmarkColor: employeeBlue,
      labelStyle: TextStyle(
        color: isSelected ? employeeBlue : theme.textTheme.bodyLarge?.color,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // 0.05 * 255 = 12.75 ≈ 13
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                controller.resetFilters();
                Get.back<void>();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                side: const BorderSide(color: employeeBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(color: employeeBlue),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CredButton(
              title: 'Apply Filters',
              onTap: () async {
                controller.applyFilters();
                Get.back<void>();
              },
              backgroundColor: employeeBlue,
            ),
          ),
        ],
      ),
    );
  }
}
