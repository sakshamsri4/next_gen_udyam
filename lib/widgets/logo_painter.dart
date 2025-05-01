import 'package:flutter/material.dart';

/// A custom painter that draws the NextGen logo.
class LogoPainter extends CustomPainter {
  /// Creates a LogoPainter.
  ///
  /// The [primaryColor] and [secondaryColor] parameters are required.
  const LogoPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  /// The primary color of the logo.
  final Color primaryColor;

  /// The secondary color of the logo.
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Draw the text "NextGen"
    final titlePainter = TextPainter(
      text: TextSpan(
        text: 'NextGen',
        style: TextStyle(
          color: primaryColor,
          fontSize: width * 0.2,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    final titleOffset = Offset(
      (width - titlePainter.width) / 2,
      height * 0.3,
    );
    titlePainter.paint(canvas, titleOffset);

    // Draw the bird silhouette
    final birdPath = Path()

      // Starting point at the left
      ..moveTo(width * 0.3, height * 0.6)

      // Body curve
      ..quadraticBezierTo(
        width * 0.4,
        height * 0.5,
        width * 0.5,
        height * 0.55,
      )

      // Wing up
      ..quadraticBezierTo(
        width * 0.6,
        height * 0.45,
        width * 0.7,
        height * 0.5,
      )

      // Head and beak
      ..quadraticBezierTo(
        width * 0.8,
        height * 0.55,
        width * 0.9,
        height * 0.5,
      )

      // Lower wing
      ..quadraticBezierTo(
        width * 0.7,
        height * 0.7,
        width * 0.5,
        height * 0.65,
      )

      // Tail
      ..quadraticBezierTo(
        width * 0.4,
        height * 0.7,
        width * 0.3,
        height * 0.6,
      );

    // Draw the bird with a gradient
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(birdPath, paint);

    // Draw the tagline
    final taglinePainter = TextPainter(
      text: TextSpan(
        text: 'Fly High With Us',
        style: TextStyle(
          color: primaryColor,
          fontSize: width * 0.08,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    final taglineOffset = Offset(
      (width - taglinePainter.width) / 2,
      height * 0.8,
    );
    taglinePainter.paint(canvas, taglineOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is LogoPainter &&
        (oldDelegate.primaryColor != primaryColor ||
            oldDelegate.secondaryColor != secondaryColor);
  }
}
