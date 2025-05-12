import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/app/modules/job_posting/models/job_post_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A widget for communication tools
class CommunicationTools extends StatefulWidget {
  /// Creates a communication tools widget
  ///
  /// [application] is the application to communicate with
  /// [job] is the job posting
  /// [onSendEmail] is called when an email is sent
  /// [onScheduleInterview] is called when an interview is scheduled
  const CommunicationTools({
    required this.application,
    required this.job,
    this.onSendEmail,
    this.onScheduleInterview,
    super.key,
  });

  /// The application to communicate with
  final ApplicationModel application;

  /// The job posting
  final JobPostModel job;

  /// Called when an email is sent
  final void Function(String subject, String body)? onSendEmail;

  /// Called when an interview is scheduled
  final void Function(DateTime date, String notes)? onScheduleInterview;

  @override
  State<CommunicationTools> createState() => _CommunicationToolsState();
}

class _CommunicationToolsState extends State<CommunicationTools>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _interviewNotesController =
      TextEditingController();
  DateTime? _interviewDate;
  TimeOfDay? _interviewTime;
  int _selectedTemplateIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    _interviewNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = RoleThemes.employerPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Communication Tools',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const HeroIcon(HeroIcons.xMark),
                onPressed: () => Get.back<void>(),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Tab bar
          TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            tabs: const [
              Tab(text: 'Email Templates'),
              Tab(text: 'Schedule Interview'),
            ],
          ),
          SizedBox(height: 16.h),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmailTemplatesTab(theme),
                _buildScheduleInterviewTab(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the email templates tab
  Widget _buildEmailTemplatesTab(ThemeData theme) {
    const primaryColor = RoleThemes.employerPrimary;
    final templates = _getEmailTemplates();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template selection
        Text(
          'Select a Template',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              final isSelected = _selectedTemplateIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTemplateIndex = index;
                    _subjectController.text = template.subject;
                    _bodyController.text = template.body;
                  });
                },
                child: Container(
                  width: 150.w,
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withAlpha(30)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? primaryColor : theme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? primaryColor : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        template.description,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),

        // Email form
        Text(
          'Email Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _subjectController,
          decoration: const InputDecoration(
            labelText: 'Subject',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: _bodyController,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: 'Body',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _bodyController.text));
                Get.snackbar(
                  'Copied',
                  'Email body copied to clipboard',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryColor),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              child: Row(
                children: [
                  const HeroIcon(
                    HeroIcons.clipboard,
                    size: 16,
                    color: primaryColor,
                  ),
                  SizedBox(width: 4.w),
                  const Text(
                    'Copy',
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: () {
                if (_subjectController.text.isEmpty ||
                    _bodyController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please fill in both subject and body',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                widget.onSendEmail?.call(
                  _subjectController.text,
                  _bodyController.text,
                );
                Get.back<void>();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              child: Row(
                children: [
                  const HeroIcon(
                    HeroIcons.envelope,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4.w),
                  const Text('Send Email'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build the schedule interview tab
  Widget _buildScheduleInterviewTab(ThemeData theme) {
    const primaryColor = RoleThemes.employerPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and time selection
        Text(
          'Interview Date & Time',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: HeroIcon(HeroIcons.calendar),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  child: Text(
                    _interviewDate == null
                        ? 'Select Date'
                        : DateFormat('MMM d, yyyy').format(_interviewDate!),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    prefixIcon: HeroIcon(HeroIcons.clock),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  child: Text(
                    _interviewTime == null
                        ? 'Select Time'
                        : _interviewTime!.format(context),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Notes
        Text(
          'Interview Notes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _interviewNotesController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Notes',
            hintText: 'Add any additional information about the interview',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _interviewDate = null;
                  _interviewTime = null;
                  _interviewNotesController.clear();
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryColor),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              child: const Text(
                'Clear',
                style: TextStyle(color: primaryColor),
              ),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: () {
                if (_interviewDate == null || _interviewTime == null) {
                  Get.snackbar(
                    'Error',
                    'Please select both date and time',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                final interviewDateTime = DateTime(
                  _interviewDate!.year,
                  _interviewDate!.month,
                  _interviewDate!.day,
                  _interviewTime!.hour,
                  _interviewTime!.minute,
                );
                widget.onScheduleInterview?.call(
                  interviewDateTime,
                  _interviewNotesController.text,
                );
                Get.back<void>();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              child: Row(
                children: [
                  const HeroIcon(
                    HeroIcons.calendar,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4.w),
                  const Text('Schedule Interview'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Select a date
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _interviewDate ?? now.add(const Duration(days: 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: RoleThemes.employerPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _interviewDate = date;
      });
    }
  }

  /// Select a time
  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _interviewTime ?? const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: RoleThemes.employerPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        _interviewTime = time;
      });
    }
  }

  /// Get email templates
  List<EmailTemplate> _getEmailTemplates() {
    final applicantName = widget.application.name;
    final jobTitle = widget.job.title;
    const companyName = 'Your Company'; // TODO(dev): Get from company profile

    return [
      EmailTemplate(
        name: 'Application Received',
        description: 'Confirm receipt of application',
        subject: 'Application Received: $jobTitle',
        body: '''
Dear $applicantName,

Thank you for applying for the $jobTitle position at $companyName. We have received your application and are currently reviewing it.

We appreciate your interest in joining our team and will be in touch soon regarding next steps.

Best regards,
Recruitment Team
$companyName''',
      ),
      EmailTemplate(
        name: 'Interview Invitation',
        description: 'Invite candidate for an interview',
        subject: 'Interview Invitation: $jobTitle',
        body: '''
Dear $applicantName,

We are pleased to inform you that we would like to invite you for an interview for the $jobTitle position at $companyName.

Please let us know your availability for an interview in the coming week. We are flexible and can accommodate your schedule.

Looking forward to meeting you.

Best regards,
Recruitment Team
$companyName''',
      ),
      EmailTemplate(
        name: 'Additional Information',
        description: 'Request additional information',
        subject: 'Additional Information Required: $jobTitle Application',
        body: '''
Dear $applicantName,

Thank you for your application for the $jobTitle position at $companyName.

We would like to request some additional information to help us better evaluate your candidacy. Could you please provide:

1. [Specific information needed]
2. [Any other details required]

Please reply to this email with the requested information at your earliest convenience.

Thank you for your cooperation.

Best regards,
Recruitment Team
$companyName''',
      ),
      EmailTemplate(
        name: 'Application Status',
        description: 'Update on application status',
        subject: 'Update on Your $jobTitle Application',
        body: '''
Dear $applicantName,

I wanted to provide you with an update on your application for the $jobTitle position at $companyName.

Your application has been reviewed by our team, and we are currently in the process of [current stage of the process].

We expect to [next steps and timeline].

Thank you for your patience and continued interest in $companyName.

Best regards,
Recruitment Team
$companyName''',
      ),
      EmailTemplate(
        name: 'Rejection',
        description: 'Polite rejection letter',
        subject: 'Regarding Your Application for $jobTitle',
        body: '''
Dear $applicantName,

Thank you for your interest in the $jobTitle position at $companyName and for taking the time to apply.

After careful consideration of all applications, we regret to inform you that we have decided to move forward with other candidates whose qualifications more closely match our current needs.

We appreciate your interest in $companyName and wish you the best in your job search.

Best regards,
Recruitment Team
$companyName''',
      ),
    ];
  }
}

/// Email template model
class EmailTemplate {
  /// Creates an email template
  const EmailTemplate({
    required this.name,
    required this.description,
    required this.subject,
    required this.body,
  });

  /// Template name
  final String name;

  /// Template description
  final String description;

  /// Email subject
  final String subject;

  /// Email body
  final String body;
}
