import 'package:flutter/material.dart';

/// This is a patched version of the fl_chart package to fix the issue with
/// MediaQuery.boldTextOverride
class FlChartPatch {
  /// Patch the fl_chart package by replacing the problematic methods
  static void apply() {
    // This is a no-op method that will be called at app startup
    // The actual patching is done by importing this file and using
    // the patched methods
  }

  /// Patched version of getThemeAwareTextStyle from fl_chart
  static TextStyle getThemeAwareTextStyle(
    BuildContext context,
    TextStyle? providedStyle,
  ) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final effectiveTextStyle =
        providedStyle?.merge(defaultTextStyle.style) ?? defaultTextStyle.style;
    return effectiveTextStyle;
  }
}
