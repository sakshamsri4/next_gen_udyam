import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

/// Dashboard view with job statistics and recent activity
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Profile button
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Obx(() {
              final user = controller.user.value;
              return user != null
                  ? GestureDetector(
                      onTap: () {
                        // Navigate to profile page
                        Get.toNamed<dynamic>('/profile');
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.2),
                        backgroundImage: user.photoURL != null
                            ? CachedNetworkImageProvider(user.photoURL!)
                            : null,
                        child: user.photoURL == null
                            ? Text(
                                user.displayName?.isNotEmpty == true
                                    ? user.displayName![0].toUpperCase()
                                    : user.email != null
                                        ? user.email![0].toUpperCase()
                                        : '?',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: () {
                        // Navigate to login page
                        Get.toNamed<dynamic>('/login');
                      },
                    );
            }),
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
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState(isMobile);
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome message
                    _buildWelcomeSection(theme, isMobile),
                    SizedBox(height: isMobile ? 16.0 : 24.0),

                    // Quick action buttons
                    _buildQuickActionButtons(theme, isMobile),
                    SizedBox(height: isMobile ? 24.0 : 32.0),

                    // Statistics section
                    _buildStatisticsSection(theme, isMobile),
                    SizedBox(height: isMobile ? 24.0 : 32.0),

                    // Recent activity section
                    _buildRecentActivitySection(theme, isMobile),
                    SizedBox(height: isMobile ? 16.0 : 24.0),

                    // Sign out button
                    _buildSignOutButton(theme, isMobile),
                    SizedBox(height: isMobile ? 16.0 : 24.0),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  /// Build the welcome section with user greeting
  Widget _buildWelcomeSection(ThemeData theme, bool isMobile) {
    return Obx(() {
      final user = controller.user.value;
      final greeting = _getGreeting();
      final name = user?.displayName?.split(' ').first ?? 'there';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hello, $name!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Here's your job search overview",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      );
    });
  }

  /// Build quick action buttons for common tasks
  Widget _buildQuickActionButtons(ThemeData theme, bool isMobile) {
    final buttonWidth = isMobile ? 150.0 : 200.0;
    const buttonHeight = 60.0;

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
              _buildQuickActionButton(
                theme,
                'Search Jobs',
                FontAwesomeIcons.magnifyingGlass,
                Colors.blue,
                buttonWidth,
                buttonHeight,
                () => Get.toNamed<dynamic>('/jobs/search'),
              ),
              const SizedBox(width: 16),
              _buildQuickActionButton(
                theme,
                'New Application',
                FontAwesomeIcons.fileCirclePlus,
                Colors.green,
                buttonWidth,
                buttonHeight,
                () => Get.toNamed<dynamic>('/applications/new'),
              ),
              const SizedBox(width: 16),
              _buildQuickActionButton(
                theme,
                'Upcoming Interviews',
                FontAwesomeIcons.calendarCheck,
                Colors.orange,
                buttonWidth,
                buttonHeight,
                () => Get.toNamed<dynamic>('/interviews'),
              ),
              const SizedBox(width: 16),
              _buildQuickActionButton(
                theme,
                'My Resume',
                FontAwesomeIcons.fileLines,
                Colors.purple,
                buttonWidth,
                buttonHeight,
                () => Get.toNamed<dynamic>('/resume'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a single quick action button
  Widget _buildQuickActionButton(
    ThemeData theme,
    String label,
    IconData icon,
    Color color,
    double width,
    double height,
    VoidCallback onTap,
  ) {
    return NeoPopButton(
      color: theme.cardColor,
      onTapUp: onTap,
      onTapDown: () {},
      border: Border.all(
        color: color.withOpacity(0.3),
      ),
      depth: 5,
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the statistics section with job statistics cards
  Widget _buildStatisticsSection(ThemeData theme, bool isMobile) {
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
        Obx(() {
          final stats = controller.jobStatistics;
          return LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the width of each card based on available width
              final cardWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth / 2) - 8;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: stats.map((stat) {
                  return SizedBox(
                    width: cardWidth,
                    child: _buildStatisticCard(theme, stat),
                  );
                }).toList(),
              );
            },
          );
        }),
      ],
    );
  }

  /// Build a single statistic card
  Widget _buildStatisticCard(ThemeData theme, JobStatistic stat) {
    return NeoPopCard(
      color: theme.cardColor,
      border: Border.all(
        color: stat.color.withOpacity(0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stat.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: stat.isPositive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        stat.isPositive
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 12,
                        color: stat.isPositive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${stat.change}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: stat.isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${stat.value}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateRandomSpots(stat.value),
                      isCurved: true,
                      color: stat.color,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: stat.color.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(enabled: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the recent activity section
  Widget _buildRecentActivitySection(ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final activities = controller.recentActivity;
          return NeoPopCard(
            color: theme.cardColor,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => Divider(
                color: theme.dividerColor.withOpacity(0.1),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(theme, activity);
              },
            ),
          );
        }),
      ],
    );
  }

  /// Build a single activity item
  Widget _buildActivityItem(ThemeData theme, ActivityItem activity) {
    final timeAgo = _getTimeAgo(activity.time);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: activity.color.withOpacity(0.1),
        child: Icon(
          activity.icon,
          color: activity.color,
          size: 20,
        ),
      ),
      title: Text(
        activity.title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            activity.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            timeAgo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    );
  }

  /// Build the sign out button
  Widget _buildSignOutButton(ThemeData theme, bool isMobile) {
    return Center(
      child: Obx(() {
        final isLoading = controller.isSignOutLoading.value;
        return NeoPopButton(
          color: theme.colorScheme.error.withOpacity(0.8),
          onTapUp: isLoading ? null : controller.signOut,
          onTapDown: isLoading ? null : () {},
          border: Border.all(
            color: theme.colorScheme.error,
          ),
          depth: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onError,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.logout,
                        color: theme.colorScheme.onError,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  /// Build the loading state with shimmer effect
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
              width: 250,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: isMobile ? 24.0 : 32.0),

            // Quick actions shimmer
            Container(
              width: 150,
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
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: isMobile ? 150 : 200,
                      height: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isMobile ? 24.0 : 32.0),

            // Statistics shimmer
            Container(
              width: 150,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                4,
                (index) => Container(
                  width: isMobile ? double.infinity : 200,
                  height: 150,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 24.0 : 32.0),

            // Recent activity shimmer
            Container(
              width: 150,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
            ),
            SizedBox(height: isMobile ? 24.0 : 32.0),

            // Sign out button shimmer
            Center(
              child: Container(
                width: 120,
                height: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get the appropriate greeting based on time of day
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
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Generate random spots for the chart
  List<FlSpot> _generateRandomSpots(int value) {
    final random = DateTime.now().millisecondsSinceEpoch;
    final spots = <FlSpot>[];

    for (var i = 0; i < 7; i++) {
      final y = (((random >> (i * 4)) & 0xF) / 15.0) * value * 1.5;
      spots.add(FlSpot(i.toDouble(), y));
    }

    return spots;
  }
}

/// Custom NeoPOP card widget
class NeoPopCard extends StatelessWidget {
  const NeoPopCard({
    required this.child,
    required this.color,
    super.key,
    this.border,
    this.depth = 5,
  });
  final Widget child;
  final Color color;
  final Border? border;
  final double depth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(depth, depth),
            blurRadius: depth,
          ),
        ],
      ),
      child: child,
    );
  }
}
