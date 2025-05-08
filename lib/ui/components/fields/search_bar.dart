import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import 'package:next_gen/ui/components/fields/custom_text_field.dart';

/// A search bar component for searching jobs
///
/// This component is a specialized text field for search functionality
class SearchBar extends StatelessWidget {
  /// Creates a search bar
  ///
  /// [controller] is the controller for the search field
  /// [hintText] is the hint text to display when the field is empty
  /// [onChanged] is called when the text changes
  /// [onClear] is called when the clear button is tapped
  /// [autofocus] determines if the field should be focused when displayed
  const SearchBar({
    required this.controller,
    super.key,
    this.hintText = 'Search for jobs...',
    this.onChanged,
    this.onClear,
    this.autofocus = false,
  });

  /// The controller for the search field
  final TextEditingController controller;

  /// The hint text to display when the field is empty
  final String hintText;

  /// Called when the text changes
  final void Function(String)? onChanged;

  /// Called when the clear button is tapped
  final VoidCallback? onClear;

  /// Whether the field should be focused when displayed
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      autofocus: autofocus,
      hintText: hintText,
      isSearchBar: true,
      prefixIcon: HeroIcons.magnifyingGlass,
      suffixIcon: HeroIcons.xMark,
      onChanged: onChanged,
      onSuffixTap: onClear,
    );
  }
}
