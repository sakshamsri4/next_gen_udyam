import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for user activity logs
class UserActivityLog {
  /// Creates a new user activity log
  UserActivityLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.timestamp,
    this.details,
    this.ipAddress,
    this.deviceInfo,
  });

  /// Factory constructor from Firestore document
  factory UserActivityLog.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return UserActivityLog(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      action: data['action'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      details: data['details'] as Map<String, dynamic>?,
      ipAddress: data['ipAddress'] as String?,
      deviceInfo: data['deviceInfo'] as String?,
    );
  }

  /// Unique identifier for the log entry
  final String id;

  /// User ID associated with this activity
  final String userId;

  /// Action performed (e.g., "login", "profile_update", "role_change")
  final String action;

  /// When the action occurred
  final DateTime timestamp;

  /// Additional details about the action
  final Map<String, dynamic>? details;

  /// IP address from which the action was performed
  final String? ipAddress;

  /// Device information
  final String? deviceInfo;

  /// Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'action': action,
      'timestamp': Timestamp.fromDate(timestamp),
      'details': details,
      'ipAddress': ipAddress,
      'deviceInfo': deviceInfo,
    };
  }

  /// Get a formatted time string
  String get formattedTime {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} '
        '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  /// Get a relative time string (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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
