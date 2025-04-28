import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ThemeController controller;

  setUp(() {
    // Set up SharedPreferences mock
    SharedPreferences.setMockInitialValues({});

    // Initialize GetX
    Get.reset();

    // Create controller
    controller = ThemeController();
    Get.put(controller);
  });

  tearDown(Get.reset);

  group('ThemeController', () {
    testWidgets('initial theme is light', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Container(),
        ),
      );

      expect(controller.isDarkMode, isFalse);
      expect(controller.theme, equals(AppTheme.lightTheme));
    });

    testWidgets('toggleTheme changes theme mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Container(),
        ),
      );

      // Initially light
      expect(controller.isDarkMode, isFalse);

      // Toggle to dark
      controller.toggleTheme();
      await tester.pump();
      expect(controller.isDarkMode, isTrue);
      expect(controller.theme, equals(AppTheme.darkTheme));

      // Toggle back to light
      controller.toggleTheme();
      await tester.pump();
      expect(controller.isDarkMode, isFalse);
      expect(controller.theme, equals(AppTheme.lightTheme));
    });

    testWidgets('setLightMode sets theme to light',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Container(),
        ),
      );

      // Set to dark first
      controller.setDarkMode();
      await tester.pump();
      expect(controller.isDarkMode, isTrue);

      // Then set to light
      controller.setLightMode();
      await tester.pump();
      expect(controller.isDarkMode, isFalse);
      expect(controller.theme, equals(AppTheme.lightTheme));
    });

    testWidgets('setDarkMode sets theme to dark', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Container(),
        ),
      );

      // Initially light
      expect(controller.isDarkMode, isFalse);

      // Set to dark
      controller.setDarkMode();
      await tester.pump();
      expect(controller.isDarkMode, isTrue);
      expect(controller.theme, equals(AppTheme.darkTheme));
    });
  });
}
