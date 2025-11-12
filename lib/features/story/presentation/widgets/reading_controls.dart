import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/reading_preferences.dart';
import '../../../../core/providers/reading_preferences_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Reading controls for story viewer (font size, theme)
class ReadingControls extends ConsumerWidget {
  final Color accentColor;

  const ReadingControls({
    super.key,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(readingPreferencesNotifierProvider);
    final notifier = ref.read(readingPreferencesNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: notifier.getBackgroundColor(),
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          // Font size controls
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.text_fields,
                  size: 20,
                  color: notifier.getTextColor().withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                ...ReadingFontSize.values.map((size) {
                  final isSelected = preferences.fontSize == size;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: ChoiceChip(
                      label: Text(
                        size.label,
                        style: TextStyle(
                          fontSize: size == ReadingFontSize.small
                              ? 12
                              : size == ReadingFontSize.medium
                                  ? 14
                                  : 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => notifier.setFontSize(size),
                      selectedColor: accentColor.withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? accentColor
                            : notifier.getTextColor(),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? accentColor
                            : Colors.grey.shade300,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 30,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),

          // Theme controls
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                size: 20,
                color: notifier.getTextColor().withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              ...ReadingTheme.values.map((theme) {
                final isSelected = preferences.theme == theme;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ChoiceChip(
                    label: Text(theme.label),
                    selected: isSelected,
                    onSelected: (_) => notifier.setTheme(theme),
                    selectedColor: accentColor.withOpacity(0.3),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? accentColor
                          : notifier.getTextColor(),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? accentColor
                          : Colors.grey.shade300,
                    ),
                    backgroundColor: _getThemeColor(theme),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Color _getThemeColor(ReadingTheme theme) {
    return switch (theme) {
      ReadingTheme.light => Colors.white,
      ReadingTheme.sepia => const Color(0xFFF4ECD8),
      ReadingTheme.dark => const Color(0xFF1E1E1E),
    };
  }
}
