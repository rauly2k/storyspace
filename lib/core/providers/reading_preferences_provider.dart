import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/reading_preferences.dart';

part 'reading_preferences_provider.g.dart';

/// Provider for reading preferences
@riverpod
class ReadingPreferencesNotifier extends _$ReadingPreferencesNotifier {
  @override
  ReadingPreferences build() {
    return const ReadingPreferences();
  }

  /// Update font size
  void setFontSize(ReadingFontSize fontSize) {
    state = state.copyWith(fontSize: fontSize, textScale: fontSize.scale);
  }

  /// Update theme
  void setTheme(ReadingTheme theme) {
    state = state.copyWith(theme: theme);
  }

  /// Toggle font size (cycle through small -> medium -> large)
  void toggleFontSize() {
    final newSize = switch (state.fontSize) {
      ReadingFontSize.small => ReadingFontSize.medium,
      ReadingFontSize.medium => ReadingFontSize.large,
      ReadingFontSize.large => ReadingFontSize.small,
    };
    setFontSize(newSize);
  }

  /// Toggle theme (cycle through light -> sepia -> dark)
  void toggleTheme() {
    final newTheme = switch (state.theme) {
      ReadingTheme.light => ReadingTheme.sepia,
      ReadingTheme.sepia => ReadingTheme.dark,
      ReadingTheme.dark => ReadingTheme.light,
    };
    setTheme(newTheme);
  }

  /// Get background color for current theme
  Color getBackgroundColor() {
    return switch (state.theme) {
      ReadingTheme.light => Colors.white,
      ReadingTheme.sepia => const Color(0xFFF4ECD8),
      ReadingTheme.dark => const Color(0xFF1E1E1E),
    };
  }

  /// Get text color for current theme
  Color getTextColor() {
    return switch (state.theme) {
      ReadingTheme.light => Colors.black87,
      ReadingTheme.sepia => const Color(0xFF5D4E37),
      ReadingTheme.dark => Colors.white70,
    };
  }
}
