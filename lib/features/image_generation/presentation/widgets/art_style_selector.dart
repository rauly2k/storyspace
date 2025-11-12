import 'package:flutter/material.dart';
import '../../domain/entities/art_style.dart';

/// Widget for selecting art style for story images
class ArtStyleSelector extends StatelessWidget {
  final ArtStyle selectedStyle;
  final ValueChanged<ArtStyle> onStyleSelected;
  final bool isPremium;

  const ArtStyleSelector({
    super.key,
    required this.selectedStyle,
    required this.onStyleSelected,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Art Style',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: ArtStyle.values.length,
          itemBuilder: (context, index) {
            final style = ArtStyle.values[index];
            final isSelected = selectedStyle == style;
            final isLocked = style.requiresPremium && !isPremium;

            return _ArtStyleCard(
              style: style,
              isSelected: isSelected,
              isLocked: isLocked,
              onTap: () {
                if (!isLocked) {
                  onStyleSelected(style);
                } else {
                  _showPremiumDialog(context);
                }
              },
            );
          },
        ),
      ],
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          'Additional art styles are available with Premium subscription. '
          'Upgrade to unlock all art styles!',
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
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

class _ArtStyleCard extends StatelessWidget {
  final ArtStyle style;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _ArtStyleCard({
    required this.style,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.white,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.iconEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    style.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    style.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            if (isSelected && !isLocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
