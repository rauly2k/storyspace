import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../story/domain/entities/story_entity.dart';

/// Recommended story card widget with play button
class RecommendedStoryCard extends StatelessWidget {
  final StoryEntity story;
  final VoidCallback? onTap;

  const RecommendedStoryCard({
    super.key,
    required this.story,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 24.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // The Card
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 4.0,
              child: SizedBox(
                width: 280.0,
                height: 180.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cover Image
                    story.coverImageUrl != null
                        ? Image.network(
                            story.coverImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.surfaceVariant,
                                child: const Icon(
                                  Icons.book,
                                  size: 48.0,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.surfaceVariant,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.surfaceVariant,
                            child: const Icon(
                              Icons.book,
                              size: 48.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                    // Dark gradient at the top
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Title
                    Positioned(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: Text(
                        story.title,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // The Play Button
            Positioned(
              bottom: -20.0,
              left: 24.0,
              child: CircleAvatar(
                radius: 28.0,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
