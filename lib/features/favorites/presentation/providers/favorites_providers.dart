import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/favorites_remote_datasource.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';

part 'favorites_providers.g.dart';

// ==================== INFRASTRUCTURE PROVIDERS ====================

/// Provides the favorites remote data source
@riverpod
FavoritesRemoteDataSource favoritesRemoteDataSource(
  FavoritesRemoteDataSourceRef ref,
) {
  return FavoritesRemoteDataSource();
}

/// Provides the favorites repository
@riverpod
FavoritesRepository favoritesRepository(FavoritesRepositoryRef ref) {
  return FavoritesRepositoryImpl(
    remoteDataSource: ref.watch(favoritesRemoteDataSourceProvider),
  );
}

// ==================== DATA PROVIDERS ====================

/// Stream of favorite story IDs for current user
@riverpod
Stream<List<String>> favoriteStoryIds(FavoriteStoryIdsRef ref) async* {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    yield [];
    return;
  }

  final repository = ref.watch(favoritesRepositoryProvider);

  await for (final result in repository.watchFavoriteStoryIds(userId: user.id)) {
    yield result.fold(
      (failure) => [],
      (storyIds) => storyIds,
    );
  }
}

/// Check if a specific story is favorited
@riverpod
Future<bool> isStoryFavorited(
  IsStoryFavoritedRef ref,
  String storyId,
) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return false;

  final repository = ref.watch(favoritesRepositoryProvider);
  final result = await repository.isFavorite(
    userId: user.id,
    storyId: storyId,
  );

  return result.fold(
    (failure) => false,
    (isFavorited) => isFavorited,
  );
}

// ==================== CONTROLLER ====================

/// Controller for favorites operations
@riverpod
class FavoritesController extends _$FavoritesController {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  /// Toggle favorite status for a story
  Future<bool> toggleFavorite({
    required String storyId,
  }) async {
    state = const AsyncValue.loading();

    final user = await ref.read(currentUserProvider.future);
    if (user == null) {
      state = AsyncValue.error(
        Exception('User not authenticated'),
        StackTrace.current,
      );
      return false;
    }

    final repository = ref.read(favoritesRepositoryProvider);

    // Check current favorite status
    final isFavoritedResult = await repository.isFavorite(
      userId: user.id,
      storyId: storyId,
    );

    final isFavorited = isFavoritedResult.fold(
      (failure) => false,
      (value) => value,
    );

    // Toggle
    final result = isFavorited
        ? await repository.removeFavorite(userId: user.id, storyId: storyId)
        : await repository.addFavorite(userId: user.id, storyId: storyId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        // Invalidate to refresh
        ref.invalidate(favoriteStoryIdsProvider);
        ref.invalidate(isStoryFavoritedProvider);
        return true;
      },
    );
  }

  /// Add a story to favorites
  Future<bool> addFavorite({
    required String storyId,
  }) async {
    state = const AsyncValue.loading();

    final user = await ref.read(currentUserProvider.future);
    if (user == null) {
      state = AsyncValue.error(
        Exception('User not authenticated'),
        StackTrace.current,
      );
      return false;
    }

    final repository = ref.read(favoritesRepositoryProvider);
    final result = await repository.addFavorite(
      userId: user.id,
      storyId: storyId,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        // Invalidate to refresh
        ref.invalidate(favoriteStoryIdsProvider);
        ref.invalidate(isStoryFavoritedProvider);
        return true;
      },
    );
  }

  /// Remove a story from favorites
  Future<bool> removeFavorite({
    required String storyId,
  }) async {
    state = const AsyncValue.loading();

    final user = await ref.read(currentUserProvider.future);
    if (user == null) {
      state = AsyncValue.error(
        Exception('User not authenticated'),
        StackTrace.current,
      );
      return false;
    }

    final repository = ref.read(favoritesRepositoryProvider);
    final result = await repository.removeFavorite(
      userId: user.id,
      storyId: storyId,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        // Invalidate to refresh
        ref.invalidate(favoriteStoryIdsProvider);
        ref.invalidate(isStoryFavoritedProvider);
        return true;
      },
    );
  }
}
