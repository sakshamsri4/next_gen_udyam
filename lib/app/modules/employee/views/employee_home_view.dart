import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/employee/controllers/employee_home_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// Home screen for employee users
///
/// This screen displays job recommendations, recent searches, and application updates.
/// It uses the blue color scheme to visually indicate the employee role.
class EmployeeHomeView extends GetView<EmployeeHomeController> {
  /// Creates an employee home view
  const EmployeeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the employee-specific colors
    const primaryColor = Color(0xFF2563EB); // Blue primary color
    const secondaryColor = Color(0xFF0D9488); // Teal secondary color

    return RoleBasedLayout(
      title: 'Home',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to search screen
          Get.toNamed<dynamic>('/search');
        },
        backgroundColor: primaryColor,
        child: const HeroIcon(
          HeroIcons.magnifyingGlass,
          style: HeroIconStyle.solid,
          color: Colors.white,
        ),
      ),
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
                // Welcome section with user name
                _buildWelcomeSection(context, primaryColor),

                const SizedBox(height: 24),

                // Quick search bar
                _buildQuickSearchBar(context, primaryColor),

                const SizedBox(height: 24),

                // Job recommendations section
                _buildSectionHeader(
                  context,
                  'Recommended for you',
                  primaryColor,
                  onSeeAllPressed: () {
                    // Navigate to recommendations screen
                    Get.toNamed<dynamic>('/recommendations');
                  },
                ),

                const SizedBox(height: 16),

                // Job recommendations list
                _buildJobRecommendations(context, primaryColor),

                const SizedBox(height: 24),

                // Recently viewed section
                _buildSectionHeader(
                  context,
                  'Recently viewed',
                  primaryColor,
                  onSeeAllPressed: () {
                    // Navigate to history screen
                    Get.toNamed<dynamic>('/history');
                  },
                ),

                const SizedBox(height: 16),

                // Recently viewed jobs list
                _buildRecentlyViewedJobs(context, primaryColor),

                const SizedBox(height: 24),

                // Application updates section
                _buildSectionHeader(
                  context,
                  'Application updates',
                  primaryColor,
                  onSeeAllPressed: () {
                    // Navigate to applications screen
                    Get.toNamed<dynamic>('/applications');
                  },
                ),

                const SizedBox(height: 16),

                // Application updates list
                _buildApplicationUpdates(context, primaryColor, secondaryColor),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the welcome section with user name
  Widget _buildWelcomeSection(BuildContext context, Color primaryColor) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final user = authController.user.value;
      final greeting = _getGreeting();
      final userName = user?.displayName?.split(' ').first ?? 'there';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting,',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find your dream job today',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    });
  }

  /// Build the quick search bar
  Widget _buildQuickSearchBar(BuildContext context, Color primaryColor) {
    return InkWell(
      onTap: () {
        // Navigate to search screen
        Get.toNamed<dynamic>('/search');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
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
            HeroIcon(
              HeroIcons.magnifyingGlass,
              color: primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search for jobs, companies, or keywords',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.mic,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
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

  /// Build the job recommendations list
  Widget _buildJobRecommendations(BuildContext context, Color primaryColor) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingJobCards();
      }

      if (controller.recommendedJobs.isEmpty) {
        return _buildEmptyState(
          'No recommendations yet',
          'We will show you personalized job recommendations based on your profile and preferences.',
        );
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
                return controller.isJobSaved(job.id);
              },
            ),
          );
        },
      );
    });
  }

  /// Build the recently viewed jobs list
  Widget _buildRecentlyViewedJobs(BuildContext context, Color primaryColor) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingJobCards();
      }

      if (controller.recentlyViewedJobs.isEmpty) {
        return _buildEmptyState(
          'No recently viewed jobs',
          'Jobs you view will appear here for quick access.',
        );
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
                return controller.isJobSaved(job.id);
              },
            ),
          );
        },
      );
    });
  }

  /// Build the application updates list
  Widget _buildApplicationUpdates(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingApplicationCards();
      }

      if (controller.applicationUpdates.isEmpty) {
        return _buildEmptyState(
          'No application updates',
          'Updates on your job applications will appear here.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.applicationUpdates.length.clamp(0, 3),
        itemBuilder: (context, index) {
          final update = controller.applicationUpdates[index];
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: secondaryColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: HeroIcon(
                            _getUpdateIcon(update.status),
                            color: secondaryColor,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              update.jobTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              update.companyName,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _getTimeAgo(update.timestamp),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    update.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigate to application details
                          Get.toNamed<dynamic>(
                            '/applications/details',
                            arguments: update.applicationId,
                          );
                        },
                        child: Text(
                          'View details',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  /// Build loading state for job cards
  Widget _buildLoadingJobCards() {
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

  /// Build loading state for application cards
  Widget _buildLoadingApplicationCards() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ShimmerWidget(
            width: double.infinity,
            height: 100,
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

  /// Get the appropriate icon for an application update status
  HeroIcons _getUpdateIcon(String status) {
    switch (status.toLowerCase()) {
      case 'reviewed':
        return HeroIcons.eye;
      case 'interview':
        return HeroIcons.calendar;
      case 'offer':
        return HeroIcons.documentCheck;
      case 'rejected':
        return HeroIcons.xMark;
      default:
        return HeroIcons.bell;
    }
  }

  /// Get a greeting based on the time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
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
