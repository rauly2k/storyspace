import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App-wide text styles using Google Fonts
/// Headers: Quicksand (playful, rounded)
/// Body: Nunito (readable, friendly)
class AppTextStyles {
  AppTextStyles._();

  // ==================== DISPLAY STYLES ====================

  static TextStyle displayLarge = GoogleFonts.quicksand(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.quicksand(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.quicksand(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // ==================== HEADLINE STYLES ====================

  static TextStyle headlineLarge = GoogleFonts.quicksand(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.quicksand(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.quicksand(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // ==================== TITLE STYLES ====================

  static TextStyle titleLarge = GoogleFonts.quicksand(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.quicksand(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  // ==================== BODY STYLES ====================

  static TextStyle bodyLarge = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  // ==================== LABEL STYLES ====================

  static TextStyle labelLarge = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  // ==================== AGE-SPECIFIC STORY TEXT STYLES ====================

  /// Story text for Sprout (Ages 3-5): Large, easy to read
  static TextStyle storySprout = GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.8,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Story text for Explorer (Ages 6-8): Medium, balanced
  static TextStyle storyExplorer = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.4,
    color: AppColors.textPrimary,
  );

  /// Story text for Visionary (Ages 9-12): Standard, more text
  static TextStyle storyVisionary = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  // ==================== BUTTON STYLES ====================

  static TextStyle button = GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  static TextStyle buttonSmall = GoogleFonts.quicksand(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  // ==================== SPECIAL STYLES ====================

  static TextStyle caption = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  static TextStyle overline = GoogleFonts.nunito(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  // ==================== UTILITY METHODS ====================

  /// Get story text style based on age bucket
  static TextStyle getStoryTextStyle(String ageBucket) {
    switch (ageBucket.toLowerCase()) {
      case 'sprout':
        return storySprout;
      case 'explorer':
        return storyExplorer;
      case 'visionary':
        return storyVisionary;
      default:
        return storyExplorer;
    }
  }

  /// Get color variant of any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get bold variant of any text style
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  /// Get italic variant of any text style
  static TextStyle italic(TextStyle style) {
    return style.copyWith(fontStyle: FontStyle.italic);
  }
}
