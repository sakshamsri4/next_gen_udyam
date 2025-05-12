import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/resume/controllers/resume_controller.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/role_based_bottom_nav.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';

/// View for the Resume Builder
class ResumeBuilderView extends GetView<ResumeController> {
  /// Constructor
  const ResumeBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final navigationController = Get.find<NavigationController>();

    // Create a local scaffold key for this view
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Resume Builder'),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.bars3),
          onPressed: () => navigationController.toggleDrawer(scaffoldKey),
        ),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const RoleBasedBottomNav(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Create a Professional Resume',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Choose a template and customize your resume',
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 24.h),

            // Templates section
            Text(
              'Templates',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildTemplateGrid(theme, isDarkMode),
            SizedBox(height: 32.h),

            // Resume sections
            Text(
              'Resume Sections',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSectionsList(theme, isDarkMode),
          ],
        ),
      ),
    );
  }

  /// Build template grid
  Widget _buildTemplateGrid(ThemeData theme, bool isDarkMode) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      children: [
        _buildTemplateCard(
          theme,
          'Professional',
          'assets/images/resume_template_1.png',
          isSelected: true,
        ),
        _buildTemplateCard(
          theme,
          'Modern',
          'assets/images/resume_template_2.png',
        ),
        _buildTemplateCard(
          theme,
          'Creative',
          'assets/images/resume_template_3.png',
        ),
        _buildTemplateCard(
          theme,
          'Simple',
          'assets/images/resume_template_4.png',
        ),
      ],
    );
  }

  /// Build template card
  Widget _buildTemplateCard(
    ThemeData theme,
    String name,
    String imagePath, {
    bool isSelected = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: isSelected
            ? BorderSide(color: AppTheme.electricBlue, width: 2.w)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _selectTemplate(name),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.description,
                      size: 48.sp,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.electricBlue,
                      size: 20.sp,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build sections list
  Widget _buildSectionsList(ThemeData theme, bool isDarkMode) {
    return Column(
      children: [
        _buildSectionCard(
          theme,
          'Personal Information',
          'Name, contact details, and summary',
          Icons.person,
          isCompleted: true,
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          theme,
          'Education',
          'Academic qualifications and certifications',
          Icons.school,
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          theme,
          'Work Experience',
          'Previous jobs and responsibilities',
          Icons.work,
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          theme,
          'Skills',
          'Technical and soft skills',
          Icons.psychology,
        ),
        SizedBox(height: 24.h),
        CustomNeoPopButton.primary(
          onTap: _generateResume,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: const Text(
              'Generate Resume',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build section card
  Widget _buildSectionCard(
    ThemeData theme,
    String title,
    String description,
    IconData icon, {
    bool isCompleted = false,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () => _editSection(title),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F0FF), // Light blue
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.electricBlue,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                isCompleted ? Icons.check_circle : Icons.edit,
                color: isCompleted ? Colors.green : Colors.grey,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Select template
  void _selectTemplate(String templateName) {
    Get.snackbar(
      'Template Selected',
      'You selected the $templateName template',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Edit section
  void _editSection(String sectionName) {
    Get.snackbar(
      'Edit Section',
      'Editing $sectionName section',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Generate resume
  void _generateResume() {
    Get.snackbar(
      'Generate Resume',
      'Generating resume with selected template and sections',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
