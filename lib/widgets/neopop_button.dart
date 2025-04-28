import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/neopop.dart';

import 'package:next_gen/core/theme/app_theme.dart';

/// A custom button widget using NeoPop design.
///
/// This widget wraps the NeoPopButton from the neopop package
/// and provides a consistent styling for buttons in the app.
class CustomNeoPopButton extends StatelessWidget {
  /// Creates a CustomNeoPopButton.
  ///
  /// The [onTap], [child], and [color] parameters are required.
  const CustomNeoPopButton({
    required this.onTap,
    required this.child,
    required this.color,
    this.onTapDown,
    this.depth = 5,
    this.border,
    this.shimmer = false,
    this.parentColor = Colors.transparent,
    this.grandparentColor = Colors.transparent,
    this.buttonPosition = Position.fullBottom,
    this.animationDuration = const Duration(milliseconds: 50),
    this.forwardDuration,
    this.reverseDuration,
    this.enabled = true,
    this.disabledColor = Colors.grey,
    this.shadowColor,
    this.rightShadowColor,
    this.leftShadowColor,
    this.topShadowColor,
    this.bottomShadowColor,
    this.onLongPress,
    super.key,
  });

  /// Creates a primary button with the app's theme.
  factory CustomNeoPopButton.primary({
    required VoidCallback onTap,
    required Widget child,
    double depth = 8,
    bool shimmer = false,
    Color? parentColor,
    bool enabled = true,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
  }) {
    return CustomNeoPopButton(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      color: AppTheme.electricBlue,
      depth: depth,
      shimmer: shimmer,
      parentColor: parentColor ?? Colors.transparent,
      enabled: enabled,
      child: child,
    );
  }

  /// Creates a secondary button with the app's theme.
  factory CustomNeoPopButton.secondary({
    required VoidCallback onTap,
    required Widget child,
    double depth = 5,
    bool shimmer = false,
    Color? parentColor,
    bool enabled = true,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
  }) {
    return CustomNeoPopButton(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      color: AppTheme.lavender,
      depth: depth,
      shimmer: shimmer,
      parentColor: parentColor ?? Colors.transparent,
      enabled: enabled,
      child: child,
    );
  }

  /// Creates a danger button with the app's theme.
  factory CustomNeoPopButton.danger({
    required VoidCallback onTap,
    required Widget child,
    double depth = 5,
    bool shimmer = false,
    Color? parentColor,
    bool enabled = true,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
  }) {
    return CustomNeoPopButton(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      color: AppTheme.coralRed,
      depth: depth,
      shimmer: shimmer,
      parentColor: parentColor ?? Colors.transparent,
      enabled: enabled,
      child: child,
    );
  }

  /// Creates a success button with the app's theme.
  factory CustomNeoPopButton.success({
    required VoidCallback onTap,
    required Widget child,
    double depth = 5,
    bool shimmer = false,
    Color? parentColor,
    bool enabled = true,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
  }) {
    return CustomNeoPopButton(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      color: AppTheme.mintGreen,
      depth: depth,
      shimmer: shimmer,
      parentColor: parentColor ?? Colors.transparent,
      enabled: enabled,
      child: child,
    );
  }

  /// Creates a flat button with the app's theme.
  factory CustomNeoPopButton.flat({
    required VoidCallback onTap,
    required Widget child,
    Color? color,
    Color? parentColor,
    bool enabled = true,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
  }) {
    return CustomNeoPopButton(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      color: color ?? Colors.white,
      depth: 0,
      parentColor: parentColor ?? Colors.transparent,
      enabled: enabled,
      child: child,
    );
  }

  /// The callback that is called when the button is released.
  final VoidCallback onTap;

  /// The callback that is called when the button is pressed.
  final VoidCallback? onTapDown;

  /// The callback that is called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// The widget to display inside the button.
  final Widget child;

  /// The background color of the button.
  final Color color;

  /// The depth of the button's 3D effect.
  final double depth;

  /// Optional border for the button.
  final Border? border;

  /// Whether to apply a shimmer effect to the button.
  final bool shimmer;

  /// Button's immediate ancestor's color.
  final Color parentColor;

  /// Button's second level ancestor's color.
  final Color grandparentColor;

  /// The position of button in reference to parent view.
  final Position buttonPosition;

  /// Animation duration of the button click.
  final Duration animationDuration;

  /// If you want different forward duration for button click.
  final Duration? forwardDuration;

  /// If you want different reverse duration for button click.
  final Duration? reverseDuration;

  /// Whether the button is enabled.
  final bool enabled;

  /// Color of the button when it is disabled.
  final Color disabledColor;

  /// The base color of the shadow. The shadow colors will be derived from this.
  final Color? shadowColor;

  /// The color of the right shadow.
  final Color? rightShadowColor;

  /// The color of the left shadow.
  final Color? leftShadowColor;

  /// The color of the top shadow.
  final Color? topShadowColor;

  /// The color of the bottom shadow.
  final Color? bottomShadowColor;

  @override
  Widget build(BuildContext context) {
    // Create a NeoPopButton with all the properties
    return NeoPopButton(
      color: color,
      onTapUp: onTap,
      onTapDown: onTapDown ?? HapticFeedback.lightImpact,
      onLongPress: onLongPress,
      depth: depth,
      border: border,
      parentColor: parentColor,
      grandparentColor: grandparentColor,
      buttonPosition: buttonPosition,
      animationDuration: animationDuration,
      forwardDuration: forwardDuration,
      reverseDuration: reverseDuration,
      enabled: enabled,
      disabledColor: disabledColor,
      shadowColor: shadowColor,
      rightShadowColor: rightShadowColor,
      leftShadowColor: leftShadowColor,
      topShadowColor: topShadowColor,
      bottomShadowColor: bottomShadowColor,
      child: shimmer
          ? NeoPopShimmer(
              shimmerColor: Colors.white.withAlpha(76), // 0.3 * 255 = 76
              child: child,
            )
          : child,
    );
  }
}
