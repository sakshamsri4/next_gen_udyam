import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('lightTheme has correct properties', () {
      final theme = AppTheme.lightTheme;

      // Test basic theme properties
      expect(theme.brightness, equals(Brightness.light));
      expect(theme.primaryColor, equals(AppTheme.electricBlue));
      expect(theme.scaffoldBackgroundColor, equals(AppTheme.lightGray));

      // Test color scheme
      expect(theme.colorScheme.primary, equals(AppTheme.electricBlue));
      expect(theme.colorScheme.secondary, equals(AppTheme.lavender));
      expect(theme.colorScheme.error, equals(AppTheme.coralRed));

      // Test app bar theme
      expect(theme.appBarTheme.backgroundColor, equals(AppTheme.electricBlue));
      expect(theme.appBarTheme.foregroundColor, equals(AppTheme.pureWhite));
      expect(theme.appBarTheme.elevation, equals(0));

      // Test button themes
      final elevatedButtonStyle = theme.elevatedButtonTheme.style;
      expect(
        elevatedButtonStyle?.backgroundColor?.resolve({}),
        equals(AppTheme.electricBlue),
      );
      expect(
        elevatedButtonStyle?.foregroundColor?.resolve({}),
        equals(AppTheme.pureWhite),
      );

      // Test card theme
      expect(theme.cardTheme.color, equals(AppTheme.pureWhite));
      expect(theme.cardTheme.elevation, equals(2));

      // Test text theme
      expect(theme.textTheme.displayLarge?.color, equals(AppTheme.navyBlue));
      expect(theme.textTheme.bodyLarge?.color, equals(AppTheme.navyBlue));
    });

    test('darkTheme has correct properties', () {
      final theme = AppTheme.darkTheme;

      // Test basic theme properties
      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.primaryColor, equals(AppTheme.electricBlue));
      expect(theme.scaffoldBackgroundColor, equals(AppTheme.navyBlue));

      // Test color scheme
      expect(theme.colorScheme.primary, equals(AppTheme.electricBlue));
      expect(theme.colorScheme.secondary, equals(AppTheme.lavender));
      expect(theme.colorScheme.error, equals(AppTheme.coralRed));

      // Test app bar theme
      expect(
          theme.appBarTheme.backgroundColor, equals(const Color(0xFF1A2138)));
      expect(theme.appBarTheme.foregroundColor, equals(AppTheme.pureWhite));
      expect(theme.appBarTheme.elevation, equals(0));

      // Test button themes
      final elevatedButtonStyle = theme.elevatedButtonTheme.style;
      expect(
        elevatedButtonStyle?.backgroundColor?.resolve({}),
        equals(AppTheme.electricBlue),
      );
      expect(
        elevatedButtonStyle?.foregroundColor?.resolve({}),
        equals(AppTheme.pureWhite),
      );

      // Test card theme
      expect(theme.cardTheme.color, equals(const Color(0xFF1A2138)));
      expect(theme.cardTheme.elevation, equals(2));

      // Test text theme
      expect(theme.textTheme.displayLarge?.color, equals(AppTheme.pureWhite));
      expect(theme.textTheme.bodyLarge?.color, equals(AppTheme.pureWhite));
    });

    test('color constants have correct values', () {
      // Primary colors
      expect(AppTheme.navyBlue, equals(const Color(0xFF0A1126)));
      expect(AppTheme.electricBlue, equals(const Color(0xFF3D63FF)));
      expect(AppTheme.mintGreen, equals(const Color(0xFF00A651)));
      expect(AppTheme.coralRed, equals(const Color(0xFFE63946)));
      expect(AppTheme.pureWhite, equals(const Color(0xFFFFFFFF)));

      // Secondary colors
      expect(AppTheme.slateGray, equals(const Color(0xFF6C757D)));
      expect(AppTheme.lavender, equals(const Color(0xFF7F5AF0)));
      expect(AppTheme.teal, equals(const Color(0xFF2EC4B6)));
      expect(AppTheme.amber, equals(const Color(0xFFFF9F1C)));
      expect(AppTheme.lightGray, equals(const Color(0xFFF8F9FA)));
    });
  });
}
