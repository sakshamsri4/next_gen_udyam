import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:neopop/neopop.dart' hide NeoPopCard;
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/widgets/email_verification_banner.dart';
import 'package:next_gen/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:next_gen/app/modules/dashboard/views/employer_dashboard_view.dart';
import 'package:next_gen/app/modules/dashboard/widgets/dashboard_widgets.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
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
  late final AuthController authController;

  // Create a unique scaffold key for this view
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    try {
      // Get the controllers in a safe way with try-catch blocks

      // 1. First get or register AuthController
      try {
        if (Get.isRegistered<AuthController>()) {
          authController = Get.find<AuthController>();
        } else {
          // Register AuthController if not already registered
          authController = Get.put(AuthController(), permanent: true);
        }
        // Refresh user data
        authController.refreshUser();
      } catch (e) {
        debugPrint('Error initializing AuthController: $e');
        // Create a new instance as fallback
        authController = Get.put(AuthController(), permanent: true);
      }

      // 2. Then get or register NavigationController
      try {
        if (Get.isRegistered<NavigationController>()) {
          navigationController = Get.find<NavigationController>();
        } else {
          navigationController =
              Get.put(NavigationController(), permanent: true);
        }
      } catch (e) {
        debugPrint('Error initializing NavigationController: $e');
        // Create a new instance as fallback
        navigationController = Get.put(NavigationController(), permanent: true);
      }

      // 3. Finally get the DashboardController
      try {
        controller = Get.find<DashboardController>();
      } catch (e) {
        debugPrint('Error finding DashboardController: $e');
        // Create a new instance as fallback
        controller = Get.put(DashboardController());
      }

      // Force reload user role in navigation controller
      // Use addPostFrameCallback instead of Future.delayed for better reliability
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          navigationController.reloadUserRole();
        } catch (e) {
          debugPrint('Error reloading user role: $e');
        }
      });
    } catch (e, stack) {
      debugPrint('Error in DashboardView.initState: $e');
      debugPrint('Stack trace: $stack');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    try {
      // Safely update the navigation index
      // Use addPostFrameCallback instead of Future.microtask for better reliability
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // First check if the controller is still valid and the widget is mounted
          if (mounted && Get.isRegistered<NavigationController>()) {
            // Use updateIndexFromRoute instead of directly modifying the value
            navigationController.updateIndexFromRoute(Routes.dashboard);
          }
        } catch (e) {
          debugPrint('Error updating navigation index: $e');
        }
      });
    } catch (e) {
      debugPrint('Error in didChangeDependencies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use GetBuilder instead of Obx to avoid nesting reactive widgets
    return GetBuilder<NavigationController>(
      builder: (navController) {
        final userRole = navController.userRole.value;

        // If user is an employer, show the employer dashboard view
        if (userRole == UserType.employer) {
          return const EmployerDashboardView();
        }

        // AuthController is already safely registered in initState
        // No need to call Get.find<AuthController>() here

        // Otherwise, show the default dashboard view
        return Scaffold(
          key: _scaffoldKey,
          drawer: const CustomDrawer(),
          bottomNavigationBar: const UnifiedBottomNav(),
          appBar: AppBar(
            title: const Text('Automotive Jobs Dashboard'),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: const HeroIcon(HeroIcons.bars3),
              onPressed: () => navigationController.toggleDrawer(_scaffoldKey),
            ),
            actions: [
              // Profile button
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildProfileButton(theme, controller),
              ),
            ],
          ),
          body: Column(
            children: [
              // Email verification banner - use GetBuilder instead of Obx
              GetBuilder<AuthController>(
                builder: (authCtrl) {
                  final user = authCtrl.user.value;

                  // Only show banner if user exists, email is not verified, and banner is visible
                  if (user != null &&
                      !user.emailVerified &&
                      authCtrl.isVerificationBannerVisible.value) {
                    return EmailVerificationBanner(
                      onResendPressed: authCtrl.sendEmailVerification,
                      onDismissed: authCtrl.toggleVerificationBanner,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Main content
              Expanded(
                child: ResponsiveBuilder(
                  builder: (context, sizingInformation) {
                    // Determine if we're on a mobile device
                    final isMobile = sizingInformation.deviceScreenType ==
                        DeviceScreenType.mobile;

                    return RefreshIndicator(
                      onRefresh: controller.refreshDashboard,
                      // Use GetBuilder instead of Obx to avoid nesting reactive widgets
                      child: GetBuilder<DashboardController>(
                        builder: (dashCtrl) {
                          // Use a local variable to access the loading state
                          final isLoading = dashCtrl.isLoading.value;

                          return isLoading
                              ? _buildLoadingState(isMobile)
                              : SingleChildScrollView(
                                  // Always use physics to ensure proper scrolling behavior
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding:
                                      EdgeInsets.all(isMobile ? 16.0 : 24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Welcome message
                                      _buildWelcomeSection(
                                        theme,
                                        isMobile,
                                        controller,
                                      ),
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

                                      // Sign out button removed - already available in drawer
                                    ],
                                  ),
                                );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build the profile button in the app bar
  Widget _buildProfileButton(ThemeData theme, DashboardController controller) {
    final user = controller.user.value;
    return user != null
        ? GestureDetector(
            onTap: () {
              // Navigate to profile page
              Get.toNamed<dynamic>('/profile');
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primary.withAlpha(50),
              backgroundImage: user.photoURL != null
                  ? CachedNetworkImageProvider(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? Text(
                      (user.displayName ?? '').isNotEmpty
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
  }

  /// Build the welcome section with user greeting
  Widget _buildWelcomeSection(
    ThemeData theme,
    bool isMobile,
    DashboardController controller,
  ) {
    final greeting = _getGreeting();
    final user = controller.user.value;
    final name = user?.displayName?.split(' ').first ?? 'there';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(178),
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
          "Here's your automotive career dashboard",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(178),
          ),
        ),
      ],
    );
  }

  /// Build quick action buttons for common tasks
  Widget _buildQuickActionButtons(
    ThemeData theme,
    bool isMobile,
  ) {
    final buttonWidth = isMobile ? 150.0 : 200.0;
    const buttonHeight = 60.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Automotive Career Actions',
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
                () => Get.toNamed<dynamic>(Routes.jobs),
              ),
              const SizedBox(width: 16),
              _buildQuickActionButton(
                theme,
                'My Applications',
                FontAwesomeIcons.fileCircleCheck,
                Colors.green,
                buttonWidth,
                buttonHeight,
                () => Get.toNamed<dynamic>(Routes.applications),
              ),
              const SizedBox(width: 16),
              _buildQuickActionButton(
                theme,
                'Skill Assessment',
                FontAwesomeIcons.gears,
                Colors.orange,
                buttonWidth,
                buttonHeight,
                () => Get.toNamed<dynamic>('/skills/assessment'),
              ),
              const SizedBox(width: 16),
              _buildQuickActionButton(
                theme,
                'Auto Resume',
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
        color: color.withAlpha(76),
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
  Widget _buildStatisticsSection(
    ThemeData theme,
    bool isMobile,
    DashboardController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Automotive Industry Metrics',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate the width of each card based on available width
            final cardWidth = isMobile
                ? constraints.maxWidth
                : (constraints.maxWidth / 2) - 8;

            final stats = controller.jobStatistics;
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
        ),
      ],
    );
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stat.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(178),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: stat.isPositive
                        ? Colors.green.withAlpha(25)
                        : Colors.red.withAlpha(25),
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
              child: SimpleLineChart(
                color: stat.color,
                value: stat.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the recent activity section
  ///
  /// Note: This section previously caused a layout overflow error (99418 pixels on the bottom).
  /// The issue was fixed by:
  /// 1. Reducing the maxHeight constraint from 300 to 250
  /// 2. Limiting the number of items to 3 instead of 4
  /// 3. Using NeverScrollableScrollPhysics to prevent scrolling within this list
  ///
  /// If you need to show more items, consider implementing a "View All" button
  /// that navigates to a dedicated screen for all activities.
  Widget _buildRecentActivitySection(
    ThemeData theme,
    bool isMobile,
    DashboardController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Automotive Activity',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        NeoPopCard(
          color: theme.cardColor,
          child: ConstrainedBox(
            // Add a maximum height constraint to prevent overflow
            constraints: const BoxConstraints(
              maxHeight: 250, // Reduced from 300 to 250 to prevent overflow
            ),
            child: ListView.separated(
              shrinkWrap: true,
              // Use NeverScrollableScrollPhysics to prevent scrolling within this list
              // since it's inside a SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(),
              // Limit the number of items to prevent overflow - reduced from 4 to 3
              itemCount: controller.recentActivity.length > 3
                  ? 3
                  : controller.recentActivity.length,
              separatorBuilder: (context, index) => Divider(
                color: theme.dividerColor.withAlpha(25),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final activity = controller.recentActivity[index];
                return _buildActivityItem(theme, activity);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Build a single activity item
  Widget _buildActivityItem(ThemeData theme, ActivityItem activity) {
    final timeAgo = _getTimeAgo(activity.time);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: activity.color.withAlpha(25),
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
              color: theme.colorScheme.onSurface.withAlpha(127),
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

  // Sign out button method removed - functionality available in drawer

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
            // Note: Keep this height in sync with the maxHeight in _buildRecentActivitySection
            // to prevent layout overflow issues (reduced from 300 to 250)
            Container(
              width: double.infinity,
              height:
                  250, // Reduced from 300 to match the constraint in the actual widget
              color: Colors.white,
            ),
            SizedBox(height: isMobile ? 24.0 : 32.0),
            // Sign out button shimmer removed
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

  // No chart data generation needed - using custom chart implementation
}
