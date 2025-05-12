import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applicant_review/models/applicant_filter_model.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A modal for filtering applicants
class ApplicantFilterModal extends StatefulWidget {
  /// Creates an applicant filter modal
  ///
  /// [initialFilter] is the initial filter to use
  /// [onApply] is called when the filter is applied
  /// [onReset] is called when the filter is reset
  const ApplicantFilterModal({
    required this.initialFilter,
    required this.onApply,
    this.onReset,
    super.key,
  });

  /// The initial filter to use
  final ApplicantFilterModel initialFilter;

  /// Called when the filter is applied
  final void Function(ApplicantFilterModel) onApply;

  /// Called when the filter is reset
  final VoidCallback? onReset;

  @override
  State<ApplicantFilterModal> createState() => _ApplicantFilterModalState();
}

class _ApplicantFilterModalState extends State<ApplicantFilterModal> {
  late ApplicantFilterModel _filter;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final List<ApplicationStatus> _selectedStatuses = [];
  DateTime? _startDate;
  DateTime? _endDate;
  bool _hasResume = false;
  bool _hasCoverLetter = false;
  ApplicantSortOption _sortBy = ApplicantSortOption.applicationDate;
  ApplicantSortOrder _sortOrder = ApplicantSortOrder.descending;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _nameController.text = _filter.name;
    _skillsController.text = _filter.skills.join(', ');
    _experienceController.text = _filter.experience.join(', ');
    _educationController.text = _filter.education.join(', ');
    _selectedStatuses.addAll(_filter.statuses);
    _startDate = _filter.applicationDateStart;
    _endDate = _filter.applicationDateEnd;
    _hasResume = _filter.hasResume;
    _hasCoverLetter = _filter.hasCoverLetter;
    _sortBy = _filter.sortBy;
    _sortOrder = _filter.sortOrder;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Applicants',
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
          SizedBox(height: 16.h),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name filter
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Applicant Name',
                      hintText: 'Search by name',
                      border: OutlineInputBorder(),
                      prefixIcon: HeroIcon(HeroIcons.user),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Skills filter
                  TextField(
                    controller: _skillsController,
                    decoration: const InputDecoration(
                      labelText: 'Skills',
                      hintText: 'e.g. React, Node.js, Flutter',
                      border: OutlineInputBorder(),
                      prefixIcon: HeroIcon(HeroIcons.wrenchScrewdriver),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Experience filter
                  TextField(
                    controller: _experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Experience',
                      hintText: 'e.g. 1-3 years, 3-5 years',
                      border: OutlineInputBorder(),
                      prefixIcon: HeroIcon(HeroIcons.briefcase),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Education filter
                  TextField(
                    controller: _educationController,
                    decoration: const InputDecoration(
                      labelText: 'Education',
                      hintText: "e.g. Bachelor's, Master's",
                      border: OutlineInputBorder(),
                      prefixIcon: HeroIcon(HeroIcons.academicCap),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Status filter
                  Text(
                    'Application Status',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: ApplicationStatus.values.map((status) {
                      final isSelected = _selectedStatuses.contains(status);
                      return FilterChip(
                        label: Text(_getStatusText(status)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedStatuses.add(status);
                            } else {
                              _selectedStatuses.remove(status);
                            }
                          });
                        },
                        selectedColor: primaryColor.withAlpha(51),
                        checkmarkColor: primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? primaryColor : null,
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),

                  // Date range filter
                  Text(
                    'Application Date Range',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                              prefixIcon: HeroIcon(HeroIcons.calendar),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                              ),
                            ),
                            child: Text(
                              _startDate == null
                                  ? 'Select'
                                  : DateFormat('MMM d, yyyy')
                                      .format(_startDate!),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                              prefixIcon: HeroIcon(HeroIcons.calendar),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                              ),
                            ),
                            child: Text(
                              _endDate == null
                                  ? 'Select'
                                  : DateFormat('MMM d, yyyy').format(_endDate!),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Document filters
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Has Resume'),
                          value: _hasResume,
                          onChanged: (value) {
                            setState(() {
                              _hasResume = value ?? false;
                            });
                          },
                          activeColor: primaryColor,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Has Cover Letter'),
                          value: _hasCoverLetter,
                          onChanged: (value) {
                            setState(() {
                              _hasCoverLetter = value ?? false;
                            });
                          },
                          activeColor: primaryColor,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Sort options
                  Text(
                    'Sort By',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<ApplicantSortOption>(
                          value: _sortBy,
                          decoration: const InputDecoration(
                            labelText: 'Sort Field',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                          items: ApplicantSortOption.values.map((option) {
                            return DropdownMenuItem<ApplicantSortOption>(
                              value: option,
                              child: Text(_getSortOptionText(option)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _sortBy = value;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: DropdownButtonFormField<ApplicantSortOrder>(
                          value: _sortOrder,
                          decoration: const InputDecoration(
                            labelText: 'Sort Order',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                          items: ApplicantSortOrder.values.map((order) {
                            return DropdownMenuItem<ApplicantSortOrder>(
                              value: order,
                              child: Text(
                                order == ApplicantSortOrder.ascending
                                    ? 'Ascending'
                                    : 'Descending',
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _sortOrder = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Reset button
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _nameController.clear();
                    _skillsController.clear();
                    _experienceController.clear();
                    _educationController.clear();
                    _selectedStatuses.clear();
                    _startDate = null;
                    _endDate = null;
                    _hasResume = false;
                    _hasCoverLetter = false;
                    _sortBy = ApplicantSortOption.applicationDate;
                    _sortOrder = ApplicantSortOrder.descending;
                  });
                  widget.onReset?.call();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryColor),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(color: primaryColor),
                ),
              ),
              SizedBox(width: 16.w),

              // Apply button
              ElevatedButton(
                onPressed: () {
                  final filter = ApplicantFilterModel(
                    jobId: _filter.jobId,
                    name: _nameController.text,
                    skills: _skillsController.text.isEmpty
                        ? []
                        : _skillsController.text
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList(),
                    experience: _experienceController.text.isEmpty
                        ? []
                        : _experienceController.text
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList(),
                    education: _educationController.text.isEmpty
                        ? []
                        : _educationController.text
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList(),
                    statuses: _selectedStatuses,
                    applicationDateStart: _startDate,
                    applicationDateEnd: _endDate,
                    hasResume: _hasResume,
                    hasCoverLetter: _hasCoverLetter,
                    sortBy: _sortBy,
                    sortOrder: _sortOrder,
                    limit: _filter.limit,
                  );
                  widget.onApply(filter);
                  Get.back<void>();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Select a date
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? _startDate : _endDate;
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: RoleThemes.employerPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  /// Get text for a status
  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.reviewed:
        return 'Reviewed';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offered:
        return 'Offered';
      case ApplicationStatus.hired:
        return 'Hired';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  /// Get text for a sort option
  String _getSortOptionText(ApplicantSortOption option) {
    switch (option) {
      case ApplicantSortOption.applicationDate:
        return 'Application Date';
      case ApplicantSortOption.name:
        return 'Name';
      case ApplicantSortOption.status:
        return 'Status';
      case ApplicantSortOption.matchScore:
        return 'Match Score';
    }
  }
}
