import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Job performance table widget
class JobPerformanceTable extends StatelessWidget {
  /// Constructor
  const JobPerformanceTable({
    required this.data,
    required this.title,
    required this.subtitle,
    super.key,
  });

  /// Table data
  final List<Map<String, dynamic>> data;

  /// Table title
  final String title;

  /// Table subtitle
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: RoleThemes.employerPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: HeroIcon(
                  HeroIcons.tableCells,
                  style: HeroIconStyle.solid,
                  color: RoleThemes.employerPrimary,
                  size: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildTable(context),
        ],
      ),
    );
  }

  /// Build the table
  Widget _buildTable(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Column(
      children: [
        // Table header
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey[800]
                : RoleThemes.employerPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              topRight: Radius.circular(8.r),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Job Title',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Views',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Apps',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Conv.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Table rows
        ...data.map((job) {
          final conversionRate = job['conversionRate'] as double;
          final conversionColor = _getConversionColor(conversionRate);

          return Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    job['jobTitle'] as String,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    (job['views'] as int).toString(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    (job['applications'] as int).toString(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: conversionColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${conversionRate.toStringAsFixed(1)}%',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: conversionColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// Get color based on conversion rate
  Color _getConversionColor(double rate) {
    if (rate >= 20) {
      return Colors.green;
    } else if (rate >= 15) {
      return Colors.teal;
    } else if (rate >= 10) {
      return Colors.blue;
    } else if (rate >= 5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
