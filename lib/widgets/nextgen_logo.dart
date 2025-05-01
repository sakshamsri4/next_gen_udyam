import 'package:flutter/material.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/logo_painter.dart';

/// A widget that displays the NextGen logo with NeoPOP styling.
class NextGenLogo extends StatelessWidget {
  /// Creates a NextGenLogo widget.
  ///
  /// The [size] parameter determines the size of the logo.
  /// The [showTagline] parameter determines whether to show the tagline.
  const NextGenLogo({
    this.size = 150,
    this.showTagline = true,
    this.animated = false,
    super.key,
  });

  /// The size of the logo.
  final double size;

  /// Whether to show the tagline.
  final bool showTagline;

  /// Whether to animate the logo.
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on theme
    final primaryColor =
        isDarkMode ? AppTheme.brightElectricBlue : AppTheme.electricBlue;

    final secondaryColor = isDarkMode ? AppTheme.neonTeal : AppTheme.teal;

    final textColor = isDarkMode ? AppTheme.pureWhite : AppTheme.navyBlue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo container with shadow and glow effects
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withAlpha(40),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              if (isDarkMode)
                Container(
                  width: size * 0.9,
                  height: size * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primaryColor.withAlpha(50),
                        Colors.transparent,
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),

              // Logo image
              Image.asset(
                'assets/images/logo.png',
                width: size * 0.8,
                height: size * 0.8,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image asset is not found
                  return _buildFallbackLogo(
                    context,
                    primaryColor,
                    secondaryColor,
                    textColor,
                  );
                },
              ),
            ],
          ),
        ),

        // Tagline
        if (showTagline)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Fly High With Us',
              style: TextStyle(
                color: textColor,
                fontSize: size * 0.12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFallbackLogo(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
    Color textColor,
  ) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: LogoPainter(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      ),
    );
  }
}
