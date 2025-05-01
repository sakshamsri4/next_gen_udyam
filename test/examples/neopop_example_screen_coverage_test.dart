import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/examples/neopop_example_screen.dart';

// This test file is specifically designed to ensure coverage of the
// NeoPopExampleScreen class.

void main() {
  group('NeoPopExampleScreen Coverage', () {
    testWidgets('renders all buttons and sections',
        (WidgetTester tester) async {
      // Set a larger surface size to ensure all widgets are visible
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: NeoPopExampleScreen(),
        ),
      );

      // Verify all section titles are rendered
      expect(find.text('NeoPop Examples'), findsOneWidget);
      expect(find.text('Elevated Buttons'), findsOneWidget);
      expect(find.text('Flat Buttons'), findsOneWidget);
      expect(find.text('Buttons with Borders'), findsOneWidget);
      expect(find.text('Special Effects'), findsOneWidget);
      expect(find.text('Adjacent Buttons'), findsOneWidget);

      // Verify all buttons are rendered
      expect(find.text('Basic Button'), findsOneWidget);
      expect(find.text('Deep Button'), findsOneWidget);
      expect(find.text('Flat Button'), findsOneWidget);
      expect(find.text('Bordered Button'), findsOneWidget);
      expect(find.text('Flat Bordered Button'), findsOneWidget);
      expect(find.text('Shimmer Button'), findsOneWidget);
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
      expect(find.text('Top Button'), findsOneWidget);
      expect(find.text('Bottom Button'), findsOneWidget);

      // Tap each button to trigger the callbacks
      await tester.tap(find.text('Shimmer Button'));
      await tester.pumpAndSettle();
      expect(find.text('Shimmer button pressed!'), findsOneWidget);

      // Dismiss the snackbar
      await tester.pumpAndSettle(const Duration(seconds: 4));

      await tester.tap(find.text('Left'));
      await tester.pumpAndSettle();
      expect(find.text('Left button pressed!'), findsOneWidget);

      // Dismiss the snackbar
      await tester.pumpAndSettle(const Duration(seconds: 4));

      await tester.tap(find.text('Right'));
      await tester.pumpAndSettle();
      expect(find.text('Right button pressed!'), findsOneWidget);

      // Dismiss the snackbar
      await tester.pumpAndSettle(const Duration(seconds: 4));

      await tester.tap(find.text('Top Button'));
      await tester.pumpAndSettle();
      expect(find.text('Top button pressed!'), findsOneWidget);

      // Dismiss the snackbar
      await tester.pumpAndSettle(const Duration(seconds: 4));

      await tester.tap(find.text('Bottom Button'));
      await tester.pumpAndSettle();
      expect(find.text('Bottom button pressed!'), findsOneWidget);
    });
  });
}
