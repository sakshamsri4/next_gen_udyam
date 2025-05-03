import 'dart:io';

/// This script directly patches the fl_chart package to fix the issue with MediaQuery.boldTextOverride
void patchFlChart() {
  try {
    // Path to the utils.dart file in the fl_chart package
    const flChartUtilsPath =
        '/Users/sakshamsrivastava/.pub-cache/hosted/pub.dev/fl_chart-0.36.4/lib/src/utils/utils.dart';

    // Read the file
    final file = File(flChartUtilsPath);
    if (!file.existsSync()) {
      // ignore: avoid_print
      print('Could not find fl_chart utils.dart file at $flChartUtilsPath');
      return;
    }

    // Read the content
    final content = file.readAsStringSync();

    // Replace the problematic method with a fixed version
    final fixedContent = content.replaceAll(
      '''
TextStyle getThemeAwareTextStyle(BuildContext context, TextStyle? providedStyle) {
  final defaultTextStyle = DefaultTextStyle.of(context);
  TextStyle? effectiveTextStyle;
  if (MediaQuery.boldTextOverride(context)) {
    effectiveTextStyle = effectiveTextStyle!.merge(const TextStyle(fontWeight: FontWeight.bold));
  }
  return effectiveTextStyle ??= defaultTextStyle.style;
}''',
      '''
TextStyle getThemeAwareTextStyle(BuildContext context, TextStyle? providedStyle) {
  final defaultTextStyle = DefaultTextStyle.of(context);
  final effectiveTextStyle = providedStyle?.merge(defaultTextStyle.style) ?? defaultTextStyle.style;
  return effectiveTextStyle;
}''',
    );

    // Write the fixed content back to the file
    file.writeAsStringSync(fixedContent);

    // ignore: avoid_print
    print('Successfully patched fl_chart package');
  } catch (e) {
    // ignore: avoid_print
    print('Error patching fl_chart package: $e');
  }
}
