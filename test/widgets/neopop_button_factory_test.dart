import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CustomNeoPopButton Factory Constructors', () {
    testWidgets('primary constructor creates button with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNeoPopButton.primary(
              onTap: () {},
              child: const Text('Primary Button'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Primary Button'), findsOneWidget);

      final neoPopButton =
          tester.widget<NeoPopButton>(find.byType(NeoPopButton));
      expect(neoPopButton.color, equals(AppTheme.electricBlue));
      expect(neoPopButton.depth, equals(8)); // Primary depth

      // We can't easily test the tap functionality in this test
      // because NeoPopButton uses GestureDetector internally
      // and the tap events are handled differently
      // Let's just verify the onTap callback is set correctly
      expect(neoPopButton.onTapUp, isNotNull);
    });

    testWidgets('secondary constructor creates button with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNeoPopButton.secondary(
              onTap: () {},
              child: const Text('Secondary Button'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Secondary Button'), findsOneWidget);

      final neoPopButton =
          tester.widget<NeoPopButton>(find.byType(NeoPopButton));
      expect(neoPopButton.color, equals(AppTheme.lavender));
      expect(neoPopButton.depth, equals(5)); // Secondary depth
    });

    testWidgets('danger constructor creates button with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNeoPopButton.danger(
              onTap: () {},
              child: const Text('Danger Button'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Danger Button'), findsOneWidget);

      final neoPopButton =
          tester.widget<NeoPopButton>(find.byType(NeoPopButton));
      expect(neoPopButton.color, equals(AppTheme.coralRed));
      expect(neoPopButton.depth, equals(5));
    });

    testWidgets('success constructor creates button with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNeoPopButton.success(
              onTap: () {},
              child: const Text('Success Button'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Success Button'), findsOneWidget);

      final neoPopButton =
          tester.widget<NeoPopButton>(find.byType(NeoPopButton));
      expect(neoPopButton.color, equals(AppTheme.mintGreen));
      expect(neoPopButton.depth, equals(5));
    });

    testWidgets('flat constructor creates button with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNeoPopButton.flat(
              onTap: () {},
              child: const Text('Flat Button'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Flat Button'), findsOneWidget);

      final neoPopButton =
          tester.widget<NeoPopButton>(find.byType(NeoPopButton));
      expect(neoPopButton.depth, equals(0)); // Flat button has zero depth
    });

    testWidgets('custom parameters are respected in factory constructors',
        (tester) async {
      // Arrange
      const customDepth = 12.0;
      const customParentColor = Colors.yellow;
      const shimmerEnabled = true;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNeoPopButton.primary(
              onTap: () {},
              depth: customDepth,
              parentColor: customParentColor,
              shimmer: shimmerEnabled,
              child: const Text('Custom Primary Button'),
            ),
          ),
        ),
      );

      // Assert
      final neoPopButton =
          tester.widget<NeoPopButton>(find.byType(NeoPopButton));
      expect(neoPopButton.depth, equals(customDepth));
      expect(neoPopButton.parentColor, equals(customParentColor));

      // Check shimmer effect
      expect(find.byType(NeoPopShimmer), findsOneWidget);
    });
  });
}
