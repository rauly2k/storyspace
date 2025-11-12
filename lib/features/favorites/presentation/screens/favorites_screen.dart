import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../story/domain/entities/story_entity.dart';
import '../../../story/presentation/providers/story_providers.dart';
import '../../../kid_profile/presentation/providers/kid_profile_providers.dart';
import '../providers/favorites_providers.dart';

/// Screen showing all favorite stories across all profiles
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteStoryIds = ref.watch(favoriteStoryIdsProvider);
    final profiles = ref.watch(kidProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: favoriteStoryIds.when(
        data: (storyIds) {
          if (storyIds.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: storyIds.length,
            itemBuilder: (context, index) {
              final storyId = storyIds[index];
              return _FavoriteStoryCard(
                storyId: storyId,
                profiles: profiles,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Error loading favorites',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Favorites Yet!',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on stories you love to save them here',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Card for displaying a favorite story
class _FavoriteStoryCard extends ConsumerWidget {
  final String storyId;
  final AsyncValue profiles;

  const _FavoriteStoryCard({
    required this.storyId,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyByIdProvider(storyId));

    return storyAsync.when(
      data: (story) {
        if (story == null) {
          return const SizedBox.shrink();
        }

        // Find the profile for this story
        final profile = profiles.value?.firstWhere(
          (p) => p.id == story.kidProfileId,
          orElse: () => null,
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              if (profile != null) {
                context.push(
                  AppRoutes.storyViewer,
                  extra: {
                    'story': story,
                    'kidProfile': profile,
                  },
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Story icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getGenreColor(story.genre).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getGenreIcon(story.genre),
                          color: _getGenreColor(story.genre),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Story info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.title,
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (profile != null)
                              Text(
                                'For ${profile.name}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Favorite button
                      IconButton(
                        icon: const Icon(Icons.favorite, color: AppColors.accent),
                        onPressed: () {
                          ref.read(favoritesControllerProvider.notifier).toggleFavorite(
                                storyId: storyId,
                              );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Genre and creation date
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(story.genre),
                        labelStyle: AppTextStyles.labelSmall,
                        backgroundColor: _getGenreColor(story.genre).withOpacity(0.1),
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        label: Text(_formatDate(story.createdAt)),
                        labelStyle: AppTextStyles.labelSmall,
                        backgroundColor: Colors.grey[200],
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Color _getGenreColor(String genre) {
    switch (genre.toLowerCase()) {
      case 'adventure':
        return Colors.orange;
      case 'fantasy':
        return Colors.purple;
      case 'mystery':
        return Colors.indigo;
      case 'science fiction':
        return Colors.blue;
      case 'educational':
        return Colors.green;
      case 'friendship':
        return Colors.pink;
      case 'animal story':
        return Colors.brown;
      case 'fairy tale':
        return Colors.deepPurple;
      default:
        return AppColors.primary;
    }
  }

  IconData _getGenreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'adventure':
        return Icons.explore;
      case 'fantasy':
        return Icons.auto_awesome;
      case 'mystery':
        return Icons.search;
      case 'science fiction':
        return Icons.rocket_launch;
      case 'educational':
        return Icons.school;
      case 'friendship':
        return Icons.favorite;
      case 'animal story':
        return Icons.pets;
      case 'fairy tale':
        return Icons.castle;
      default:
        return Icons.menu_book;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
