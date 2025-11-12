import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../kid_profile/domain/entities/kid_profile_entity.dart';
import '../../../story/presentation/providers/story_providers.dart';
import '../../domain/models/story_wizard_state.dart';

part 'story_wizard_provider.g.dart';

/// Provider for story wizard state management
@riverpod
class StoryWizardNotifier extends _$StoryWizardNotifier {
  @override
  StoryWizardState build() {
    return const StoryWizardState();
  }

  /// Move to next step
  void nextStep() {
    if (state.currentStep < state.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  /// Move to previous step
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Go to specific step
  void goToStep(int step) {
    if (step >= 0 && step < state.totalSteps) {
      state = state.copyWith(currentStep: step);
    }
  }

  /// Step 1: Select kid profile
  void selectProfile(KidProfileEntity profile) {
    state = state.copyWith(
      selectedProfile: profile,
      selectedInterests: profile.interests,
    );
  }

  /// Step 2: Select genre
  void selectGenre(String genre) {
    state = state.copyWith(selectedGenre: genre);
  }

  /// Step 2: Select story length
  void selectLength(StoryLength length) {
    state = state.copyWith(storyLength: length);
  }

  /// Step 2: Toggle interest
  void toggleInterest(String interest) {
    final interests = List<String>.from(state.selectedInterests);
    if (interests.contains(interest)) {
      interests.remove(interest);
    } else {
      interests.add(interest);
    }
    state = state.copyWith(selectedInterests: interests);
  }

  /// Step 2: Set moral lesson
  void setMoralLesson(String? lesson) {
    state = state.copyWith(moralLesson: lesson);
  }

  /// Step 3: Select art style
  void selectArtStyle(ArtStyle artStyle) {
    state = state.copyWith(artStyle: artStyle);
  }

  /// Step 4: Upload photo
  void uploadPhoto(File? photo) {
    state = state.copyWith(uploadedPhoto: photo);
  }

  /// Generate story
  Future<bool> generateStory() async {
    if (!state.isComplete) return false;

    state = state.copyWith(isGenerating: true, errorMessage: null);

    try {
      final controller = ref.read(storyControllerProvider.notifier);

      // Build custom prompt from all selections
      final customPrompt = _buildCustomPrompt();

      final success = await controller.generateAIStory(
        kidProfileId: state.selectedProfile!.id,
        kidName: state.selectedProfile!.name,
        kidAge: state.selectedProfile!.age,
        genre: state.selectedGenre,
        interests: state.selectedInterests,
        customPrompt: customPrompt,
      );

      if (success) {
        state = state.copyWith(isGenerating: false);
        reset();
        return true;
      } else {
        state = state.copyWith(
          isGenerating: false,
          errorMessage: 'Failed to generate story. Please try again.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Build custom prompt from wizard selections
  String _buildCustomPrompt() {
    final parts = <String>[];

    // Add story length preference
    parts.add('Make it ${state.storyLength.label.toLowerCase()}');

    // Add moral lesson if provided
    if (state.moralLesson != null && state.moralLesson!.isNotEmpty) {
      parts.add('Include a lesson about ${state.moralLesson}');
    }

    // Add art style note (for future image generation)
    parts.add('Art style: ${state.artStyle.label}');

    return parts.join('. ');
  }

  /// Reset wizard to initial state
  void reset() {
    state = const StoryWizardState();
  }
}
