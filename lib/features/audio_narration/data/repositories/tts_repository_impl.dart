import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/tts_state.dart';
import '../../domain/repositories/tts_repository.dart';

/// Implementation of [TTSRepository] using flutter_tts.
class TTSRepositoryImpl implements TTSRepository {
  final FlutterTts _flutterTts;
  final StreamController<TTSState> _stateController =
      StreamController<TTSState>.broadcast();

  TTSState _currentState = TTSState.idle;

  TTSRepositoryImpl({FlutterTts? flutterTts})
      : _flutterTts = flutterTts ?? FlutterTts() {
    _initializeTTS();
  }

  void _initializeTTS() {
    // Set up handlers
    _flutterTts.setStartHandler(() {
      _updateState(TTSState.playing);
    });

    _flutterTts.setCompletionHandler(() {
      _updateState(TTSState.idle);
    });

    _flutterTts.setCancelHandler(() {
      _updateState(TTSState.idle);
    });

    _flutterTts.setPauseHandler(() {
      _updateState(TTSState.paused);
    });

    _flutterTts.setContinueHandler(() {
      _updateState(TTSState.playing);
    });

    _flutterTts.setErrorHandler((msg) {
      _updateState(TTSState.error);
    });

    // Set default values
    _flutterTts.setVolume(1.0);
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setPitch(1.0);
  }

  void _updateState(TTSState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  @override
  TTSState get currentState => _currentState;

  @override
  Stream<TTSState> get stateStream => _stateController.stream;

  @override
  Future<Either<Failure, void>> speak(String text) async {
    try {
      if (text.isEmpty) {
        return left(const Failure.validation(
          message: 'Text cannot be empty',
        ));
      }

      _updateState(TTSState.loading);
      await _flutterTts.speak(text);
      return right(null);
    } catch (e) {
      _updateState(TTSState.error);
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> pause() async {
    try {
      await _flutterTts.pause();
      return right(null);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resume() async {
    try {
      // flutter_tts doesn't have a direct resume method
      // We need to continue from where we paused
      // This is a limitation of the flutter_tts package
      // For now, we'll just update the state
      _updateState(TTSState.playing);
      return right(null);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stop() async {
    try {
      await _flutterTts.stop();
      _updateState(TTSState.idle);
      return right(null);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setSpeechRate(double rate) async {
    try {
      if (rate < 0.0 || rate > 1.0) {
        return left(const Failure.validation(
          message: 'Speech rate must be between 0.0 and 1.0',
        ));
      }
      await _flutterTts.setSpeechRate(rate);
      return right(null);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setPitch(double pitch) async {
    try {
      if (pitch < 0.5 || pitch > 2.0) {
        return left(const Failure.validation(
          message: 'Pitch must be between 0.5 and 2.0',
        ));
      }
      await _flutterTts.setPitch(pitch);
      return right(null);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setVolume(double volume) async {
    try {
      if (volume < 0.0 || volume > 1.0) {
        return left(const Failure.validation(
          message: 'Volume must be between 0.0 and 1.0',
        ));
      }
      await _flutterTts.setVolume(volume);
      return right(null);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableVoices() async {
    try {
      final voices = await _flutterTts.getVoices as List<dynamic>;
      final voiceNames = voices
          .map((voice) => voice['name'] as String? ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
      return right(voiceNames);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setVoice(String voice) async {
    try {
      await _flutterTts.setVoice({'name': voice, 'locale': 'en-US'});
      return right(null);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAvailable() async {
    try {
      // Try to get languages as a way to check if TTS is available
      final languages = await _flutterTts.getLanguages;
      return right(languages != null && languages.isNotEmpty);
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  /// Dispose resources
  void dispose() {
    _stateController.close();
    _flutterTts.stop();
  }
}
