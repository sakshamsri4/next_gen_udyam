import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/search/models/saved_search_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A widget for displaying a saved search item
class SavedSearchItem extends StatelessWidget {
  /// Creates a saved search item
  const SavedSearchItem({
    required this.search,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// The saved search model
  final SavedSearchModel search;

  /// Callback when the item is tapped
  final VoidCallback onTap;

  /// Callback when the delete button is tapped
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    const primaryColor = RoleThemes.employeePrimary;
    // Use fixed colors instead of opacity to avoid deprecation warnings
    const primaryColorLight = Color(0xFFE6F0FF); // Light blue
    const primaryColorMedium = Color(0xFFB3D1FF); // Medium blue

    return Container(
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: primaryColorMedium,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HeroIcon(
                  HeroIcons.bookmark,
                  size: 16.w,
                  color: primaryColor,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    search.displayName,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 6.w),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: HeroIcon(
                      HeroIcons.xMark,
                      size: 14.w,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
