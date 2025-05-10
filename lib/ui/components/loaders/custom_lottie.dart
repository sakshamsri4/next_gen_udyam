import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

/// A custom component for displaying Lottie animations with text
///
/// This component is commonly used for empty states, loading states,
/// and error states
class CustomLottie extends StatelessWidget {
  /// Creates a custom Lottie component
  ///
  /// [title] is the main text to display
  /// [asset] is the path to the Lottie animation asset
  /// [onTryAgain] is called when the try again button is tapped
  /// [repeat] determines if the animation should repeat
  /// [description] is additional text to display
  /// [assetHeight] is the height of the animation
  /// [padding] is the padding around the component
  /// [titleStyle] is the style for the title text
  /// [descriptionStyle] is the style for the description text
  const CustomLottie({
    required this.title,
    required this.asset,
    super.key,
    this.onTryAgain,
    this.repeat = false,
    this.description,
    this.assetHeight,
    this.padding,
    this.titleStyle,
    this.descriptionStyle,
  });

  /// The main title text to display
  final String title;

  /// Optional additional description text
  final String? description;

  /// Lottie animation asset path
  final String asset;

  /// Whether the animation should repeat
  final bool repeat;

  /// Callback when the try again button is tapped
  final void Function()? onTryAgain;

  /// Height of the Lottie animation
  final double? assetHeight;

  /// Padding around the component
  final EdgeInsetsGeometry? padding;

  /// Style for the title text
  final TextStyle? titleStyle;

  /// Style for the description text
  final TextStyle? descriptionStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.only(bottom: kToolbarHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(
              asset,
              height: assetHeight ?? 250.h,
              fit: BoxFit.contain,
              repeat: repeat,
            ),
            Text(
              title,
              style: titleStyle ??
                  GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (description != null) SizedBox(height: 5.w),
            if (description != null)
              Text(
                description!,
                textAlign: TextAlign.center,
                style: descriptionStyle ??
                    GoogleFonts.poppins(
                      color: theme.colorScheme.tertiary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            if (onTryAgain != null)
              TextButton(
                onPressed: onTryAgain,
                child: Text(
                  'Try again',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
