import 'package:hive/hive.dart';

/// Hive type ID for ThemeSettings
const themeSettingsTypeId = 1;

/// Hive box name for theme settings
const themeSettingsBoxName = 'theme_settings';

/// Model class for theme settings stored in Hive
class ThemeSettings {
  /// Constructor for ThemeSettings
  ThemeSettings({this.isDarkMode = true});

  /// Whether the app is in dark mode
  bool isDarkMode;

  /// Creates a copy of this ThemeSettings with specified attributes replaced
  ThemeSettings copyWith({bool? isDarkMode}) {
    return ThemeSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
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
      isDarkMode: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isDarkMode);
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
