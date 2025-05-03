import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/neopop_theme.dart';

void main() {
  group('Theme Classes', () {
    test('AppTheme has correct color constants', () {
      // This test indirectly tests the private constructor
      // by accessing static members
      expect(AppTheme.navyBlue, const Color(0xFF0A1126));
      expect(AppTheme.electricBlue, const Color(0xFF3D63FF));
      expect(AppTheme.mintGreen, const Color(0xFF00A651));
      expect(AppTheme.coralRed, const Color(0xFFE63946));
      expect(AppTheme.pureWhite, const Color(0xFFFFFFFF));
    });

    test('NeoPopTheme has correct button styles', () {
      // This test indirectly tests the private constructor
      // by accessing static methods
      expect(NeoPopTheme.primaryButtonStyle, isNotNull);
      expect(NeoPopTheme.secondaryButtonStyle, isNotNull);
      expect(NeoPopTheme.dangerButtonStyle, isNotNull);
      expect(NeoPopTheme.successButtonStyle, isNotNull);
      expect(NeoPopTheme.flatButtonStyle, isNotNull);
      expect(NeoPopTheme.cardStyle, isNotNull);
    });
  });
}
