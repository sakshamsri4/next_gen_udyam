import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

/// A reusable empty state widget
class EmptyState extends StatelessWidget {
  /// Creates an empty state widget
  ///
  /// [icon] is the icon to display
  /// [title] is the title text
  /// [description] is the description text
  /// [buttonText] is the text for the action button
  /// [onButtonPressed] is called when the button is pressed
  const EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
    super.key,
  });

  /// The icon to display
  final HeroIcons icon;

  /// The title text
  final String title;

  /// The description text
  final String description;

  /// The text for the action button
  final String? buttonText;

  /// Called when the button is pressed
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              icon,
              size: 64.r,
              color:
                  theme.colorScheme.primary.withAlpha(179), // 0.7 * 255 = 179
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface
                    .withAlpha(179), // 0.7 * 255 = 179
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                ),
                onPressed: onButtonPressed,
                child: Text(
                  buttonText!,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
