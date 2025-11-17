import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../kid_profile/domain/entities/kid_profile_entity.dart';
import '../providers/story_providers.dart';
import '../widgets/story_card.dart';

/// Screen displaying the story library for a specific kid profile.
class StoryLibraryScreen extends ConsumerWidget {
  final KidProfileEntity kidProfile;

  const StoryLibraryScreen({
    super.key,
    required this.kidProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesForKidProvider(kidProfile.id));
    final currentUser = ref.watch(currentUserProvider).value;
    final aiStoryCountAsync = ref.watch(aiStoryCountProvider);

    return Scaffold(
      backgroundColor: AppColors.getAgeBucketColor(kidProfile.ageBucket).withOpacity(0.1),
      appBar: AppBar(
        title: Text('${kidProfile.name}\'s Stories'),
        actions: [
          // AI Story count indicator
          aiStoryCountAsync.when(
            data: (count) {
              final limit = AppConstants.getAIStoryLimit(
                currentUser?.subscriptionTier ?? 'free',
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    limit == -1 ? 'AI: $count' : 'AI: $count/$limit',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: storiesAsync.when(
        data: (stories) {
          if (stories.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: StoryCard(
                  story: story,
                  kidProfile: kidProfile,
                  onTap: () {
                    context.push(
                      '${AppRoutes.storyViewer}?storyId=${story.id}',
                      extra: {
                        'story': story,
                        'kidProfile': kidProfile,
                      },
                    );
                  },
                  onDelete: () => _showDeleteConfirmation(context, ref, story.id),
                ),
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
                'Failed to load stories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStoryTypeDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Story'),
        backgroundColor: AppColors.getAgeBucketColor(kidProfile.ageBucket),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories,
              size: 120,
              color: AppColors.getAgeBucketColor(kidProfile.ageBucket).withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No Stories Yet!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.getAgeBucketColor(kidProfile.ageBucket),
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create ${kidProfile.name}\'s first magical adventure',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showStoryTypeDialog(context, ref),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate AI Story'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.getAgeBucketColor(kidProfile.ageBucket),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoryTypeDialog(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(currentUserProvider).value;
    final aiStoryCountAsync = ref.read(aiStoryCountProvider);

    // Check if user has reached limit
    aiStoryCountAsync.whenData((count) {
      final limit = AppConstants.getAIStoryLimit(
        currentUser?.subscriptionTier ?? 'free',
      );
      if (limit != -1 && count >= limit) {
        _showUpgradeDialog(context);
        return;
      }

      // Directly navigate to story wizard
      context.push(AppRoutes.storyWizard);
    });
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade Required'),
        content: const Text(
          'You\'ve reached your AI story limit. Upgrade to Premium or Premium+ '
          'to generate unlimited stories!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push(AppRoutes.subscription);
            },
            child: const Text('View Plans'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String storyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Story?'),
        content: const Text(
          'Are you sure you want to delete this story? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final controller = ref.read(storyControllerProvider.notifier);
              final success = await controller.deleteStory(storyId: storyId);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Story deleted successfully'
                          : 'Failed to delete story',
                    ),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
