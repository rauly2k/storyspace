import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/reading_preferences_provider.dart';
import '../../../kid_profile/domain/entities/kid_profile_entity.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../audio_narration/presentation/widgets/audio_controls.dart';
import '../../domain/entities/story_entity.dart';
import '../providers/story_providers.dart';
import '../widgets/reading_controls.dart';

/// Screen for viewing a full story.
class StoryViewerScreen extends ConsumerStatefulWidget {
  final StoryEntity story;
  final KidProfileEntity kidProfile;

  const StoryViewerScreen({
    super.key,
    required this.story,
    required this.kidProfile,
  });

  @override
  ConsumerState<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends ConsumerState<StoryViewerScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasMarkedAsRead = false;

  @override
  void initState() {
    super.initState();
    // Mark as read when story is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasMarkedAsRead) {
        _markAsRead();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _markAsRead() async {
    if (_hasMarkedAsRead) return;

    final controller = ref.read(storyControllerProvider.notifier);
    await controller.markAsRead(storyId: widget.story.id);
    _hasMarkedAsRead = true;
  }

  @override
  Widget build(BuildContext context) {
    final ageBucketColor = AppColors.getAgeBucketColor(widget.kidProfile.ageBucket);
    final preferences = ref.watch(readingPreferencesProvider);
    final preferencesNotifier = ref.read(readingPreferencesProvider.notifier);
    final backgroundColor = preferencesNotifier.getBackgroundColor();
    final textColor = preferencesNotifier.getTextColor();
    final showControls = ref.watch(_showControlsProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(widget.story.title),
        actions: [
          // Toggle reading controls
          IconButton(
            icon: Icon(
              showControls ? Icons.settings : Icons.settings_outlined,
              color: textColor,
            ),
            onPressed: () {
              ref.read(_showControlsProvider.notifier).state = !showControls;
            },
            tooltip: 'Reading Settings',
          ),
          // Favorite button
          Consumer(
            builder: (context, ref, child) {
              final isFavoritedAsync = ref.watch(
                isStoryFavoritedProvider(widget.story.id),
              );

              return isFavoritedAsync.when(
                data: (isFavorited) => IconButton(
                  icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.red : textColor,
                  ),
                  onPressed: () async {
                    final controller = ref.read(favoritesControllerProvider.notifier);
                    final success = await controller.toggleFavorite(
                      storyId: widget.story.id,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? isFavorited
                                    ? 'Removed from favorites'
                                    : 'Added to favorites'
                                : 'Failed to update favorites',
                          ),
                          backgroundColor: success ? AppColors.success : AppColors.error,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  tooltip: isFavorited ? 'Remove from Favorites' : 'Add to Favorites',
                ),
                loading: () => const IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: null,
                ),
                error: (_, __) => const IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: null,
                ),
              );
            },
          ),
          // Story metadata badge
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ageBucketColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ageBucketColor),
                ),
                child: Text(
                  widget.story.readingTimeDisplay,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: ageBucketColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Reading controls (collapsible)
          if (showControls)
            ReadingControls(accentColor: ageBucketColor),

          // Story content
          Expanded(
            child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.story.title,
              style: AppTextStyles.getStoryTextStyle(widget.kidProfile.ageBucket).copyWith(
                fontSize: (32 * preferences.textScale).toDouble(),
                fontWeight: FontWeight.bold,
                color: ageBucketColor,
              ),
            ),
            const SizedBox(height: 16),

            // Metadata
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildMetadataChip(
                  icon: Icons.person_outline,
                  label: 'For ${widget.kidProfile.name}',
                  color: ageBucketColor,
                ),
                _buildMetadataChip(
                  icon: Icons.category_outlined,
                  label: widget.story.genre,
                  color: AppColors.getGenreColor(widget.story.genre),
                ),
                if (widget.story.isAIGenerated)
                  _buildMetadataChip(
                    icon: Icons.auto_awesome,
                    label: 'AI Generated',
                    color: AppColors.aiStory,
                  ),
                _buildMetadataChip(
                  icon: Icons.visibility_outlined,
                  label: widget.story.readCountDisplay,
                  color: Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),

            // Story content
            SelectableText(
              widget.story.content,
              style: AppTextStyles.getStoryTextStyle(widget.kidProfile.ageBucket).copyWith(
                height: 1.8,
                letterSpacing: 0.3,
                fontSize: AppTextStyles.getStoryTextStyle(widget.kidProfile.ageBucket).fontSize! * preferences.textScale,
                color: textColor,
              ),
            ),

            const SizedBox(height: 48),

            // End decoration
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.auto_stories,
                    size: 48,
                    color: ageBucketColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The End',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: ageBucketColor,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // AI Prompt (if available)
            if (widget.story.isAIGenerated && widget.story.aiPrompt != null) ...[
              const Divider(),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.aiStory.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.aiStory.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 20,
                          color: AppColors.aiStory,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Custom Request',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.aiStory,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.story.aiPrompt!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
            ),
          ),

          // Audio controls
          AudioControls(
            storyContent: widget.story.content,
            accentColor: ageBucketColor,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Scroll to top
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: ageBucketColor,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget _buildMetadataChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// StateProvider to manage reading controls visibility
final _showControlsProvider = StateProvider<bool>((ref) => false);
