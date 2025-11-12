import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../story/domain/entities/story_entity.dart';
import '../entities/download_progress_entity.dart';
import '../entities/downloaded_story_info.dart';

/// Repository for offline story management
abstract class OfflineRepository {
  // ==================== DOWNLOAD OPERATIONS ====================

  /// Download a story for offline access
  /// Returns Either<Failure, void> indicating success or failure
  Future<Either<Failure, void>> downloadStory(String storyId);

  /// Delete a downloaded story
  /// Returns Either<Failure, void> indicating success or failure
  Future<Either<Failure, void>> deleteDownload(String storyId);

  /// Check if a story is downloaded
  Future<Either<Failure, bool>> isStoryDownloaded(String storyId);

  /// Get all downloaded stories for the current user
  Future<Either<Failure, List<StoryEntity>>> getDownloadedStories();

  /// Get download information for a specific story
  Future<Either<Failure, DownloadedStoryInfo?>> getDownloadInfo(String storyId);

  // ==================== PROGRESS TRACKING ====================

  /// Watch download progress for a story (stream)
  /// Emits updates as the download progresses
  Stream<DownloadProgressEntity?> watchDownloadProgress(String storyId);

  /// Get current download progress for a story
  Future<Either<Failure, DownloadProgressEntity?>> getDownloadProgress(
      String storyId);

  /// Get all active downloads
  Future<Either<Failure, List<DownloadProgressEntity>>> getActiveDownloads();

  /// Cancel an ongoing download
  Future<Either<Failure, void>> cancelDownload(String storyId);

  // ==================== STORAGE MANAGEMENT ====================

  /// Get count of downloaded stories for the current user
  Future<Either<Failure, int>> getDownloadCount();

  /// Get total storage used by downloads (in bytes)
  Future<Either<Failure, int>> getTotalStorageUsed();

  /// Check if user can download more stories based on subscription tier
  Future<Either<Failure, bool>> canDownloadMore();

  /// Get remaining download slots for current subscription
  Future<Either<Failure, int>> getRemainingDownloads();

  /// Clear all downloads for the current user
  Future<Either<Failure, void>> clearAllDownloads();

  // ==================== SYNC OPERATIONS ====================

  /// Sync favorites status between offline and online
  Future<Either<Failure, void>> syncFavorites();

  /// Sync read counts between offline and online
  Future<Either<Failure, void>> syncReadCounts();

  /// Update a story's offline data from remote
  Future<Either<Failure, void>> updateOfflineStory(String storyId);

  // ==================== IMAGE CACHING ====================

  /// Get local path for a cached image
  Future<Either<Failure, String?>> getLocalImagePath(
      String storyId, String remoteUrl);

  /// Cache an image for offline access
  Future<Either<Failure, String>> cacheImage(
      String storyId, String remoteUrl);

  /// Clear cached images for a story
  Future<Either<Failure, void>> clearImagesForStory(String storyId);
}
