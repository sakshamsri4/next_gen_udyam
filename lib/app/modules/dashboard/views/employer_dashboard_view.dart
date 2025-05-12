import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/buttons/role_adaptive_button.dart';
import 'package:next_gen/widgets/neopop_card.dart';

/// Dashboard screen for employer users
///
/// Note: This view uses DashboardController which contains employer-specific properties
/// like companyName, activeJobsCount, etc. In the future, this should be refactored to use
/// a dedicated EmployerDashboardController with these properties properly defined.
class EmployerDashboardView extends GetView<DashboardController> {
  /// Creates an employer dashboard view
  const EmployerDashboardView({super.key});

  /// Extension getter for recentActivities to fix naming inconsistency
  /// This getter exists to maintain consistent naming conventions in the UI
  /// while the controller uses the singular form 'recentActivity'
  RxList<ActivityItem> get recentActivities => controller.recentActivity;

  @override
  Widget build(BuildContext context) {
    return RoleBasedLayout(
      title: 'Dashboard',
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed<dynamic>(Routes.jobPosting),
        backgroundColor: RoleThemes.employerPrimary,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        color: RoleThemes.employerPrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              _buildWelcomeSection(context),
              const SizedBox(height: 24),

              // Key metrics
              _buildSectionHeader(context, 'Key Metrics'),
              const SizedBox(height: 16),
              _buildKeyMetrics(context),
              const SizedBox(height: 24),

              // Quick actions
              _buildSectionHeader(context, 'Quick Actions'),
              const SizedBox(height: 16),
              _buildQuickActions(context),
              const SizedBox(height: 24),

              // Recent activity
              _buildSectionHeader(context, 'Recent Activity'),
              const SizedBox(height: 16),
              _buildRecentActivity(context),
              const SizedBox(height: 24),

              // Upcoming interviews
              _buildSectionHeader(context, 'Upcoming Interviews'),
              const SizedBox(height: 16),
              _buildUpcomingInterviews(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final companyName = controller.companyName.value.isNotEmpty
          ? controller.companyName.value
          : 'Company';

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RoleThemes.employerPrimary.withAlpha(26), // 0.1 * 255 ≈ 26
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $companyName!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: RoleThemes.employerPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your job postings and applicants',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            RoleAdaptiveButton(
              text: 'Post a New Job',
              onPressed: () => Get.toNamed<dynamic>(Routes.jobPosting),
              icon: Icons.add,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(
              color: RoleThemes.employerPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyMetrics(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMetricCard(
            context,
            'Active Jobs',
            controller.activeJobsCount.toString(),
            HeroIcons.briefcase,
          ),
          _buildMetricCard(
            context,
            'Total Applicants',
            controller.totalApplicantsCount.toString(),
            HeroIcons.users,
          ),
          _buildMetricCard(
            context,
            'Job Views',
            controller.jobViewsCount.toString(),
            HeroIcons.eye,
          ),
          _buildMetricCard(
            context,
            'Conversion Rate',
            '${controller.conversionRate.toStringAsFixed(1)}%',
            HeroIcons.chartBar,
          ),
        ],
      );
    });
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    HeroIcons icon,
  ) {
    return NeoPopCard(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              icon,
              color: RoleThemes.employerPrimary,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: RoleThemes.employerPrimary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildActionCard(
          context,
          'Post Job',
          'Create a new job listing',
          HeroIcons.plus,
          () => Get.toNamed<dynamic>(Routes.jobPosting),
        ),
        _buildActionCard(
          context,
          'Review Applicants',
          'Check new applications',
          HeroIcons.userGroup,
          () => Get.toNamed<dynamic>(Routes.search),
        ),
        _buildActionCard(
          context,
          'Edit Profile',
          'Update company information',
          HeroIcons.buildingOffice2,
          () => Get.toNamed<dynamic>(Routes.companyProfile),
        ),
        _buildActionCard(
          context,
          'Analytics',
          'View detailed metrics',
          HeroIcons.chartBar,
          () {},
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    HeroIcons icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: NeoPopCard(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(
                icon,
                color: RoleThemes.employerPrimary,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Obx(() {
      if (recentActivities.isEmpty) {
        return _buildEmptyState(
          context,
          'No recent activity',
          'Recent activities will appear here.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentActivities.length,
        itemBuilder: (context, index) {
          final activity = recentActivities[index];
          return NeoPopCard(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(activity.title),
              subtitle: Text(activity.description),
              trailing: Text(
                _getTimeAgo(activity.time),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {},
            ),
          );
        },
      );
    });
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

  Widget _buildUpcomingInterviews(BuildContext context) {
    return Obx(() {
      if (controller.upcomingInterviews.isEmpty) {
        return _buildEmptyState(
          context,
          'No upcoming interviews',
          'Scheduled interviews will appear here.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.upcomingInterviews.length,
        itemBuilder: (context, index) {
          final interview = controller.upcomingInterviews[index];
          return NeoPopCard(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(interview.candidateName),
              subtitle: Text(interview.jobTitle),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    interview.date,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    interview.time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyState(BuildContext context, String title, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: RoleThemes.employerPrimary.withAlpha(128), // 0.5 * 255 = 128
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
