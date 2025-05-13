import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/interview_management/controllers/interview_management_controller.dart';
import 'package:next_gen/app/modules/interview_management/models/interview_model.dart';
import 'package:next_gen/app/modules/interview_management/views/widgets/interview_card.dart';
import 'package:next_gen/app/modules/interview_management/views/widgets/interview_details.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Interview management view
class InterviewManagementView extends GetView<InterviewManagementController> {
  /// Constructor
  const InterviewManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interview Management',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Add interview button
          IconButton(
            icon: const HeroIcon(HeroIcons.plus),
            onPressed: () => _showScheduleInterviewForm(context),
            tooltip: 'Schedule Interview',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const UnifiedBottomNav(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showScheduleInterviewForm(context),
        backgroundColor: RoleThemes.employerPrimary,
        icon: const HeroIcon(
          HeroIcons.plus,
          style: HeroIconStyle.solid,
          color: Colors.white,
        ),
        label: const Text(
          'Schedule Interview',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error.value}',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshInterviews(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // If an interview is selected, show the details
        if (controller.selectedInterview.value != null) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: InterviewDetails(
              interview: controller.selectedInterview.value!,
              onClose: () => controller.clearSelectedInterview(),
              onReschedule: () => _showRescheduleForm(
                context,
                controller.selectedInterview.value!,
              ),
              onCancel: () => _showCancelConfirmation(
                context,
                controller.selectedInterview.value!,
              ),
              onAddFeedback: () => _showFeedbackForm(
                context,
                controller.selectedInterview.value!,
              ),
            ),
          );
        }

        return Column(
          children: [
            // Tab bar
            Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TabBar(
                controller: controller.tabController,
                labelStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: primaryColor,
                ),
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past'),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  // Upcoming interviews tab
                  _buildInterviewsList(
                    context,
                    controller.upcomingInterviews,
                    'No upcoming interviews',
                    'Schedule an interview to get started.',
                  ),

                  // Past interviews tab
                  _buildInterviewsList(
                    context,
                    controller.pastInterviews,
                    'No past interviews',
                    'Past interviews will appear here.',
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Build interviews list
  Widget _buildInterviewsList(
    BuildContext context,
    RxList<InterviewModel> interviews,
    String emptyTitle,
    String emptyMessage,
  ) {
    if (interviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              emptyTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshInterviews,
      color: RoleThemes.employerPrimary,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: interviews.length,
        itemBuilder: (context, index) {
          final interview = interviews[index];
          return InterviewCard(
            interview: interview,
            onTap: () => controller.selectInterview(interview),
            onReschedule: _canReschedule(interview)
                ? () => _showRescheduleForm(context, interview)
                : null,
            onCancel: _canCancel(interview)
                ? () => _showCancelConfirmation(context, interview)
                : null,
            onAddFeedback: _canAddFeedback(interview)
                ? () => _showFeedbackForm(context, interview)
                : null,
          );
        },
      ),
    );
  }

  /// Show schedule interview form
  void _showScheduleInterviewForm(BuildContext context) {
    // In a real app, we would show a form to schedule a new interview
    Get.snackbar(
      'Coming Soon',
      'Interview scheduling form will be implemented in a future update.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  /// Show reschedule form
  void _showRescheduleForm(BuildContext context, InterviewModel interview) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    var selectedDate = DateTime.now().add(const Duration(days: 1));
    var selectedTime = TimeOfDay.now();

    Get.dialog<void>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          width: 400.w,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reschedule Interview',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Current date: ${DateFormat('MMM d, yyyy • h:mm a').format(interview.scheduledDate)}',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 24.h),
              Text(
                'New Date',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: primaryColor,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    selectedDate = date;
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      const HeroIcon(HeroIcons.calendar),
                      SizedBox(width: 8.w),
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      const HeroIcon(HeroIcons.chevronDown),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'New Time',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: primaryColor,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    selectedTime = time;
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      const HeroIcon(HeroIcons.clock),
                      SizedBox(width: 8.w),
                      Text(
                        selectedTime.format(context),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      const HeroIcon(HeroIcons.chevronDown),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Reason',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.reasonController,
                decoration: InputDecoration(
                  hintText: 'Enter reason for rescheduling',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back<void>(),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.reasonController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter a reason for rescheduling',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Combine date and time
                      final newDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      controller.rescheduleInterview(
                        interview.id,
                        newDate,
                        controller.reasonController.text,
                      );
                      Get.back<void>();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reschedule'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show cancel confirmation
  void _showCancelConfirmation(BuildContext context, InterviewModel interview) {
    final theme = Theme.of(context);

    Get.dialog<void>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          width: 400.w,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cancel Interview',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Are you sure you want to cancel this interview?',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 8.h),
              Text(
                'Interview with ${interview.candidateName} on ${DateFormat('MMM d, yyyy • h:mm a').format(interview.scheduledDate)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Reason',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.reasonController,
                decoration: InputDecoration(
                  hintText: 'Enter reason for cancellation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back<void>(),
                    child: const Text('Back'),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.reasonController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter a reason for cancellation',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      controller.cancelInterview(
                        interview.id,
                        controller.reasonController.text,
                      );
                      Get.back<void>();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cancel Interview'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show feedback form
  void _showFeedbackForm(BuildContext context, InterviewModel interview) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    Get.dialog<void>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          width: 400.w,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Feedback',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Interview with ${interview.candidateName} on ${DateFormat('MMM d, yyyy • h:mm a').format(interview.scheduledDate)}',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 16.h),
              Text(
                'Feedback',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.feedbackController,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback about the interview',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back<void>(),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.feedbackController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter feedback',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      controller.addFeedback(
                        interview.id,
                        controller.feedbackController.text,
                      );
                      Get.back<void>();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Feedback'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Check if interview can be rescheduled
  bool _canReschedule(InterviewModel interview) {
    return interview.scheduledDate.isAfter(DateTime.now()) &&
        interview.status != InterviewStatus.canceled;
  }

  /// Check if interview can be canceled
  bool _canCancel(InterviewModel interview) {
    return interview.scheduledDate.isAfter(DateTime.now()) &&
        interview.status != InterviewStatus.canceled;
  }

  /// Check if feedback can be added
  bool _canAddFeedback(InterviewModel interview) {
    return interview.status == InterviewStatus.completed &&
        (interview.feedback == null || interview.feedback!.isEmpty);
  }
}
