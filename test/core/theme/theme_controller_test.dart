import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/theme_controller.dart';

// Create a mock StorageService for testing
class MockStorageService extends Fake implements StorageService {
  final ThemeSettings _themeSettings = ThemeSettings();

  @override
  ThemeSettings getThemeSettings() {
    return _themeSettings;
  }

  @override
  Future<void> saveThemeSettings(ThemeSettings settings) async {
    _themeSettings.isDarkMode = settings.isDarkMode;
    _themeSettings.useMaterial3 = settings.useMaterial3;
    _themeSettings.useHighContrast = settings.useHighContrast;
  }
}

// Create a mock LoggerService for testing
class MockLoggerService extends Fake implements LoggerService {
  @override
  void i(String message, [dynamic error, StackTrace? stackTrace]) {}

  @override
  void d(String message, [dynamic error, StackTrace? stackTrace]) {}

  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ThemeController controller;
  late MockStorageService mockStorageService;
  late MockLoggerService mockLoggerService;

  setUp(() {
    // Create mocks
    mockStorageService = MockStorageService();
    mockLoggerService = MockLoggerService();

    // Reset mock state
    mockStorageService.getThemeSettings().isDarkMode = true;

    // Initialize GetX
    Get.reset();

    // Create controller with mocks
    controller =
        ThemeController.forTesting(mockStorageService, mockLoggerService);
    Get.put(controller);
  });

  tearDown(Get.reset);

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
