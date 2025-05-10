import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer effect widget for loading states
///
/// This widget displays a shimmer effect commonly used for loading states
class ShimmerWidget extends StatelessWidget {
  /// Creates a shimmer widget
  ///
  /// [width] is the width of the shimmer
  /// [height] is the height of the shimmer
  /// [radius] is the border radius of the shimmer
  /// [child] is an optional child widget
  /// [margin] is the margin around the shimmer
  const ShimmerWidget({
    required this.width,
    required this.height,
    super.key,
    this.radius,
    this.child,
    this.margin,
  })  : isCircular = false,
        borderRadius = 0;

  /// Creates a rectangular shimmer widget
  const ShimmerWidget.rectangular({
    required this.width,
    required this.height,
    this.borderRadius = 0,
    super.key,
    this.margin,
  })  : isCircular = false,
        radius = borderRadius,
        child = null;

  /// Creates a circular shimmer widget
  const ShimmerWidget.circular({
    required this.width,
    required this.height,
    super.key,
    this.margin,
  })  : isCircular = true,
        radius = null,
        borderRadius = 0,
        child = null;

  final double width;
  final double height;
  final double? radius;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final bool isCircular;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.brightness == Brightness.light
        ? Colors.grey.shade300
        : Colors.grey.shade700;
    final highlightColor = theme.brightness == Brightness.light
        ? Colors.grey.shade100
        : Colors.grey.shade500;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius:
              isCircular ? null : BorderRadius.circular(radius ?? borderRadius),
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
