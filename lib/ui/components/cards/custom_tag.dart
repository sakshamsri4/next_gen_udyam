import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

/// A custom tag for displaying job attributes
///
/// This tag displays an icon and text, commonly used for job attributes
/// like workplace type, employment type, and location
class CustomTag extends StatelessWidget {
  /// Creates a custom tag
  ///
  /// [icon] is the icon to display
  /// [title] is the text to display
  /// [isFeatured] indicates if this tag is for a featured job
  /// [titleColor] is the color of the text
  /// [backgroundColor] is the background color of the tag
  const CustomTag({
    Key? key,
    required this.icon,
    required this.title,
    this.isFeatured = false,
    required this.titleColor,
    required this.backgroundColor,
  }) : super(key: key);
  
  final HeroIcons icon;
  final String title;
  final bool isFeatured;
  final Color titleColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 6.w, top: 6.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            icon,
            color: titleColor,
            size: 15.w,
          ),
          SizedBox(width: 5.w),
          Text(
            title.capitalize!,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          )
        ],
      ),
    );
  }
}
