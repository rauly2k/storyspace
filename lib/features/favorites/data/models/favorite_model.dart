import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/favorite_entity.dart';

part 'favorite_model.freezed.dart';
part 'favorite_model.g.dart';

/// Data model for Favorite with JSON and Firestore serialization.
@freezed
class FavoriteModel with _$FavoriteModel {
  const FavoriteModel._();

  const factory FavoriteModel({
    required String id,
    required String userId,
    required String storyId,
    @TimestampConverter() required DateTime createdAt,
  }) = _FavoriteModel;

  /// Convert from JSON
  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  /// Convert from Firestore document
  factory FavoriteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavoriteModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  /// Convert to Firestore document (excludes id)
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  /// Convert to domain entity
  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      userId: userId,
      storyId: storyId,
      createdAt: createdAt,
    );
  }

  /// Create from domain entity
  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      id: entity.id,
      userId: entity.userId,
      storyId: entity.storyId,
      createdAt: entity.createdAt,
    );
  }
}

/// Converter for Firestore Timestamps
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    if (timestamp == null) {
      return DateTime.now();
    }
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}
