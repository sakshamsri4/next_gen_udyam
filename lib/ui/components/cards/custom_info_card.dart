import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

/// A custom card for displaying information with a title and icon
/// following CRED design principles
///
/// This card is commonly used for profile sections, job details, etc.
/// It implements CRED design principles with physical appearance,
/// elevation, and subtle animations.
class CustomInfoCard extends StatelessWidget {
  /// Creates a custom info card with CRED design
  ///
  /// [child] is the content to display in the card
  /// [icon] is the icon to display in the header
  /// [title] is the title to display in the header
  /// [action] is an optional icon for an action button
  /// [onActionTap] is called when the action button is tapped
  /// [backgroundColor] is the background color of the card (defaults to theme surface color)
  /// [elevation] is the elevation of the card (defaults to 8)
  /// [borderRadius] is the border radius of the card (defaults to 16)
  const CustomInfoCard({
    required this.child,
    required this.icon,
    required this.title,
    super.key,
    this.action,
    this.onActionTap,
    this.backgroundColor,
    this.elevation = 8,
    this.borderRadius = 16,
  });

  /// The content to display in the card
  final Widget child;

  /// The icon to display in the header
  final HeroIcons icon;

  /// Optional icon for an action button
  final HeroIcons? action;

  /// The title to display in the header
  final String title;

  /// Called when the action button is tapped
  final void Function()? onActionTap;

  /// The background color of the card
  final Color? backgroundColor;

  /// The elevation of the card
  final double elevation;

  /// The border radius of the card
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        backgroundColor ?? theme.cardTheme.color ?? theme.colorScheme.surface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.only(bottom: 16.h, right: 16.w, left: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40), // 0.16 opacity
            blurRadius: elevation,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withAlpha(20), // 0.08 opacity
            blurRadius: elevation * 2,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withAlpha(30), // Very subtle border
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: HeroIcon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              if (action != null)
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  child: InkWell(
                    onTap: onActionTap,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: HeroIcon(
                        action!,
                        color: theme.colorScheme.primary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(
            color: theme.dividerColor.withAlpha(50),
            thickness: 1,
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}
