import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/employee/controllers/employee_home_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';

/// Discover view for employee users
///
/// This screen combines job recommendations, activity feed, and quick access
/// to recently viewed jobs. It serves as the main landing page for employee users.
class DiscoverView extends GetView<EmployeeHomeController> {
  /// Creates a discover view
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleBasedLayout(
      title: 'Discover',
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: RoleThemes.employeePrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              _buildWelcomeSection(context),
              const SizedBox(height: 24),

              // Quick search bar
              _buildQuickSearchBar(context),
              const SizedBox(height: 24),

              // Job recommendations
              _buildSectionHeader(context, 'Recommended for You'),
              const SizedBox(height: 16),
              _buildJobRecommendations(context),
              const SizedBox(height: 24),

              // Recently viewed jobs
              _buildSectionHeader(context, 'Recently Viewed'),
              const SizedBox(height: 16),
              _buildRecentlyViewedJobs(context),
              const SizedBox(height: 24),

              // Activity feed
              _buildSectionHeader(context, 'Activity Feed'),
              const SizedBox(height: 16),
              _buildActivityFeed(context),
              const SizedBox(height: 24),

              // Industry insights
              _buildSectionHeader(context, 'Industry Insights'),
              const SizedBox(height: 16),
              _buildIndustryInsights(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build welcome section with personalized greeting
  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final userName = controller.userName.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${userName.isNotEmpty ? userName : 'there'}!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: RoleThemes.employeePrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover opportunities tailored for you',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyLarge?.color
                  ?.withAlpha(179), // 0.7 * 255 = 179
            ),
          ),
        ],
      );
    });
  }

  /// Build quick search bar
  Widget _buildQuickSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => Get.toNamed<dynamic>(Routes.search),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            HeroIcon(
              HeroIcons.magnifyingGlass,
              color: theme.textTheme.bodyLarge?.color
                  ?.withAlpha(179), // 0.7 * 255 = 179
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Search for jobs, companies, or keywords',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color
                    ?.withAlpha(179), // 0.7 * 255 = 179
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build section header with optional "See All" button
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to appropriate section based on title
            if (title == 'Recommended for You' || title == 'Recently Viewed') {
              Get.toNamed<dynamic>(Routes.search);
            } else if (title == 'Activity Feed') {
              Get.toNamed<dynamic>(Routes.applications);
            }
          },
          child: const Text(
            'See All',
            style: TextStyle(
              color: RoleThemes.employeePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Build job recommendations section
  Widget _buildJobRecommendations(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingShimmer();
      }

      if (controller.recommendedJobs.isEmpty) {
        return _buildEmptyState('No recommendations yet');
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recommendedJobs.length.clamp(0, 3),
        itemBuilder: (context, index) {
          final job = controller.recommendedJobs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CustomJobCard(
              avatar: job.logoUrl ?? '',
              companyName: job.company,
              publishTime: job.postedDate.toIso8601String(),
              jobPosition: job.title,
              workplace: job.isRemote ? 'Remote' : 'On-site',
              location: job.location,
              employmentType: job.jobType,
              actionIcon: HeroIcons.bookmark,
              description: job.description,
              onTap: () =>
                  Get.toNamed<dynamic>('/jobs/details', arguments: job),
              onAvatarTap: () {},
              onActionTap: ({required bool isLiked}) async {
                // Save or unsave the job
                await controller.toggleSaveJob(job.id);
                return null;
              },
            ),
          );
        },
      );
    });
  }

  /// Build recently viewed jobs section
  Widget _buildRecentlyViewedJobs(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingShimmer();
      }

      if (controller.recentlyViewedJobs.isEmpty) {
        return _buildEmptyState('No recently viewed jobs');
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentlyViewedJobs.length.clamp(0, 3),
        itemBuilder: (context, index) {
          final job = controller.recentlyViewedJobs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CustomJobCard(
              avatar: job.logoUrl ?? '',
              companyName: job.company,
              publishTime: job.postedDate.toIso8601String(),
              jobPosition: job.title,
              workplace: job.isRemote ? 'Remote' : 'On-site',
              location: job.location,
              employmentType: job.jobType,
              actionIcon: HeroIcons.bookmark,
              description: job.description,
              onTap: () =>
                  Get.toNamed<dynamic>('/jobs/details', arguments: job),
              onAvatarTap: () {},
              onActionTap: ({required bool isLiked}) async {
                // Save or unsave the job
                await controller.toggleSaveJob(job.id);
                return null;
              },
            ),
          );
        },
      );
    });
  }

  /// Build activity feed section
  Widget _buildActivityFeed(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingShimmer();
      }

      if (controller.applications.isEmpty) {
        return _buildEmptyState('No recent activity');
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.applications.length.clamp(0, 3),
        itemBuilder: (context, index) {
          final application = controller.applications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor:
                    RoleThemes.employeePrimary.withAlpha(51), // 0.2 * 255 = 51
                child: const HeroIcon(
                  HeroIcons.documentText,
                  color: RoleThemes.employeePrimary,
                  size: 20,
                ),
              ),
              title: Text(
                application.jobTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    application.companyName,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${application.status}',
                    style: TextStyle(
                      color: _getStatusColor(application.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () => Get.toNamed<dynamic>(
                '/applications/${application.applicationId}',
              ),
            ),
          );
        },
      );
    });
  }

  /// Build industry insights section
  Widget _buildIndustryInsights(BuildContext context) {
    final theme = Theme.of(context);

    // This would typically come from an API or service
    // For now, we'll use static data
    final insights = [
      {
        'title': 'Tech Industry Growth',
        'description': 'The tech sector is projected to grow by 15% in 2023.',
        'icon': HeroIcons.computerDesktop,
      },
      {
        'title': 'Remote Work Trends',
        'description': '70% of companies now offer permanent remote options.',
        'icon': HeroIcons.home,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: insights.length,
      itemBuilder: (context, index) {
        final insight = insights[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor:
                  RoleThemes.employeePrimary.withAlpha(51), // 0.2 * 255 = 51
              child: HeroIcon(
                insight['icon']! as HeroIcons,
                color: RoleThemes.employeePrimary,
                size: 20,
              ),
            ),
            title: Text(
              insight['title']! as String,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                insight['description']! as String,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build loading shimmer placeholder
  Widget _buildLoadingShimmer() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Build empty state placeholder
  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(message),
      ),
    );
  }

  /// Get color based on application status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'applied':
        return Colors.blue;
      case 'in review':
        return Colors.orange;
      case 'interview':
        return Colors.purple;
      case 'offered':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
