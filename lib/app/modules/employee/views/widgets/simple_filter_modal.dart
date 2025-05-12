import 'package:flutter/material.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A simplified filter modal for the Jobs view
class SimpleFilterModal extends StatefulWidget {
  /// Constructor
  const SimpleFilterModal({
    required this.onApply,
    super.key,
  });

  /// Callback when the apply button is tapped
  final ValueChanged<Map<String, dynamic>> onApply;

  @override
  State<SimpleFilterModal> createState() => _SimpleFilterModalState();
}

class _SimpleFilterModalState extends State<SimpleFilterModal> {
  final TextEditingController _locationController = TextEditingController();
  String _selectedJobType = '';
  bool _isRemote = false;

  // Job type options
  final List<String> _jobTypeOptions = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Temporary',
    'Freelance',
  ];

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  color: RoleThemes.employeePrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
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
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
              final isSelected = _selectedJobType == type;
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedJobType = selected ? type : '';
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
                value: _isRemote,
                activeColor: RoleThemes.employeePrimary,
                onChanged: (value) {
                  setState(() {
                    _isRemote = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _locationController.clear();
                    setState(() {
                      _selectedJobType = '';
                      _isRemote = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final filters = <String, dynamic>{};

                    if (_locationController.text.isNotEmpty) {
                      filters['location'] = _locationController.text;
                    }

                    if (_selectedJobType.isNotEmpty) {
                      filters['jobType'] = _selectedJobType;
                    }

                    if (_isRemote) {
                      filters['isRemote'] = true;
                    }

                    widget.onApply(filters);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RoleThemes.employeePrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
