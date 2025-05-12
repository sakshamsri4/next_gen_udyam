import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A widget for displaying a search history item
class SearchHistoryItem extends StatelessWidget {
  /// Constructor
  const SearchHistoryItem({
    required this.item,
    required this.onTap,
    required this.onDelete,
    this.accentColor,
    super.key,
  });

  /// Search history item
  final SearchHistory item;

  /// Callback when the item is tapped
  final VoidCallback onTap;

  /// Callback when the delete button is tapped
  final VoidCallback onDelete;

  /// Accent color for the item
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use the provided accent color or default to employee blue
    final color = accentColor ?? RoleThemes.employeePrimary;

    return Card(
      elevation: 0,
      color: color.withAlpha(15), // Very light background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: color.withAlpha(50),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.clockRotateLeft,
          size: 16,
          color: color,
        ),
        title: Text(
          item.query,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Searched ${_getTimeAgo(item.timestamp)}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(
            FontAwesomeIcons.xmark,
            color: color,
          ),
          onPressed: onDelete,
          iconSize: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Get a human-readable time ago string
  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}
