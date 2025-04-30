import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:neopop/neopop.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A responsive NeoPOP button that adapts to different screen sizes and platforms.
///
/// This button combines NeoPOP styling with responsive design and platform-specific
/// adaptations to provide a consistent experience across Android, iOS, and web.
class ResponsiveNeoPopButton extends StatelessWidget {
  /// Creates a ResponsiveNeoPopButton.
  ///
  /// The [onTap], [child], and [color] parameters are required.
  const ResponsiveNeoPopButton({
    required this.onTap,
    required this.child,
    required this.color,
    this.onTapDown,
    this.depth,
    this.border,
    this.shimmer = false,
    this.parentColor = Colors.transparent,
    this.grandparentColor = Colors.transparent,
    this.buttonPosition = Position.fullBottom,
    this.animationDuration = const Duration(milliseconds: 50),
    this.enabled = true,
    this.disabledColor = Colors.grey,
    this.shadowColor,
    this.rightShadowColor,
    this.leftShadowColor,
    this.topShadowColor,
    this.bottomShadowColor,
    this.onLongPress,
    this.useAnimation = true,
    this.platformAware = true,
    super.key,
  });

  /// The callback that is called when the button is tapped.
  final VoidCallback onTap;

  /// The widget to display inside the button.
  final Widget child;

  /// The color of the button.
  final Color color;

  /// The callback that is called when the button is pressed down.
  final VoidCallback? onTapDown;

  /// The depth of the button's shadow.
  final double? depth;

  /// The border of the button.
  final Border? border;

  /// Whether to show a shimmer effect on the button.
  final bool shimmer;

  /// The color of the button's parent.
  final Color parentColor;

  /// The color of the button's grandparent.
  final Color grandparentColor;

  /// The position of the button.
  final Position buttonPosition;

  /// The duration of the button's animation.
  final Duration animationDuration;

  /// Whether the button is enabled.
  final bool enabled;

  /// The color of the button when it is disabled.
  final Color disabledColor;

  /// The color of the button's shadow.
  final Color? shadowColor;

  /// The color of the button's right shadow.
  final Color? rightShadowColor;

  /// The color of the button's left shadow.
  final Color? leftShadowColor;

  /// The color of the button's top shadow.
  final Color? topShadowColor;

  /// The color of the button's bottom shadow.
  final Color? bottomShadowColor;

  /// The callback that is called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether to use animations for the button.
  final bool useAnimation;

  /// Whether to adapt the button to the current platform.
  final bool platformAware;

  @override
  Widget build(BuildContext context) {
    // Get the device type to adapt the button's appearance
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Adjust depth based on screen size
        final effectiveDepth = _getEffectiveDepth(sizingInformation);

        // Create the base button
        Widget button = _buildNeoPopButton(context, effectiveDepth);

        // Apply platform-specific styling if needed
        if (platformAware) {
          button = _applyPlatformStyling(context, button);
        }

        // Apply animations if enabled
        if (useAnimation) {
          button = _applyAnimations(button);
        }

        return button;
      },
    );
  }

  /// Builds the base NeoPOP button with the given depth.
  Widget _buildNeoPopButton(BuildContext context, double effectiveDepth) {
    return NeoPopButton(
      color: color,
      onTapUp: enabled ? onTap : null,
      onTapDown: enabled ? (onTapDown ?? () {}) : null,
      onLongPress: enabled ? onLongPress : null,
      depth: effectiveDepth,
      border: border,
      parentColor: parentColor,
      grandparentColor: grandparentColor,
      buttonPosition: buttonPosition,
      animationDuration: animationDuration,
      enabled: enabled,
      disabledColor: disabledColor,
      shadowColor: shadowColor,
      rightShadowColor: rightShadowColor,
      leftShadowColor: leftShadowColor,
      topShadowColor: topShadowColor,
      bottomShadowColor: bottomShadowColor,
      child: shimmer
          ? NeoPopShimmer(
              shimmerColor: Colors.white.withAlpha(76),
              child: child,
            )
          : child,
    );
  }

  /// Applies platform-specific styling to the button.
  Widget _applyPlatformStyling(BuildContext context, Widget button) {
    // On iOS, add a slight blur effect to match Cupertino style
    if (isCupertino(context)) {
      return button.backgroundBlur(5);
    }

    // On web, add a hover effect
    if (isWeb) {
      return button.mouseRegion(
        cursor: SystemMouseCursors.click,
        opaque: false,
      );
    }

    return button;
  }

  /// Applies animations to the button.
  Widget _applyAnimations(Widget button) {
    return button
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shimmer(duration: 1800.ms, delay: 400.ms)
        .animate(target: enabled ? 1 : 0.7)
        .fade(duration: 200.ms)
        .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02))
        .then(delay: 200.ms)
        .scale(begin: const Offset(1.02, 1.02), end: const Offset(1, 1));
  }

  /// Gets the effective depth based on the screen size.
  double _getEffectiveDepth(SizingInformation sizingInformation) {
    // Use provided depth if available
    if (depth != null) return depth!;

    // Otherwise, adjust based on device type
    switch (sizingInformation.deviceScreenType) {
      case DeviceScreenType.desktop:
        return 8.0; // Larger depth for desktop
      case DeviceScreenType.tablet:
        return 6.0; // Medium depth for tablet
      case DeviceScreenType.mobile:
      default:
        return 4.0; // Smaller depth for mobile
    }
  }
}

/// Factory extension for creating common button variants
extension ResponsiveNeoPopButtonFactory on ResponsiveNeoPopButton {
  /// Creates a primary button with responsive styling.
  static ResponsiveNeoPopButton primary({
    required VoidCallback onTap,
    required Widget child,
    Color? color,
    double? depth,
    bool shimmer = false,
    Color? parentColor,
    bool enabled = true,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
    bool useAnimation = true,
    bool platformAware = true,
  }) {
    return ResponsiveNeoPopButton(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      color: color ?? const Color(0xFF3D63FF), // Electric Blue
      depth: depth,
      shimmer: shimmer,
      parentColor: parentColor ?? Colors.transparent,
      enabled: enabled,
      useAnimation: useAnimation,
      platformAware: platformAware,
      child: child,
    );
  }

  /// Creates a secondary button with responsive styling.
  static ResponsiveNeoPopButton secondary({
    required VoidCallback onTap,
    required Widget child,
    Color? color,
    double? depth,
    bool shimmer = false,
    Color? parentColor,
    bool enabled = true,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
    bool useAnimation = true,
    bool platformAware = true,
  }) {
    return ResponsiveNeoPopButton(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      color: color ?? const Color(0xFF7F5AF0), // Lavender
      depth: depth,
      shimmer: shimmer,
      parentColor: parentColor ?? Colors.transparent,
      enabled: enabled,
      useAnimation: useAnimation,
      platformAware: platformAware,
      child: child,
    );
  }

  /// Creates a flat button with responsive styling.
  static ResponsiveNeoPopButton flat({
    required VoidCallback onTap,
    required Widget child,
    Color? color,
    Border? border,
    Color? parentColor,
    bool enabled = true,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
    bool useAnimation = true,
    bool platformAware = true,
  }) {
    return ResponsiveNeoPopButton(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      color: color ?? Colors.white,
      depth: 0, // Zero depth for flat appearance
      border:
          border ?? Border.all(color: const Color(0xFF6C757D).withOpacity(0.3)),
      parentColor: parentColor ?? Colors.transparent,
      enabled: enabled,
      useAnimation: useAnimation,
      platformAware: platformAware,
      child: child,
    );
  }
}

/// Example usage:
///
/// ```dart
/// ResponsiveNeoPopButton.primary(
///   onTap: () => print('Button tapped'),
///   child: Padding(
///     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
///     child: Text('Primary Button'),
///   ),
/// )
/// ```
