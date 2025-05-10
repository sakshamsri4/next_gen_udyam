import 'package:intl/intl.dart';

/// Utility class for formatting dates consistently across the app
class DateFormatter {
  /// Private constructor to prevent instantiation
  DateFormatter._();

  /// Format a date as a relative time (e.g., "2 days ago", "Just now")
  ///
  /// This is used for timestamps in activity feeds, comments, etc.
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.isNegative) {
      // Handle future dates
      return DateFormat('MMM d, yyyy').format(date);
    } else if (difference.inDays > 30) {
      return DateFormat('MMM d, yyyy').format(date);
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format a date as a compact relative time (e.g., "2d ago", "Just now")
  ///
  /// This is used for timestamps in cards and other compact UI elements.
  static String formatCompactRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.isNegative) {
      // Handle future dates
      return DateFormat('MMM d').format(date);
    } else if (difference.inDays > 30) {
      return DateFormat('MMM d').format(date);
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }

  /// Format a date as a friendly date (e.g., "today", "yesterday", "2 days ago")
  ///
  /// This is used for dates in job listings and other content.
  static String formatFriendlyDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  /// Format a date as a standard date (e.g., "Jan 1, 2023")
  ///
  /// This is used for dates in profiles, job details, etc.
  static String formatStandardDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Format a date as a short date (e.g., "Jan 1")
  ///
  /// This is used for dates in compact UI elements.
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
}
