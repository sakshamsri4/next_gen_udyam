import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// Dashboard screen for admin users
///
/// This screen displays system metrics, moderation queue, and recent activity.
/// It uses the indigo color scheme to visually indicate the admin role.
class AdminDashboardView extends GetView<AdminDashboardController> {
  /// Creates an admin dashboard view
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the admin-specific colors
    const primaryColor = Color(0xFF4F46E5); // Indigo primary color
    const secondaryColor = Color(0xFFE11D48); // Rose secondary color
    const accentColor = Color(0xFFF59E0B); // Amber accent color

    return RoleBasedLayout(
      title: 'Admin Dashboard',
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System health overview
                _buildSystemHealthOverview(
                  context,
                  primaryColor,
                  secondaryColor,
                  accentColor,
                ),

                const SizedBox(height: 24),

                // User metrics
                _buildUserMetrics(context, primaryColor),

                const SizedBox(height: 24),

                // Moderation queue section
                _buildSectionHeader(
                  context,
                  'Moderation Queue',
                  primaryColor,
                  onSeeAllPressed: () {
                    // Navigate to moderation screen
                    Get.toNamed<dynamic>(Routes.moderation);
                  },
                ),

                const SizedBox(height: 16),

                // Moderation queue list
                _buildModerationQueue(context, primaryColor, secondaryColor),

                const SizedBox(height: 24),

                // Recent activity section
                _buildSectionHeader(
                  context,
                  'Recent Activity',
                  primaryColor,
                  onSeeAllPressed: () {
                    // Navigate to activity log screen
                    Get.toNamed<dynamic>(Routes.activityLog);
                  },
                ),

                const SizedBox(height: 16),

                // Recent activity list
                _buildRecentActivity(context, primaryColor),

                const SizedBox(height: 24),

                // Quick actions section
                _buildQuickActions(
                  context,
                  primaryColor,
                  secondaryColor,
                  accentColor,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the system health overview section
  Widget _buildSystemHealthOverview(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
    Color accentColor,
  ) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const ShimmerWidget(
          width: double.infinity,
          height: 120,
        );
      }

      final metrics = controller.systemMetrics;
      if (metrics.isEmpty) {
        return const SizedBox.shrink();
      }

      final serverLoad = metrics['serverLoad'] as int? ?? 0;
      final responseTime = metrics['responseTime'] as int? ?? 0;
      final errorRate = metrics['errorRate'] as double? ?? 0.0;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'System Health',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getHealthStatusColor(
                      serverLoad,
                      responseTime,
                      errorRate,
                    ).withAlpha(26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getHealthStatus(serverLoad, responseTime, errorRate),
                    style: TextStyle(
                      color: _getHealthStatusColor(
                        serverLoad,
                        responseTime,
                        errorRate,
                      ),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildHealthMetricItem(
                  context,
                  icon: HeroIcons.serverStack,
                  label: 'Server Load',
                  value: '$serverLoad%',
                  color: _getMetricColor(serverLoad, 50, 80),
                ),
                _buildHealthMetricItem(
                  context,
                  icon: HeroIcons.clock,
                  label: 'Response Time',
                  value: '$responseTime ms',
                  color: _getMetricColor(responseTime, 300, 500),
                ),
                _buildHealthMetricItem(
                  context,
                  icon: HeroIcons.exclamationTriangle,
                  label: 'Error Rate',
                  value: '${errorRate.toStringAsFixed(2)}%',
                  color: _getMetricColor(errorRate, 1.0, 5.0),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Build the user metrics section
  Widget _buildUserMetrics(BuildContext context, Color primaryColor) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const ShimmerWidget(
          width: double.infinity,
          height: 180,
        );
      }

      final metrics = controller.systemMetrics;
      if (metrics.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Platform Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetricItem(
                  context,
                  icon: HeroIcons.users,
                  label: 'Total Users',
                  value: '${metrics['totalUsers'] ?? 0}',
                  subValue: '+${metrics['newUsersToday'] ?? 0} today',
                  color: primaryColor,
                ),
                _buildMetricItem(
                  context,
                  icon: HeroIcons.briefcase,
                  label: 'Active Jobs',
                  value: '${metrics['activeJobs'] ?? 0}',
                  subValue: '+${metrics['newJobsToday'] ?? 0} today',
                  color: Colors.green,
                ),
                _buildMetricItem(
                  context,
                  icon: HeroIcons.documentText,
                  label: 'Applications',
                  value: '${metrics['totalApplications'] ?? 0}',
                  subValue: '+${metrics['newApplicationsToday'] ?? 0} today',
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Build a health metric item
  Widget _buildHealthMetricItem(
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build a metric item
  Widget _buildMetricItem(
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required String value,
    required String subValue,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: HeroIcon(
                icon,
                color: color,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subValue,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build a section header with title and see all button
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    Color primaryColor, {
    VoidCallback? onSeeAllPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        if (onSeeAllPressed != null)
          TextButton(
            onPressed: onSeeAllPressed,
            child: Text(
              'See all',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  /// Build the moderation queue list
  Widget _buildModerationQueue(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingModerationItems();
      }

      if (controller.moderationQueue.isEmpty) {
        return _buildEmptyState(
          'No items in queue',
          'All content has been moderated.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.moderationQueue.length.clamp(0, 3),
        itemBuilder: (context, index) {
          final item = controller.moderationQueue[index];
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
                    color: Colors.black.withAlpha(13),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor(item.type).withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.type,
                          style: TextStyle(
                            color: _getTypeColor(item.type),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(item.priority).withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.priority,
                          style: TextStyle(
                            color: _getPriorityColor(item.priority),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _getTimeAgo(item.submittedAt),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Submitted by ${item.submittedBy}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          controller.rejectModerationItem(item.id);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: secondaryColor,
                          side: BorderSide(color: secondaryColor),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Reject'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          controller.approveModerationItem(item.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Approve'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  /// Build the recent activity list
  Widget _buildRecentActivity(BuildContext context, Color primaryColor) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingActivityItems();
      }

      if (controller.recentActivity.isEmpty) {
        return _buildEmptyState(
          'No recent activity',
          'User activity will appear here.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentActivity.length.clamp(0, 4),
        itemBuilder: (context, index) {
          final activity = controller.recentActivity[index];
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
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // User photo
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(activity.userPhoto),
                  ),
                  const SizedBox(width: 16),
                  // Activity info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              activity.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              activity.action,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity.details,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getTimeAgo(activity.timestamp),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // View button
                  IconButton(
                    onPressed: () {
                      // Navigate to user management screen
                      Get.toNamed<dynamic>(Routes.userManagement);
                    },
                    icon: HeroIcon(
                      HeroIcons.chevronRight,
                      color: primaryColor,
                      size: 20,
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

  /// Build the quick actions section
  Widget _buildQuickActions(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionItem(
                context,
                icon: HeroIcons.users,
                label: 'Users',
                color: primaryColor,
                onTap: () => Get.toNamed<dynamic>(Routes.userManagement),
              ),
              _buildQuickActionItem(
                context,
                icon: HeroIcons.shieldCheck,
                label: 'Moderation',
                color: secondaryColor,
                onTap: () => Get.toNamed<dynamic>(Routes.moderation),
              ),
              _buildQuickActionItem(
                context,
                icon: HeroIcons.cog6Tooth,
                label: 'Settings',
                color: Colors.grey[700]!,
                onTap: () => Get.toNamed<dynamic>(Routes.systemConfig),
              ),
              _buildQuickActionItem(
                context,
                icon: HeroIcons.chartBar,
                label: 'Analytics',
                color: accentColor,
                onTap: () {
                  // TODO(developer): Implement analytics screen
                  // This route doesn't exist yet
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a quick action item
  Widget _buildQuickActionItem(
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: HeroIcon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build loading state for moderation items
  Widget _buildLoadingModerationItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
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

  /// Build loading state for activity items
  Widget _buildLoadingActivityItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ShimmerWidget(
            width: double.infinity,
            height: 80,
          ),
        );
      },
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(String title, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
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

  /// Get the appropriate color for a content type
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'job posting':
        return Colors.blue;
      case 'company profile':
        return Colors.green;
      case 'user report':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Get the appropriate color for a priority level
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Get the appropriate color for a metric value
  Color _getMetricColor(
    num value,
    num warningThreshold,
    num criticalThreshold,
  ) {
    if (value >= criticalThreshold) {
      return Colors.red;
    } else if (value >= warningThreshold) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  /// Get the system health status
  String _getHealthStatus(int serverLoad, int responseTime, double errorRate) {
    if (serverLoad >= 80 || responseTime >= 500 || errorRate >= 5.0) {
      return 'Critical';
    } else if (serverLoad >= 50 || responseTime >= 300 || errorRate >= 1.0) {
      return 'Warning';
    } else {
      return 'Good';
    }
  }

  /// Get the appropriate color for the health status
  Color _getHealthStatusColor(
    int serverLoad,
    int responseTime,
    double errorRate,
  ) {
    if (serverLoad >= 80 || responseTime >= 500 || errorRate >= 5.0) {
      return Colors.red;
    } else if (serverLoad >= 50 || responseTime >= 300 || errorRate >= 1.0) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  /// Get a human-readable time ago string
  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
