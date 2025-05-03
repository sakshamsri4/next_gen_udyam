import 'package:hive/hive.dart';

/// Hive type ID for ThemeSettings
const themeSettingsTypeId = 1;

/// Hive box name for theme settings
const themeSettingsBoxName = 'theme_settings';

/// Model class for theme settings stored in Hive
@HiveType(typeId: themeSettingsTypeId)
class ThemeSettings extends HiveObject {
  /// Constructor for ThemeSettings
  ThemeSettings({
    this.isDarkMode = true,
    this.useMaterial3 = true,
    this.useHighContrast = false,
  });

  /// Whether the app is in dark mode
  @HiveField(0)
  bool isDarkMode;

  /// Whether to use Material 3
  @HiveField(1)
  bool useMaterial3;

  /// Whether to use high contrast
  @HiveField(2)
  bool useHighContrast;

  /// Creates a copy of this ThemeSettings with specified attributes replaced
  ThemeSettings copyWith({
    bool? isDarkMode,
    bool? useMaterial3,
    bool? useHighContrast,
  }) {
    return ThemeSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      useHighContrast: useHighContrast ?? this.useHighContrast,
    );
  }

  @override
  String toString() {
    return 'ThemeSettings(isDarkMode: $isDarkMode, '
        'useMaterial3: $useMaterial3, '
        'useHighContrast: $useHighContrast)';
  }
}

/// Adapter for ThemeSettings to be used with Hive
class ThemeSettingsAdapter extends TypeAdapter<ThemeSettings> {
  @override
  final int typeId = themeSettingsTypeId;

  @override
  ThemeSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeSettings(
      isDarkMode: fields[0] as bool? ?? true,
      useMaterial3: fields[1] as bool? ?? true,
      useHighContrast: fields[2] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.useMaterial3)
      ..writeByte(2)
      ..write(obj.useHighContrast);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
