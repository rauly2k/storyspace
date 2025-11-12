import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/models/story_wizard_state.dart';
import '../../providers/story_wizard_provider.dart';

/// Step 2: Story settings (genre, length, interests, moral)
class Step2StorySettings extends ConsumerWidget {
  const Step2StorySettings({super.key});

  static const List<String> _genres = [
    'Adventure',
    'Fantasy',
    'Mystery',
    'Science Fiction',
    'Educational',
    'Friendship',
    'Animal Story',
    'Fairy Tale',
  ];

  static const List<String> _commonInterests = [
    'Space',
    'Dinosaurs',
    'Animals',
    'Magic',
    'Sports',
    'Music',
    'Art',
    'Science',
    'Nature',
    'Robots',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(storyWizardNotifierProvider);
    final wizardNotifier = ref.read(storyWizardNotifierProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Story Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize the story for ${wizardState.selectedProfile?.name ?? "your child"}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),

          // Genre selection
          Text(
            'Genre',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _genres.map((genre) {
              final isSelected = wizardState.selectedGenre == genre;
              return ChoiceChip(
                label: Text(genre),
                selected: isSelected,
                onSelected: (_) => wizardNotifier.selectGenre(genre),
                selectedColor: AppColors.primary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Story length
          Text(
            'Story Length',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...StoryLength.values.map((length) {
            final isSelected = wizardState.storyLength == length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RadioListTile<StoryLength>(
                value: length,
                groupValue: wizardState.storyLength,
                onChanged: (value) {
                  if (value != null) {
                    wizardNotifier.selectLength(value);
                  }
                },
                title: Text(
                  length.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
                subtitle: Text(length.description),
                activeColor: AppColors.primary,
                tileColor: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 32),

          // Interests
          Text(
            'Interests (Optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select topics to include in the story',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Profile interests (pre-selected)
              if (wizardState.selectedProfile != null)
                ...wizardState.selectedProfile!.interests.map((interest) {
                  final isSelected = wizardState.selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (_) => wizardNotifier.toggleInterest(interest),
                    selectedColor: AppColors.secondary.withOpacity(0.3),
                    checkmarkColor: AppColors.secondary,
                    side: BorderSide(
                      color: isSelected ? AppColors.secondary : Colors.grey[300]!,
                    ),
                  );
                }),

              // Common interests
              ..._commonInterests.map((interest) {
                // Skip if already in profile interests
                if (wizardState.selectedProfile?.interests.contains(interest) == true) {
                  return const SizedBox.shrink();
                }

                final isSelected = wizardState.selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (_) => wizardNotifier.toggleInterest(interest),
                  selectedColor: AppColors.accent.withOpacity(0.3),
                  checkmarkColor: AppColors.accent,
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : Colors.grey[300]!,
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 32),

          // Moral lesson
          Text(
            'Moral Lesson (Optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'What should this story teach?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'e.g., kindness, sharing, bravery, honesty...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            maxLength: 100,
            onChanged: wizardNotifier.setMoralLesson,
          ),
        ],
      ),
    );
  }
}
