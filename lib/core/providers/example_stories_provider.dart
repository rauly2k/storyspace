import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/story/domain/entities/story_entity.dart';
import '../data/example_stories.dart';

part 'example_stories_provider.g.dart';

/// Provider for example stories that converts them to StoryEntity format
@riverpod
List<StoryEntity> exampleStoriesProvider(Ref ref) {
  return exampleStories.map((exampleStory) {
    // Convert example story pages to content string
    final content = exampleStory.pages.map((page) => page.text).join('\n\n');

    return StoryEntity(
      id: exampleStory.id,
      userId: 'example_user',
      kidProfileId: 'example',
      title: exampleStory.title,
      content: content,
      genre: exampleStory.genre,
      coverImageUrl: exampleStory.coverImageUrl,
      sceneImageUrls: exampleStory.pages
          .where((page) => page.imageUrl != null)
          .map((page) => page.imageUrl!)
          .toList(),
      isAIGenerated: true,
      readCount: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      lastReadAt: null,
    );
  }).toList();
}

/// Provider for getting a specific example story by ID
@riverpod
ExampleStory? getExampleStory(Ref ref, String storyId) {
  try {
    return exampleStories.firstWhere((story) => story.id == storyId);
  } catch (e) {
    return null;
  }
}
