import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/story_entity.dart';

/// Repository interface for story operations.
abstract class StoryRepository {
  /// Watch all stories for a specific kid profile (real-time updates)
  Stream<Either<Failure, List<StoryEntity>>> watchStoriesForKid({
    required String kidProfileId,
  });

  /// Get all stories for a specific kid profile
  Future<Either<Failure, List<StoryEntity>>> getStoriesForKid({
    required String kidProfileId,
  });

  /// Get a single story by ID
  Future<Either<Failure, StoryEntity>> getStoryById({
    required String storyId,
  });

  /// Create a new story
  Future<Either<Failure, StoryEntity>> createStory({
    required String kidProfileId,
    required String userId,
    required String title,
    required String content,
    required String genre,
    String? coverImageUrl,
    bool isAIGenerated = false,
    String? aiPrompt,
  });

  /// Generate an AI story using Gemini API
  Future<Either<Failure, StoryEntity>> generateAIStory({
    required String kidProfileId,
    required String userId,
    required String kidName,
    required int kidAge,
    required String genre,
    required List<String> interests,
    String? customPrompt,
    String? artStyle,
    bool generateImages = false,
  });

  /// Update a story
  Future<Either<Failure, StoryEntity>> updateStory({
    required String storyId,
    String? title,
    String? content,
    String? genre,
    String? coverImageUrl,
  });

  /// Increment read count and update last read time
  Future<Either<Failure, void>> markAsRead({
    required String storyId,
  });

  /// Delete a story
  Future<Either<Failure, void>> deleteStory({
    required String storyId,
  });

  /// Get total story count for a user (for subscription limits)
  Future<Either<Failure, int>> getAIStoryCountForUser({
    required String userId,
  });
}
