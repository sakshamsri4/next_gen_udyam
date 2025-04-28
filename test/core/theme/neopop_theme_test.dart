import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/neopop_theme.dart';

void main() {
  group('NeoPopTheme', () {
    testWidgets('styles are created correctly', (WidgetTester tester) async {
      late BuildContext testContext;

      // Create a widget with a Builder to capture the context
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            cardTheme: const CardTheme(color: Colors.white),
          ),
          home: Builder(
            builder: (BuildContext context) {
              testContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );

      // Now we have a valid context to use in our tests

      // Test primary button style
      final primaryStyle = NeoPopTheme.primaryButtonStyle(context: testContext);
      expect(primaryStyle.color, equals(AppTheme.electricBlue));
      expect(primaryStyle.depth, equals(8));
      expect(primaryStyle.border, isNotNull);

      // Test secondary button style
      final secondaryStyle =
          NeoPopTheme.secondaryButtonStyle(context: testContext);
      expect(secondaryStyle.color, equals(AppTheme.lavender));
      expect(secondaryStyle.depth, equals(5));
      expect(secondaryStyle.border, isNotNull);

      // Test danger button style
      final dangerStyle = NeoPopTheme.dangerButtonStyle(context: testContext);
      expect(dangerStyle.color, equals(AppTheme.coralRed));
      expect(dangerStyle.depth, equals(5));
      expect(dangerStyle.border, isNotNull);

      // Test success button style
      final successStyle = NeoPopTheme.successButtonStyle(context: testContext);
      expect(successStyle.color, equals(AppTheme.mintGreen));
      expect(successStyle.depth, equals(5));
      expect(successStyle.border, isNotNull);

      // Test flat button style
      final flatStyle = NeoPopTheme.flatButtonStyle(context: testContext);
      expect(flatStyle.depth, equals(0));
      expect(flatStyle.border, isNotNull);

      // Test card style
      final cardStyle = NeoPopTheme.cardStyle(context: testContext);
      expect(cardStyle.depth, equals(2));
      expect(cardStyle.border, isNotNull);

      // Test custom parameters
      const customColor = Colors.purple;
      const customDepth = 10.0;
      const customParentColor = Colors.yellow;

      final customStyle = NeoPopTheme.primaryButtonStyle(
        context: testContext,
        color: customColor,
        depth: customDepth,
        parentColor: customParentColor,
      );

      expect(customStyle.color, equals(customColor));
      expect(customStyle.depth, equals(customDepth));
      expect(customStyle.parentColor, equals(customParentColor));
    });
  });
}
