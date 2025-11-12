/// App-wide constants
class AppConstants {
  AppConstants._();

  // ==================== APP INFO ====================

  static const String appName = 'StorySpace';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Where Stories Come Alive';

  // ==================== AGE BUCKETS ====================

  static const String ageBucketSprout = 'sprout';
  static const String ageBucketExplorer = 'explorer';
  static const String ageBucketVisionary = 'visionary';

  // Age ranges
  static const int sproutMinAge = 3;
  static const int sproutMaxAge = 5;
  static const int explorerMinAge = 6;
  static const int explorerMaxAge = 8;
  static const int visionaryMinAge = 9;
  static const int visionaryMaxAge = 12;

  // Word counts per age bucket
  static const int sproutWordCount = 250;
  static const int explorerWordCount = 500;
  static const int visionaryWordCount = 900;

  // ==================== SUBSCRIPTION TIERS ====================

  static const String tierFree = 'free';
  static const String tierPremium = 'premium';
  static const String tierPremiumPlus = 'premium+';

  // Pricing
  static const double premiumPrice = 4.99;
  static const double premiumPlusPrice = 9.99;

  // ==================== SUBSCRIPTION LIMITS ====================

  // Pre-made stories
  static const int freePreMadeStoryLimit = 5;
  static const int premiumPreMadeStoryLimit = 999999; // Unlimited
  static const int premiumPlusPreMadeStoryLimit = 999999; // Unlimited

  // Kid profiles
  static const int freeKidProfileLimit = 1;
  static const int premiumKidProfileLimit = 3;
  static const int premiumPlusKidProfileLimit = 999999; // Unlimited

  // AI story generation per month
  static const int freeAIStoriesPerMonth = 2;
  static const int premiumAIStoriesPerMonth = 20;
  static const int premiumPlusAIStoriesPerMonth = 999999; // Unlimited

  // Offline downloads
  static const int freeDownloadLimit = 0;
  static const int premiumDownloadLimit = 10;
  static const int premiumPlusDownloadLimit = 999999; // Unlimited

  // ==================== STORY CATEGORIES ====================

  static const List<String> storyCategories = [
    'Adventure',
    'Fantasy',
    'Sci-Fi',
    'Mystery',
    'Funny',
    'Magical',
    'School',
    'Spooky',
    'Bedtime',
    'Learning',
  ];

  // ==================== STORY LENGTHS ====================

  static const String storyLengthShort = 'short';
  static const String storyLengthMedium = 'medium';
  static const String storyLengthLong = 'long';

  // Reading time estimates (in minutes)
  static const int shortReadingTime = 5;
  static const int mediumReadingTime = 10;
  static const int longReadingTime = 15;

  // ==================== IMAGE GENERATION ====================

  static const List<String> artStyles = [
    'Cartoon',
    'Storybook',
    '3D',
    'Anime',
  ];

  // Number of images per story
  static const int coverImageCount = 1;
  static const int sceneImageCount = 3;
  static const int totalImagesPerStory = coverImageCount + sceneImageCount;

  // ==================== API TIMEOUTS ====================

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration aiGenerationTimeout = Duration(seconds: 120);
  static const Duration imageGenerationTimeout = Duration(seconds: 60);

  // ==================== PAGINATION ====================

  static const int storiesPerPage = 20;
  static const int maxSearchResults = 50;

  // ==================== FILE SIZES ====================

  static const int maxProfilePhotoSize = 5 * 1024 * 1024; // 5MB
  static const int maxStoryImageSize = 10 * 1024 * 1024; // 10MB

  // ==================== CACHE DURATION ====================

  static const Duration storyCacheDuration = Duration(hours: 24);
  static const Duration imageCacheDuration = Duration(days: 7);

  // ==================== TEXT-TO-SPEECH ====================

  static const double minSpeechRate = 0.5;
  static const double defaultSpeechRate = 1.0;
  static const double maxSpeechRate = 2.0;

  // ==================== VALIDATION ====================

  static const int minPasswordLength = 8;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minAge = 1;
  static const int maxAge = 12;

  // ==================== ERROR MESSAGES ====================

  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String permissionDenied = 'Permission denied.';

  // ==================== ONBOARDING ====================

  static const int onboardingSlideCount = 3;

  static const List<Map<String, String>> onboardingSlides = [
    {
      'title': 'Welcome to StorySpace',
      'subtitle': 'Where Stories Come Alive',
      'description': 'Read amazing stories and create your own magical adventures!',
    },
    {
      'title': 'Create Your Story',
      'subtitle': 'You\'re the Hero!',
      'description': 'Use AI to generate personalized stories featuring you as the main character!',
    },
    {
      'title': 'Ready for Adventure?',
      'subtitle': 'Let\'s Get Started!',
      'description': 'Join thousands of kids exploring endless stories. Your adventure begins now!',
    },
  ];

  // ==================== UTILITY METHODS ====================

  /// Get age bucket from age
  static String getAgeBucket(int age) {
    if (age >= sproutMinAge && age <= sproutMaxAge) {
      return ageBucketSprout;
    } else if (age >= explorerMinAge && age <= explorerMaxAge) {
      return ageBucketExplorer;
    } else if (age >= visionaryMinAge && age <= visionaryMaxAge) {
      return ageBucketVisionary;
    }
    return ageBucketExplorer; // Default
  }

  /// Get word count for age bucket
  static int getWordCountForAgeBucket(String ageBucket) {
    switch (ageBucket.toLowerCase()) {
      case ageBucketSprout:
        return sproutWordCount;
      case ageBucketExplorer:
        return explorerWordCount;
      case ageBucketVisionary:
        return visionaryWordCount;
      default:
        return explorerWordCount;
    }
  }

  /// Get word count for story length and age bucket
  static int getWordCountForLength(String length, String ageBucket) {
    final baseCount = getWordCountForAgeBucket(ageBucket);
    switch (length.toLowerCase()) {
      case storyLengthShort:
        return baseCount;
      case storyLengthMedium:
        return (baseCount * 1.5).round();
      case storyLengthLong:
        return baseCount * 2;
      default:
        return baseCount;
    }
  }

  /// Get AI stories limit for tier
  static int getAIStoriesLimit(String tier) {
    switch (tier.toLowerCase()) {
      case tierFree:
        return freeAIStoriesPerMonth;
      case tierPremium:
        return premiumAIStoriesPerMonth;
      case tierPremiumPlus:
        return premiumPlusAIStoriesPerMonth;
      default:
        return freeAIStoriesPerMonth;
    }
  }

  /// Get kid profile limit for tier
  static int getKidProfileLimit(String tier) {
    switch (tier.toLowerCase()) {
      case tierFree:
        return freeKidProfileLimit;
      case tierPremium:
        return premiumKidProfileLimit;
      case tierPremiumPlus:
        return premiumPlusKidProfileLimit;
      default:
        return freeKidProfileLimit;
    }
  }

  /// Get download limit for tier
  static int getDownloadLimit(String tier) {
    switch (tier.toLowerCase()) {
      case tierFree:
        return freeDownloadLimit;
      case tierPremium:
        return premiumDownloadLimit;
      case tierPremiumPlus:
        return premiumPlusDownloadLimit;
      default:
        return freeDownloadLimit;
    }
  }

  /// Check if feature is available for tier
  static bool isFeatureAvailable(String tier, String feature) {
    switch (feature.toLowerCase()) {
      case 'audio_narration':
        return tier == tierPremium || tier == tierPremiumPlus;
      case 'pdf_export':
        return tier == tierPremiumPlus;
      case 'photo_in_story':
        return tier == tierPremiumPlus;
      case 'all_art_styles':
        return tier == tierPremium || tier == tierPremiumPlus;
      case 'offline_downloads':
        return tier == tierPremium || tier == tierPremiumPlus;
      default:
        return true; // Available for all tiers by default
    }
  }
}
