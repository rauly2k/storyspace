import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../kid_profile/domain/entities/kid_profile_entity.dart';
import '../../domain/entities/story_entity.dart';

/// Card widget displaying a story in the library.
class StoryCard extends StatelessWidget {
  final StoryEntity story;
  final KidProfileEntity kidProfile;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const StoryCard({
    super.key,
    required this.story,
    required this.kidProfile,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ageBucketColor = AppColors.getAgeBucketColor(kidProfile.ageBucket);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image or placeholder
            _buildCoverImage(ageBucketColor),

            // Story info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          story.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (story.isAIGenerated)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.aiStory.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.aiStory),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 12,
                                color: AppColors.aiStory,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'AI',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.aiStory,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Excerpt
                  Text(
                    story.excerpt,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Metadata
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildMetadataChip(
                        context,
                        icon: Icons.category_outlined,
                        label: story.genre,
                        color: AppColors.getGenreColor(story.genre),
                      ),
                      _buildMetadataChip(
                        context,
                        icon: Icons.schedule,
                        label: story.readingTimeDisplay,
                        color: ageBucketColor,
                      ),
                      _buildMetadataChip(
                        context,
                        icon: Icons.visibility_outlined,
                        label: story.readCountDisplay,
                        color: Colors.grey,
                      ),
                    ],
                  ),

                  // Actions
                  if (onDelete != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline),
                          color: AppColors.error,
                          tooltip: 'Delete story',
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(Color ageBucketColor) {
    if (story.coverImageUrl != null && story.coverImageUrl!.isNotEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: story.coverImageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: ageBucketColor.withOpacity(0.2),
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => _buildPlaceholder(ageBucketColor),
        ),
      );
    }

    return _buildPlaceholder(ageBucketColor);
  }

  Widget _buildPlaceholder(Color ageBucketColor) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ageBucketColor.withOpacity(0.3),
              ageBucketColor.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.auto_stories,
            size: 64,
            color: ageBucketColor,
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
