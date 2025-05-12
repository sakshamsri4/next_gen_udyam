import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neopop/neopop.dart' hide NeoPopCard;
import 'package:next_gen/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:next_gen/app/modules/dashboard/widgets/dashboard_widgets.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_bottom_nav.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

/// Dashboard view with job statistics and recent activity
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late final DashboardController controller;
  late final NavigationController navigationController;

  @override
  void initState() {
    super.initState();
    // Get the controllers
    controller = Get.find<DashboardController>();
    navigationController = Get.find<NavigationController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the selected index to the Dashboard tab (index 0)
    // This is safer than using initState with a direct value assignment
    navigationController.selectedIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: const RoleBasedBottomNav(),
      appBar: AppBar(
        title: const Text('Automotive Jobs Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Profile button
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildProfileButton(theme, controller),
          ),
        ],
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          // Determine if we're on a mobile device
          final isMobile =
              sizingInformation.deviceScreenType == DeviceScreenType.mobile;

          return RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            child: controller.isLoading.value
                ? _buildLoadingState(isMobile)
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome message
                        _buildWelcomeSection(theme, isMobile, controller),
                        SizedBox(height: isMobile ? 16.0 : 24.0),

                        // Quick action buttons
                        _buildQuickActionButtons(theme, isMobile),
                        SizedBox(height: isMobile ? 24.0 : 32.0),

                        // Statistics section
                        _buildStatisticsSection(
                          theme,
                          isMobile,
                          controller,
                        ),
                        SizedBox(height: isMobile ? 24.0 : 32.0),

                        // Recent activity section
                        _buildRecentActivitySection(
                          theme,
                          isMobile,
                          controller,
                        ),
                        SizedBox(height: isMobile ? 16.0 : 24.0),

                        // Sign out button
                        _buildSignOutButton(theme, isMobile, controller),
                        SizedBox(height: isMobile ? 16.0 : 24.0),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  /// Build the profile button in the app bar
  Widget _buildProfileButton(ThemeData theme, DashboardController controller) {
    return Obx(() {
      final user = controller.user.value;
      if (user == null) {
        return const SizedBox.shrink();
      }

      final photoUrl = user.photoURL;
      final displayName = user.displayName ?? 'User';
      final email = user.email ?? '';

      return GestureDetector(
        onTap: () => Get.toNamed<dynamic>(Routes.profile),
        child: CircleAvatar(
          radius: 18,
          backgroundColor:
              theme.colorScheme.primary.withAlpha(51), // 0.2 * 255 = 51
          backgroundImage: photoUrl != null && photoUrl.isNotEmpty
              ? CachedNetworkImageProvider(photoUrl) as ImageProvider
              : null,
          child: photoUrl == null || photoUrl.isEmpty
              ? Text(
                  displayName.isNotEmpty
                      ? displayName[0].toUpperCase()
                      : email.isNotEmpty
                          ? email[0].toUpperCase()
                          : 'U',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
      );
    });
  }

  /// Build the welcome section with user greeting
  Widget _buildWelcomeSection(
    ThemeData theme,
    bool isMobile,
    DashboardController controller,
  ) {
    return Obx(() {
      final user = controller.user.value;
      final displayName = user?.displayName ?? 'User';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: theme.textTheme.titleMedium?.copyWith(
              color:
                  theme.colorScheme.onSurface.withAlpha(178), // 0.7 * 255 = 178
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayName,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Here's your automotive job dashboard",
            style: theme.textTheme.bodyLarge?.copyWith(
              color:
                  theme.colorScheme.onSurface.withAlpha(178), // 0.7 * 255 = 178
            ),
          ),
        ],
      );
    });
  }

  /// Build the quick action buttons section
  Widget _buildQuickActionButtons(ThemeData theme, bool isMobile) {
    final buttonWidth = isMobile ? 150.0 : 200.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildActionButton(
                theme,
                'Find Jobs',
                FontAwesomeIcons.magnifyingGlass,
                () => Get.toNamed<dynamic>(Routes.search),
                buttonWidth,
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                theme,
                'My Resume',
                FontAwesomeIcons.fileLines,
                () => Get.toNamed<dynamic>(Routes.resume),
                buttonWidth,
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                theme,
                'My Profile',
                FontAwesomeIcons.user,
                () => Get.toNamed<dynamic>(Routes.profile),
                buttonWidth,
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                theme,
                'Job Alerts',
                FontAwesomeIcons.bell,
                () {
                  Get.snackbar(
                    'Coming Soon',
                    'Job alerts feature is under development',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                buttonWidth,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a single action button
  Widget _buildActionButton(
    ThemeData theme,
    String label,
    IconData icon,
    VoidCallback onTap,
    double width,
  ) {
    return NeoPopButton(
      color: theme.colorScheme.primary,
      onTapUp: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the statistics section
  Widget _buildStatisticsSection(
    ThemeData theme,
    bool isMobile,
    DashboardController controller,
  ) {
    return Obx(() {
      final stats = controller.jobStatistics;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Statistics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.5 : 1.8,
            children:
                stats.map((stat) => _buildStatisticCard(theme, stat)).toList(),
          ),
        ],
      );
    });
  }

  /// Build a single statistic card
  Widget _buildStatisticCard(ThemeData theme, JobStatistic stat) {
    return NeoPopCard(
      color: theme.cardColor,
      border: Border.all(
        color: stat.color.withAlpha(76),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  stat.icon,
                  color: stat.color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  stat.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  stat.value.toString(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: stat.color,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  stat.unit,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withAlpha(178), // 0.7 * 255 = 178
                  ),
                ),
                if (stat.change != 0) ...[
                  const Spacer(),
                  _buildChangeIndicator(theme, stat.change.toDouble()),
                ],
              ],
            ),
            const SizedBox(height: 16),
            SimpleLineChart(
              color: stat.color,
              value: stat.value,
            ),
          ],
        ),
      ),
    );
  }

  /// Build change indicator with arrow
  Widget _buildChangeIndicator(ThemeData theme, double change) {
    final isPositive = change > 0;
    final color = isPositive ? Colors.green : Colors.red;
    final icon =
        isPositive ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          '${change.abs()}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Build the recent activity section
  Widget _buildRecentActivitySection(
    ThemeData theme,
    bool isMobile,
    DashboardController controller,
  ) {
    return Obx(() {
      final activities = controller.recentActivity;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'View all activities feature is under development',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          NeoPopCard(
            color: theme.cardColor,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => Divider(
                color: theme.dividerColor,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(theme, activity);
              },
            ),
          ),
        ],
      );
    });
  }

  /// Build a single activity item
  Widget _buildActivityItem(ThemeData theme, ActivityItem activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: activity.color.withAlpha(51), // 0.2 * 255 = 51
        child: Icon(
          activity.icon,
          color: activity.color,
          size: 20,
        ),
      ),
      title: Text(
        activity.title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        activity.description,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(178), // 0.7 * 255 = 178
        ),
      ),
      trailing: Text(
        _formatDateTime(activity.time),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(128), // 0.5 * 255 = 128
        ),
      ),
      onTap: () {
        Get.snackbar(
          'Activity Details',
          'Details for ${activity.title}',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// Build the sign out button
  Widget _buildSignOutButton(
    ThemeData theme,
    bool isMobile,
    DashboardController controller,
  ) {
    return Center(
      child: NeoPopButton(
        color: theme.colorScheme.error,
        onTapUp: controller.signOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Obx(() {
            return controller.isSignOutLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.rightFromBracket,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  /// Build loading state with shimmer effect
  Widget _buildLoadingState(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section shimmer
            Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: 250,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 32),

            // Quick actions shimmer
            Container(
              width: 120,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: index < 3 ? 16.0 : 0),
                    child: Container(
                      width: isMobile ? 150 : 200,
                      height: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Statistics shimmer
            Container(
              width: 120,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: isMobile ? 1 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 1.5 : 1.8,
              children: List.generate(
                4,
                (index) => Container(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Recent activity shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 24,
                  color: Colors.white,
                ),
                Container(
                  width: 60,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  /// Format date time for activity items
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
