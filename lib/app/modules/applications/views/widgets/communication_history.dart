import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Communication history widget for application details
class CommunicationHistory extends StatelessWidget {
  /// Creates a communication history widget
  const CommunicationHistory({
    required this.application,
    super.key,
  });

  /// The application model
  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // For now, we'll use dummy data since the actual communication
    // history is not implemented in the model yet
    final messages = _getDummyMessages(application);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
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
                  'Communication History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const HeroIcon(
                    HeroIcons.chatBubbleLeftRight,
                    style: HeroIconStyle.outline,
                  ),
                  onPressed: () {
                    // This would open a chat interface in a real implementation
                    _showComingSoonMessage(context);
                  },
                  tooltip: 'Open Chat',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            if (messages.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Column(
                    children: [
                      HeroIcon(
                        HeroIcons.chatBubbleBottomCenterText,
                        size: 48.w,
                        color: isDarkMode ? Colors.white38 : Colors.black26,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No messages yet',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDarkMode ? Colors.white54 : Colors.black45,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Messages between you and the employer will appear here',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: messages.length,
                separatorBuilder: (context, index) => Divider(
                  height: 24.h,
                  color: isDarkMode ? Colors.white12 : Colors.black12,
                ),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageItem(context, message, isDarkMode);
                },
              ),

            SizedBox(height: 16.h),

            // Send message button
            Center(
              child: OutlinedButton.icon(
                onPressed: () => _showComingSoonMessage(context),
                icon: const HeroIcon(
                  HeroIcons.paperAirplane,
                  size: 16,
                ),
                label: const Text('Send Message'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: RoleThemes.employeePrimary,
                  side: const BorderSide(color: RoleThemes.employeePrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a message item
  Widget _buildMessageItem(
    BuildContext context,
    Message message,
    bool isDarkMode,
  ) {
    final theme = Theme.of(context);
    final isFromEmployer = message.sender == MessageSender.employer;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        CircleAvatar(
          radius: 20.r,
          backgroundColor: isFromEmployer
              ? Colors.green.withAlpha(50)
              : RoleThemes.employeePrimary.withAlpha(50),
          child: HeroIcon(
            isFromEmployer ? HeroIcons.buildingOffice : HeroIcons.user,
            size: 20.w,
            color: isFromEmployer ? Colors.green : RoleThemes.employeePrimary,
          ),
        ),
        SizedBox(width: 12.w),

        // Message content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isFromEmployer ? 'Employer' : 'You',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isFromEmployer
                          ? Colors.green
                          : RoleThemes.employeePrimary,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, h:mm a').format(message.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Message text
              Text(
                message.text,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Show coming soon message
  void _showComingSoonMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Messaging functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Get dummy messages for the application
  List<Message> _getDummyMessages(ApplicationModel application) {
    // In a real implementation, these would come from a database
    // For now, we'll return an empty list to show the empty state
    return [];

    // Uncomment this to show dummy messages
    /*
    final now = DateTime.now();
    
    return [
      Message(
        sender: MessageSender.employer,
        text: 'Thank you for your application. We are reviewing it and will get back to you soon.',
        timestamp: now.subtract(const Duration(days: 5)),
      ),
      Message(
        sender: MessageSender.applicant,
        text: 'Thank you for considering my application. I look forward to hearing from you.',
        timestamp: now.subtract(const Duration(days: 4)),
      ),
      Message(
        sender: MessageSender.employer,
        text: 'We would like to schedule an interview with you. Are you available next week?',
        timestamp: now.subtract(const Duration(days: 2)),
      ),
      Message(
        sender: MessageSender.applicant,
        text: 'Yes, I am available next week. Please let me know what time works best for you.',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
    ];
    */
  }
}

/// Message model
class Message {
  /// Creates a message
  Message({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  /// Message sender
  final MessageSender sender;

  /// Message text
  final String text;

  /// Message timestamp
  final DateTime timestamp;
}

/// Message sender enum
enum MessageSender {
  /// Employer
  employer,

  /// Applicant
  applicant,
}
