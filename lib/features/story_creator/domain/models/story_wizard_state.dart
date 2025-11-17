import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../kid_profile/domain/entities/kid_profile_entity.dart';

part 'story_wizard_state.freezed.dart';

/// State for the story creation wizard
@freezed
abstract class StoryWizardState with _$StoryWizardState {
  const factory StoryWizardState({
    // Current step (0-4)
    @Default(0) int currentStep,

    // Step 1: Kid profile selection
    KidProfileEntity? selectedProfile,

    // Step 2: Story settings
    @Default('Adventure') String selectedGenre,
    @Default(StoryLength.medium) StoryLength storyLength,
    @Default([]) List<String> selectedInterests,
    String? moralLesson,

    // Step 3: Art style (Premium+)
    @Default(ArtStyle.cartoon) ArtStyle artStyle,

    // Step 4: Photo upload (Premium+)
    File? uploadedPhoto,

    // Generation state
    @Default(false) bool isGenerating,
    String? errorMessage,
  }) = _StoryWizardState;

  const StoryWizardState._();

  /// Check if current step is complete and can proceed
  bool get canProceedFromCurrentStep {
    switch (currentStep) {
      case 0:
        return selectedProfile != null;
      case 1:
        return selectedGenre.isNotEmpty;
      case 2:
        return true; // Art style has default
      case 3:
        return true; // Photo is optional
      case 4:
        return true; // Review step
      default:
        return false;
    }
  }

  /// Check if wizard is complete
  bool get isComplete {
    return selectedProfile != null && selectedGenre.isNotEmpty;
  }

  /// Get total number of steps
  int get totalSteps => 5;

  /// Get word count based on story length
  int get wordCount {
    return switch (storyLength) {
      StoryLength.short => 250,
      StoryLength.medium => 500,
      StoryLength.long => 900,
    };
  }
}

/// Story length options
enum StoryLength {
  short,
  medium,
  long;

  String get label {
    switch (this) {
      case StoryLength.short:
        return 'Short (5 min)';
      case StoryLength.medium:
        return 'Medium (10 min)';
      case StoryLength.long:
        return 'Long (15 min)';
    }
  }

  String get description {
    switch (this) {
      case StoryLength.short:
        return '~250 words, perfect for bedtime';
      case StoryLength.medium:
        return '~500 words, great for reading time';
      case StoryLength.long:
        return '~900 words, an epic adventure';
    }
  }
}

/// Art style options (Premium+ feature)
enum ArtStyle {
  cartoon,
  storybook,
  anime,
  realistic;

  String get label {
    switch (this) {
      case ArtStyle.cartoon:
        return 'Cartoon';
      case ArtStyle.storybook:
        return 'Storybook';
      case ArtStyle.anime:
        return 'Anime';
      case ArtStyle.realistic:
        return '3D Realistic';
    }
  }

  String get description {
    switch (this) {
      case ArtStyle.cartoon:
        return 'Fun, colorful cartoon style';
      case ArtStyle.storybook:
        return 'Classic storybook illustrations';
      case ArtStyle.anime:
        return 'Anime/manga inspired art';
      case ArtStyle.realistic:
        return 'Realistic 3D rendered style';
    }
  }
}
