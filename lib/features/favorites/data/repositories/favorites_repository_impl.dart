import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

/// Implementation of [FavoritesRepository] using Firebase.
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource _remoteDataSource;

  FavoritesRepositoryImpl({
    required FavoritesRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<String>>> getFavoriteStoryIds({
    required String userId,
  }) async {
    try {
      final storyIds = await _remoteDataSource.getFavoriteStoryIds(
        userId: userId,
      );
      return right(storyIds);
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite({
    required String userId,
    required String storyId,
  }) async {
    try {
      final isFavorited = await _remoteDataSource.isFavorite(
        userId: userId,
        storyId: storyId,
      );
      return right(isFavorited);
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FavoriteEntity>> addFavorite({
    required String userId,
    required String storyId,
  }) async {
    try {
      final model = await _remoteDataSource.addFavorite(
        userId: userId,
        storyId: storyId,
      );
      return right(model.toEntity());
    } catch (e) {
      if (e.toString().contains('already in favorites')) {
        return left(const Failure.validation(
          message: 'Story is already in favorites',
        ));
      }
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite({
    required String userId,
    required String storyId,
  }) async {
    try {
      await _remoteDataSource.removeFavorite(
        userId: userId,
        storyId: storyId,
      );
      return right(null);
    } catch (e) {
      if (e.toString().contains('not found')) {
        return left(const Failure.notFound(
          message: 'Favorite not found',
        ));
      }
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<String>>> watchFavoriteStoryIds({
    required String userId,
  }) async* {
    try {
      yield* _remoteDataSource
          .watchFavoriteStoryIds(userId: userId)
          .map((storyIds) {
        return right<Failure, List<String>>(storyIds);
      }).handleError((error) {
        return left<Failure, List<String>>(
          Failure.database(message: error.toString()),
        );
      });
    } catch (e) {
      yield left(Failure.database(message: e.toString()));
    }
  }
}
