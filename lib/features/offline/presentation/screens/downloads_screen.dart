import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/offline_providers.dart';
import '../../../story/presentation/widgets/story_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

/// Screen displaying all downloaded stories
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadedStoriesAsync = ref.watch(downloadedStoriesProvider);
    final downloadCountAsync = ref.watch(downloadCountProvider);
    final storageUsedAsync = ref.watch(formattedStorageUsedProvider);
    final remainingAsync = ref.watch(remainingDownloadsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Downloads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showDownloadSettings(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Storage info card
          _buildStorageInfo(
            context,
            downloadCountAsync,
            storageUsedAsync,
            remainingAsync,
          ),

          // Downloaded stories list
          Expanded(
            child: downloadedStoriesAsync.when(
              data: (stories) {
                if (stories.isEmpty) {
                  return _buildEmptyState(context);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(downloadedStoriesProvider);
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      return StoryCard(
                        story: story,
                        onTap: () {
                          context.push('/story/${story.id}');
                        },
                        showOfflineBadge: true,
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load downloads',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(downloadedStoriesProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
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

  Widget _buildStorageInfo(
    BuildContext context,
    AsyncValue<int> downloadCount,
    AsyncValue<String> storageUsed,
    AsyncValue<int> remaining,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storage, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Storage Info',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.download,
                  label: 'Downloaded',
                  value: downloadCount.when(
                    data: (count) => count.toString(),
                    loading: () => '...',
                    error: (_, __) => 'N/A',
                  ),
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.folder,
                  label: 'Storage Used',
                  value: storageUsed.when(
                    data: (size) => size,
                    loading: () => '...',
                    error: (_, __) => 'N/A',
                  ),
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.download_for_offline,
                  label: 'Remaining',
                  value: remaining.when(
                    data: (count) {
                      if (count >= AppConstants.premiumPlusDownloadLimit) {
                        return '∞';
                      }
                      return count.toString();
                    },
                    loading: () => '...',
                    error: (_, __) => 'N/A',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppColors.secondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_outlined,
            size: 100,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 24),
          Text(
            'No Downloads Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Download stories to read them offline anytime, anywhere!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/stories');
            },
            icon: const Icon(Icons.explore),
            label: const Text('Browse Stories'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDownloadSettings(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(offlineControllerProvider.notifier);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.sync, color: AppColors.primary),
                title: const Text('Sync with Cloud'),
                subtitle: const Text('Update your downloads with latest changes'),
                onTap: () async {
                  Navigator.pop(context);
                  await controller.syncFavorites();
                  await controller.syncReadCounts();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sync completed!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_sweep, color: AppColors.error),
                title: const Text('Clear All Downloads'),
                subtitle: const Text('Remove all downloaded stories'),
                onTap: () async {
                  Navigator.pop(context);
                  final confirmed = await _showClearAllDialog(context);

                  if (confirmed != true || !context.mounted) return;

                  final success = await controller.clearAllDownloads();

                  if (!context.mounted) return;

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All downloads cleared!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _showClearAllDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Downloads?'),
        content: const Text(
          'Are you sure you want to remove all downloaded stories? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
