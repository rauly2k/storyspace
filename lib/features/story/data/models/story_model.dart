import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/story_entity.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

/// Data model for Story with JSON and Firestore serialization.
@freezed
class StoryModel with _$StoryModel {
  const StoryModel._();

  const factory StoryModel({
    required String id,
    required String kidProfileId,
    required String userId,
    required String title,
    required String content,
    required String genre,
    String? coverImageUrl,
    @Default(false) bool isAIGenerated,
    String? aiPrompt,
    @Default(0) int readCount,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() DateTime? lastReadAt,
  }) = _StoryModel;

  /// Convert from JSON
  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  /// Convert from Firestore document
  factory StoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryModel.fromJson({
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
  StoryEntity toEntity() {
    return StoryEntity(
      id: id,
      kidProfileId: kidProfileId,
      userId: userId,
      title: title,
      content: content,
      genre: genre,
      coverImageUrl: coverImageUrl,
      isAIGenerated: isAIGenerated,
      aiPrompt: aiPrompt,
      readCount: readCount,
      createdAt: createdAt,
      lastReadAt: lastReadAt,
    );
  }

  /// Create from domain entity
  factory StoryModel.fromEntity(StoryEntity entity) {
    return StoryModel(
      id: entity.id,
      kidProfileId: entity.kidProfileId,
      userId: entity.userId,
      title: entity.title,
      content: entity.content,
      genre: entity.genre,
      coverImageUrl: entity.coverImageUrl,
      isAIGenerated: entity.isAIGenerated,
      aiPrompt: entity.aiPrompt,
      readCount: entity.readCount,
      createdAt: entity.createdAt,
      lastReadAt: entity.lastReadAt,
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
