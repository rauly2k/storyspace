import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/story_remote_datasource.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';

part 'story_providers.g.dart';

// ==================== INFRASTRUCTURE PROVIDERS ====================

/// Provides the Gemini AI service
@riverpod
GeminiService geminiService(Ref ref) {
  return GeminiService();
}

/// Provides the story remote data source
@riverpod
StoryRemoteDataSource storyRemoteDataSource(Ref ref) {
  return StoryRemoteDataSource();
}

/// Provides the story repository
@riverpod
StoryRepository storyRepository(Ref ref) {
  return StoryRepositoryImpl(
    remoteDataSource: ref.watch(storyRemoteDataSourceProvider),
    geminiService: ref.watch(geminiServiceProvider),
  );
}

// ==================== DATA PROVIDERS ====================

/// Stream of stories for a specific kid profile
@riverpod
Stream<List<StoryEntity>> storiesForKid(
  Ref ref,
  String kidProfileId,
) async* {
  final repository = ref.watch(storyRepositoryProvider);

  await for (final result in repository.watchStoriesForKid(kidProfileId: kidProfileId)) {
    yield result.fold(
      (failure) => [],
      (stories) => stories,
    );
  }
}

/// Get a single story by ID
@riverpod
Future<StoryEntity?> story(Ref ref, String storyId) async {
  final repository = ref.watch(storyRepositoryProvider);

  final result = await repository.getStoryById(storyId: storyId);

  return result.fold(
    (failure) => null,
    (story) => story,
  );
}

/// Get AI story count for current user (for subscription limits)
@riverpod
Future<int> aiStoryCount(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return 0;

  final repository = ref.watch(storyRepositoryProvider);
  final result = await repository.getAIStoryCountForUser(userId: user.id);

  return result.fold(
    (failure) => 0,
    (count) => count,
  );
}

// ==================== CONTROLLER ====================

/// Controller for story operations
@riverpod
class StoryController extends _$StoryController {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  /// Create a manual story
  Future<bool> createStory({
    required String kidProfileId,
    required String title,
    required String content,
    required String genre,
    String? coverImageUrl,
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

    final repository = ref.read(storyRepositoryProvider);
    final result = await repository.createStory(
      kidProfileId: kidProfileId,
      userId: user.id,
      title: title,
      content: content,
      genre: genre,
      coverImageUrl: coverImageUrl,
      isAIGenerated: false,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (story) {
        state = const AsyncValue.data(null);
        // Invalidate the stories list to refresh
        ref.invalidate(storiesForKidProvider);
        return true;
      },
    );
  }

  /// Generate an AI story
  Future<bool> generateAIStory({
    required String kidProfileId,
    required String kidName,
    required int kidAge,
    required String genre,
    required List<String> interests,
    String? customPrompt,
    String? artStyle,
    bool generateImages = false,
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

    final repository = ref.read(storyRepositoryProvider);
    final result = await repository.generateAIStory(
      kidProfileId: kidProfileId,
      userId: user.id,
      kidName: kidName,
      kidAge: kidAge,
      genre: genre,
      interests: interests,
      customPrompt: customPrompt,
      artStyle: artStyle,
      generateImages: generateImages,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (story) {
        state = const AsyncValue.data(null);
        // Invalidate providers to refresh
        ref.invalidate(storiesForKidProvider);
        ref.invalidate(aiStoryCountProvider);
        return true;
      },
    );
  }

  /// Update a story
  Future<bool> updateStory({
    required String storyId,
    String? title,
    String? content,
    String? genre,
    String? coverImageUrl,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(storyRepositoryProvider);
    final result = await repository.updateStory(
      storyId: storyId,
      title: title,
      content: content,
      genre: genre,
      coverImageUrl: coverImageUrl,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (story) {
        state = const AsyncValue.data(null);
        // Invalidate the stories list to refresh
        ref.invalidate(storiesForKidProvider);
        return true;
      },
    );
  }

  /// Mark story as read
  Future<bool> markAsRead({
    required String storyId,
  }) async {
    final repository = ref.read(storyRepositoryProvider);
    final result = await repository.markAsRead(storyId: storyId);

    return result.fold(
      (failure) => false,
      (_) {
        // Invalidate the stories list to refresh read count
        ref.invalidate(storiesForKidProvider);
        return true;
      },
    );
  }

  /// Delete a story
  Future<bool> deleteStory({
    required String storyId,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(storyRepositoryProvider);
    final result = await repository.deleteStory(storyId: storyId);

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
        // Invalidate the stories list to refresh
        ref.invalidate(storiesForKidProvider);
        ref.invalidate(aiStoryCountProvider);
        return true;
      },
    );
  }
}
