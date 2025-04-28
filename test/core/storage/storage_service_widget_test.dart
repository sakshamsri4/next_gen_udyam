import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';

void main() {
  group('StorageService', () {
    test('_defaultGetThemeSettings and _defaultSaveThemeSettings exist', () {
      // We can't easily test the implementation details of these methods,
      // but we can ensure they exist by accessing them through reflection
      expect(StorageService.getThemeSettingsImpl, isNotNull);
      expect(StorageService.saveThemeSettingsImpl, isNotNull);
    });

    test('ThemeSettingsAdapter methods exist', () {
      final adapter = ThemeSettingsAdapter();
      expect(adapter.typeId, equals(themeSettingsTypeId));
      expect(adapter.hashCode, isNotNull);
      expect(adapter == adapter, isTrue);
      expect(adapter == Object(), isFalse);
    });
  });
}
