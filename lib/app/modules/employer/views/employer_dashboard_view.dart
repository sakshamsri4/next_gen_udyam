import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/employer/controllers/employer_dashboard_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// Dashboard screen for employer users
///
/// This screen displays key metrics, active jobs, and recent applicants.
/// It uses the green color scheme to visually indicate the employer role.
class EmployerDashboardView extends GetView<EmployerDashboardController> {
  /// Creates an employer dashboard view
  const EmployerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the employer-specific colors
    const primaryColor = Color(0xFF059669); // Green primary color
    const secondaryColor = Color(0xFFD97706); // Amber secondary color
    const accentColor = Color(0xFFDC2626); // Red accent color

    return RoleBasedLayout(
      title: 'Dashboard',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to job posting screen
          Get.toNamed<dynamic>('/job-posting');
        },
        backgroundColor: primaryColor,
        child: const HeroIcon(
          HeroIcons.plus,
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
                // Welcome section with company name
                _buildWelcomeSection(context, primaryColor),

                const SizedBox(height: 24),

                // Metrics overview
                _buildMetricsOverview(context, primaryColor, secondaryColor),

                const SizedBox(height: 24),

                // Active jobs section
                _buildSectionHeader(
                  context,
                  'Active job postings',
                  primaryColor,
                  onSeeAllPressed: () {
                    // Navigate to jobs management screen
                    Get.toNamed<dynamic>('/jobs-management');
                  },
                ),

                const SizedBox(height: 16),

                // Active jobs list
                _buildActiveJobs(context, primaryColor),

                const SizedBox(height: 24),

                // Recent applicants section
                _buildSectionHeader(
                  context,
                  'Recent applicants',
                  primaryColor,
                  onSeeAllPressed: () {
                    // Navigate to applicants screen
                    Get.toNamed<dynamic>('/applicants');
                  },
                ),

                const SizedBox(height: 16),

                // Recent applicants list
                _buildRecentApplicants(context, primaryColor, secondaryColor),

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

  /// Build the welcome section with company name
  Widget _buildWelcomeSection(BuildContext context, Color primaryColor) {
    final companyName = controller.getCompanyName();
    final greeting = _getGreeting();

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
          companyName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Here's what's happening with your job postings",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Build the metrics overview section
  Widget _buildMetricsOverview(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const ShimmerWidget(
          width: double.infinity,
          height: 180,
        );
      }

      final metrics = controller.metrics;
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
              "Today's Overview",
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
                  icon: HeroIcons.briefcase,
                  label: 'Active Jobs',
                  value: '${metrics['activeJobs'] ?? 0}',
                  color: primaryColor,
                ),
                _buildMetricItem(
                  context,
                  icon: HeroIcons.users,
                  label: 'New Applicants',
                  value: '${metrics['newApplicants'] ?? 0}',
                  color: secondaryColor,
                ),
                _buildMetricItem(
                  context,
                  icon: HeroIcons.eye,
                  label: 'Views Today',
                  value: '${metrics['viewsToday'] ?? 0}',
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetricItem(
                  context,
                  icon: HeroIcons.documentText,
                  label: 'Applications',
                  value: '${metrics['applicationsToday'] ?? 0}',
                  color: Colors.purple,
                ),
                _buildMetricItem(
                  context,
                  icon: HeroIcons.calendar,
                  label: 'Interviews',
                  value: '${metrics['interviewsScheduled'] ?? 0}',
                  color: Colors.orange,
                ),
                _buildMetricItem(
                  context,
                  icon: HeroIcons.chartBar,
                  label: 'Conversion',
                  value: '${metrics['conversionRate'] ?? 0}%',
                  color: Colors.teal,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Build a metric item
  Widget _buildMetricItem(
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required String value,
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

  /// Build the active jobs list
  Widget _buildActiveJobs(BuildContext context, Color primaryColor) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingJobCards();
      }

      if (controller.activeJobs.isEmpty) {
        return _buildEmptyState(
          'No active jobs',
          'Post a job to start receiving applications.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.activeJobs.length.clamp(0, 3),
        itemBuilder: (context, index) {
          final job = controller.activeJobs[index];
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
              actionIcon: HeroIcons.pencilSquare,
              description: job.description,
              onTap: () => Get.toNamed<dynamic>('/jobs/edit', arguments: job),
              onAvatarTap: () {},
              onActionTap: ({required bool isLiked}) async {
                // Edit the job
                Get.toNamed<dynamic>('/jobs/edit', arguments: job);
                return true;
              },
            ),
          );
        },
      );
    });
  }

  /// Build the recent applicants list
  Widget _buildRecentApplicants(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingApplicantCards();
      }

      if (controller.recentApplicants.isEmpty) {
        return _buildEmptyState(
          'No recent applicants',
          'Applicants will appear here when they apply to your jobs.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentApplicants.length.clamp(0, 3),
        itemBuilder: (context, index) {
          final applicant = controller.recentApplicants[index];
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
                  // Applicant photo
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(applicant.applicantPhoto),
                  ),
                  const SizedBox(width: 16),
                  // Applicant info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant.applicantName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Applied for ${applicant.jobTitle}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(applicant.status)
                                    .withAlpha(26),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                applicant.status,
                                style: TextStyle(
                                  color: _getStatusColor(applicant.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getTimeAgo(applicant.timestamp),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // View button
                  IconButton(
                    onPressed: () {
                      // Navigate to applicant details
                      Get.toNamed<dynamic>(
                        '/applicants/details',
                        arguments: applicant.applicantId,
                      );
                    },
                    icon: HeroIcon(
                      HeroIcons.chevronRight,
                      color: primaryColor,
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
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildQuickActionItem(
                context,
                icon: HeroIcons.plus,
                label: 'Post Job',
                color: primaryColor,
                onTap: () => Get.toNamed<dynamic>('/job-posting'),
              ),
              _buildQuickActionItem(
                context,
                icon: HeroIcons.users,
                label: 'Applicants',
                color: secondaryColor,
                onTap: () => Get.toNamed<dynamic>('/applicants'),
              ),
              _buildQuickActionItem(
                context,
                icon: HeroIcons.buildingOffice2,
                label: 'Company',
                color: Colors.blue,
                onTap: () => Get.toNamed<dynamic>('/company-profile'),
              ),
              _buildQuickActionItem(
                context,
                icon: HeroIcons.chartBar,
                label: 'Analytics',
                color: Colors.purple,
                onTap: () => Get.toNamed<dynamic>('/employer-analytics'),
              ),
              _buildQuickActionItem(
                context,
                icon: HeroIcons.calendar,
                label: 'Interviews',
                color: Colors.teal,
                onTap: () => Get.toNamed<dynamic>('/interview-management'),
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

  /// Build loading state for applicant cards
  Widget _buildLoadingApplicantCards() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
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

  /// Get the appropriate color for an application status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'reviewed':
        return Colors.orange;
      case 'interview':
        return Colors.purple;
      case 'offer':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
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
