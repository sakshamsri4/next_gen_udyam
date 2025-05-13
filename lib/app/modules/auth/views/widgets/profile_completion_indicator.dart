import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Profile completion indicator widget
class ProfileCompletionIndicator extends StatelessWidget {
  /// Creates a profile completion indicator
  const ProfileCompletionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get logger
    LoggerService? logger;
    try {
      logger = Get.find<LoggerService>();
    } catch (e) {
      debugPrint('Error finding LoggerService: $e');
    }

    // Safely get the AuthController
    AuthController? controller;
    try {
      controller = Get.find<AuthController>();
      logger?.d('ProfileCompletionIndicator: Found AuthController');
    } catch (e) {
      logger?.e('ProfileCompletionIndicator: Error finding AuthController', e);
      debugPrint('Error finding AuthController: $e');
      // Return a placeholder if controller is not found
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: const Center(
            child: Text('Unable to load profile completion data'),
          ),
        ),
      );
    }

    // Calculate completion percentage
    final user = controller.user.value;
    if (user == null) {
      logger?.w('ProfileCompletionIndicator: User is null');
      return const SizedBox.shrink();
    }

    logger?.d('ProfileCompletionIndicator: Building with user ${user.uid}');

    // Calculate profile completion percentage
    final completionItems = <CompletionItem>[
      CompletionItem(
        title: 'Profile Picture',
        isCompleted: user.photoURL != null && user.photoURL!.isNotEmpty,
        points: 20,
      ),
      CompletionItem(
        title: 'Display Name',
        isCompleted: user.displayName != null && user.displayName!.isNotEmpty,
        points: 20,
      ),
      CompletionItem(
        title: 'Email Verification',
        isCompleted: user.emailVerified,
        points: 20,
      ),
      CompletionItem(
        title: 'Enhanced Profile',
        isCompleted: false, // This would come from CustomerProfileController
        points: 20,
      ),
      CompletionItem(
        title: 'Resume Upload',
        isCompleted: false, // This would come from ResumeController
        points: 20,
      ),
    ];

    final totalPoints = completionItems.fold<int>(
      0,
      (sum, item) => sum + item.points,
    );
    final completedPoints = completionItems
        .where((item) => item.isCompleted)
        .fold<int>(0, (sum, item) => sum + item.points);
    final completionPercentage = (completedPoints / totalPoints * 100).round();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile Completion',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _getCompletionColor(completionPercentage).withAlpha(30),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    '$completionPercentage%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getCompletionColor(completionPercentage),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: completionPercentage / 100,
                backgroundColor: isDarkMode ? Colors.white12 : Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getCompletionColor(completionPercentage),
                ),
                minHeight: 8.h,
              ),
            ),
            SizedBox(height: 16.h),

            // Completion items
            ...completionItems.map(
              (item) => _buildCompletionItem(
                context,
                item: item,
                isDarkMode: isDarkMode,
              ),
            ),

            SizedBox(height: 16.h),

            // Tip
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white10 : Colors.black.withAlpha(5),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isDarkMode ? Colors.white24 : Colors.black12,
                ),
              ),
              child: Row(
                children: [
                  HeroIcon(
                    HeroIcons.lightBulb,
                    size: 20.w,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Complete your profile to increase your chances of getting hired!',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a completion item
  Widget _buildCompletionItem(
    BuildContext context, {
    required CompletionItem item,
    required bool isDarkMode,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          // Completion indicator
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: item.isCompleted
                  ? RoleThemes.employeePrimary
                  : isDarkMode
                      ? Colors.white24
                      : Colors.black12,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: item.isCompleted
                  ? HeroIcon(
                      HeroIcons.check,
                      size: 16.w,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),

          // Item title
          Expanded(
            child: Text(
              item.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight:
                    item.isCompleted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          // Points
          Text(
            '+${item.points} pts',
            style: theme.textTheme.bodySmall?.copyWith(
              color: item.isCompleted
                  ? RoleThemes.employeePrimary
                  : isDarkMode
                      ? Colors.white54
                      : Colors.black45,
              fontWeight:
                  item.isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Get color based on completion percentage
  Color _getCompletionColor(int percentage) {
    if (percentage < 30) {
      return Colors.red;
    } else if (percentage < 70) {
      return Colors.orange;
    } else if (percentage < 100) {
      return Colors.green;
    } else {
      return RoleThemes.employeePrimary;
    }
  }
}

/// Completion item model
class CompletionItem {
  /// Creates a completion item
  CompletionItem({
    required this.title,
    required this.isCompleted,
    required this.points,
  });

  /// Item title
  final String title;

  /// Whether the item is completed
  final bool isCompleted;

  /// Points awarded for completion
  final int points;
}
