import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/job_posting/controllers/job_posting_controller.dart';
import 'package:next_gen/core/theme/role_themes.dart';

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
    final theme = Get.theme;
    const primaryColor = RoleThemes.employerPrimary;

    return Column(
      children: [
        // Templates section
        if (!isEditing) ...[
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: primaryColor.withAlpha(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    HeroIcon(
                      HeroIcons.documentDuplicate,
                      color: primaryColor,
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Job Templates',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Start with a template to save time. Select a template to pre-fill the form.',
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: 12.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTemplateCard(
                        title: 'Software Engineer',
                        description:
                            'Full-stack developer with React and Node.js',
                        onTap: () => _applyTemplate('software_engineer'),
                        theme: theme,
                      ),
                      SizedBox(width: 12.w),
                      _buildTemplateCard(
                        title: 'Product Manager',
                        description: 'Product strategy and roadmap planning',
                        onTap: () => _applyTemplate('product_manager'),
                        theme: theme,
                      ),
                      SizedBox(width: 12.w),
                      _buildTemplateCard(
                        title: 'UI/UX Designer',
                        description: 'User experience and interface design',
                        onTap: () => _applyTemplate('designer'),
                        theme: theme,
                      ),
                      SizedBox(width: 12.w),
                      _buildTemplateCard(
                        title: 'Marketing Specialist',
                        description: 'Digital marketing and growth strategies',
                        onTap: () => _applyTemplate('marketing'),
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],

        // Job Title
        TextField(
          controller: controller.titleController,
          decoration: const InputDecoration(
            labelText: 'Job Title',
            hintText: 'e.g. Senior Software Engineer',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
                activeColor: primaryColor,
              );
            }),
            const Text('This is a remote position'),
          ],
        ),
      ],
    );
  }

  /// Build a template card
  Widget _buildTemplateCard({
    required String title,
    required String description,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 180.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: theme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Use Template',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: RoleThemes.employerPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4.w),
                HeroIcon(
                  HeroIcons.arrowRight,
                  size: 14.r,
                  color: RoleThemes.employerPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Apply a template to the form
  void _applyTemplate(String templateId) {
    switch (templateId) {
      case 'software_engineer':
        controller.titleController.text = 'Software Engineer';
        controller.jobTypeController.text = 'Full-time';
        controller.locationController.text = 'San Francisco, CA';
        controller.isRemote = true;
        controller.salaryController.text = '120000';
        controller.experienceController.text = '3-5 years';
        controller.educationController.text =
            "Bachelor's Degree in Computer Science";
        controller.industryController.text = 'Technology';
        controller.descriptionController.text =
            'We are looking for a skilled Software Engineer to join our development team. You will be responsible for developing and maintaining high-quality applications.';
        controller.requirementsController.text =
            "Bachelor's degree in Computer Science or related field\nAt least 3 years of experience in software development\nProficiency in JavaScript, React, and Node.js\nExperience with RESTful APIs and microservices\nFamiliarity with agile development methodologies";
        controller.responsibilitiesController.text =
            'Design and develop high-quality software applications\nCollaborate with cross-functional teams\nWrite clean, maintainable, and efficient code\nTroubleshoot, debug, and upgrade existing systems\nStay up-to-date with emerging trends and technologies';
        controller.skillsController.text =
            'JavaScript, React, Node.js, RESTful APIs, Git, Agile';
        controller.benefitsController.text =
            'Competitive salary and equity\nHealth, dental, and vision insurance\nFlexible work hours\nRemote work options\n401(k) matching';

      case 'product_manager':
        controller.titleController.text = 'Product Manager';
        controller.jobTypeController.text = 'Full-time';
        controller.locationController.text = 'New York, NY';
        controller.isRemote = true;
        controller.salaryController.text = '130000';
        controller.experienceController.text = '4-6 years';
        controller.educationController.text =
            "Bachelor's Degree in Business or related field";
        controller.industryController.text = 'Technology';
        controller.descriptionController.text =
            'We are seeking an experienced Product Manager to lead our product development efforts. You will be responsible for defining product strategy and roadmap.';
        controller.requirementsController.text =
            "Bachelor's degree in Business, Computer Science, or related field\nAt least 4 years of experience in product management\nStrong analytical and problem-solving skills\nExcellent communication and leadership abilities\nExperience with agile methodologies";
        controller.responsibilitiesController.text =
            'Define product vision, strategy, and roadmap\nGather and prioritize product requirements\nWork closely with engineering, design, and marketing teams\nAnalyze market trends and competition\nDrive product launches and measure success';
        controller.skillsController.text =
            'Product Strategy, Roadmapping, User Research, Agile, Data Analysis, A/B Testing';
        controller.benefitsController.text =
            'Competitive salary and equity\nHealth, dental, and vision insurance\nFlexible work hours\nRemote work options\n401(k) matching';

      case 'designer':
        controller.titleController.text = 'UI/UX Designer';
        controller.jobTypeController.text = 'Full-time';
        controller.locationController.text = 'Seattle, WA';
        controller.isRemote = true;
        controller.salaryController.text = '110000';
        controller.experienceController.text = '2-4 years';
        controller.educationController.text =
            "Bachelor's Degree in Design or related field";
        controller.industryController.text = 'Technology';
        controller.descriptionController.text =
            'We are looking for a talented UI/UX Designer to create amazing user experiences. You will be responsible for the design and visual appearance of our products.';
        controller.requirementsController.text =
            "Bachelor's degree in Design, HCI, or related field\nAt least 2 years of experience in UI/UX design\nProficiency with design tools like Figma and Adobe Creative Suite\nStrong portfolio demonstrating UI/UX projects\nUnderstanding of user-centered design principles";
        controller.responsibilitiesController.text =
            'Create wireframes, prototypes, and high-fidelity designs\nConduct user research and usability testing\nCollaborate with product and engineering teams\nDesign intuitive and visually appealing interfaces\nDevelop and maintain design systems';
        controller.skillsController.text =
            'Figma, Adobe XD, Sketch, Prototyping, User Research, Visual Design, Interaction Design';
        controller.benefitsController.text =
            'Competitive salary and equity\nHealth, dental, and vision insurance\nFlexible work hours\nRemote work options\n401(k) matching';

      case 'marketing':
        controller.titleController.text = 'Marketing Specialist';
        controller.jobTypeController.text = 'Full-time';
        controller.locationController.text = 'Chicago, IL';
        controller.isRemote = true;
        controller.salaryController.text = '85000';
        controller.experienceController.text = '2-4 years';
        controller.educationController.text =
            "Bachelor's Degree in Marketing or related field";
        controller.industryController.text = 'Technology';
        controller.descriptionController.text =
            'We are seeking a Marketing Specialist to help grow our brand and acquire new customers. You will be responsible for implementing marketing strategies across various channels.';
        controller.requirementsController.text =
            "Bachelor's degree in Marketing, Communications, or related field\nAt least 2 years of experience in digital marketing\nExperience with social media marketing and content creation\nFamiliarity with SEO/SEM and analytics tools\nStrong written and verbal communication skills";
        controller.responsibilitiesController.text =
            'Develop and execute marketing campaigns\nManage social media accounts and create engaging content\nTrack and analyze marketing metrics\nOptimize campaigns for better performance\nCollaborate with design and product teams';
        controller.skillsController.text =
            'Digital Marketing, Social Media, Content Creation, SEO/SEM, Google Analytics, Email Marketing';
        controller.benefitsController.text =
            'Competitive salary and equity\nHealth, dental, and vision insurance\nFlexible work hours\nRemote work options\n401(k) matching';
    }

    // Show success message
    Get.snackbar(
      'Template Applied',
      'The $templateId template has been applied. You can still edit all fields.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: RoleThemes.employerPrimary,
      colorText: Colors.white,
    );
  }

  /// Build job details step
  Widget _buildJobDetailsStep() {
    const primaryColor = RoleThemes.employerPrimary;

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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  /// Build requirements and responsibilities step
  Widget _buildRequirementsStep() {
    const primaryColor = RoleThemes.employerPrimary;

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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  /// Build additional information step
  Widget _buildAdditionalInfoStep() {
    const primaryColor = RoleThemes.employerPrimary;

    return Column(
      children: [
        // Skills
        TextField(
          controller: controller.skillsController,
          decoration: const InputDecoration(
            labelText: 'Skills',
            hintText: 'Enter skills separated by commas',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Application Deadline
        Obx(() {
          // Format the date if available
          final displayText = controller.applicationDeadline != null
              ? DateFormat('yyyy-MM-dd').format(controller.applicationDeadline!)
              : '';
          const primaryColor = RoleThemes.employerPrimary;

          return GestureDetector(
            onTap: () => _selectDate(Get.context!),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Application Deadline',
                hintText: displayText.isEmpty ? 'Select a deadline' : null,
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                suffixIcon: const HeroIcon(
                  HeroIcons.calendar,
                  color: primaryColor,
                ),
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
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: RoleThemes.employerPrimary.withAlpha(15),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: RoleThemes.employerPrimary.withAlpha(30),
            ),
          ),
          child: Row(
            children: [
              Obx(() {
                return Checkbox(
                  value: controller.isFeatured,
                  onChanged: (value) => controller.isFeatured = value ?? false,
                  activeColor: RoleThemes.employerPrimary,
                );
              }),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feature this job',
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Featured jobs appear at the top of search results and get more visibility',
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const HeroIcon(
                HeroIcons.star,
                color: Color(0xFFFFB800),
                size: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build preview mode
  Widget _buildPreviewMode(ThemeData theme) {
    const primaryColor = RoleThemes.employerPrimary;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with job title and type
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.titleController.text.isEmpty
                            ? 'Job Title'
                            : controller.titleController.text,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.headlineSmall?.color,
                        ),
                      ),
                    ),
                    if (controller.isFeatured)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800).withAlpha(30),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const HeroIcon(
                              HeroIcons.star,
                              size: 16,
                              color: Color(0xFFFFB800),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Featured',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFFB800),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Job details
                Row(
                  children: [
                    _buildJobDetailItem(
                      icon: controller.isRemote
                          ? HeroIcons.globeAlt
                          : HeroIcons.mapPin,
                      text: controller.isRemote
                          ? 'Remote'
                          : (controller.locationController.text.isEmpty
                              ? 'Location'
                              : controller.locationController.text),
                      theme: theme,
                    ),
                    SizedBox(width: 16.w),
                    _buildJobDetailItem(
                      icon: HeroIcons.briefcase,
                      text: controller.jobTypeController.text.isEmpty
                          ? 'Job Type'
                          : controller.jobTypeController.text,
                      theme: theme,
                    ),
                    SizedBox(width: 16.w),
                    _buildJobDetailItem(
                      icon: HeroIcons.currencyDollar,
                      text: controller.salaryController.text.isEmpty
                          ? 'Salary'
                          : '\$${controller.salaryController.text}',
                      theme: theme,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Job description
          _buildPreviewSection(
            title: 'Job Description',
            content: controller.descriptionController.text.isEmpty
                ? 'No description provided'
                : controller.descriptionController.text,
            theme: theme,
          ),
          SizedBox(height: 24.h),

          // Requirements
          _buildPreviewSection(
            title: 'Requirements',
            content: controller.requirementsController.text.isEmpty
                ? 'No requirements provided'
                : controller.requirementsController.text,
            theme: theme,
            isList: true,
          ),
          SizedBox(height: 24.h),

          // Responsibilities
          _buildPreviewSection(
            title: 'Responsibilities',
            content: controller.responsibilitiesController.text.isEmpty
                ? 'No responsibilities provided'
                : controller.responsibilitiesController.text,
            theme: theme,
            isList: true,
          ),
          SizedBox(height: 24.h),

          // Skills
          _buildPreviewSection(
            title: 'Skills',
            content: controller.skillsController.text.isEmpty
                ? 'No skills provided'
                : controller.skillsController.text,
            theme: theme,
            isSkills: true,
          ),
          SizedBox(height: 24.h),

          // Additional information
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                // Experience
                _buildInfoRow(
                  label: 'Experience',
                  value: controller.experienceController.text.isEmpty
                      ? 'Not specified'
                      : controller.experienceController.text,
                  theme: theme,
                ),
                SizedBox(height: 8.h),

                // Education
                _buildInfoRow(
                  label: 'Education',
                  value: controller.educationController.text.isEmpty
                      ? 'Not specified'
                      : controller.educationController.text,
                  theme: theme,
                ),
                SizedBox(height: 8.h),

                // Industry
                _buildInfoRow(
                  label: 'Industry',
                  value: controller.industryController.text.isEmpty
                      ? 'Not specified'
                      : controller.industryController.text,
                  theme: theme,
                ),
                SizedBox(height: 8.h),

                // Application deadline
                _buildInfoRow(
                  label: 'Application Deadline',
                  value: controller.applicationDeadline == null
                      ? 'Not specified'
                      : DateFormat('MMMM d, yyyy')
                          .format(controller.applicationDeadline!),
                  theme: theme,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Benefits
          if (controller.benefitsController.text.isNotEmpty)
            _buildPreviewSection(
              title: 'Benefits',
              content: controller.benefitsController.text,
              theme: theme,
              isList: true,
            ),

          // Apply button
          SizedBox(height: 32.h),
          Center(
            child: ElevatedButton(
              onPressed: null, // Disabled in preview
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 16.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Apply Now',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              'This is a preview. The actual job posting may look different.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withAlpha(128),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a job detail item for the preview
  Widget _buildJobDetailItem({
    required HeroIcons icon,
    required String text,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        HeroIcon(
          icon,
          size: 18.r,
          color: RoleThemes.employerPrimary,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Build a preview section
  Widget _buildPreviewSection({
    required String title,
    required String content,
    required ThemeData theme,
    bool isList = false,
    bool isSkills = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          if (isList) ...[
            ...content
                .split('\n')
                .where((line) => line.trim().isNotEmpty)
                .map((line) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroIcon(
                      HeroIcons.chevronRight,
                      size: 16.r,
                      color: RoleThemes.employerPrimary,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        line.trim(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ] else if (isSkills) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: content
                  .split(',')
                  .where((skill) => skill.trim().isNotEmpty)
                  .map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: RoleThemes.employerPrimary.withAlpha(20),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    skill.trim(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: RoleThemes.employerPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            Text(
              content,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  /// Build an info row for the preview
  Widget _buildInfoRow({
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            '$label:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
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
