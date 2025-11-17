import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app preferences and local storage
class PreferencesService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyLastReadDate = 'last_read_date_';

  /// Mark onboarding as completed
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  /// Check if onboarding has been completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Update last read date for a user
  static Future<void> updateLastReadDate(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setString('$_keyLastReadDate$userId', today);
  }

  /// Get last read date for a user
  static Future<String?> getLastReadDate(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_keyLastReadDate$userId');
  }

  /// Get user streak (days in a row they've read)
  static Future<int> getUserStreak(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final lastReadDateStr = prefs.getString('$_keyLastReadDate$userId');

    if (lastReadDateStr == null) return 0;

    try {
      final lastReadDate = DateTime.parse(lastReadDateStr);
      final today = DateTime.now();
      final difference = today.difference(lastReadDate).inDays;

      // If last read was today or yesterday, maintain streak
      if (difference <= 1) {
        // Get stored streak or start at 1
        final streak = prefs.getInt('${_keyLastReadDate}${userId}_streak') ?? 1;
        return streak;
      } else {
        // Streak broken, reset to 0
        await prefs.setInt('${_keyLastReadDate}${userId}_streak', 0);
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  /// Increment user streak
  static Future<void> incrementStreak(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final lastReadDateStr = prefs.getString('$_keyLastReadDate$userId');
    final today = DateTime.now().toIso8601String().split('T')[0];
    final todayDate = DateTime.parse(today);

    if (lastReadDateStr == null) {
      // First time reading
      await prefs.setString('$_keyLastReadDate$userId', today);
      await prefs.setInt('${_keyLastReadDate}${userId}_streak', 1);
      return;
    }

    final lastReadDate = DateTime.parse(lastReadDateStr);
    final difference = todayDate.difference(lastReadDate).inDays;

    if (difference == 0) {
      // Already read today, don't increment
      return;
    } else if (difference == 1) {
      // Read yesterday, increment streak
      final currentStreak = prefs.getInt('${_keyLastReadDate}${userId}_streak') ?? 1;
      await prefs.setInt('${_keyLastReadDate}${userId}_streak', currentStreak + 1);
      await prefs.setString('$_keyLastReadDate$userId', today);
    } else {
      // Streak broken, reset
      await prefs.setInt('${_keyLastReadDate}${userId}_streak', 1);
      await prefs.setString('$_keyLastReadDate$userId', today);
    }
  }

  /// Clear all preferences (for testing or logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
