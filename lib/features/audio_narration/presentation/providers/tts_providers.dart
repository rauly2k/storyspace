import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/repositories/tts_repository_impl.dart';
import '../../domain/entities/tts_state.dart';
import '../../domain/repositories/tts_repository.dart';

part 'tts_providers.g.dart';

// ==================== INFRASTRUCTURE PROVIDERS ====================

/// Provides the TTS repository
@riverpod
TTSRepository ttsRepository(TtsRepositoryRef ref) {
  final repository = TTSRepositoryImpl();
  // Dispose when provider is disposed
  ref.onDispose(() {
    repository.dispose();
  });
  return repository;
}

// ==================== DATA PROVIDERS ====================

/// Stream of TTS state changes
@riverpod
Stream<TTSState> ttsState(TtsStateRef ref) {
  final repository = ref.watch(ttsRepositoryProvider);
  return repository.stateStream;
}

/// Check if TTS is available on device
@riverpod
Future<bool> ttsAvailable(TtsAvailableRef ref) async {
  final repository = ref.watch(ttsRepositoryProvider);
  final result = await repository.isAvailable();
  return result.fold(
    (failure) => false,
    (isAvailable) => isAvailable,
  );
}

/// Check if audio narration is available for current user's subscription
@riverpod
Future<bool> audioNarrationEnabled(AudioNarrationEnabledRef ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return false;

  // Audio narration is available for Premium and Premium+ tiers
  return user.subscriptionTier == AppConstants.tierPremium ||
      user.subscriptionTier == AppConstants.tierPremiumPlus;
}

// ==================== CONTROLLER ====================

/// Controller for TTS operations
@riverpod
class TTSController extends _$TTSController {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  /// Speak the given text
  Future<bool> speak(String text) async {
    state = const AsyncValue.loading();

    // Check if audio is enabled for user
    final isEnabled = await ref.read(audioNarrationEnabledProvider.future);
    if (!isEnabled) {
      state = AsyncValue.error(
        Exception('Audio narration requires Premium subscription'),
        StackTrace.current,
      );
      return false;
    }

    final repository = ref.read(ttsRepositoryProvider);
    final result = await repository.speak(text);

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  /// Pause current speech
  Future<bool> pause() async {
    final repository = ref.read(ttsRepositoryProvider);
    final result = await repository.pause();

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Resume paused speech
  Future<bool> resume() async {
    final repository = ref.read(ttsRepositoryProvider);
    final result = await repository.resume();

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Stop current speech
  Future<bool> stop() async {
    final repository = ref.read(ttsRepositoryProvider);
    final result = await repository.stop();

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Set speech rate (0.0 - 1.0)
  Future<bool> setSpeechRate(double rate) async {
    final repository = ref.read(ttsRepositoryProvider);
    final result = await repository.setSpeechRate(rate);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Set pitch (0.5 - 2.0)
  Future<bool> setPitch(double pitch) async {
    final repository = ref.read(ttsRepositoryProvider);
    final result = await repository.setPitch(pitch);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Set volume (0.0 - 1.0)
  Future<bool> setVolume(double volume) async {
    final repository = ref.read(ttsRepositoryProvider);
    final result = await repository.setVolume(volume);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Toggle play/pause
  Future<bool> togglePlayPause(String text) async {
    final repository = ref.read(ttsRepositoryProvider);
    final currentState = repository.currentState;

    if (currentState.isPlaying) {
      return await pause();
    } else if (currentState.isPaused) {
      return await resume();
    } else {
      return await speak(text);
    }
  }
}
