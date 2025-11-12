import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/gemini_service.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_remote_datasource.dart';

/// Implementation of [StoryRepository] using Firebase and Gemini AI.
class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource _remoteDataSource;
  final GeminiService _geminiService;

  StoryRepositoryImpl({
    required StoryRemoteDataSource remoteDataSource,
    required GeminiService geminiService,
  })  : _remoteDataSource = remoteDataSource,
        _geminiService = geminiService;

  @override
  Stream<Either<Failure, List<StoryEntity>>> watchStoriesForKid({
    required String kidProfileId,
  }) async* {
    try {
      yield* _remoteDataSource
          .watchStoriesForKid(kidProfileId: kidProfileId)
          .map((models) {
        final entities = models.map((model) => model.toEntity()).toList();
        return right<Failure, List<StoryEntity>>(entities);
      }).handleError((error) {
        return left<Failure, List<StoryEntity>>(
          Failure.database(message: error.toString()),
        );
      });
    } catch (e) {
      yield left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> getStoriesForKid({
    required String kidProfileId,
  }) async {
    try {
      final models = await _remoteDataSource.getStoriesForKid(
        kidProfileId: kidProfileId,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return right(entities);
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> getStoryById({
    required String storyId,
  }) async {
    try {
      final model = await _remoteDataSource.getStoryById(storyId: storyId);
      return right(model.toEntity());
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> createStory({
    required String kidProfileId,
    required String userId,
    required String title,
    required String content,
    required String genre,
    String? coverImageUrl,
    bool isAIGenerated = false,
    String? aiPrompt,
  }) async {
    try {
      final model = await _remoteDataSource.createStory(
        kidProfileId: kidProfileId,
        userId: userId,
        title: title,
        content: content,
        genre: genre,
        coverImageUrl: coverImageUrl,
        isAIGenerated: isAIGenerated,
        aiPrompt: aiPrompt,
      );
      return right(model.toEntity());
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> generateAIStory({
    required String kidProfileId,
    required String userId,
    required String kidName,
    required int kidAge,
    required String genre,
    required List<String> interests,
    String? customPrompt,
  }) async {
    try {
      // Generate story content using Gemini
      final storyContent = await _geminiService.generateStory(
        kidName: kidName,
        age: kidAge,
        genre: genre,
        interests: interests,
        customPrompt: customPrompt,
      );

      // Generate title based on content
      final title = await _geminiService.generateTitle(
        storyContent: storyContent,
        genre: genre,
      );

      // Save to Firestore
      final model = await _remoteDataSource.createStory(
        kidProfileId: kidProfileId,
        userId: userId,
        title: title,
        content: storyContent,
        genre: genre,
        isAIGenerated: true,
        aiPrompt: customPrompt,
      );

      return right(model.toEntity());
    } on Exception catch (e) {
      if (e.toString().contains('GEMINI_API_KEY')) {
        return left(const Failure.configuration(
          message: 'Gemini API key not configured. Please add it to your .env file.',
        ));
      }
      if (e.toString().contains('Failed to generate')) {
        return left(Failure.api(
          message: 'Failed to generate story. Please try again.',
        ));
      }
      return left(Failure.unknown(message: e.toString()));
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> updateStory({
    required String storyId,
    String? title,
    String? content,
    String? genre,
    String? coverImageUrl,
  }) async {
    try {
      final model = await _remoteDataSource.updateStory(
        storyId: storyId,
        title: title,
        content: content,
        genre: genre,
        coverImageUrl: coverImageUrl,
      );
      return right(model.toEntity());
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String storyId,
  }) async {
    try {
      await _remoteDataSource.markAsRead(storyId: storyId);
      return right(null);
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStory({
    required String storyId,
  }) async {
    try {
      await _remoteDataSource.deleteStory(storyId: storyId);
      return right(null);
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getAIStoryCountForUser({
    required String userId,
  }) async {
    try {
      final count = await _remoteDataSource.getAIStoryCountForUser(
        userId: userId,
      );
      return right(count);
    } catch (e) {
      return left(Failure.database(message: e.toString()));
    }
  }
}
