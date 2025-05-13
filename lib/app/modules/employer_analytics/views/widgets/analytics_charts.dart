import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/employer_analytics/views/widgets/analytics_charts_part2.dart';

/// Line chart widget for analytics
class AnalyticsLineChart extends StatelessWidget {
  /// Constructor
  const AnalyticsLineChart({
    required this.data,
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  /// Chart data (x-axis labels and y-axis values)
  final Map<String, int> data;

  /// Chart title
  final String title;

  /// Chart subtitle
  final String subtitle;

  /// Chart color
  final Color color;

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
            color: Colors.black.withAlpha(13), // 0.05 * 255 ≈ 13
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
                      color: theme.textTheme.bodySmall?.color
                          ?.withAlpha(179), // 0.7 * 255 ≈ 179,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withAlpha(26), // 0.1 * 255 ≈ 26
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: HeroIcon(
                  HeroIcons.chartBar,
                  style: HeroIconStyle.solid,
                  color: color,
                  size: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: _LineChartWidget(
              data: data,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Line chart widget implementation
class _LineChartWidget extends StatelessWidget {
  const _LineChartWidget({
    required this.data,
    required this.color,
  });

  final Map<String, int> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // For a real app, we would use a proper chart library like fl_chart
    // For now, we'll use a simplified custom implementation
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _LineChartPainter(
              data: data,
              color: color,
              isDarkMode: isDarkMode,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: data.keys.map((label) {
            return Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color
                    ?.withAlpha(179), // 0.7 * 255 ≈ 179,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Custom painter for line chart
class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.data,
    required this.color,
    required this.isDarkMode,
  });

  final Map<String, int> data;
  final Color color;
  final bool isDarkMode;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final fillPaint = Paint()
      ..color = color.withAlpha(51) // 0.2 * 255 ≈ 51
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dotStrokePaint = Paint()
      ..color = isDarkMode ? Colors.grey[850]! : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final fillPath = Path();

    final values = data.values.toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    const minValue = 0.0; // Assuming min value is 0

    final xStep = size.width / (data.length - 1);
    final yStep = size.height / (maxValue - minValue);

    var firstPoint = true;
    var i = 0;

    for (final value in values) {
      final x = i * xStep;
      final y = size.height - (value - minValue) * yStep;

      if (firstPoint) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
        firstPoint = false;
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw dots at each data point
      canvas
        ..drawCircle(Offset(x, y), 5, dotPaint)
        ..drawCircle(Offset(x, y), 5, dotStrokePaint);

      i++;
    }

    // Complete the fill path
    fillPath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Draw the fill and the line
    canvas
      ..drawPath(fillPath, fillPaint)
      ..drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Bar chart widget for analytics
class AnalyticsBarChart extends StatelessWidget {
  /// Constructor
  const AnalyticsBarChart({
    required this.data,
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  /// Chart data (x-axis labels and y-axis values)
  final Map<String, int> data;

  /// Chart title
  final String title;

  /// Chart subtitle
  final String subtitle;

  /// Chart color
  final Color color;

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
            color: Colors.black.withAlpha(13), // 0.05 * 255 ≈ 13
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
                      color: theme.textTheme.bodySmall?.color
                          ?.withAlpha(179), // 0.7 * 255 ≈ 179,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withAlpha(26), // 0.1 * 255 ≈ 26
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: HeroIcon(
                  HeroIcons.chartBar,
                  style: HeroIconStyle.solid,
                  color: color,
                  size: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: BarChartWidget(
              data: data,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
