import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../kid_profile/presentation/providers/kid_profile_providers.dart';
import '../../../kid_profile/presentation/widgets/kid_profile_card.dart';
import '../providers/story_wizard_provider.dart';

/// Story creator launcher screen - select profile then start wizard
class StoryCreatorLauncherScreen extends ConsumerWidget {
  const StoryCreatorLauncherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(kidProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Story'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: profilesAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.secondary.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create AI Story',
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a kid profile to start creating a personalized story',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Profile selection
                Text(
                  'Select Kid Profile',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Profile grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return KidProfileCard(
                      profile: profile,
                      onTap: () => _launchWizard(context, ref, profile),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Features info
                _buildFeaturesInfo(context),
              ],
            ),
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
                'Error loading profiles',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.person_add_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Profiles Yet!',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a kid profile first to generate personalized stories',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // Navigate to Library tab to create profile
                // Since we can't directly change tabs from here, show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Go to Library tab to create a kid profile first'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go to Library'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesInfo(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Story Wizard',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFeatureItem('Choose story settings (genre, length, interests)'),
            _buildFeatureItem('Select art style (Premium+ only)'),
            _buildFeatureItem('Upload photo to put your kid in the story (Premium+ only)'),
            _buildFeatureItem('Review and generate with AI'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchWizard(BuildContext context, WidgetRef ref, dynamic profile) {
    // Reset wizard state and select profile
    ref.read(storyWizardProvider.notifier).reset();
    ref.read(storyWizardProvider.notifier).selectProfile(profile);

    // Navigate to wizard
    context.push(AppRoutes.storyWizard);
  }
}
