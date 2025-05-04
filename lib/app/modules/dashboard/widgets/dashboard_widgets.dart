import 'package:flutter/material.dart';

/// Simple line chart widget
class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({
    required this.color,
    required this.value,
    super.key,
  });

  final Color color;
  final int value;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChartPainter(
        color: color,
        value: value,
      ),
      size: const Size(double.infinity, 40),
    );
  }
}

/// Custom painter for the line chart
class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.color,
    required this.value,
  });

  final Color color;
  final int value;

  @override
  void paint(Canvas canvas, Size size) {
    final random = DateTime.now().millisecondsSinceEpoch;
    final points = <Offset>[];

    // Generate random points
    for (var i = 0; i < 7; i++) {
      final x = size.width * i / 6;
      final y = size.height -
          (size.height * (((random >> (i * 4)) & 0xF) / 15.0) * 0.8);
      points.add(Offset(x, y));
    }

    // Draw filled area
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];

      // Use quadratic bezier for smooth curve
      final controlX = (p0.dx + p1.dx) / 2;
      path.quadraticBezierTo(controlX, p0.dy, p1.dx, p1.dy);
    }

    path
      ..lineTo(size.width, size.height)
      ..close();

    // Fill the area
    final fillPaint = Paint()
      ..color = color.withAlpha(25) // Using withAlpha instead of withOpacity
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // Draw the line
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];

      // Use quadratic bezier for smooth curve
      final controlX = (p0.dx + p1.dx) / 2;
      linePath.quadraticBezierTo(controlX, p0.dy, p1.dx, p1.dy);
    }

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
            color: Colors.black.withAlpha(25),
            offset: Offset(depth, depth),
            blurRadius: depth,
          ),
        ],
      ),
      child: child,
    );
  }
}
