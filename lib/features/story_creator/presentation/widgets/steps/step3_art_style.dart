import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/story_wizard_state.dart';
import '../../providers/story_wizard_provider.dart';

/// Step 3: Art style selection (Premium+ feature)
class Step3ArtStyle extends ConsumerWidget {
  const Step3ArtStyle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(storyWizardNotifierProvider);
    final wizardNotifier = ref.read(storyWizardNotifierProvider.notifier);
    final currentUser = ref.watch(currentUserProvider).value;

    final isPremiumPlus = currentUser?.subscriptionTier == AppConstants.tierPremiumPlus;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Art Style',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the visual style for your story',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),

          if (!isPremiumPlus) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.workspace_premium, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium+ Feature',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.orange[900],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Upgrade to Premium+ to choose art styles',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.orange[700],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Art style grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: ArtStyle.values.length,
            itemBuilder: (context, index) {
              final artStyle = ArtStyle.values[index];
              final isSelected = wizardState.artStyle == artStyle;
              final isLocked = !isPremiumPlus;

              return GestureDetector(
                onTap: isLocked
                    ? () => _showUpgradeDialog(context)
                    : () => wizardNotifier.selectArtStyle(artStyle),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Image placeholder
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getArtStyleColor(artStyle).withOpacity(0.1),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(11),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(
                                      _getArtStyleIcon(artStyle),
                                      size: 64,
                                      color: _getArtStyleColor(artStyle),
                                    ),
                                  ),
                                  if (isLocked)
                                    Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: const Center(
                                        child: Icon(
                                          Icons.lock,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Title and description
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artStyle.label,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? AppColors.primary : null,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  artStyle.description,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selection indicator
                    if (isSelected && !isLocked)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Art styles are coming soon! Your selection will be saved for when image generation is available.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[900],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getArtStyleColor(ArtStyle style) {
    return switch (style) {
      ArtStyle.cartoon => Colors.orange,
      ArtStyle.storybook => Colors.purple,
      ArtStyle.anime => Colors.pink,
      ArtStyle.realistic => Colors.blue,
    };
  }

  IconData _getArtStyleIcon(ArtStyle style) {
    return switch (style) {
      ArtStyle.cartoon => Icons.sentiment_very_satisfied,
      ArtStyle.storybook => Icons.menu_book,
      ArtStyle.anime => Icons.star,
      ArtStyle.realistic => Icons.view_in_ar,
    };
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium+ Required'),
        content: const Text(
          'Art style selection is a Premium+ feature. Upgrade to unlock all art styles!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to subscription screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription screen coming soon!'),
                ),
              );
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}
