import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:next_gen/app/modules/search/models/search_filter.dart';
import 'package:next_gen/core/theme/app_theme.dart';
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

  // Job type options
  final List<String> _jobTypeOptions = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Temporary',
  ];

  // These options are defined for future implementation
  // of additional filter options
  // ignore: unused_field
  final List<String> _experienceOptions = [
    '0-1 years',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    '10+ years',
  ];

  // ignore: unused_field
  final List<String> _educationOptions = [
    'High School',
    "Associate's",
    "Bachelor's",
    "Master's",
    'Doctorate',
  ];

  // ignore: unused_field
  final List<String> _industryOptions = [
    'Automotive',
    'Manufacturing',
    'Engineering',
    'Technology',
    'Sales',
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
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
                ),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.xmark),
                onPressed: widget.onCancel,
                color: isDarkMode ? AppTheme.slateGray : AppTheme.slateGray,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Location
          Text(
            'Location',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter location',
              prefixIcon: Icon(
                FontAwesomeIcons.locationDot,
                size: 16,
                color: isDarkMode ? AppTheme.slateGray : AppTheme.slateGray,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(location: value);
              });
            },
          ),
          const SizedBox(height: 24),

          // Salary Range
          Text(
            'Salary Range',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
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
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_filter.minSalary}',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '\$${_filter.maxSalary}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Job Type
          Text(
            'Job Type',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
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
                ),
              ),
              const Spacer(),
              Switch(
                value: _filter.isRemote,
                onChanged: (value) {
                  setState(() {
                    _filter = _filter.copyWith(isRemote: value);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sort By
          Text(
            'Sort By',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<SortOption>(
            value: _filter.sortBy,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                  });
                },
                borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                child: CustomNeoPopButton(
                  color: theme.colorScheme.error,
                  onTap: widget.onReset,
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
                  color: theme.colorScheme.primary,
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
