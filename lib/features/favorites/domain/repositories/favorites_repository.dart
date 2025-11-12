import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/favorite_entity.dart';

/// Repository interface for favorites operations.
abstract class FavoritesRepository {
  /// Get all favorite story IDs for a user
  Future<Either<Failure, List<String>>> getFavoriteStoryIds({
    required String userId,
  });

  /// Check if a story is favorited
  Future<Either<Failure, bool>> isFavorite({
    required String userId,
    required String storyId,
  });

  /// Add a story to favorites
  Future<Either<Failure, FavoriteEntity>> addFavorite({
    required String userId,
    required String storyId,
  });

  /// Remove a story from favorites
  Future<Either<Failure, void>> removeFavorite({
    required String userId,
    required String storyId,
  });

  /// Watch favorite story IDs (real-time updates)
  Stream<Either<Failure, List<String>>> watchFavoriteStoryIds({
    required String userId,
  });
}
