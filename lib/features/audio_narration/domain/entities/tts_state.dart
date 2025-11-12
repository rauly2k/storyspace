/// Text-to-speech playback states
enum TTSState {
  /// TTS is idle, not playing
  idle,

  /// TTS is currently playing
  playing,

  /// TTS is paused
  paused,

  /// TTS is loading/initializing
  loading,

  /// TTS encountered an error
  error;

  bool get isPlaying => this == TTSState.playing;
  bool get isPaused => this == TTSState.paused;
  bool get isIdle => this == TTSState.idle;
  bool get canPlay => this == TTSState.idle || this == TTSState.paused;
  bool get canPause => this == TTSState.playing;
}
