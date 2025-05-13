import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/employer_analytics/controllers/employer_analytics_controller.dart';
import 'package:next_gen/app/modules/employer_analytics/views/widgets/analytics_charts.dart';
import 'package:next_gen/app/modules/employer_analytics/views/widgets/analytics_charts_part2.dart';
import 'package:next_gen/app/modules/employer_analytics/views/widgets/job_performance_table.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Employer analytics view
class EmployerAnalyticsView extends GetView<EmployerAnalyticsController> {
  /// Constructor
  const EmployerAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics Dashboard',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Export button
          Obx(() {
            return IconButton(
              icon: controller.isExporting.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const HeroIcon(HeroIcons.arrowDownTray),
              onPressed: controller.isExporting.value
                  ? null
                  : () => controller.exportData(),
              tooltip: 'Export Data',
            );
          }),
        ],
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const UnifiedBottomNav(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error.value}',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period selector
                  _buildPeriodSelector(context),
                  SizedBox(height: 24.h),

                  // Tab bar
                  _buildTabBar(context),
                  SizedBox(height: 24.h),

                  // Tab content
                  SizedBox(
                    height: 600.h, // Fixed height for tab content
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        // Overview tab
                        _buildOverviewTab(context),

                        // Job Performance tab
                        _buildJobPerformanceTab(context),

                        // Applicant Funnel tab
                        _buildApplicantFunnelTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Build period selector
  Widget _buildPeriodSelector(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    return Obx(() {
      final selectedPeriod = controller.selectedPeriod.value;

      return Row(
        children: [
          Text(
            'Time Period:',
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(width: 16.w),
          _buildPeriodButton(
            context,
            'Daily',
            'daily',
            selectedPeriod,
            primaryColor,
          ),
          SizedBox(width: 8.w),
          _buildPeriodButton(
            context,
            'Weekly',
            'weekly',
            selectedPeriod,
            primaryColor,
          ),
          SizedBox(width: 8.w),
          _buildPeriodButton(
            context,
            'Monthly',
            'monthly',
            selectedPeriod,
            primaryColor,
          ),
        ],
      );
    });
  }

  /// Build period button
  Widget _buildPeriodButton(
    BuildContext context,
    String label,
    String value,
    String selectedValue,
    Color primaryColor,
  ) {
    final isSelected = value == selectedValue;

    return ElevatedButton(
      onPressed: () => controller.changePeriod(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        elevation: isSelected ? 2 : 0,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(label),
    );
  }

  /// Build tab bar
  Widget _buildTabBar(BuildContext context) {
    const primaryColor = RoleThemes.employerPrimary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: controller.tabController,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: primaryColor,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Job Performance'),
          Tab(text: 'Applicant Funnel'),
        ],
      ),
    );
  }

  /// Build overview tab
  Widget _buildOverviewTab(BuildContext context) {
    return Obx(() {
      final data = controller.analyticsData.value;
      if (data == null) {
        return const Center(child: Text('No data available'));
      }

      return Column(
        children: [
          // Job views chart
          AnalyticsLineChart(
            data: data.jobViews,
            title: 'Job Views',
            subtitle: 'Total views over time',
            color: RoleThemes.employerPrimary,
          ),
          SizedBox(height: 24.h),

          // Applications chart
          AnalyticsBarChart(
            data: data.applications,
            title: 'Applications',
            subtitle: 'Total applications over time',
            color: Colors.purple,
          ),
        ],
      );
    });
  }

  /// Build job performance tab
  Widget _buildJobPerformanceTab(BuildContext context) {
    return Obx(() {
      return JobPerformanceTable(
        data: controller.jobPerformance,
        title: 'Job Performance',
        subtitle: 'Performance metrics for all jobs',
      );
    });
  }

  /// Build applicant funnel tab
  Widget _buildApplicantFunnelTab(BuildContext context) {
    return Obx(() {
      return AnalyticsFunnelChart(
        data: controller.applicantFunnel,
        title: 'Applicant Funnel',
        subtitle: 'Conversion through hiring stages',
      );
    });
  }
}
