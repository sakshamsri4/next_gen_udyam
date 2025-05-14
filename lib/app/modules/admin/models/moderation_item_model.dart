import 'package:cloud_firestore/cloud_firestore.dart';

/// Status of a moderation item
enum ModerationStatus {
  /// Pending review
  pending,

  /// Approved
  approved,

  /// Rejected
  rejected,

  /// Requires additional information
  needsInfo,
}

/// Priority level for moderation items
enum ModerationPriority {
  /// Low priority
  low,

  /// Medium priority
  medium,

  /// High priority
  high,

  /// Urgent priority
  urgent,
}

/// Type of content being moderated
enum ModerationItemType {
  /// Job posting
  jobPosting,

  /// User profile
  userProfile,

  /// Company profile
  companyProfile,

  /// User report
  userReport,

  /// Other content
  other,
}

/// Model for moderation items
class ModerationItem {
  /// Creates a new moderation item
  ModerationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.submittedBy,
    required this.submittedAt,
    required this.status,
    required this.priority,
    this.contentId,
    this.reason,
    this.notes,
    this.reviewedBy,
    this.reviewedAt,
  });

  /// Factory constructor from Firestore document
  factory ModerationItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return ModerationItem(
      id: doc.id,
      type: data['type'] as String? ?? '',
      title: data['title'] as String? ?? '',
      submittedBy: data['submittedBy'] as String? ?? '',
      submittedAt:
          (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] as String? ?? 'Pending',
      priority: data['priority'] as String? ?? 'Medium',
      contentId: data['contentId'] as String?,
      reason: data['reason'] as String?,
      notes: data['notes'] as String?,
      reviewedBy: data['reviewedBy'] as String?,
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Unique identifier
  final String id;

  /// Type of content (e.g., "Job Posting", "User Profile")
  final String type;

  /// Title of the content
  final String title;

  /// User who submitted the content
  final String submittedBy;

  /// When the content was submitted
  final DateTime submittedAt;

  /// Current status (e.g., "Pending", "Approved", "Rejected")
  final String status;

  /// Priority level (e.g., "High", "Medium", "Low")
  final String priority;

  /// ID of the content being moderated
  final String? contentId;

  /// Reason for moderation
  final String? reason;

  /// Additional notes
  final String? notes;

  /// Admin who reviewed the item
  final String? reviewedBy;

  /// When the item was reviewed
  final DateTime? reviewedAt;

  /// Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'submittedBy': submittedBy,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'status': status,
      'priority': priority,
      'contentId': contentId,
      'reason': reason,
      'notes': notes,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
    };
  }

  /// Get a formatted submission time string
  String get formattedSubmissionTime {
    return '${submittedAt.day}/${submittedAt.month}/${submittedAt.year} '
        '${submittedAt.hour}:${submittedAt.minute.toString().padLeft(2, '0')}';
  }

  /// Get a relative time string for submission (e.g., "2 hours ago")
  String get submissionTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(submittedAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
