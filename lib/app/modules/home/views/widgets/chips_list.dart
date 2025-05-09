import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/ui/components/loaders/shimmer/shimmer_widget.dart';

/// A custom chip widget for category selection
class CustomChip extends StatelessWidget {
  /// Creates a custom chip
  ///
  /// [title] is the text to display in the chip
  /// [isActive] determines if the chip is selected
  /// [onPressed] is called when the chip is tapped
  const CustomChip({
    required this.title,
    required this.isActive,
    required this.onPressed,
    super.key,
  });

  /// The text to display in the chip
  final String title;

  /// Whether the chip is selected
  final bool isActive;

  /// Callback for when the chip is tapped
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(right: 6.w),
      child: ActionChip(
        padding: EdgeInsets.all(6.w),
        label: Text(title),
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.white : theme.colorScheme.secondary,
        ),
        elevation: 0,
        side: BorderSide(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          width: 1.w,
        ),
        labelPadding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 15.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        onPressed: onPressed,
        backgroundColor: isActive
            ? theme.colorScheme.primary
            : theme.scaffoldBackgroundColor,
      ),
    );
  }
}

/// A shimmer effect for category chips
class ChipsShimmer extends StatelessWidget {
  /// Creates a chips shimmer
  const ChipsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 16.w),
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(right: 8.w),
        child: ShimmerWidget(
          width: 80.w,
          height: 32.h,
          radius: 14.r,
        ),
      ),
    );
  }
}

/// A horizontal list of category chips
class ChipsList extends GetWidget<HomeController> {
  /// Creates a chips list
  const ChipsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Obx(() {
        if (controller.isCategoriesLoading) {
          return const ChipsShimmer();
        }

        if (controller.categoriesError.isNotEmpty) {
          return const Center(
            child: Text(
              'Failed to load categories',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.categories.length,
          padding: EdgeInsets.only(left: 16.w),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Obx(
              () => CustomChip(
                title: category.title,
                isActive: category.title == controller.selectedCategory,
                onPressed: () =>
                    controller.updateSelectedCategory(category.title),
              ),
            );
          },
        );
      }),
    );
  }
}
