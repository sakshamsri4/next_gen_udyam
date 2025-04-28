import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/neopop_theme.dart';

void main() {
  testWidgets('NeoPopTheme styles are created correctly', (tester) async {
    // Build a simple widget to get a BuildContext
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          cardTheme: const CardTheme(color: Colors.white),
        ),
        home: Builder(
          builder: (context) {
            // Test all NeoPopTheme methods
            final primaryStyle =
                NeoPopTheme.primaryButtonStyle(context: context);
            expect(primaryStyle, isNotNull);
            expect(primaryStyle.color, equals(AppTheme.electricBlue));
            expect(primaryStyle.depth, equals(8));

            final secondaryStyle =
                NeoPopTheme.secondaryButtonStyle(context: context);
            expect(secondaryStyle, isNotNull);
            expect(secondaryStyle.color, equals(AppTheme.lavender));
            expect(secondaryStyle.depth, equals(5));

            final dangerStyle = NeoPopTheme.dangerButtonStyle(context: context);
            expect(dangerStyle, isNotNull);
            expect(dangerStyle.color, equals(AppTheme.coralRed));
            expect(dangerStyle.depth, equals(5));

            final successStyle =
                NeoPopTheme.successButtonStyle(context: context);
            expect(successStyle, isNotNull);
            expect(successStyle.color, equals(AppTheme.mintGreen));
            expect(successStyle.depth, equals(5));

            final flatStyle = NeoPopTheme.flatButtonStyle(context: context);
            expect(flatStyle, isNotNull);
            expect(flatStyle.depth, equals(0));

            final cardStyle = NeoPopTheme.cardStyle(context: context);
            expect(cardStyle, isNotNull);
            expect(cardStyle.depth, equals(2));

            // Test with custom parameters
            final customPrimaryStyle = NeoPopTheme.primaryButtonStyle(
              context: context,
              color: Colors.blue,
              depth: 10,
              parentColor: Colors.white,
            );
            expect(customPrimaryStyle.color, equals(Colors.blue));
            expect(customPrimaryStyle.depth, equals(10));
            expect(customPrimaryStyle.parentColor, equals(Colors.white));

            // Test NeoPopButtonStyle constructor
            final border = Border.all();
            final buttonStyle = NeoPopButtonStyle(
              color: Colors.blue,
              depth: 5,
              parentColor: Colors.white,
              border: border,
              grandparentColor: Colors.grey,
            );
            expect(buttonStyle.color, equals(Colors.blue));
            expect(buttonStyle.depth, equals(5));
            expect(buttonStyle.parentColor, equals(Colors.white));
            expect(buttonStyle.border, equals(border));
            expect(buttonStyle.grandparentColor, equals(Colors.grey));

            // Test NeoPopCardStyle constructor
            final cardBorder = Border.all();
            final customCardStyle = NeoPopCardStyle(
              color: Colors.blue,
              depth: 5,
              parentColor: Colors.white,
              border: cardBorder,
              grandparentColor: Colors.grey,
            );
            expect(customCardStyle.color, equals(Colors.blue));
            expect(customCardStyle.depth, equals(5));
            expect(customCardStyle.parentColor, equals(Colors.white));
            expect(customCardStyle.border, equals(cardBorder));
            expect(customCardStyle.grandparentColor, equals(Colors.grey));

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
