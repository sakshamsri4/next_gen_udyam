import 'dart:io';
import 'package:flutter/foundation.dart';

/// This script monkey patches the fl_chart package to fix the issue with
/// MediaQuery.boldTextOverride
void monkeyPatchFlChart() {
  // Path to the utils.dart file in the fl_chart package
  const flChartUtilsPath =
      '/Users/sakshamsrivastava/.pub-cache/hosted/pub.dev/fl_chart-0.36.4/lib/src/utils/utils.dart';

  // Read the file
  final file = File(flChartUtilsPath);
  if (!file.existsSync()) {
    debugPrint('Could not find fl_chart utils.dart file at $flChartUtilsPath');
    return;
  }

  // Read the content
  final content = file.readAsStringSync();

  // Check if the file contains the problematic code
  if (content.contains('MediaQuery.boldTextOverride')) {
    // Replace the problematic code
    final newContent = content
        .replaceAll(
          'if (MediaQuery.boldTextOverride(context)) {',
          // Removed MediaQuery.boldTextOverride check as it is not available
          // in newer Flutter versions
          '// if (MediaQuery.boldTextOverride(context)) {',
        )
        .replaceAll(
          'effectiveTextStyle = effectiveTextStyle!.merge(const TextStyle('
              ' fontWeight: FontWeight.bold));',
          // Disabled bold text style merge
          '// effectiveTextStyle = effectiveTextStyle!.merge(const TextStyle('
              ' fontWeight: FontWeight.bold));',
        );

    // Write the new content
    file.writeAsStringSync(newContent);
    debugPrint('Successfully patched fl_chart package');
  } else {
    debugPrint(
      'The fl_chart package does not contain the problematic code '
      'or has already been patched',
    );
  }
}
