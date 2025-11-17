import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';
import '../../providers/story_wizard_provider.dart';

/// Step 4: Photo upload (Premium+ feature)
class Step4PhotoUpload extends ConsumerWidget {
  const Step4PhotoUpload({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(storyWizardProvider);
    final wizardNotifier = ref.read(storyWizardProvider.notifier);
    final currentUser = ref.watch(currentUserProvider).value;

    final isPremiumPlus = currentUser?.subscriptionTier == AppConstants.tierPremiumPlus;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Put Your Kid in the Story',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload a photo to make ${wizardState.selectedProfile?.name ?? "your child"} the hero!',
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
                          'Premium+ Exclusive',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.orange[900],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Upgrade to Premium+ to use your child\'s photo',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.orange[700],
                              ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      // TODO: Navigate to subscription screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Subscription screen coming soon!'),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                    ),
                    child: const Text('Upgrade'),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Photo upload area
          Center(
            child: wizardState.uploadedPhoto != null
                ? _buildPhotoPreview(
                    context,
                    wizardState.uploadedPhoto!,
                    () => wizardNotifier.uploadPhoto(null),
                  )
                : _buildUploadButton(
                    context,
                    ref,
                    wizardNotifier,
                    !isPremiumPlus,
                  ),
          ),

          const SizedBox(height: 32),

          // Feature info
          _buildFeatureInfo(context),

          const SizedBox(height: 24),

          // Skip button
          Center(
            child: TextButton.icon(
              onPressed: () {
                // Skip this step
                wizardNotifier.uploadPhoto(null);
              },
              icon: const Icon(Icons.skip_next),
              label: const Text('Skip for Now'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(
    BuildContext context,
    WidgetRef ref,
    StoryWizardNotifier notifier,
    bool isLocked,
  ) {
    return GestureDetector(
      onTap: isLocked
          ? null
          : () => _pickPhoto(context, ref, notifier),
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey[200] : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked ? Colors.grey[400]! : AppColors.primary,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLocked ? Icons.lock : Icons.add_a_photo,
              size: 64,
              color: isLocked ? Colors.grey[400] : AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              isLocked ? 'Locked' : 'Tap to Upload Photo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isLocked ? Colors.grey[400] : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                isLocked
                    ? 'Premium+ required'
                    : 'Upload a clear photo of your child',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLocked ? Colors.grey[400] : Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(
    BuildContext context,
    File photo,
    VoidCallback onRemove,
  ) {
    return Stack(
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: FileImage(photo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'How it Works',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBulletPoint(context, 'AI will use the photo to create character images'),
          _buildBulletPoint(context, 'Your child becomes the story\'s protagonist'),
          _buildBulletPoint(context, 'Photos are processed securely and never shared'),
          const SizedBox(height: 8),
          Text(
            'Note: Image generation coming soon!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue[700],
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue[900],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhoto(
    BuildContext context,
    WidgetRef ref,
    StoryWizardNotifier notifier,
  ) async {
    final picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        notifier.uploadPhoto(File(image.path));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick photo: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
