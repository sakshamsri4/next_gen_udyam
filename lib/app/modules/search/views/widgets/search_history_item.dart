import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A widget for displaying a search history item
class SearchHistoryItem extends StatelessWidget {
  /// Constructor
  const SearchHistoryItem({
    required this.item,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// Search history item
  final SearchHistory item;

  /// Callback when the item is tapped
  final VoidCallback onTap;

  /// Callback when the delete button is tapped
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: const Icon(
        FontAwesomeIcons.clockRotateLeft,
        size: 16,
        color: AppTheme.slateGray,
      ),
      title: Text(
        item.query,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: IconButton(
        icon: const Icon(FontAwesomeIcons.xmark),
        onPressed: onDelete,
        iconSize: 16,
        color: AppTheme.slateGray,
      ),
      onTap: onTap,
    );
  }
}
