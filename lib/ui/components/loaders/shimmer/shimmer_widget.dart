import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    Key? key,
    required this.width,
    required this.height,
    this.radius,
    this.child,
    this.margin,
  }) : super(key: key);
  
  final double width;
  final double height;
  final double? radius;
  final Widget? child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Shimmer.fromColors(
      baseColor: theme.primaryColor.withOpacity(0.38),
      highlightColor: theme.colorScheme.background,
      child: Container(
        width: width,
        height: height,
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius ?? 14.r),
          color: theme.primaryColor.withOpacity(0.38),
        ),
        child: child,
      ),
    );
  }
}
