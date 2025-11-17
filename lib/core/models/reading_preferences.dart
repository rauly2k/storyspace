import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_preferences.freezed.dart';
part 'reading_preferences.g.dart';

/// Reading preferences for story viewer customization
@freezed
abstract class ReadingPreferences with _$ReadingPreferences {
  const factory ReadingPreferences({
    @Default(ReadingFontSize.medium) ReadingFontSize fontSize,
    @Default(ReadingTheme.light) ReadingTheme theme,
    @Default(1.0) double textScale,
  }) = _ReadingPreferences;

  factory ReadingPreferences.fromJson(Map<String, dynamic> json) =>
      _$ReadingPreferencesFromJson(json);
}

/// Font size options for reading
enum ReadingFontSize {
  small,
  medium,
  large;

  String get label {
    switch (this) {
      case ReadingFontSize.small:
        return 'A-';
      case ReadingFontSize.medium:
        return 'A';
      case ReadingFontSize.large:
        return 'A+';
    }
  }

  double get scale {
    switch (this) {
      case ReadingFontSize.small:
        return 0.85;
      case ReadingFontSize.medium:
        return 1.0;
      case ReadingFontSize.large:
        return 1.2;
    }
  }
}

/// Background theme options for reading
enum ReadingTheme {
  light,
  sepia,
  dark;

  String get label {
    switch (this) {
      case ReadingTheme.light:
        return 'Light';
      case ReadingTheme.sepia:
        return 'Sepia';
      case ReadingTheme.dark:
        return 'Dark';
    }
  }
}
