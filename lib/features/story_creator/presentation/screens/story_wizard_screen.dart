import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/story_wizard_state.dart';
import '../providers/story_wizard_provider.dart';
import '../widgets/steps/step1_select_profile.dart';
import '../widgets/steps/step2_story_settings.dart';
import '../widgets/steps/step3_art_style.dart';
import '../widgets/steps/step4_photo_upload.dart';
import '../widgets/steps/step5_review.dart';

/// Main story creation wizard screen with stepper
class StoryWizardScreen extends ConsumerWidget {
  const StoryWizardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(storyWizardProvider);
    final wizardNotifier = ref.read(storyWizardProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Story'),
        actions: [
          if (wizardState.currentStep > 0)
            TextButton(
              onPressed: () => _showCancelConfirmation(context, wizardNotifier),
              child: const Text('Cancel'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(context, wizardState),

          // Step content
          Expanded(
            child: _buildStepContent(wizardState.currentStep),
          ),

          // Navigation buttons
          _buildNavigationButtons(context, ref, wizardState, wizardNotifier),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, StoryWizardState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${state.currentStep + 1} of ${state.totalSteps}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${((state.currentStep + 1) / state.totalSteps * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (state.currentStep + 1) / state.totalSteps,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step) {
    return switch (step) {
      0 => const Step1SelectProfile(),
      1 => const Step2StorySettings(),
      2 => const Step3ArtStyle(),
      3 => const Step4PhotoUpload(),
      4 => const Step5Review(),
      _ => const Center(child: Text('Unknown step')),
    };
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    WidgetRef ref,
    StoryWizardState state,
    StoryWizardNotifier notifier,
  ) {
    final isLastStep = state.currentStep == state.totalSteps - 1;
    final canProceed = state.canProceedFromCurrentStep;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          if (state.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: state.isGenerating ? null : notifier.previousStep,
                child: const Text('Back'),
              ),
            ),

          if (state.currentStep > 0) const SizedBox(width: 16),

          // Next/Generate button
          Expanded(
            flex: state.currentStep == 0 ? 1 : 1,
            child: FilledButton(
              onPressed: canProceed && !state.isGenerating
                  ? () => _handleNext(context, ref, state, notifier, isLastStep)
                  : null,
              child: state.isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(isLastStep ? 'Generate Story' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext(
    BuildContext context,
    WidgetRef ref,
    StoryWizardState state,
    StoryWizardNotifier notifier,
    bool isLastStep,
  ) async {
    if (isLastStep) {
      // Generate story
      final success = await notifier.generateStory();

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Story generated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to generate story'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } else {
      // Move to next step
      notifier.nextStep();
    }
  }

  void _showCancelConfirmation(
    BuildContext context,
    StoryWizardNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Story Creation'),
        content: const Text(
          'Are you sure you want to cancel? All your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Continue Editing'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              notifier.reset();
              context.pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Cancel Creation'),
          ),
        ],
      ),
    );
  }
}
