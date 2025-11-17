import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../kid_profile/presentation/providers/kid_profile_providers.dart';
import '../../../story/presentation/providers/story_providers.dart';
import '../../../story/domain/entities/story_entity.dart';
import '../widgets/recommended_story_card.dart';

part 'library_screen.g.dart';

/// Library screen showing all stories across all kid profiles
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final kidProfilesAsync = ref.watch(kidProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search stories...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Genre filter chips
          SizedBox(
            height: 50.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Adventure'),
                _buildFilterChip('Fantasy'),
                _buildFilterChip('Sci-Fi'),
                _buildFilterChip('Mystery'),
                _buildFilterChip('Funny'),
                _buildFilterChip('Magical'),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          // Stories grid
          Expanded(
            child: kidProfilesAsync.when(
              data: (profiles) {
                if (profiles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add,
                          size: 80.0,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'No kid profiles yet',
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Create a profile to start creating stories!',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.go(AppRoutes.createKidProfile);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create Profile'),
                        ),
                      ],
                    ),
                  );
                }

                // Collect all stories from all profiles
                return _AllStoriesView(
                  profiles: profiles,
                  searchQuery: _searchQuery,
                  genreFilter: _selectedFilter,
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80.0,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Error loading profiles',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        checkmarkColor: Colors.white,
      ),
    );
  }
}

/// Widget to display all stories from all profiles
class _AllStoriesView extends ConsumerWidget {
  final List<dynamic> profiles;
  final String searchQuery;
  final String genreFilter;

  const _AllStoriesView({
    required this.profiles,
    required this.searchQuery,
    required this.genreFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Collect stories from all profiles
    final allStoriesAsync = ref.watch(_allStoriesProvider(profiles));

    return allStoriesAsync.when(
      data: (allStories) {
        if (allStories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 80.0,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'No stories yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Create your first story!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          );
        }

        // Filter stories by search query and genre
        final filteredStories = allStories.where((item) {
          final story = item['story'] as StoryEntity;
          final matchesSearch = searchQuery.isEmpty ||
              story.title.toLowerCase().contains(searchQuery) ||
              story.content.toLowerCase().contains(searchQuery);
          final matchesGenre = genreFilter == 'All' ||
              story.genre.toLowerCase() == genreFilter.toLowerCase();
          return matchesSearch && matchesGenre;
        }).toList();

        if (filteredStories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80.0,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'No stories found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Try a different search or filter',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: filteredStories.length,
          itemBuilder: (context, index) {
            final item = filteredStories[index];
            final story = item['story'] as StoryEntity;
            final kidProfile = item['kidProfile'];

            return GestureDetector(
              onTap: () {
                context.push(
                  AppRoutes.storyViewer,
                  extra: {
                    'story': story,
                    'kidProfile': kidProfile,
                  },
                );
              },
              child: RecommendedStoryCard(
                story: story,
                onTap: () {
                  context.push(
                    AppRoutes.storyViewer,
                    extra: {
                      'story': story,
                      'kidProfile': kidProfile,
                    },
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80.0,
              color: AppColors.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Error loading stories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider to aggregate all stories from all profiles
@riverpod
Future<List<Map<String, dynamic>>> _allStories(
  Ref ref,
  List<dynamic> profiles,
) async {
  final allStories = <Map<String, dynamic>>[];

  for (final profile in profiles) {
    final storiesAsync = await ref.watch(storiesForKidProvider(profile.id).future);
    for (final story in storiesAsync) {
      allStories.add({
        'story': story,
        'kidProfile': profile,
      });
    }
  }

  // Sort by creation date (most recent first)
  allStories.sort((a, b) {
    final storyA = a['story'] as StoryEntity;
    final storyB = b['story'] as StoryEntity;
    return storyB.createdAt.compareTo(storyA.createdAt);
  });

  return allStories;
}
