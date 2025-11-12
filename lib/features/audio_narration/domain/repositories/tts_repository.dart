import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/tts_state.dart';

/// Repository interface for text-to-speech operations.
abstract class TTSRepository {
  /// Speak the given text
  Future<Either<Failure, void>> speak(String text);

  /// Pause the current speech
  Future<Either<Failure, void>> pause();

  /// Resume paused speech
  Future<Either<Failure, void>> resume();

  /// Stop the current speech
  Future<Either<Failure, void>> stop();

  /// Set speech rate (0.5 - 2.0)
  Future<Either<Failure, void>> setSpeechRate(double rate);

  /// Set speech pitch (0.5 - 2.0)
  Future<Either<Failure, void>> setPitch(double pitch);

  /// Set speech volume (0.0 - 1.0)
  Future<Either<Failure, void>> setVolume(double volume);

  /// Get available voices
  Future<Either<Failure, List<String>>> getAvailableVoices();

  /// Set voice
  Future<Either<Failure, void>> setVoice(String voice);

  /// Get current TTS state
  TTSState get currentState;

  /// Stream of TTS state changes
  Stream<TTSState> get stateStream;

  /// Check if TTS is available on this device
  Future<Either<Failure, bool>> isAvailable();
}
