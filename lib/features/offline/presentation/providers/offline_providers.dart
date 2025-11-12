import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../story/presentation/providers/story_providers.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../data/datasources/offline_local_datasource.dart';
import '../../data/repositories/offline_repository_impl.dart';
import '../../domain/entities/download_progress_entity.dart';
import '../../domain/entities/downloaded_story_info.dart';
import '../../domain/repositories/offline_repository.dart';
import '../../../story/domain/entities/story_entity.dart';

part 'offline_providers.g.dart';

// ==================== DATABASE ====================

/// Provider for AppDatabase instance
@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

// ==================== DATA SOURCES ====================

/// Provider for OfflineLocalDataSource
@riverpod
OfflineLocalDataSource offlineLocalDataSource(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return OfflineLocalDataSource(database);
}

// ==================== DIO CLIENT ====================

/// Provider for Dio HTTP client
@riverpod
Dio dioClient(Ref ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );
}

// ==================== REPOSITORIES ====================

/// Provider for OfflineRepository
@riverpod
Future<OfflineRepository> offlineRepository(Ref ref) async {
  final localDataSource = ref.watch(offlineLocalDataSourceProvider);
  final storyRepository = ref.watch(storyRepositoryProvider);
  final favoritesRepository = ref.watch(favoritesRepositoryProvider);
  final dio = ref.watch(dioClientProvider);

  // Get current user
  final userAsync = await ref.watch(currentUserProvider.future);

  if (userAsync == null) {
    throw Exception('User not authenticated');
  }

  return OfflineRepositoryImpl(
    localDataSource: localDataSource,
    storyRepository: storyRepository,
    favoritesRepository: favoritesRepository,
    dio: dio,
    currentUser: userAsync,
  );
}

// ==================== DOWNLOADED STORIES ====================

/// Provider for downloaded stories list
@riverpod
Future<List<StoryEntity>> downloadedStories(Ref ref) async {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  final result = await repository.getDownloadedStories();

  return result.fold(
    (failure) => [],
    (stories) => stories,
  );
}

/// Watch downloaded stories (auto-refresh)
@riverpod
Stream<List<StoryEntity>> watchDownloadedStories(Ref ref) async* {
  while (true) {
    final repository = await ref.watch(offlineRepositoryProvider.future);
    final result = await repository.getDownloadedStories();

    yield result.fold(
      (failure) => [],
      (stories) => stories,
    );

    // Poll every 2 seconds for updates
    await Future.delayed(const Duration(seconds: 2));
  }
}

// ==================== DOWNLOAD STATUS ====================

/// Check if a specific story is downloaded
@riverpod
Future<bool> isStoryDownloaded(Ref ref, String storyId) async {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  final result = await repository.isStoryDownloaded(storyId);

  return result.fold(
    (failure) => false,
    (isDownloaded) => isDownloaded,
  );
}

/// Get download info for a story
@riverpod
Future<DownloadedStoryInfo?> downloadInfo(Ref ref, String storyId) async {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  final result = await repository.getDownloadInfo(storyId);

  return result.fold(
    (failure) => null,
    (info) => info,
  );
}

// ==================== DOWNLOAD PROGRESS ====================

/// Watch download progress for a specific story
@riverpod
Stream<DownloadProgressEntity?> watchDownloadProgress(
    Ref ref, String storyId) async* {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  yield* repository.watchDownloadProgress(storyId);
}

/// Get all active downloads
@riverpod
Future<List<DownloadProgressEntity>> activeDownloads(Ref ref) async {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  final result = await repository.getActiveDownloads();

  return result.fold(
    (failure) => [],
    (downloads) => downloads,
  );
}

// ==================== STORAGE INFO ====================

/// Get count of downloaded stories
@riverpod
Future<int> downloadCount(Ref ref) async {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  final result = await repository.getDownloadCount();

  return result.fold(
    (failure) => 0,
    (count) => count,
  );
}

/// Get total storage used by downloads
@riverpod
Future<int> totalStorageUsed(Ref ref) async {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  final result = await repository.getTotalStorageUsed();

  return result.fold(
    (failure) => 0,
    (size) => size,
  );
}

/// Get formatted storage size
@riverpod
Future<String> formattedStorageUsed(Ref ref) async {
  final size = await ref.watch(totalStorageUsedProvider.future);

  if (size < 1024) {
    return '$size B';
  } else if (size < 1024 * 1024) {
    return '${(size / 1024).toStringAsFixed(1)} KB';
  } else {
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Check if user can download more stories
@riverpod
Future<bool> canDownloadMore(Ref ref) async {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  final result = await repository.canDownloadMore();

  return result.fold(
    (failure) => false,
    (canDownload) => canDownload,
  );
}

/// Get remaining download slots
@riverpod
Future<int> remainingDownloads(Ref ref) async {
  final repository = await ref.watch(offlineRepositoryProvider.future);
  final result = await repository.getRemainingDownloads();

  return result.fold(
    (failure) => 0,
    (remaining) => remaining,
  );
}

// ==================== OFFLINE CONTROLLER ====================

/// Offline controller state
class OfflineState {
  final bool isProcessing;
  final String? error;
  final String? successMessage;

  const OfflineState({
    this.isProcessing = false,
    this.error,
    this.successMessage,
  });

  OfflineState copyWith({
    bool? isProcessing,
    String? error,
    String? successMessage,
  }) {
    return OfflineState(
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Offline controller for handling download operations
@riverpod
class OfflineController extends _$OfflineController {
  @override
  OfflineState build() {
    return const OfflineState();
  }

  /// Download a story
  Future<bool> downloadStory(String storyId) async {
    state = state.copyWith(isProcessing: true, error: null, successMessage: null);

    try {
      final repository = await ref.read(offlineRepositoryProvider.future);
      final result = await repository.downloadStory(storyId);

      if (!ref.mounted) return false;

      return result.fold(
        (failure) {
          state = state.copyWith(
            isProcessing: false,
            error: failure.errorMessage,
          );
          return false;
        },
        (_) {
          state = state.copyWith(
            isProcessing: false,
            successMessage: 'Story downloaded successfully!',
          );

          // Invalidate downloaded stories to refresh
          ref.invalidate(downloadedStoriesProvider);
          ref.invalidate(downloadCountProvider);
          ref.invalidate(totalStorageUsedProvider);
          ref.invalidate(isStoryDownloadedProvider(storyId));

          return true;
        },
      );
    } catch (e) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isProcessing: false,
        error: 'Failed to download story: $e',
      );
      return false;
    }
  }

  /// Delete a downloaded story
  Future<bool> deleteDownload(String storyId) async {
    state = state.copyWith(isProcessing: true, error: null, successMessage: null);

    try {
      final repository = await ref.read(offlineRepositoryProvider.future);
      final result = await repository.deleteDownload(storyId);

      if (!ref.mounted) return false;

      return result.fold(
        (failure) {
          state = state.copyWith(
            isProcessing: false,
            error: failure.errorMessage,
          );
          return false;
        },
        (_) {
          state = state.copyWith(
            isProcessing: false,
            successMessage: 'Story deleted successfully!',
          );

          // Invalidate providers to refresh
          ref.invalidate(downloadedStoriesProvider);
          ref.invalidate(downloadCountProvider);
          ref.invalidate(totalStorageUsedProvider);
          ref.invalidate(isStoryDownloadedProvider(storyId));

          return true;
        },
      );
    } catch (e) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isProcessing: false,
        error: 'Failed to delete story: $e',
      );
      return false;
    }
  }

  /// Cancel an ongoing download
  Future<bool> cancelDownload(String storyId) async {
    state = state.copyWith(isProcessing: true, error: null, successMessage: null);

    try {
      final repository = await ref.read(offlineRepositoryProvider.future);
      final result = await repository.cancelDownload(storyId);

      if (!ref.mounted) return false;

      return result.fold(
        (failure) {
          state = state.copyWith(
            isProcessing: false,
            error: failure.errorMessage,
          );
          return false;
        },
        (_) {
          state = state.copyWith(
            isProcessing: false,
            successMessage: 'Download cancelled',
          );

          ref.invalidate(activeDownloadsProvider);

          return true;
        },
      );
    } catch (e) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isProcessing: false,
        error: 'Failed to cancel download: $e',
      );
      return false;
    }
  }

  /// Clear all downloads
  Future<bool> clearAllDownloads() async {
    state = state.copyWith(isProcessing: true, error: null, successMessage: null);

    try {
      final repository = await ref.read(offlineRepositoryProvider.future);
      final result = await repository.clearAllDownloads();

      if (!ref.mounted) return false;

      return result.fold(
        (failure) {
          state = state.copyWith(
            isProcessing: false,
            error: failure.errorMessage,
          );
          return false;
        },
        (_) {
          state = state.copyWith(
            isProcessing: false,
            successMessage: 'All downloads cleared!',
          );

          // Invalidate all offline providers
          ref.invalidate(downloadedStoriesProvider);
          ref.invalidate(downloadCountProvider);
          ref.invalidate(totalStorageUsedProvider);

          return true;
        },
      );
    } catch (e) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isProcessing: false,
        error: 'Failed to clear downloads: $e',
      );
      return false;
    }
  }

  /// Sync favorites with remote
  Future<bool> syncFavorites() async {
    try {
      final repository = await ref.read(offlineRepositoryProvider.future);
      final result = await repository.syncFavorites();

      return result.fold(
        (failure) => false,
        (_) {
          ref.invalidate(downloadedStoriesProvider);
          return true;
        },
      );
    } catch (e) {
      return false;
    }
  }

  /// Sync read counts with remote
  Future<bool> syncReadCounts() async {
    try {
      final repository = await ref.read(offlineRepositoryProvider.future);
      final result = await repository.syncReadCounts();

      return result.fold(
        (failure) => false,
        (_) {
          ref.invalidate(downloadedStoriesProvider);
          return true;
        },
      );
    } catch (e) {
      return false;
    }
  }

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}
