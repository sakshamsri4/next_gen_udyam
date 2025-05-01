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
      expect(theme.primaryColor, equals(AppTheme.brightElectricBlue));
      expect(theme.scaffoldBackgroundColor, equals(AppTheme.deepNavy));

      // Test color scheme
      expect(theme.colorScheme.primary, equals(AppTheme.brightElectricBlue));
      expect(theme.colorScheme.secondary, equals(AppTheme.brightLavender));
      expect(theme.colorScheme.error, equals(AppTheme.neonPink));

      // Test app bar theme
      expect(
        theme.appBarTheme.backgroundColor,
        equals(AppTheme.darkSurface2),

      );
      expect(theme.appBarTheme.foregroundColor, equals(AppTheme.pureWhite));
      expect(theme.appBarTheme.elevation, equals(0));

      // Test button themes
      final elevatedButtonStyle = theme.elevatedButtonTheme.style;
      expect(
        elevatedButtonStyle?.backgroundColor?.resolve({}),
        equals(AppTheme.brightElectricBlue),
      );
      expect(
        elevatedButtonStyle?.foregroundColor?.resolve({}),
        equals(AppTheme.pureWhite),
      );

      // Test card theme
      expect(theme.cardTheme.color, equals(AppTheme.darkSurface2));
      expect(theme.cardTheme.elevation, equals(8));

      // Test text theme
      expect(theme.textTheme.displayLarge?.color, equals(AppTheme.pureWhite));
      expect(theme.textTheme.bodyLarge?.color, equals(AppTheme.offWhite));
    });

    test('color constants have correct values', () {
      // Primary colors
      expect(AppTheme.navyBlue, equals(const Color(0xFF0A1126)));
      expect(AppTheme.deepNavy, equals(const Color(0xFF050A17)));
      expect(AppTheme.electricBlue, equals(const Color(0xFF3D63FF)));
      expect(AppTheme.brightElectricBlue, equals(const Color(0xFF5A7FFF)));
      expect(AppTheme.mintGreen, equals(const Color(0xFF00A651)));
      expect(AppTheme.neonGreen, equals(const Color(0xFF00E676)));
      expect(AppTheme.coralRed, equals(const Color(0xFFE63946)));
      expect(AppTheme.neonPink, equals(const Color(0xFFFF2D55)));
      expect(AppTheme.pureWhite, equals(const Color(0xFFFFFFFF)));
      expect(AppTheme.offWhite, equals(const Color(0xFFF0F0F0)));

      // Secondary colors
      expect(AppTheme.slateGray, equals(const Color(0xFF6C757D)));
      expect(AppTheme.darkSlateGray, equals(const Color(0xFF343A40)));
      expect(AppTheme.lavender, equals(const Color(0xFF7F5AF0)));
      expect(AppTheme.brightLavender, equals(const Color(0xFF9D7FFF)));
      expect(AppTheme.teal, equals(const Color(0xFF2EC4B6)));
      expect(AppTheme.neonTeal, equals(const Color(0xFF00F5D4)));
      expect(AppTheme.amber, equals(const Color(0xFFFF9F1C)));
      expect(AppTheme.neonYellow, equals(const Color(0xFFFFD60A)));
      expect(AppTheme.lightGray, equals(const Color(0xFFF8F9FA)));

      // Surface colors
      expect(AppTheme.darkSurface1, equals(const Color(0xFF121827)));
      expect(AppTheme.darkSurface2, equals(const Color(0xFF1A2138)));
      expect(AppTheme.darkSurface3, equals(const Color(0xFF232A40)));
    });
  });
}
