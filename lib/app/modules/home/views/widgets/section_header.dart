import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// A section header widget for the home screen
class SectionHeader extends StatelessWidget {
  /// Creates a section header
  ///
  /// [title] is the title of the section
  /// [actionTitle] is an optional action text to display on the right
  /// [onActionTap] is an optional callback for when the action is tapped
  const SectionHeader({
    required this.title,
    this.actionTitle,
    this.onActionTap,
    super.key,
  });

  /// The title of the section
  final String title;

  /// The action title to display on the right (optional)
  final String? actionTitle;

  /// Callback for when the action is tapped (optional)
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (actionTitle != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionTitle!,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
