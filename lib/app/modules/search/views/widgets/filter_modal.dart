import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/widgets/neopop_button.dart';

/// A modal widget for filtering search results
class FilterModal extends StatefulWidget {
  /// Constructor
  const FilterModal({
    required this.initialFilter,
    required this.onApply,
    required this.onReset,
    required this.onCancel,
    super.key,
  });

  /// Initial filter
  final SearchFilter initialFilter;

  /// Callback when the apply button is tapped
  final ValueChanged<SearchFilter> onApply;

  /// Callback when the reset button is tapped
  final VoidCallback onReset;

  /// Callback when the cancel button is tapped
  final VoidCallback onCancel;

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late SearchFilter _filter;
  final TextEditingController _locationController = TextEditingController();
  final RxBool _showSaveSearchOption = false.obs;
  final TextEditingController _saveSearchNameController =
      TextEditingController();

  // Job type options
  final List<String> _jobTypeOptions = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Temporary',
    'Freelance',
  ];

  // Experience options
  final List<String> _experienceOptions = [
    '0-1 years',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    '10+ years',
  ];

  // Education options
  final List<String> _educationOptions = [
    'High School',
    "Associate's",
    "Bachelor's",
    "Master's",
    'Doctorate',
  ];

  // Industry options
  final List<String> _industryOptions = [
    'Automotive',
    'Manufacturing',
    'Engineering',
    'Technology',
    'Sales',
    'Healthcare',
    'Finance',
    'Education',
    'Retail',
    'Hospitality',
  ];

  @override
  void initState() {
    super.initState();
    // Ensure maxSalary is not greater than the slider's max value
    final initialFilter = widget.initialFilter;
    _filter = initialFilter.copyWith(
      maxSalary:
          initialFilter.maxSalary > 200000 ? 200000 : initialFilter.maxSalary,
    );
    _locationController.text = _filter.location;

    // Show save search option if filter is not empty
    _showSaveSearchOption.value = initialFilter.isNotEmpty;
  }

  @override
  void dispose() {
    _locationController.dispose();
    _saveSearchNameController.dispose();
    super.dispose();
  }

  /// Get the number of active filters
  int _getActiveFilterCount() {
    var count = 0;
    if (_filter.location.isNotEmpty) count++;
    if (_filter.minSalary > 0) count++;
    if (_filter.maxSalary < 200000) count++;
    if (_filter.jobTypes.isNotEmpty) count++;
    if (_filter.experience.isNotEmpty) count++;
    if (_filter.education.isNotEmpty) count++;
    if (_filter.industries.isNotEmpty) count++;
    if (_filter.isRemote) count++;
    if (_filter.sortBy != SortOption.relevance) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define employee blue color
    const employeeBlue = RoleThemes.employeePrimary;
    final employeeLightBlue = employeeBlue.withAlpha(26); // 0.1 * 255 = 26

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Jobs',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: employeeBlue,
                ),
              ),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.xmark,
                  color: employeeBlue,
                ),
                onPressed: widget.onCancel,
              ),
            ],
          ),

          // Active filters count
          if (_filter.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${_getActiveFilterCount()} active filters',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: employeeBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Location
          Text(
            'Location',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: employeeBlue,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter location',
              prefixIcon: const Icon(
                FontAwesomeIcons.locationDot,
                size: 16,
                color: employeeBlue,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: employeeBlue, width: 2),
              ),
              filled: true,
              fillColor: employeeLightBlue,
            ),
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(location: value);
                // Show save search option if filter is not empty
                _showSaveSearchOption.value = _filter.isNotEmpty;
              });
            },
          ),
          const SizedBox(height: 24),

          // Salary Range
          Text(
            'Salary Range',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: employeeBlue,
            ),
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: RangeValues(
              _filter.minSalary.toDouble().clamp(0, 200000),
              _filter.maxSalary.toDouble().clamp(0, 200000),
            ),
            max: 200000,
            divisions: 20,
            activeColor: employeeBlue,
            inactiveColor: employeeLightBlue,
            labels: RangeLabels(
              '\$${_filter.minSalary}',
              '\$${_filter.maxSalary}',
            ),
            onChanged: (values) {
              setState(() {
                _filter = _filter.copyWith(
                  minSalary: values.start.round(),
                  maxSalary: values.end.round(),
                );
                // Show save search option if filter is not empty
                _showSaveSearchOption.value = _filter.isNotEmpty;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_filter.minSalary}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: employeeBlue,
                ),
              ),
              Text(
                '\$${_filter.maxSalary}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: employeeBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Job Type
          Text(
            'Job Type',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: employeeBlue,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _jobTypeOptions.map((type) {
              final isSelected = _filter.jobTypes.contains(type);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                selectedColor: employeeLightBlue,
                checkmarkColor: employeeBlue,
                labelStyle: TextStyle(
                  color: isSelected
                      ? employeeBlue
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? employeeBlue : Colors.grey.shade300,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _filter = _filter.copyWith(
                        jobTypes: [..._filter.jobTypes, type],
                      );
                    } else {
                      _filter = _filter.copyWith(
                        jobTypes:
                            _filter.jobTypes.where((t) => t != type).toList(),
                      );
                    }
                    // Show save search option if filter is not empty
                    _showSaveSearchOption.value = _filter.isNotEmpty;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Remote
          Row(
            children: [
              Text(
                'Remote Only',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: employeeBlue,
                ),
              ),
              const Spacer(),
              Switch(
                value: _filter.isRemote,
                activeColor: employeeBlue,
                activeTrackColor: employeeLightBlue,
                onChanged: (value) {
                  setState(() {
                    _filter = _filter.copyWith(isRemote: value);
                    // Show save search option if filter is not empty
                    _showSaveSearchOption.value = _filter.isNotEmpty;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Experience Level
          Text(
            'Experience Level',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: employeeBlue,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _experienceOptions.map((exp) {
              final isSelected = _filter.experience.contains(exp);
              return FilterChip(
                label: Text(exp),
                selected: isSelected,
                selectedColor: employeeLightBlue,
                checkmarkColor: employeeBlue,
                labelStyle: TextStyle(
                  color: isSelected
                      ? employeeBlue
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? employeeBlue : Colors.grey.shade300,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _filter = _filter.copyWith(
                        experience: [..._filter.experience, exp],
                      );
                    } else {
                      _filter = _filter.copyWith(
                        experience:
                            _filter.experience.where((e) => e != exp).toList(),
                      );
                    }
                    // Show save search option if filter is not empty
                    _showSaveSearchOption.value = _filter.isNotEmpty;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Education Level
          Text(
            'Education Level',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: employeeBlue,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _educationOptions.map((edu) {
              final isSelected = _filter.education.contains(edu);
              return FilterChip(
                label: Text(edu),
                selected: isSelected,
                selectedColor: employeeLightBlue,
                checkmarkColor: employeeBlue,
                labelStyle: TextStyle(
                  color: isSelected
                      ? employeeBlue
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? employeeBlue : Colors.grey.shade300,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _filter = _filter.copyWith(
                        education: [..._filter.education, edu],
                      );
                    } else {
                      _filter = _filter.copyWith(
                        education:
                            _filter.education.where((e) => e != edu).toList(),
                      );
                    }
                    // Show save search option if filter is not empty
                    _showSaveSearchOption.value = _filter.isNotEmpty;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Industry
          Text(
            'Industry',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: employeeBlue,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _industryOptions.map((industry) {
              final isSelected = _filter.industries.contains(industry);
              return FilterChip(
                label: Text(industry),
                selected: isSelected,
                selectedColor: employeeLightBlue,
                checkmarkColor: employeeBlue,
                labelStyle: TextStyle(
                  color: isSelected
                      ? employeeBlue
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? employeeBlue : Colors.grey.shade300,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _filter = _filter.copyWith(
                        industries: [..._filter.industries, industry],
                      );
                    } else {
                      _filter = _filter.copyWith(
                        industries: _filter.industries
                            .where((i) => i != industry)
                            .toList(),
                      );
                    }
                    // Show save search option if filter is not empty
                    _showSaveSearchOption.value = _filter.isNotEmpty;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Sort By
          Text(
            'Sort By',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: employeeBlue,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<SortOption>(
            value: _filter.sortBy,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: employeeBlue, width: 2),
              ),
              filled: true,
              fillColor: employeeLightBlue,
            ),
            dropdownColor: theme.cardColor,
            icon: const Icon(
              FontAwesomeIcons.chevronDown,
              color: employeeBlue,
              size: 16,
            ),
            items: SortOption.values.map((option) {
              return DropdownMenuItem<SortOption>(
                value: option,
                child: Text(_getSortOptionLabel(option)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _filter = _filter.copyWith(sortBy: value);
                  // Show save search option if filter is not empty
                  _showSaveSearchOption.value = _filter.isNotEmpty;
                });
              }
            },
          ),
          const SizedBox(height: 16),

          // Sort Order
          Row(
            children: [
              Text(
                'Sort Order',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: employeeBlue,
                ),
              ),
              const Spacer(),
              ToggleButtons(
                isSelected: [
                  _filter.sortOrder == SortOrder.ascending,
                  _filter.sortOrder == SortOrder.descending,
                ],
                onPressed: (index) {
                  setState(() {
                    _filter = _filter.copyWith(
                      sortOrder: index == 0
                          ? SortOrder.ascending
                          : SortOrder.descending,
                    );
                    // Show save search option if filter is not empty
                    _showSaveSearchOption.value = _filter.isNotEmpty;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                selectedBorderColor: employeeBlue,
                selectedColor: Colors.white,
                fillColor: employeeBlue,
                color: employeeBlue,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(FontAwesomeIcons.arrowUp),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(FontAwesomeIcons.arrowDown),
                  ),
                ],
              ),
            ],
          ),

          // Save Search Option
          Obx(() {
            if (_showSaveSearchOption.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Save This Search',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: employeeBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _saveSearchNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter a name for this search',
                            prefixIcon: const Icon(
                              FontAwesomeIcons.bookmark,
                              size: 16,
                              color: employeeBlue,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: employeeBlue,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: employeeLightBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.floppyDisk,
                          color: employeeBlue,
                        ),
                        onPressed: () {
                          // TODO(developer): Implement save search functionality
                          Get.snackbar(
                            'Search Saved',
                            'Your search has been saved',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: employeeBlue,
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const SizedBox(height: 32);
            }
          }),

          // Buttons
          Row(
            children: [
              Expanded(
                child: CustomNeoPopButton(
                  color: theme.colorScheme.error,
                  onTap: () {
                    _saveSearchNameController.clear();
                    widget.onReset();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Reset',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomNeoPopButton(
                  color: employeeBlue,
                  onTap: () => widget.onApply(_filter),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Apply',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get the label for a sort option
  String _getSortOptionLabel(SortOption option) {
    switch (option) {
      case SortOption.relevance:
        return 'Relevance';
      case SortOption.date:
        return 'Date';
      case SortOption.salary:
        return 'Salary';
      case SortOption.company:
        return 'Company';
      case SortOption.location:
        return 'Location';
    }
  }
}
