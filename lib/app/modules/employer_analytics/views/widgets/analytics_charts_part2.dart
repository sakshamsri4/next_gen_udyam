import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Bar chart widget implementation
class BarChartWidget extends StatelessWidget {
  /// Constructor
  const BarChartWidget({
    required this.data,
    required this.color,
    super.key,
  });

  final Map<String, int> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // For a real app, we would use a proper chart library like fl_chart
    // For now, we'll use a simplified custom implementation
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _BarChartPainter(
              data: data,
              color: color,
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
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Custom painter for bar chart
class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.data,
    required this.color,
  });

  final Map<String, int> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final values = data.values.toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    const minValue = 0.0; // Assuming min value is 0

    final barWidth = size.width / data.length * 0.7;
    final spacing = size.width / data.length * 0.3;
    final yStep = size.height / (maxValue - minValue);

    var i = 0;

    for (final value in values) {
      final x = i * (barWidth + spacing) + spacing / 2;
      final y = size.height - (value - minValue) * yStep;

      final rect = Rect.fromLTWH(x, y, barWidth, size.height - y);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(4.r));

      canvas.drawRRect(rrect, paint);

      i++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Funnel chart widget for analytics
class AnalyticsFunnelChart extends StatelessWidget {
  /// Constructor
  const AnalyticsFunnelChart({
    required this.data,
    required this.title,
    required this.subtitle,
    super.key,
  });

  /// Chart data (stage labels and values)
  final Map<String, int> data;

  /// Chart title
  final String title;

  /// Chart subtitle
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
                  HeroIcons.funnel,
                  style: HeroIconStyle.solid,
                  color: RoleThemes.employerPrimary,
                  size: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 250.h,
            child: _FunnelChartWidget(data: data),
          ),
        ],
      ),
    );
  }
}

/// Funnel chart widget implementation
class _FunnelChartWidget extends StatelessWidget {
  const _FunnelChartWidget({
    required this.data,
  });

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final stages = data.keys.toList();
    final values = data.values.toList();
    final maxValue =
        values.first; // Assuming the first stage has the highest value

    return Row(
      children: [
        // Stage labels
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: stages.map((stage) {
            return Text(
              stage,
              style: theme.textTheme.bodyMedium,
            );
          }).toList(),
        ),
        SizedBox(width: 16.w),
        // Funnel chart
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _FunnelChartPainter(
              data: data,
              maxValue: maxValue,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        // Values
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: values.map((value) {
            return Text(
              value.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Custom painter for funnel chart
class _FunnelChartPainter extends CustomPainter {
  _FunnelChartPainter({
    required this.data,
    required this.maxValue,
  });

  final Map<String, int> data;
  final int maxValue;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final values = data.values.toList();
    final stages = values.length;
    final stageHeight = size.height / stages;

    // Define gradient colors
    final colors = [
      RoleThemes.employerPrimary,
      const Color(0xFF34D399), // Green-400
      const Color(0xFF6EE7B7), // Green-300
      const Color(0xFFA7F3D0), // Green-200
      const Color(0xFFD1FAE5), // Green-100
      const Color(0xFFECFDF5), // Green-50
    ];

    for (var i = 0; i < stages; i++) {
      final value = values[i];
      final widthRatio = value / maxValue;
      final topWidth = size.width * (i == 0 ? 1 : values[i - 1] / maxValue);
      final bottomWidth = size.width * widthRatio;
      final y = i * stageHeight;

      final paint = Paint()
        ..color = i < colors.length ? colors[i] : colors.last
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo((size.width - topWidth) / 2, y)
        ..lineTo((size.width + topWidth) / 2, y)
        ..lineTo((size.width + bottomWidth) / 2, y + stageHeight)
        ..lineTo((size.width - bottomWidth) / 2, y + stageHeight)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
