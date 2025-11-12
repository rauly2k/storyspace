import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/offline_providers.dart';
import '../../../../core/theme/app_colors.dart';

/// Button for downloading/deleting offline stories
class DownloadButton extends ConsumerWidget {
  final String storyId;
  final bool mini;

  const DownloadButton({
    required this.storyId,
    this.mini = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDownloadedAsync = ref.watch(isStoryDownloadedProvider(storyId));
    final progressAsync = ref.watch(watchDownloadProgressProvider(storyId));
    final controller = ref.watch(offlineControllerProvider.notifier);

    return isDownloadedAsync.when(
      data: (isDownloaded) {
        // Check if currently downloading
        return progressAsync.when(
          data: (progress) {
            if (progress != null && progress.isDownloading) {
              // Show progress indicator
              return mini
                  ? _buildMiniProgressIndicator(progress.progressPercentage)
                  : _buildFullProgressButton(
                      context,
                      progress.progressPercentage,
                      () => controller.cancelDownload(storyId),
                    );
            }

            // Show download or delete button
            if (isDownloaded) {
              return mini
                  ? _buildMiniButton(
                      icon: Icons.download_done,
                      color: AppColors.success,
                      onPressed: () => _showDeleteDialog(context, ref),
                    )
                  : _buildFullButton(
                      context,
                      icon: Icons.delete_outline,
                      label: 'Remove',
                      color: AppColors.error,
                      onPressed: () => _showDeleteDialog(context, ref),
                    );
            } else {
              return mini
                  ? _buildMiniButton(
                      icon: Icons.download_outlined,
                      color: AppColors.primary,
                      onPressed: () => _handleDownload(context, ref),
                    )
                  : _buildFullButton(
                      context,
                      icon: Icons.download_outlined,
                      label: 'Download',
                      color: AppColors.primary,
                      onPressed: () => _handleDownload(context, ref),
                    );
            }
          },
          loading: () => mini
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const CircularProgressIndicator(),
          error: (_, __) => mini
              ? _buildMiniButton(
                  icon: Icons.error_outline,
                  color: AppColors.error,
                  onPressed: () {},
                )
              : _buildFullButton(
                  context,
                  icon: Icons.error_outline,
                  label: 'Error',
                  color: AppColors.error,
                  onPressed: () {},
                ),
        );
      },
      loading: () => mini
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const CircularProgressIndicator(),
      error: (_, __) => mini
          ? _buildMiniButton(
              icon: Icons.error_outline,
              color: AppColors.error,
              onPressed: () {},
            )
          : _buildFullButton(
              context,
              icon: Icons.error_outline,
              label: 'Error',
              color: AppColors.error,
              onPressed: () {},
            ),
    );
  }

  Widget _buildMiniButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      iconSize: 24,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildFullButton(
    BuildContext context,
    {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildMiniProgressIndicator(int percentage) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 2,
            color: AppColors.primary,
          ),
          Text(
            '$percentage',
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFullProgressButton(
    BuildContext context,
    int percentage,
    VoidCallback onCancel,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(value: percentage / 100),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Downloading $percentage%'),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleDownload(BuildContext context, WidgetRef ref) async {
    final canDownload = await ref.read(canDownloadMoreProvider.future);

    if (!canDownload) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Download limit reached. Upgrade to Premium for more downloads!',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final controller = ref.read(offlineControllerProvider.notifier);
    final success = await controller.downloadStory(storyId);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Story downloaded successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final error = ref.read(offlineControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to download story'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Download'),
        content: const Text(
          'Are you sure you want to remove this downloaded story? '
          'You can download it again later.',
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
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final controller = ref.read(offlineControllerProvider.notifier);
    final success = await controller.deleteDownload(storyId);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Story removed successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final error = ref.read(offlineControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to remove story'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
