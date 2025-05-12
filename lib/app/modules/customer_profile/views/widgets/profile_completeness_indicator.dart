import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/customer_profile/controllers/customer_profile_controller.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A widget that displays the profile completeness
class ProfileCompletenessIndicator extends GetView<CustomerProfileController> {
  /// Creates a new profile completeness indicator
  const ProfileCompletenessIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final completeness = controller.profileCompleteness.value;
      final percentage = (completeness * 100).toInt();

      // Determine color based on completeness
      Color progressColor;
      if (percentage < 30) {
        progressColor = Colors.red;
      } else if (percentage < 70) {
        progressColor = Colors.orange;
      } else {
        progressColor = AppTheme.electricBlue;
      }

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and percentage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Completeness',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: completeness,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 8.h,
                ),
              ),

              SizedBox(height: 12.h),

              // Message
              Text(
                _getCompletionMessage(percentage),
                style: theme.textTheme.bodyMedium,
              ),

              SizedBox(height: 16.h),

              // Action button
              if (percentage < 100)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditProfileDialog(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Complete Your Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.electricBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  /// Get a message based on the completion percentage
  String _getCompletionMessage(int percentage) {
    if (percentage < 30) {
      return 'Your profile is just getting started. Complete more sections to increase your chances of getting noticed by employers.';
    } else if (percentage < 70) {
      return "You're making good progress! Add more details to make your profile stand out.";
    } else if (percentage < 100) {
      return 'Your profile is almost complete! Just a few more details to make it perfect.';
    } else {
      return 'Congratulations! Your profile is complete and ready to impress employers.';
    }
  }

  /// Show the edit profile dialog
  void _showEditProfileDialog(BuildContext context) {
    controller.toggleEditMode();
  }
}
