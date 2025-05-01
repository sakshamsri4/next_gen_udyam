import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/theme_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ThemeController controller;
  final mockThemeSettings = ThemeSettings();

  // Store original implementations
  final originalInitImpl = StorageService.initImpl;
  final originalGetThemeSettingsImpl = StorageService.getThemeSettingsImpl;
  final originalSaveThemeSettingsImpl = StorageService.saveThemeSettingsImpl;

  setUp(() {
    // Replace implementations with test versions
    StorageService.initImpl = () async {
      // No-op for testing
    };

    StorageService.getThemeSettingsImpl = () {
      return mockThemeSettings;
    };

    StorageService.saveThemeSettingsImpl = (settings) async {
      mockThemeSettings.isDarkMode = settings.isDarkMode;
    };

    // Reset mock state
    mockThemeSettings.isDarkMode = false;

    // Initialize GetX
    Get.reset();

    // Create controller
    controller = ThemeController();
    Get.put(controller);
  });

  tearDown(() {
    // Restore original implementations
    StorageService.initImpl = originalInitImpl;
    StorageService.getThemeSettingsImpl = originalGetThemeSettingsImpl;
    StorageService.saveThemeSettingsImpl = originalSaveThemeSettingsImpl;

    Get.reset();
  });

  group('ThemeController', () {
    testWidgets('initial theme is dark', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Container(),
        ),
      );

      expect(controller.isDarkMode, isTrue);
      expect(controller.theme, equals(AppTheme.darkTheme));
    });

    testWidgets('toggleTheme changes theme mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Container(),
        ),
      );

      // Initially dark
      expect(controller.isDarkMode, isTrue);

      // Toggle to light
      controller.toggleTheme();
      await tester.pump();
      expect(controller.isDarkMode, isFalse);
      expect(controller.theme, equals(AppTheme.lightTheme));

      // Toggle back to dark
      controller.toggleTheme();
      await tester.pump();
      expect(controller.isDarkMode, isTrue);
      expect(controller.theme, equals(AppTheme.darkTheme));
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

      // Set to light first
      controller.setLightMode();
      await tester.pump();
      expect(controller.isDarkMode, isFalse);

      // Then set to dark
      controller.setDarkMode();
      await tester.pump();
      expect(controller.isDarkMode, isTrue);
      expect(controller.theme, equals(AppTheme.darkTheme));
    });
  });
}
