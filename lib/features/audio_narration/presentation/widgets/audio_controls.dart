import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/tts_state.dart';
import '../providers/tts_providers.dart';

/// Audio controls widget for story narration
class AudioControls extends ConsumerStatefulWidget {
  final String storyContent;
  final Color accentColor;

  const AudioControls({
    super.key,
    required this.storyContent,
    required this.accentColor,
  });

  @override
  ConsumerState<AudioControls> createState() => _AudioControlsState();
}

class _AudioControlsState extends ConsumerState<AudioControls> {
  double _speechRate = 0.5; // Default rate (0.0 - 1.0)

  @override
  Widget build(BuildContext context) {
    final ttsStateAsync = ref.watch(ttsStateProvider);
    final isEnabledAsync = ref.watch(audioNarrationEnabledProvider);

    return isEnabledAsync.when(
      data: (isEnabled) {
        if (!isEnabled) {
          return _buildUpgradePrompt(context);
        }

        return ttsStateAsync.when(
          data: (ttsState) => _buildControls(context, ttsState),
          loading: () => _buildControls(context, TTSState.loading),
          error: (_, __) => _buildControls(context, TTSState.error),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _buildUpgradePrompt(context),
    );
  }

  Widget _buildControls(BuildContext context, TTSState ttsState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stop button
              IconButton(
                onPressed: ttsState.isPlaying || ttsState.isPaused
                    ? () async {
                        await ref.read(ttsControllerProvider.notifier).stop();
                      }
                    : null,
                icon: const Icon(Icons.stop),
                iconSize: 32,
                color: widget.accentColor,
              ),

              const SizedBox(width: 24),

              // Play/Pause button
              Container(
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: ttsState == TTSState.loading
                      ? null
                      : () async {
                          final controller =
                              ref.read(ttsControllerProvider.notifier);
                          await controller.togglePlayPause(widget.storyContent);
                        },
                  icon: Icon(
                    ttsState.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  iconSize: 40,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 24),

              // Speed indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${(_speechRate * 2).toStringAsFixed(1)}x',
                  style: TextStyle(
                    color: widget.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Speed slider
          Row(
            children: [
              Icon(
                Icons.speed,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: _speechRate,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: 'Speed: ${(_speechRate * 2).toStringAsFixed(1)}x',
                  activeColor: widget.accentColor,
                  onChanged: (value) {
                    setState(() {
                      _speechRate = value;
                    });
                  },
                  onChangeEnd: (value) async {
                    await ref
                        .read(ttsControllerProvider.notifier)
                        .setSpeechRate(value);
                  },
                ),
              ),
              Text(
                'Slow',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Fast',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          // Status indicator
          if (ttsState.isPlaying) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(widget.accentColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Reading story...',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.accentColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpgradePrompt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border(
          top: BorderSide(color: Colors.orange.shade300),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.volume_up,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Audio Narration',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.orange[900],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Upgrade to Premium for audio narration',
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
    );
  }
}
