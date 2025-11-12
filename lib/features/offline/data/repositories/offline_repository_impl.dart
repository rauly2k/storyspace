import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../../core/error/failures.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../story/domain/entities/story_entity.dart';
import '../../../story/domain/repositories/story_repository.dart';
import '../../../favorites/domain/repositories/favorites_repository.dart';
import '../../domain/entities/download_progress_entity.dart';
import '../../domain/entities/downloaded_story_info.dart';
import '../../domain/repositories/offline_repository.dart';
import '../datasources/offline_local_datasource.dart';

/// Implementation of offline repository
class OfflineRepositoryImpl implements OfflineRepository {
  final OfflineLocalDataSource _localDataSource;
  final StoryRepository _storyRepository;
  final FavoritesRepository _favoritesRepository;
  final Dio _dio;
  final UserEntity _currentUser;

  OfflineRepositoryImpl({
    required OfflineLocalDataSource localDataSource,
    required StoryRepository storyRepository,
    required FavoritesRepository favoritesRepository,
    required Dio dio,
    required UserEntity currentUser,
  })  : _localDataSource = localDataSource,
        _storyRepository = storyRepository,
        _favoritesRepository = favoritesRepository,
        _dio = dio,
        _currentUser = currentUser;

  // ==================== DOWNLOAD OPERATIONS ====================

  @override
  Future<Either<Failure, void>> downloadStory(String storyId) async {
    try {
      // Check if already downloaded
      final isDownloaded = await _localDataSource.isStoryDownloaded(storyId);
      if (isDownloaded) {
        return const Right(null);
      }

      // Check download limit
      final canDownload = await canDownloadMore();
      if (canDownload.isLeft()) {
        return Left(canDownload.getLeft().toNullable()!);
      }
      if (!canDownload.getRight().toNullable()!) {
        return const Left(Failure.subscription(
          'Download limit reached. Upgrade to download more stories.',
        ));
      }

      // Initialize progress
      await _localDataSource.saveDownloadProgress(
        storyId: storyId,
        progress: 0.0,
        status: DownloadStatus.downloading,
      );

      // Fetch story from remote
      final storyResult = await _storyRepository.getStoryById(storyId: storyId);
      if (storyResult.isLeft()) {
        await _localDataSource.updateDownloadProgress(
          storyId: storyId,
          progress: 0.0,
          status: DownloadStatus.failed,
          errorMessage: 'Failed to fetch story',
        );
        return Left(storyResult.getLeft().toNullable()!);
      }

      final story = storyResult.getRight().toNullable()!;

      // Update progress: Story fetched (20%)
      await _localDataSource.updateDownloadProgress(
        storyId: storyId,
        progress: 0.2,
        status: DownloadStatus.downloading,
      );

      // Calculate story size (approximate)
      int totalSize = story.content.length;

      // Download cover image if exists
      if (story.coverImageUrl != null && story.coverImageUrl!.isNotEmpty) {
        try {
          final imagePath = await _downloadImage(
            storyId: storyId,
            imageUrl: story.coverImageUrl!,
            onProgress: (progress) async {
              // Progress 20% - 80% for image download
              final totalProgress = 0.2 + (progress * 0.6);
              await _localDataSource.updateDownloadProgress(
                storyId: storyId,
                progress: totalProgress,
                status: DownloadStatus.downloading,
              );
            },
          );

          if (imagePath != null) {
            final imageFile = File(imagePath);
            totalSize += await imageFile.length();
          }
        } catch (e) {
          // Continue even if image download fails
          print('Failed to download cover image: $e');
        }
      }

      // Update progress: Images downloaded (80%)
      await _localDataSource.updateDownloadProgress(
        storyId: storyId,
        progress: 0.8,
        status: DownloadStatus.downloading,
      );

      // Check if story is favorited
      final isFavoriteResult =
          await _favoritesRepository.isFavorite(storyId, _currentUser.id);
      final isFavorite =
          isFavoriteResult.getOrElse((l) => false);

      // Save story to local database
      await _localDataSource.saveStory(
        id: story.id,
        kidProfileId: story.kidProfileId,
        userId: story.userId,
        title: story.title,
        content: story.content,
        genre: story.genre,
        coverImageUrl: story.coverImageUrl,
        isAIGenerated: story.isAIGenerated,
        aiPrompt: story.aiPrompt,
        readCount: story.readCount,
        createdAt: story.createdAt,
        lastReadAt: story.lastReadAt,
        downloadSize: totalSize,
      );

      // Update favorite status if needed
      if (isFavorite) {
        await _localDataSource.toggleFavorite(storyId, true);
      }

      // Update progress: Complete (100%)
      await _localDataSource.updateDownloadProgress(
        storyId: storyId,
        progress: 1.0,
        status: DownloadStatus.completed,
      );

      // Clean up progress after a delay
      Future.delayed(const Duration(seconds: 2), () {
        _localDataSource.deleteDownloadProgress(storyId);
      });

      return const Right(null);
    } catch (e) {
      await _localDataSource.updateDownloadProgress(
        storyId: storyId,
        progress: 0.0,
        status: DownloadStatus.failed,
        errorMessage: e.toString(),
      );
      return Left(Failure.cache('Failed to download story: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDownload(String storyId) async {
    try {
      // Get images to delete files
      final images = await _localDataSource.getImagesForStory(storyId);

      // Delete image files from storage
      for (final image in images) {
        try {
          final file = File(image.localPath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          print('Failed to delete image file: $e');
        }
      }

      // Delete from database
      await _localDataSource.deleteStory(storyId);

      return const Right(null);
    } catch (e) {
      return Left(Failure.cache('Failed to delete download: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isStoryDownloaded(String storyId) async {
    try {
      final isDownloaded = await _localDataSource.isStoryDownloaded(storyId);
      return Right(isDownloaded);
    } catch (e) {
      return Left(Failure.cache('Failed to check download status: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> getDownloadedStories() async {
    try {
      final offlineStories =
          await _localDataSource.getDownloadedStories(_currentUser.id);

      final stories = offlineStories.map((offlineStory) {
        return StoryEntity(
          id: offlineStory.id,
          kidProfileId: offlineStory.kidProfileId,
          userId: offlineStory.userId,
          title: offlineStory.title,
          content: offlineStory.content,
          genre: offlineStory.genre,
          coverImageUrl: offlineStory.coverImageUrl,
          isAIGenerated: offlineStory.isAIGenerated,
          aiPrompt: offlineStory.aiPrompt,
          readCount: offlineStory.readCount,
          createdAt: offlineStory.createdAt,
          lastReadAt: offlineStory.lastReadAt,
        );
      }).toList();

      return Right(stories);
    } catch (e) {
      return Left(Failure.cache('Failed to get downloaded stories: $e'));
    }
  }

  @override
  Future<Either<Failure, DownloadedStoryInfo?>> getDownloadInfo(
      String storyId) async {
    try {
      final story = await _localDataSource.getStoryById(storyId);
      if (story == null) {
        return const Right(null);
      }

      final images = await _localDataSource.getImagesForStory(storyId);

      final info = DownloadedStoryInfo(
        storyId: story.id,
        downloadedAt: story.downloadedAt,
        downloadSize: story.downloadSize,
        hasImages: images.isNotEmpty,
        imageCount: images.length,
      );

      return Right(info);
    } catch (e) {
      return Left(Failure.cache('Failed to get download info: $e'));
    }
  }

  // ==================== PROGRESS TRACKING ====================

  @override
  Stream<DownloadProgressEntity?> watchDownloadProgress(String storyId) {
    return _localDataSource.watchDownloadProgress(storyId).map((data) {
      if (data == null) return null;

      return DownloadProgressEntity(
        storyId: data.storyId,
        progress: data.progress,
        status: _parseDownloadStatus(data.status),
        errorMessage: data.errorMessage,
        startedAt: data.startedAt,
        updatedAt: data.updatedAt,
      );
    });
  }

  @override
  Future<Either<Failure, DownloadProgressEntity?>> getDownloadProgress(
      String storyId) async {
    try {
      final data = await _localDataSource.getDownloadProgress(storyId);
      if (data == null) {
        return const Right(null);
      }

      final entity = DownloadProgressEntity(
        storyId: data.storyId,
        progress: data.progress,
        status: _parseDownloadStatus(data.status),
        errorMessage: data.errorMessage,
        startedAt: data.startedAt,
        updatedAt: data.updatedAt,
      );

      return Right(entity);
    } catch (e) {
      return Left(Failure.cache('Failed to get download progress: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DownloadProgressEntity>>> getActiveDownloads() async {
    try {
      final dataList = await _localDataSource.getActiveDownloads();

      final entities = dataList.map((data) {
        return DownloadProgressEntity(
          storyId: data.storyId,
          progress: data.progress,
          status: _parseDownloadStatus(data.status),
          errorMessage: data.errorMessage,
          startedAt: data.startedAt,
          updatedAt: data.updatedAt,
        );
      }).toList();

      return Right(entities);
    } catch (e) {
      return Left(Failure.cache('Failed to get active downloads: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelDownload(String storyId) async {
    try {
      await _localDataSource.updateDownloadProgress(
        storyId: storyId,
        progress: 0.0,
        status: DownloadStatus.failed,
        errorMessage: 'Download cancelled by user',
      );

      // Clean up any partial data
      await _localDataSource.deleteStory(storyId);

      return const Right(null);
    } catch (e) {
      return Left(Failure.cache('Failed to cancel download: $e'));
    }
  }

  // ==================== STORAGE MANAGEMENT ====================

  @override
  Future<Either<Failure, int>> getDownloadCount() async {
    try {
      final count = await _localDataSource.getDownloadCount(_currentUser.id);
      return Right(count);
    } catch (e) {
      return Left(Failure.cache('Failed to get download count: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalStorageUsed() async {
    try {
      final size = await _localDataSource.getTotalStorageUsed(_currentUser.id);
      return Right(size);
    } catch (e) {
      return Left(Failure.cache('Failed to get storage used: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> canDownloadMore() async {
    try {
      final count = await _localDataSource.getDownloadCount(_currentUser.id);
      final limit = AppConstants.getDownloadLimit(_currentUser.subscriptionTier);

      // Unlimited downloads for premium+
      if (limit >= AppConstants.premiumPlusDownloadLimit) {
        return const Right(true);
      }

      return Right(count < limit);
    } catch (e) {
      return Left(Failure.cache('Failed to check download limit: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getRemainingDownloads() async {
    try {
      final count = await _localDataSource.getDownloadCount(_currentUser.id);
      final limit = AppConstants.getDownloadLimit(_currentUser.subscriptionTier);

      // Unlimited downloads
      if (limit >= AppConstants.premiumPlusDownloadLimit) {
        return const Right(999999);
      }

      final remaining = limit - count;
      return Right(remaining > 0 ? remaining : 0);
    } catch (e) {
      return Left(Failure.cache('Failed to get remaining downloads: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllDownloads() async {
    try {
      // Get all stories to delete image files
      final stories =
          await _localDataSource.getDownloadedStories(_currentUser.id);

      for (final story in stories) {
        final images = await _localDataSource.getImagesForStory(story.id);
        for (final image in images) {
          try {
            final file = File(image.localPath);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (e) {
            print('Failed to delete image file: $e');
          }
        }
      }

      await _localDataSource.clearAllDownloads(_currentUser.id);
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache('Failed to clear downloads: $e'));
    }
  }

  // ==================== SYNC OPERATIONS ====================

  @override
  Future<Either<Failure, void>> syncFavorites() async {
    try {
      // Get local favorites
      final localStories =
          await _localDataSource.getFavoriteStories(_currentUser.id);

      // Sync each favorite with remote
      for (final story in localStories) {
        final isFavoriteResult =
            await _favoritesRepository.isFavorite(story.id, _currentUser.id);

        if (isFavoriteResult.isRight()) {
          final isFavorite = isFavoriteResult.getRight().toNullable()!;
          if (story.isFavorite != isFavorite) {
            await _localDataSource.toggleFavorite(story.id, isFavorite);
          }
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure.cache('Failed to sync favorites: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncReadCounts() async {
    try {
      // Get local stories
      final localStories =
          await _localDataSource.getDownloadedStories(_currentUser.id);

      // Sync read counts with remote
      for (final story in localStories) {
        try {
          final remoteResult =
              await _storyRepository.getStoryById(storyId: story.id);

          if (remoteResult.isRight()) {
            final remoteStory = remoteResult.getRight().toNullable()!;

            // Update local if remote has higher read count
            if (remoteStory.readCount > story.readCount) {
              // Update local database directly
              await _localDataSource.saveStory(
                id: story.id,
                kidProfileId: story.kidProfileId,
                userId: story.userId,
                title: story.title,
                content: story.content,
                genre: story.genre,
                coverImageUrl: story.coverImageUrl,
                isAIGenerated: story.isAIGenerated,
                aiPrompt: story.aiPrompt,
                readCount: remoteStory.readCount,
                createdAt: story.createdAt,
                lastReadAt: remoteStory.lastReadAt,
                downloadSize: story.downloadSize,
              );
            }
          }
        } catch (e) {
          print('Failed to sync read count for story ${story.id}: $e');
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure.cache('Failed to sync read counts: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOfflineStory(String storyId) async {
    try {
      // Fetch latest version from remote
      final storyResult = await _storyRepository.getStoryById(storyId: storyId);
      if (storyResult.isLeft()) {
        return Left(storyResult.getLeft().toNullable()!);
      }

      final story = storyResult.getRight().toNullable()!;
      final localStory = await _localDataSource.getStoryById(storyId);

      if (localStory == null) {
        return const Left(Failure.cache('Story not found in offline storage'));
      }

      // Update local copy
      await _localDataSource.saveStory(
        id: story.id,
        kidProfileId: story.kidProfileId,
        userId: story.userId,
        title: story.title,
        content: story.content,
        genre: story.genre,
        coverImageUrl: story.coverImageUrl,
        isAIGenerated: story.isAIGenerated,
        aiPrompt: story.aiPrompt,
        readCount: story.readCount,
        createdAt: story.createdAt,
        lastReadAt: story.lastReadAt,
        downloadSize: localStory.downloadSize,
      );

      return const Right(null);
    } catch (e) {
      return Left(Failure.cache('Failed to update offline story: $e'));
    }
  }

  // ==================== IMAGE CACHING ====================

  @override
  Future<Either<Failure, String?>> getLocalImagePath(
      String storyId, String remoteUrl) async {
    try {
      final path = await _localDataSource.getLocalPathForUrl(storyId, remoteUrl);
      return Right(path);
    } catch (e) {
      return Left(Failure.cache('Failed to get local image path: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> cacheImage(
      String storyId, String remoteUrl) async {
    try {
      // Check if already cached
      final existingPath =
          await _localDataSource.getLocalPathForUrl(storyId, remoteUrl);
      if (existingPath != null) {
        final file = File(existingPath);
        if (await file.exists()) {
          return Right(existingPath);
        }
      }

      // Download and cache
      final path = await _downloadImage(storyId: storyId, imageUrl: remoteUrl);
      if (path == null) {
        return const Left(Failure.cache('Failed to download image'));
      }

      return Right(path);
    } catch (e) {
      return Left(Failure.cache('Failed to cache image: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearImagesForStory(String storyId) async {
    try {
      final images = await _localDataSource.getImagesForStory(storyId);

      for (final image in images) {
        try {
          final file = File(image.localPath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          print('Failed to delete image file: $e');
        }
      }

      await _localDataSource.deleteImagesForStory(storyId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache('Failed to clear images: $e'));
    }
  }

  // ==================== HELPER METHODS ====================

  /// Download an image and save to local storage
  Future<String?> _downloadImage({
    required String storyId,
    required String imageUrl,
    Function(double)? onProgress,
  }) async {
    try {
      // Get app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'story_images', storyId));

      // Create directory if it doesn't exist
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Generate local filename
      final fileName = p.basename(Uri.parse(imageUrl).path);
      final localPath = p.join(imagesDir.path, fileName);

      // Download image
      await _dio.download(
        imageUrl,
        localPath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      // Get file size
      final file = File(localPath);
      final fileSize = await file.length();

      // Save to database
      await _localDataSource.saveImage(
        storyId: storyId,
        remoteUrl: imageUrl,
        localPath: localPath,
        fileSize: fileSize,
      );

      return localPath;
    } catch (e) {
      print('Failed to download image: $e');
      return null;
    }
  }

  /// Parse download status from string
  DownloadStatus _parseDownloadStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return DownloadStatus.pending;
      case 'downloading':
        return DownloadStatus.downloading;
      case 'completed':
        return DownloadStatus.completed;
      case 'failed':
        return DownloadStatus.failed;
      default:
        return DownloadStatus.pending;
    }
  }
}
