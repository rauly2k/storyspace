import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_entity.freezed.dart';

/// Represents a favorite story for a user.
@freezed
class FavoriteEntity with _$FavoriteEntity {
  const factory FavoriteEntity({
    required String id,
    required String userId,
    required String storyId,
    required DateTime createdAt,
  }) = _FavoriteEntity;
}
