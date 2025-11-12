/// Firebase collection and field names
class FirebaseConstants {
  FirebaseConstants._();

  // ==================== COLLECTIONS ====================

  static const String usersCollection = 'users';
  static const String kidProfilesCollection = 'kid_profiles';
  static const String storiesCollection = 'stories';
  static const String favoritesCollection = 'favorites';
  static const String subscriptionsCollection = 'subscriptions';
  static const String reportsCollection = 'reports';

  // ==================== STORAGE BUCKETS ====================

  static const String userPhotosPath = 'user_photos';
  static const String kidProfilesPath = 'kid_profiles';
  static const String storyImagesPath = 'story_images';

  // ==================== USER FIELDS ====================

  static const String userId = 'id';
  static const String userEmail = 'email';
  static const String userDisplayName = 'displayName';
  static const String userPhotoUrl = 'photoUrl';
  static const String userIsPremium = 'isPremium';
  static const String userSubscriptionTier = 'subscriptionTier';
  static const String userCreatedAt = 'createdAt';
  static const String userUpdatedAt = 'updatedAt';

  // ==================== KID PROFILE FIELDS ====================

  static const String profileId = 'id';
  static const String profileUserId = 'userId';
  static const String profileName = 'name';
  static const String profileAge = 'age';
  static const String profileAgeBucket = 'ageBucket';
  static const String profilePhotoUrl = 'photoUrl';
  static const String profileInterests = 'interests';
  static const String profileCreatedAt = 'createdAt';
  static const String profileUpdatedAt = 'updatedAt';

  // ==================== STORY FIELDS ====================

  static const String storyId = 'id';
  static const String storyKidProfileIdField = 'kidProfileId';
  static const String storyUserIdField = 'userId';
  static const String storyTitleField = 'title';
  static const String storyContentField = 'content';
  static const String storyGenreField = 'genre';
  static const String storyCoverImageUrlField = 'coverImageUrl';
  static const String storyIsAIGeneratedField = 'isAIGenerated';
  static const String storyAIPromptField = 'aiPrompt';
  static const String storyReadCountField = 'readCount';
  static const String storyCreatedAtField = 'createdAt';
  static const String storyLastReadAtField = 'lastReadAt';

  // Legacy fields (for backwards compatibility)
  static const String storyTitle = 'title';
  static const String storyContent = 'content';
  static const String storyCategory = 'category';
  static const String storyAgeBucket = 'ageBucket';
  static const String storyCoverImageUrl = 'coverImageUrl';
  static const String storyPages = 'pages';
  static const String storyAuthorId = 'authorId';
  static const String storyIsAIGenerated = 'isAIGenerated';
  static const String storyLength = 'length';
  static const String storyCreatedAt = 'createdAt';
  static const String storyUpdatedAt = 'updatedAt';
  static const String storyReadCount = 'readCount';

  // Story Page Fields
  static const String pageNumber = 'pageNumber';
  static const String pageText = 'text';
  static const String pageImageUrl = 'imageUrl';

  // ==================== FAVORITES FIELDS ====================

  static const String favoriteId = 'id';
  static const String favoriteUserId = 'userId';
  static const String favoriteStoryId = 'storyId';
  static const String favoriteCreatedAt = 'createdAt';

  // ==================== SUBSCRIPTION FIELDS ====================

  static const String subscriptionId = 'id';
  static const String subscriptionUserId = 'userId';
  static const String subscriptionTier = 'tier';
  static const String subscriptionStartDate = 'startDate';
  static const String subscriptionEndDate = 'endDate';
  static const String subscriptionIsActive = 'isActive';
  static const String subscriptionAIStoriesUsed = 'aiStoriesUsed';
  static const String subscriptionAIStoriesLimit = 'aiStoriesLimit';
  static const String subscriptionCreatedAt = 'createdAt';
  static const String subscriptionUpdatedAt = 'updatedAt';

  // ==================== REPORT FIELDS ====================

  static const String reportId = 'id';
  static const String reportUserId = 'userId';
  static const String reportStoryId = 'storyId';
  static const String reportReason = 'reason';
  static const String reportDescription = 'description';
  static const String reportStatus = 'status';
  static const String reportCreatedAt = 'createdAt';

  // ==================== STORAGE PATHS ====================

  /// Get path for user profile photo
  static String getUserPhotoPath(String userId, String fileName) {
    return '$userPhotosPath/$userId/$fileName';
  }

  /// Get path for kid profile photo
  static String getKidProfilePhotoPath(String userId, String profileId, String fileName) {
    return '$kidProfilesPath/$userId/$profileId/$fileName';
  }

  /// Get path for story cover image
  static String getStoryCoverPath(String storyId, String fileName) {
    return '$storyImagesPath/$storyId/cover/$fileName';
  }

  /// Get path for story page image
  static String getStoryPageImagePath(String storyId, int pageNumber, String fileName) {
    return '$storyImagesPath/$storyId/pages/$pageNumber/$fileName';
  }

  // ==================== QUERY HELPERS ====================

  /// Get stories query path for user
  static String getUserStoriesPath(String userId) {
    return '$storiesCollection?$storyAuthorId=$userId';
  }

  /// Get favorites query path for user
  static String getUserFavoritesPath(String userId) {
    return '$favoritesCollection?$favoriteUserId=$userId';
  }

  /// Get kid profiles query path for user
  static String getUserKidProfilesPath(String userId) {
    return '$kidProfilesCollection?$profileUserId=$userId';
  }

  /// Get subscription path for user
  static String getUserSubscriptionPath(String userId) {
    return '$subscriptionsCollection?$subscriptionUserId=$userId';
  }
}
