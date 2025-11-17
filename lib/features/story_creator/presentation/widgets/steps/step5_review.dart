import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';
import '../../../../story/presentation/providers/story_providers.dart';
import '../../providers/story_wizard_provider.dart';

/// Step 5: Review & generate
class Step5Review extends ConsumerWidget {
  const Step5Review({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(storyWizardProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final aiStoryCountAsync = ref.watch(aiStoryCountProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Generate',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check your story settings before generating',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),

          // Profile info
          _buildSection(
            context,
            icon: Icons.person,
            title: 'Kid Profile',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wizardState.selectedProfile?.name ?? 'Not selected',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${wizardState.selectedProfile?.age} years old (${wizardState.selectedProfile?.ageBucket})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const Divider(height: 32),

          // Story settings
          _buildSection(
            context,
            icon: Icons.book,
            title: 'Story Settings',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(context, 'Genre', wizardState.selectedGenre),
                const SizedBox(height: 8),
                _buildInfoRow(
                  context,
                  'Length',
                  '${wizardState.storyLength.label} (~${wizardState.wordCount} words)',
                ),
                if (wizardState.selectedInterests.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Interests:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: wizardState.selectedInterests.map((interest) {
                      return Chip(
                        label: Text(interest),
                        labelStyle: const TextStyle(fontSize: 12),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ],
                if (wizardState.moralLesson != null &&
                    wizardState.moralLesson!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    'Moral Lesson',
                    wizardState.moralLesson!,
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 32),

          // Art style
          _buildSection(
            context,
            icon: Icons.palette,
            title: 'Art Style',
            content: Text(
              wizardState.artStyle.label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          const Divider(height: 32),

          // Photo
          _buildSection(
            context,
            icon: Icons.photo_camera,
            title: 'Photo',
            content: Text(
              wizardState.uploadedPhoto != null ? 'Photo uploaded ✓' : 'No photo',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          const SizedBox(height: 32),

          // AI credit usage
          aiStoryCountAsync.when(
            data: (count) {
              final tier = currentUser?.subscriptionTier ?? 'free';
              final limit = AppConstants.getAIStoryLimit(tier);

              if (limit == -1) {
                return _buildCreditInfo(
                  context,
                  'Unlimited',
                  'You have unlimited AI story generation',
                  Colors.green,
                );
              } else {
                final remaining = limit - count;
                final isLow = remaining <= 2;

                return _buildCreditInfo(
                  context,
                  '$remaining / $limit remaining',
                  isLow
                      ? 'Running low on AI stories. Consider upgrading!'
                      : 'AI stories remaining this month',
                  isLow ? Colors.orange : Colors.blue,
                );
              }
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          // Estimated time
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Generation Time',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '10-30 seconds',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: content,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditInfo(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.stars, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color.withOpacity(0.9),
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
