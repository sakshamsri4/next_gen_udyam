import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applicant_review/controllers/applicant_review_controller.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A view for comparing applicants
class ApplicantComparisonView extends GetView<ApplicantReviewController> {
  /// Creates an applicant comparison view
  const ApplicantComparisonView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    return Obx(() {
      final selectedApplications = controller.selectedApplications;

      if (selectedApplications.isEmpty) {
        return const Center(
          child: Text('No applicants selected for comparison'),
        );
      }

      return Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comparing ${selectedApplications.length} Applicants',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        controller.exitComparisonMode();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryColor),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                      child: Row(
                        children: [
                          HeroIcon(
                            HeroIcons.arrowLeft,
                            size: 16.r,
                            color: primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          const Text(
                            'Back',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ElevatedButton(
                      onPressed: () {
                        controller.saveComparison();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                      child: Row(
                        children: [
                          HeroIcon(
                            HeroIcons.bookmark,
                            size: 16.r,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          const Text('Save Comparison'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Comparison table
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Applicant headers
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category column
                      SizedBox(
                        width: 120.w,
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: Text(
                            'Categories',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Applicant columns
                      ...selectedApplications.map((application) {
                        return Expanded(
                          child: _buildApplicantHeader(
                            application,
                            theme,
                            controller.comparison?.getRating(application.id) ??
                                0,
                            (rating) {
                              controller.updateApplicantRating(
                                application.id,
                                rating,
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Divider
                  Divider(height: 1, thickness: 1, color: theme.dividerColor),
                  SizedBox(height: 16.h),

                  // Basic information
                  _buildComparisonSection(
                    title: 'Basic Information',
                    rows: [
                      ComparisonRow(
                        label: 'Applied On',
                        valueGetter: (app) =>
                            DateFormat('MMM d, yyyy').format(app.appliedAt),
                      ),
                      ComparisonRow(
                        label: 'Status',
                        valueGetter: (app) => _getStatusText(app.status),
                        colorGetter: (app) => _getStatusColor(app.status),
                      ),
                      ComparisonRow(
                        label: 'Resume',
                        valueGetter: (app) => app.resumeUrl != null
                            ? 'Available'
                            : 'Not available',
                        iconGetter: (app) => app.resumeUrl != null
                            ? HeroIcons.documentText
                            : null,
                      ),
                      ComparisonRow(
                        label: 'Cover Letter',
                        valueGetter: (app) => app.coverLetter.isNotEmpty
                            ? 'Available'
                            : 'Not available',
                        iconGetter: (app) => app.coverLetter.isNotEmpty
                            ? HeroIcons.document
                            : null,
                      ),
                    ],
                    applications: selectedApplications,
                    theme: theme,
                  ),
                  SizedBox(height: 24.h),

                  // Skills and experience
                  _buildComparisonSection(
                    title: 'Skills & Experience',
                    rows: [
                      ComparisonRow(
                        label: 'Resume',
                        valueGetter: (app) => app.resumeUrl != null
                            ? 'Available'
                            : 'Not available',
                        isHighlight: true,
                      ),
                      ComparisonRow(
                        label: 'Cover Letter',
                        valueGetter: (app) => app.coverLetter.isNotEmpty
                            ? 'Available'
                            : 'Not available',
                        isHighlight: true,
                      ),
                      ComparisonRow(
                        label: 'Phone',
                        valueGetter: (app) =>
                            app.phone.isNotEmpty ? app.phone : 'Not provided',
                      ),
                      ComparisonRow(
                        label: 'Application Date',
                        valueGetter: (app) =>
                            DateFormat('MMM d, yyyy').format(app.appliedAt),
                        isHighlight: true,
                      ),
                    ],
                    applications: selectedApplications,
                    theme: theme,
                  ),
                  SizedBox(height: 24.h),

                  // Interview and feedback
                  _buildComparisonSection(
                    title: 'Interview & Feedback',
                    rows: [
                      ComparisonRow(
                        label: 'Interview Date',
                        valueGetter: (app) => app.interviewDate != null
                            ? DateFormat('MMM d, yyyy')
                                .format(app.interviewDate!)
                            : 'Not scheduled',
                        iconGetter: (app) => app.interviewDate != null
                            ? HeroIcons.calendar
                            : null,
                      ),
                      ComparisonRow(
                        label: 'Feedback',
                        valueGetter: (app) =>
                            app.feedback == null || app.feedback!.isEmpty
                                ? 'No feedback'
                                : app.feedback!,
                        isMultiline: true,
                      ),
                    ],
                    applications: selectedApplications,
                    theme: theme,
                  ),
                  SizedBox(height: 24.h),

                  // Notes
                  Text(
                    'Comparison Notes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Add notes about this comparison...',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      controller.updateComparisonNotes(value);
                    },
                    controller: TextEditingController(
                      text: controller.comparison?.notes ?? '',
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  /// Build an applicant header
  Widget _buildApplicantHeader(
    ApplicationModel application,
    ThemeData theme,
    int rating,
    void Function(int) onRatingChanged,
  ) {
    const primaryColor = RoleThemes.employerPrimary;

    return Container(
      padding: EdgeInsets.all(12.w),
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
        children: [
          // Applicant avatar
          CircleAvatar(
            radius: 24.r,
            backgroundColor: primaryColor.withAlpha(30),
            child: Text(
              application.name.isNotEmpty
                  ? application.name[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Applicant name
          Text(
            application.name.isNotEmpty
                ? application.name
                : 'Unnamed Applicant',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),

          // Applicant email
          Text(
            application.email,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),

          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: HeroIcon(
                  index < rating ? HeroIcons.star : HeroIcons.star,
                  size: 20.r,
                  color: index < rating ? Colors.amber : Colors.grey,
                ),
                onPressed: () => onRatingChanged(index + 1),
                constraints: BoxConstraints(
                  minWidth: 24.w,
                  minHeight: 24.h,
                ),
                padding: EdgeInsets.zero,
                splashRadius: 20.r,
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build a comparison section
  Widget _buildComparisonSection({
    required String title,
    required List<ComparisonRow> rows,
    required List<ApplicationModel> applications,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ...rows.map((row) {
          return _buildComparisonRow(
            row: row,
            applications: applications,
            theme: theme,
          );
        }),
      ],
    );
  }

  /// Build a comparison row
  Widget _buildComparisonRow({
    required ComparisonRow row,
    required List<ApplicationModel> applications,
    required ThemeData theme,
  }) {
    const primaryColor = RoleThemes.employerPrimary;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label column
          SizedBox(
            width: 120.w,
            child: Text(
              row.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Value columns
          ...applications.map((application) {
            final value = row.valueGetter(application);
            final color = row.colorGetter?.call(application);
            final icon = row.iconGetter?.call(application);

            return Expanded(
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: row.isHighlight
                      ? primaryColor.withAlpha(10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (icon != null) ...[
                      HeroIcon(
                        icon,
                        size: 16.r,
                        color: color ?? primaryColor,
                      ),
                      SizedBox(width: 4.w),
                    ],
                    Expanded(
                      child: Text(
                        value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontWeight: row.isHighlight ? FontWeight.bold : null,
                        ),
                        maxLines: row.isMultiline ? 3 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Get text for a status
  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.reviewed:
        return 'Reviewed';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offered:
        return 'Offered';
      case ApplicationStatus.hired:
        return 'Hired';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  /// Get color for a status
  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.blue;
      case ApplicationStatus.reviewed:
        return Colors.orange;
      case ApplicationStatus.shortlisted:
        return Colors.purple;
      case ApplicationStatus.interview:
        return Colors.indigo;
      case ApplicationStatus.offered:
        return Colors.green;
      case ApplicationStatus.hired:
        return Colors.teal;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.withdrawn:
        return Colors.grey;
    }
  }
}

/// Model for a comparison row
class ComparisonRow {
  /// Creates a comparison row
  const ComparisonRow({
    required this.label,
    required this.valueGetter,
    this.colorGetter,
    this.iconGetter,
    this.isHighlight = false,
    this.isMultiline = false,
  });

  /// Row label
  final String label;

  /// Function to get the value for an application
  final String Function(ApplicationModel) valueGetter;

  /// Function to get the color for an application
  final Color? Function(ApplicationModel)? colorGetter;

  /// Function to get the icon for an application
  final HeroIcons? Function(ApplicationModel)? iconGetter;

  /// Whether to highlight this row
  final bool isHighlight;

  /// Whether this row contains multiline text
  final bool isMultiline;
}
