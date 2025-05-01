import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A custom loading indicator that follows NeoPOP design principles.
///
/// This widget creates a visually appealing loading animation with
/// customizable colors and sizes that match the app's design language.
class NeoPopLoadingIndicator extends StatefulWidget {
  /// Creates a NeoPopLoadingIndicator.
  ///
  /// The [size] parameter determines the size of the indicator.
  /// The [color] parameter determines the primary color of the indicator.
  /// The [secondaryColor] parameter determines the secondary color of the indicator.
  /// The [strokeWidth] parameter determines the width of the indicator's stroke.
  const NeoPopLoadingIndicator({
    this.size = 20.0,
    this.color,
    this.secondaryColor,
    this.strokeWidth = 2.0,
    super.key,
  });

  /// The size of the indicator.
  final double size;

  /// The primary color of the indicator.
  final Color? color;

  /// The secondary color of the indicator.
  final Color? secondaryColor;

  /// The width of the indicator's stroke.
  final double strokeWidth;

  @override
  State<NeoPopLoadingIndicator> createState() => _NeoPopLoadingIndicatorState();
}

class _NeoPopLoadingIndicatorState extends State<NeoPopLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = widget.color ??
        (isDarkMode ? AppTheme.brightElectricBlue : AppTheme.electricBlue);
    final secondaryColor = widget.secondaryColor ??
        (isDarkMode ? AppTheme.neonPink : AppTheme.coralRed);

    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _NeoPopLoadingPainter(
              animation: _controller,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _NeoPopLoadingPainter extends CustomPainter {
  _NeoPopLoadingPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;

    // Create gradient shader
    final shader = SweepGradient(
      colors: [primaryColor, secondaryColor, primaryColor],
      stops: const [0.0, 0.5, 1.0],
      transform: GradientRotation(animation.value * 2 * math.pi),
    ).createShader(rect);

    // Create path for the arc
    final path = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
      );

    // Draw the background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = primaryColor.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Draw the animated arc
    final arcPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Rotate the canvas for the animation
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animation.value * 2 * math.pi);
    canvas.translate(-center.dx, -center.dy);

    // Draw the arc with varying sweep angle for animation effect
    final sweepAngle = math.sin(animation.value * math.pi) * math.pi + math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + animation.value * 4 * math.pi,
      sweepAngle,
      false,
      arcPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_NeoPopLoadingPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
