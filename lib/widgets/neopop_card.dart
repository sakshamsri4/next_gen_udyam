import 'package:flutter/material.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A custom card widget using NeoPOP design.
///
/// This widget provides a consistent styling for cards in the app
/// with NeoPOP-inspired design elements.
class NeoPopCard extends StatefulWidget {
  /// Creates a NeoPopCard.
  ///
  /// The [child] parameter is required.
  const NeoPopCard({
    required this.child,
    this.color,
    this.borderColor,
    this.elevation = 8,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.onTap,
    this.width,
    this.height,
    this.gradient,
    this.shimmer = false,
    super.key,
  });

  /// The widget to display inside the card.
  final Widget child;

  /// The background color of the card.
  final Color? color;

  /// The border color of the card.
  final Color? borderColor;

  /// The elevation of the card.
  final double elevation;

  /// The border radius of the card.
  final double borderRadius;

  /// The padding inside the card.
  final EdgeInsetsGeometry padding;

  /// The margin around the card.
  final EdgeInsetsGeometry margin;

  /// The callback that is called when the card is tapped.
  final VoidCallback? onTap;

  /// The width of the card.
  final double? width;

  /// The height of the card.
  final double? height;

  /// The gradient to apply to the card background.
  final Gradient? gradient;

  /// Whether to apply a shimmer effect to the card.
  final bool shimmer;

  @override
  State<NeoPopCard> createState() => _NeoPopCardState();
}

class _NeoPopCardState extends State<NeoPopCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation * 0.5,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse().then((_) => widget.onTap?.call());
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on theme
    final Color cardColor =
        widget.color ?? (isDarkMode ? AppTheme.darkSurface2 : Colors.white);

    final Color cardBorderColor = widget.borderColor ??
        (isDarkMode ? AppTheme.darkSurface3 : AppTheme.lightGray);

    final Color shadowColor =
        isDarkMode ? Colors.black.withAlpha(100) : Colors.grey.withAlpha(50);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              decoration: BoxDecoration(
                color: widget.gradient != null ? null : cardColor,
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: cardBorderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius - 1),
                child: widget.shimmer
                    ? _ShimmerEffect(
                        child: Padding(
                        padding: widget.padding,
                        child: widget.child,
                      ))
                    : Padding(
                        padding: widget.padding,
                        child: widget.child,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect({required this.child});

  final Widget child;

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                isDarkMode ? Colors.white24 : Colors.black12,
                isDarkMode ? Colors.white : Colors.white,
                isDarkMode ? Colors.white24 : Colors.black12,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_shimmerAnimation.value - 1, 0),
              end: Alignment(_shimmerAnimation.value, 0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
