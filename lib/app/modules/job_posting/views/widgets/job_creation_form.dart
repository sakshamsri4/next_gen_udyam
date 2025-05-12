import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/job_posting/controllers/job_posting_controller.dart';

/// Multi-step form for job creation and editing
class JobCreationForm extends GetView<JobPostingController> {
  /// Creates a job creation form
  ///
  /// [isEditing] determines if this is for editing an existing job
  const JobCreationForm({
    required this.isEditing,
    super.key,
  });

  /// Whether this form is for editing an existing job
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Job Posting' : 'Create Job Posting',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.xMark),
          onPressed: () => Get.back<void>(),
        ),
        actions: [
          // Preview button
          Obx(() {
            return IconButton(
              icon: HeroIcon(
                controller.previewMode ? HeroIcons.pencil : HeroIcons.eye,
              ),
              onPressed: controller.togglePreviewMode,
              tooltip: controller.previewMode ? 'Edit Mode' : 'Preview Mode',
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.previewMode) {
          return _buildPreviewMode(theme);
        }

        return _buildEditMode(theme);
      }),
    );
  }

  /// Build edit mode with stepper
  Widget _buildEditMode(ThemeData theme) {
    return Stepper(
      currentStep: controller.currentStep,
      onStepContinue: () {
        if (_validateCurrentStep()) {
          controller.nextStep();
        }
      },
      onStepCancel: controller.previousStep,
      onStepTapped: (step) => controller.currentStep = step,
      controlsBuilder: (context, details) {
        return Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Row(
            children: [
              if (details.currentStep < 3)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  onPressed: details.onStepContinue,
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (details.currentStep == 3)
                Obx(() {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                    ),
                    onPressed: controller.isCreating || controller.isUpdating
                        ? null
                        : _submitForm,
                    child: controller.isCreating || controller.isUpdating
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEditing ? 'Update Job' : 'Create Job',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                }),
              SizedBox(width: 16.w),
              if (details.currentStep > 0)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  onPressed: details.onStepCancel,
                  child: Text(
                    'Back',
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      steps: [
        // Step 1: Basic Information
        Step(
          title: const Text('Basic Information'),
          content: _buildBasicInfoStep(),
          isActive: controller.currentStep >= 0,
          state: controller.currentStep > 0
              ? StepState.complete
              : StepState.indexed,
        ),

        // Step 2: Job Details
        Step(
          title: const Text('Job Details'),
          content: _buildJobDetailsStep(),
          isActive: controller.currentStep >= 1,
          state: controller.currentStep > 1
              ? StepState.complete
              : StepState.indexed,
        ),

        // Step 3: Requirements & Responsibilities
        Step(
          title: const Text('Requirements & Responsibilities'),
          content: _buildRequirementsStep(),
          isActive: controller.currentStep >= 2,
          state: controller.currentStep > 2
              ? StepState.complete
              : StepState.indexed,
        ),

        // Step 4: Additional Information
        Step(
          title: const Text('Additional Information'),
          content: _buildAdditionalInfoStep(),
          isActive: controller.currentStep >= 3,
          state: controller.currentStep > 3
              ? StepState.complete
              : StepState.indexed,
        ),
      ],
    );
  }

  /// Build basic information step
  Widget _buildBasicInfoStep() {
    return Column(
      children: [
        // Job Title
        TextField(
          controller: controller.titleController,
          decoration: const InputDecoration(
            labelText: 'Job Title',
            hintText: 'e.g. Senior Software Engineer',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Job Type
        TextField(
          controller: controller.jobTypeController,
          decoration: const InputDecoration(
            labelText: 'Job Type',
            hintText: 'e.g. Full-time, Part-time, Contract',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Location
        TextField(
          controller: controller.locationController,
          decoration: const InputDecoration(
            labelText: 'Location',
            hintText: 'e.g. New York, NY',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Remote Option
        Row(
          children: [
            Obx(() {
              return Checkbox(
                value: controller.isRemote,
                onChanged: (value) => controller.isRemote = value ?? false,
              );
            }),
            const Text('This is a remote position'),
          ],
        ),
      ],
    );
  }

  /// Build job details step
  Widget _buildJobDetailsStep() {
    return Column(
      children: [
        // Salary
        TextField(
          controller: controller.salaryController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Salary',
            hintText: 'e.g. 100000',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Experience
        TextField(
          controller: controller.experienceController,
          decoration: const InputDecoration(
            labelText: 'Experience Required',
            hintText: 'e.g. 3-5 years',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Education
        TextField(
          controller: controller.educationController,
          decoration: const InputDecoration(
            labelText: 'Education Required',
            hintText: "e.g. Bachelor's Degree",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Industry
        TextField(
          controller: controller.industryController,
          decoration: const InputDecoration(
            labelText: 'Industry',
            hintText: 'e.g. Technology, Healthcare',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  /// Build requirements and responsibilities step
  Widget _buildRequirementsStep() {
    return Column(
      children: [
        // Job Description
        TextField(
          controller: controller.descriptionController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Job Description',
            hintText: 'Enter a detailed job description',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Requirements
        TextField(
          controller: controller.requirementsController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Requirements',
            hintText: 'Enter each requirement on a new line',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Responsibilities
        TextField(
          controller: controller.responsibilitiesController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Responsibilities',
            hintText: 'Enter each responsibility on a new line',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  /// Build additional information step
  Widget _buildAdditionalInfoStep() {
    return Column(
      children: [
        // Skills
        TextField(
          controller: controller.skillsController,
          decoration: const InputDecoration(
            labelText: 'Skills',
            hintText: 'Enter skills separated by commas',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Benefits
        TextField(
          controller: controller.benefitsController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Benefits',
            hintText: 'Enter each benefit on a new line',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),

        // Application Deadline
        Obx(() {
          // Format the date if available
          final displayText = controller.applicationDeadline != null
              ? DateFormat('yyyy-MM-dd').format(controller.applicationDeadline!)
              : '';

          return GestureDetector(
            onTap: () => _selectDate(Get.context!),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Application Deadline',
                hintText: displayText.isEmpty ? 'Select a deadline' : null,
                border: const OutlineInputBorder(),
                suffixIcon: const HeroIcon(HeroIcons.calendar),
              ),
              child: Text(
                displayText.isEmpty ? '' : displayText,
                style: Theme.of(Get.context!).textTheme.bodyMedium,
              ),
            ),
          );
        }),
        SizedBox(height: 16.h),

        // Featured Job
        Row(
          children: [
            Obx(() {
              return Checkbox(
                value: controller.isFeatured,
                onChanged: (value) => controller.isFeatured = value ?? false,
              );
            }),
            const Text('Feature this job (appears in featured section)'),
          ],
        ),
      ],
    );
  }

  /// Build preview mode
  Widget _buildPreviewMode(ThemeData theme) {
    // Implementation will be added in the next update
    return Center(
      child: Text(
        'Preview mode coming soon',
        style: theme.textTheme.headlineSmall,
      ),
    );
  }

  /// Validate the current step
  bool _validateCurrentStep() {
    switch (controller.currentStep) {
      case 0:
        return controller.titleController.text.isNotEmpty &&
            controller.jobTypeController.text.isNotEmpty &&
            controller.locationController.text.isNotEmpty;
      case 1:
        // Validate salary as a number
        final salary = int.tryParse(controller.salaryController.text);
        if (salary == null || salary <= 0) {
          Get.snackbar(
            'Validation Error',
            'Please enter a valid salary amount (numeric value greater than 0)',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }

        return controller.experienceController.text.isNotEmpty &&
            controller.educationController.text.isNotEmpty &&
            controller.industryController.text.isNotEmpty;
      case 2:
        return controller.descriptionController.text.isNotEmpty &&
            controller.requirementsController.text.isNotEmpty &&
            controller.responsibilitiesController.text.isNotEmpty;
      case 3:
        return controller.skillsController.text.isNotEmpty;
      default:
        return true;
    }
  }

  /// Select date for application deadline
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.applicationDeadline ??
          DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.applicationDeadline = picked;
    }
  }

  /// Submit the form
  Future<void> _submitForm() async {
    if (!_validateCurrentStep()) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = isEditing
        ? await controller.updateJobPosting()
        : await controller.createJobPosting();

    if (success) {
      Get.back<void>();
    }
  }
}
