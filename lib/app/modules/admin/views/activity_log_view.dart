import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/admin/controllers/activity_log_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// Activity log view for admin users
class ActivityLogView extends GetView<ActivityLogController> {
  /// Creates an activity log view
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    // Admin-specific colors are defined in RoleThemes

    return RoleBasedLayout(
      title: 'Activity Log',
      body: Obx(() {
        return controller.isLoading.value
            ? _buildLoadingState(context)
            : _buildContent(context);
      }),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and filter bar
          _buildSearchAndFilter(context),

          const SizedBox(height: 24),

          // Activity log list
          Expanded(
            child: _buildActivityLogList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: controller.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search activity logs...',
              prefixIcon: const HeroIcon(HeroIcons.magnifyingGlass),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Filter options
          Row(
            children: [
              // Date range filter
              Expanded(
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.dateFilter.value,
                    decoration: InputDecoration(
                      labelText: 'Date Range',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      'All Time',
                      'Today',
                      'Last 7 Days',
                      'Last 30 Days',
                      'Custom',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateDateFilter(value);
                      }
                    },
                  );
                }),
              ),

              const SizedBox(width: 16),

              // Activity type filter
              Expanded(
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.activityTypeFilter.value,
                    decoration: InputDecoration(
                      labelText: 'Activity Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      'All Types',
                      'Login',
                      'Profile Update',
                      'Job Posting',
                      'Job Application',
                      'System',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateActivityTypeFilter(value);
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogList(BuildContext context) {
    return Obx(() {
      if (controller.filteredLogs.isEmpty) {
        return _buildEmptyState(
          'No activity logs found',
          'Try adjusting your filters to see more results.',
        );
      }

      return ListView.builder(
        itemCount: controller.filteredLogs.length,
        itemBuilder: (context, index) {
          final log = controller.filteredLogs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 13),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // User info
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                'https://ui-avatars.com/api/?name=${log.userName}&background=4F46E5&color=fff',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              log.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Activity type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getActivityTypeColor(log.action)
                              .withValues(alpha: 26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log.action,
                          style: TextStyle(
                            color: _getActivityTypeColor(log.action),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Activity details
                  Text(
                    log.details,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Timestamp
                  Text(
                    log.timestamp,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildLoadingState(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ShimmerWidget(
            width: double.infinity,
            height: 120,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'login':
        return Colors.blue;
      case 'profile update':
        return Colors.green;
      case 'job posting':
        return Colors.purple;
      case 'job application':
        return Colors.orange;
      case 'system':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
