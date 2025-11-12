import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_entity.freezed.dart';

/// Represents a story in the application.
/// Stories can be AI-generated or manually created.
@freezed
abstract class StoryEntity with _$StoryEntity {
  const StoryEntity._();

  const factory StoryEntity({
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
    required DateTime createdAt,
    DateTime? lastReadAt,
  }) = _StoryEntity;

  /// Get a short excerpt of the story (first 100 characters)
  String get excerpt {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  /// Get formatted read count
  String get readCountDisplay {
    if (readCount == 0) return 'Not read yet';
    if (readCount == 1) return 'Read once';
    return 'Read $readCount times';
  }

  /// Get reading time estimate based on word count
  int get estimatedReadingTimeMinutes {
    final wordCount = content.split(RegExp(r'\s+')).length;
    // Average reading speed: 200 words per minute for kids
    return (wordCount / 200).ceil();
  }

  /// Get formatted reading time
  String get readingTimeDisplay {
    final minutes = estimatedReadingTimeMinutes;
    if (minutes < 1) return 'Less than 1 min';
    if (minutes == 1) return '1 min';
    return '$minutes mins';
  }
}
