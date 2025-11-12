import 'package:flutter/material.dart';

/// App-wide color palette with kid-friendly, vibrant colors
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFFF6B9D); // Pink
  static const Color secondary = Color(0xFF4ECDC4); // Turquoise
  static const Color accent = Color(0xFFFFC75F); // Yellow

  // Age Bucket Colors
  static const Color sproutColor = Color(0xFF95E1D3); // Ages 3-5 (Mint)
  static const Color explorerColor = Color(0xFF5DADE2); // Ages 6-8 (Blue)
  static const Color visionaryColor = Color(0xFF9B59B6); // Ages 9-12 (Purple)

  // Background Colors
  static const Color background = Color(0xFFFFF8F0); // Warm cream
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Light gray

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50); // Dark blue-gray
  static const Color textSecondary = Color(0xFF7F8C8D); // Medium gray
  static const Color textLight = Color(0xFFBDC3C7); // Light gray

  // Status Colors
  static const Color success = Color(0xFF2ECC71); // Green
  static const Color error = Color(0xFFE74C3C); // Red
  static const Color warning = Color(0xFFF39C12); // Orange
  static const Color info = Color(0xFF3498DB); // Blue

  // Subscription Tier Colors
  static const Color free = Color(0xFF95A5A6); // Gray
  static const Color premium = Color(0xFFE67E22); // Orange
  static const Color premiumPlus = Color(0xFFF1C40F); // Gold

  // Genre Colors (for story categories)
  static const Color genreAdventure = Color(0xFFE74C3C); // Red
  static const Color genreFantasy = Color(0xFF9B59B6); // Purple
  static const Color genreSciFi = Color(0xFF3498DB); // Blue
  static const Color genreMystery = Color(0xFF34495E); // Dark gray
  static const Color genreFunny = Color(0xFFF39C12); // Orange
  static const Color genreMagical = Color(0xFFAB47BC); // Magenta
  static const Color genreSchool = Color(0xFF26A69A); // Teal
  static const Color genreSpooky = Color(0xFF5D4037); // Brown

  // Overlay Colors
  static const Color overlay = Color(0x80000000); // Black 50%
  static const Color overlayLight = Color(0x40000000); // Black 25%

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFFFD93D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Get color for age bucket
  static Color getAgeBucketColor(String ageBucket) {
    switch (ageBucket.toLowerCase()) {
      case 'sprout':
        return sproutColor;
      case 'explorer':
        return explorerColor;
      case 'visionary':
        return visionaryColor;
      default:
        return primary;
    }
  }

  /// Get color for genre
  static Color getGenreColor(String genre) {
    switch (genre.toLowerCase()) {
      case 'adventure':
        return genreAdventure;
      case 'fantasy':
        return genreFantasy;
      case 'sci-fi':
      case 'scifi':
        return genreSciFi;
      case 'mystery':
        return genreMystery;
      case 'funny':
        return genreFunny;
      case 'magical':
        return genreMagical;
      case 'school':
        return genreSchool;
      case 'spooky':
        return genreSpooky;
      default:
        return primary;
    }
  }

  /// Get color for subscription tier
  static Color getSubscriptionColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'free':
        return free;
      case 'premium':
        return premium;
      case 'premium+':
      case 'premiumplus':
        return premiumPlus;
      default:
        return free;
    }
  }
}
