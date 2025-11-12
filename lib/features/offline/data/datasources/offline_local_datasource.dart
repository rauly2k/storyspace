import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/download_progress_entity.dart';

/// Local data source for offline stories using Drift
class OfflineLocalDataSource {
  final AppDatabase _database;

  OfflineLocalDataSource(this._database);

  // ==================== STORY OPERATIONS ====================

  /// Get all downloaded stories for a user
  Future<List<OfflineStory>> getDownloadedStories(String userId) async {
    return await _database.getDownloadedStoriesForUser(userId);
  }

  /// Get a specific story by ID
  Future<OfflineStory?> getStoryById(String storyId) async {
    return await _database.getStoryById(storyId);
  }

  /// Check if a story is downloaded
  Future<bool> isStoryDownloaded(String storyId) async {
    return await _database.isStoryDownloaded(storyId);
  }

  /// Save a story to offline storage
  Future<void> saveStory({
    required String id,
    required String kidProfileId,
    required String userId,
    required String title,
    required String content,
    required String genre,
    String? coverImageUrl,
    required bool isAIGenerated,
    String? aiPrompt,
    required int readCount,
    required DateTime createdAt,
    DateTime? lastReadAt,
    required int downloadSize,
  }) async {
    final companion = OfflineStoriesCompanion(
      id: Value(id),
      kidProfileId: Value(kidProfileId),
      userId: Value(userId),
      title: Value(title),
      content: Value(content),
      genre: Value(genre),
      coverImageUrl: Value(coverImageUrl),
      isAIGenerated: Value(isAIGenerated),
      aiPrompt: Value(aiPrompt),
      readCount: Value(readCount),
      createdAt: Value(createdAt),
      lastReadAt: Value(lastReadAt),
      downloadedAt: Value(DateTime.now()),
      downloadSize: Value(downloadSize),
    );

    await _database.upsertStory(companion);
  }

  /// Delete a downloaded story
  Future<void> deleteStory(String storyId) async {
    await _database.deleteStory(storyId);
  }

  /// Get download count for a user
  Future<int> getDownloadCount(String userId) async {
    return await _database.getDownloadCount(userId);
  }

  /// Get total storage used
  Future<int> getTotalStorageUsed(String userId) async {
    return await _database.getTotalStorageUsed(userId);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String storyId, bool isFavorite) async {
    await _database.toggleFavorite(storyId, isFavorite);
  }

  /// Increment read count
  Future<void> incrementReadCount(String storyId) async {
    await _database.incrementReadCount(storyId);
  }

  /// Get favorite stories
  Future<List<OfflineStory>> getFavoriteStories(String userId) async {
    return await _database.getFavoriteStories(userId);
  }

  /// Clear all downloads for a user
  Future<void> clearAllDownloads(String userId) async {
    await _database.deleteAllUserData(userId);
  }

  // ==================== IMAGE OPERATIONS ====================

  /// Save a downloaded image
  Future<void> saveImage({
    required String storyId,
    required String remoteUrl,
    required String localPath,
    required int fileSize,
  }) async {
    final companion = DownloadedImagesCompanion(
      storyId: Value(storyId),
      remoteUrl: Value(remoteUrl),
      localPath: Value(localPath),
      fileSize: Value(fileSize),
      downloadedAt: Value(DateTime.now()),
    );

    await _database.insertDownloadedImage(companion);
  }

  /// Get images for a story
  Future<List<DownloadedImage>> getImagesForStory(String storyId) async {
    return await _database.getImagesForStory(storyId);
  }

  /// Get local path for a remote URL
  Future<String?> getLocalPathForUrl(String storyId, String remoteUrl) async {
    return await _database.getLocalPathForUrl(storyId, remoteUrl);
  }

  /// Delete images for a story
  Future<void> deleteImagesForStory(String storyId) async {
    await _database.deleteImagesForStory(storyId);
  }

  // ==================== DOWNLOAD PROGRESS OPERATIONS ====================

  /// Save download progress
  Future<void> saveDownloadProgress({
    required String storyId,
    required double progress,
    required DownloadStatus status,
    String? errorMessage,
  }) async {
    final companion = DownloadProgressCompanion(
      storyId: Value(storyId),
      progress: Value(progress),
      status: Value(status.name),
      errorMessage: Value(errorMessage),
      startedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await _database.upsertDownloadProgress(companion);
  }

  /// Update download progress
  Future<void> updateDownloadProgress({
    required String storyId,
    required double progress,
    required DownloadStatus status,
    String? errorMessage,
  }) async {
    // Get existing progress to keep the startedAt time
    final existing = await _database.getDownloadProgress(storyId);

    final companion = DownloadProgressCompanion(
      storyId: Value(storyId),
      progress: Value(progress),
      status: Value(status.name),
      errorMessage: Value(errorMessage),
      startedAt: Value(existing?.startedAt ?? DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await _database.upsertDownloadProgress(companion);
  }

  /// Get download progress
  Future<DownloadProgressData?> getDownloadProgress(String storyId) async {
    return await _database.getDownloadProgress(storyId);
  }

  /// Watch download progress (stream)
  Stream<DownloadProgressData?> watchDownloadProgress(String storyId) {
    return _database.watchDownloadProgress(storyId);
  }

  /// Delete download progress
  Future<void> deleteDownloadProgress(String storyId) async {
    await _database.deleteDownloadProgress(storyId);
  }

  /// Get all active downloads
  Future<List<DownloadProgressData>> getActiveDownloads() async {
    return await _database.getActiveDownloads();
  }

  /// Clear completed downloads
  Future<void> clearCompletedDownloads() async {
    await _database.clearCompletedDownloads();
  }
}
