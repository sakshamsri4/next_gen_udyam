import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/interview_management/models/interview_model.dart';
import 'package:next_gen/app/modules/interview_management/services/interview_management_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for interview management
class InterviewManagementController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Constructor
  InterviewManagementController() {
    _interviewService = Get.find<InterviewManagementService>();
    _logger = Get.find<LoggerService>();
  }

  late final InterviewManagementService _interviewService;
  late final LoggerService _logger;
  late TabController tabController;

  // Observable state variables
  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;
  final RxList<InterviewModel> interviews = <InterviewModel>[].obs;
  final RxList<InterviewModel> upcomingInterviews = <InterviewModel>[].obs;
  final RxList<InterviewModel> pastInterviews = <InterviewModel>[].obs;
  final Rx<InterviewModel?> selectedInterview = Rx<InterviewModel?>(null);

  // Form controllers
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _logger.i('InterviewManagementController initialized');

    // Initialize tab controller
    tabController = TabController(length: 2, vsync: this);

    // Load initial data
    loadInterviews();
  }

  @override
  void onClose() {
    tabController.dispose();
    feedbackController.dispose();
    notesController.dispose();
    reasonController.dispose();
    super.onClose();
  }

  /// Load all interviews
  Future<void> loadInterviews() async {
    try {
      isLoading.value = true;
      error.value = '';

      final allInterviews = await _interviewService.getInterviews();
      interviews.value = allInterviews;

      // Filter interviews into upcoming and past
      final now = DateTime.now();
      upcomingInterviews.value = allInterviews
          .where(
            (interview) =>
                interview.scheduledDate.isAfter(now) &&
                interview.status != InterviewStatus.canceled,
          )
          .toList();
      pastInterviews.value = allInterviews
          .where(
            (interview) =>
                interview.scheduledDate.isBefore(now) ||
                interview.status == InterviewStatus.canceled,
          )
          .toList();

      // Sort interviews by date
      upcomingInterviews
          .sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
      pastInterviews.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));

      _logger.d('Interviews loaded successfully');
    } catch (e) {
      _logger.e('Error loading interviews', e);
      error.value = 'Failed to load interviews. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh interviews
  Future<void> refreshInterviews() async {
    _logger.d('Refreshing interviews');
    return loadInterviews();
  }

  /// Select an interview
  void selectInterview(InterviewModel interview) {
    selectedInterview.value = interview;
    feedbackController.text = interview.feedback ?? '';
    notesController.text = interview.notes ?? '';
  }

  /// Clear selected interview
  void clearSelectedInterview() {
    selectedInterview.value = null;
    feedbackController.clear();
    notesController.clear();
    reasonController.clear();
  }

  /// Create a new interview
  Future<bool> createInterview(InterviewModel interview) async {
    try {
      isSubmitting.value = true;

      final newInterview = await _interviewService.createInterview(interview);
      interviews.add(newInterview);

      // Update filtered lists
      final now = DateTime.now();
      if (newInterview.scheduledDate.isAfter(now)) {
        upcomingInterviews
          ..add(newInterview)
          ..sort(
            (a, b) => a.scheduledDate.compareTo(b.scheduledDate),
          );
      } else {
        pastInterviews
          ..add(newInterview)
          ..sort(
            (a, b) => b.scheduledDate.compareTo(a.scheduledDate),
          );
      }

      Get.snackbar(
        'Success',
        'Interview scheduled successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      _logger.e('Error creating interview', e);
      Get.snackbar(
        'Error',
        'Failed to schedule interview. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Cancel an interview
  Future<bool> cancelInterview(String id, String reason) async {
    try {
      isSubmitting.value = true;

      final success = await _interviewService.cancelInterview(id, reason);
      if (success) {
        // Update the interview in the lists
        final index = interviews.indexWhere((interview) => interview.id == id);
        if (index != -1) {
          final updatedInterview = interviews[index].copyWith(
            status: InterviewStatus.canceled,
            notes: '${interviews[index].notes ?? ''}\n\nCanceled: $reason',
            updatedAt: DateTime.now(),
          );
          interviews[index] = updatedInterview;

          // Update filtered lists
          _updateFilteredLists(updatedInterview);
        }

        Get.snackbar(
          'Success',
          'Interview canceled successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to cancel interview. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      _logger.e('Error canceling interview', e);
      Get.snackbar(
        'Error',
        'Failed to cancel interview. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Reschedule an interview
  Future<bool> rescheduleInterview(
    String id,
    DateTime newDate,
    String reason,
  ) async {
    try {
      isSubmitting.value = true;

      final updatedInterview = await _interviewService.rescheduleInterview(
        id,
        newDate,
        reason,
      );

      // Update the interview in the lists
      final index = interviews.indexWhere((interview) => interview.id == id);
      if (index != -1) {
        interviews[index] = updatedInterview;

        // Update filtered lists
        _updateFilteredLists(updatedInterview);
      }

      Get.snackbar(
        'Success',
        'Interview rescheduled successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      _logger.e('Error rescheduling interview', e);
      Get.snackbar(
        'Error',
        'Failed to reschedule interview. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Add feedback to an interview
  Future<bool> addFeedback(String id, String feedback) async {
    try {
      isSubmitting.value = true;

      final updatedInterview = await _interviewService.addFeedback(
        id,
        feedback,
      );

      // Update the interview in the lists
      final index = interviews.indexWhere((interview) => interview.id == id);
      if (index != -1) {
        interviews[index] = updatedInterview;

        // Update filtered lists
        _updateFilteredLists(updatedInterview);
      }

      Get.snackbar(
        'Success',
        'Feedback added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      _logger.e('Error adding feedback', e);
      Get.snackbar(
        'Error',
        'Failed to add feedback. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Update filtered lists
  void _updateFilteredLists(InterviewModel interview) {
    final now = DateTime.now();
    final isUpcoming = interview.scheduledDate.isAfter(now) &&
        interview.status != InterviewStatus.canceled;

    // Remove from both lists first
    upcomingInterviews.removeWhere((i) => i.id == interview.id);
    pastInterviews.removeWhere((i) => i.id == interview.id);

    // Add to the appropriate list
    if (isUpcoming) {
      upcomingInterviews
        ..add(interview)
        ..sort(
          (a, b) => a.scheduledDate.compareTo(b.scheduledDate),
        );
    } else {
      pastInterviews
        ..add(interview)
        ..sort(
          (a, b) => b.scheduledDate.compareTo(a.scheduledDate),
        );
    }
  }
}
