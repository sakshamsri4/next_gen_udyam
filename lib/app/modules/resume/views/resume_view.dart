import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/resume/controllers/resume_controller.dart';
import 'package:next_gen/app/modules/resume/models/resume_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/role_based_bottom_nav.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';

/// View for the Resume module
class ResumeView extends GetView<ResumeController> {
  /// Constructor
  const ResumeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final navigationController = Get.find<NavigationController>();

    // Create a local scaffold key for this view
    final scaffoldKey = GlobalKey<ScaffoldState>();

    // Set the selected index to the Resume tab (index 3)
    navigationController.selectedIndex.value = 3;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('My Resume'),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.bars3),
          onPressed: () => navigationController.toggleDrawer(scaffoldKey),
        ),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const RoleBasedBottomNav(),
      body: RefreshIndicator(
        onRefresh: controller.refreshResumes,
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          if (controller.resumes.isEmpty) {
            return _buildEmptyState(theme);
          }

          return _buildResumeList(theme, isDarkMode);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.pickAndUploadResume,
        backgroundColor: AppTheme.electricBlue,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Resume icon
            Icon(
              FontAwesomeIcons.fileLines,
              size: 80.sp,
              color: theme.colorScheme.primary,
            ),

            SizedBox(height: 32.h),

            // Title
            Text(
              'Resume Management',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // Description
            Text(
              'Upload and manage your resume to apply for jobs.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 48.h),

            // Upload button
            CustomNeoPopButton.primary(
              onTap: controller.pickAndUploadResume,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: const Text(
                  'Upload Resume',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build resume list
  Widget _buildResumeList(ThemeData theme, bool isDarkMode) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Text(
            'My Resumes',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Resume cards
        ...controller.resumes.map(
          (resume) => _buildResumeCard(resume, theme, isDarkMode),
        ),
      ],
    );
  }

  /// Build resume card
  Widget _buildResumeCard(
    ResumeModel resume,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resume name and default badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    resume.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (resume.isDefault)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.electricBlue.withAlpha(25),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: AppTheme.electricBlue),
                    ),
                    child: Text(
                      'Default',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.electricBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),

            // File type
            Row(
              children: [
                Icon(
                  _getFileTypeIcon(resume.fileType),
                  size: 16.sp,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  resume.fileType?.toUpperCase() ?? 'Unknown',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.access_time,
                  size: 16.sp,
                  color: theme.colorScheme.onSurface.withAlpha(153),
                ),
                SizedBox(width: 8.w),
                Text(
                  DateFormat('MMM d, yyyy').format(resume.uploadedAt),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(153),
                  ),
                ),
              ],
            ),

            // Description
            if (resume.description != null &&
                resume.description!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                resume.description!,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Divider
            SizedBox(height: 16.h),
            const Divider(),
            SizedBox(height: 16.h),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // View button
                OutlinedButton.icon(
                  onPressed: () => controller.viewResume(resume.fileUrl),
                  icon: const Icon(Icons.visibility),
                  label: const Text('View'),
                ),

                // Action buttons
                Row(
                  children: [
                    // Edit button
                    IconButton(
                      onPressed: () => controller.editResumeDetails(resume.id),
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit',
                    ),

                    // Set as default button (if not default)
                    if (!resume.isDefault)
                      IconButton(
                        onPressed: () => controller.setDefaultResume(resume.id),
                        icon: const Icon(Icons.star_outline),
                        tooltip: 'Set as Default',
                      ),

                    // Delete button
                    IconButton(
                      onPressed: () => _showDeleteConfirmation(
                        resume.id,
                        resume.name,
                      ),
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get file type icon
  IconData _getFileTypeIcon(String? fileType) {
    if (fileType == null) {
      return Icons.insert_drive_file;
    }

    switch (fileType.toLowerCase()) {
      case 'pdf':
        return FontAwesomeIcons.filePdf;
      case 'doc':
      case 'docx':
        return FontAwesomeIcons.fileWord;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(String resumeId, String resumeName) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Delete Resume'),
        content: Text(
          'Are you sure you want to delete "$resumeName"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back<void>();
              controller.deleteResume(resumeId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
