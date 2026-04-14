import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_audio_controller.dart';

/// Voiceover recording overlay — record voice over edited video.
class VoiceoverRecorder extends StatelessWidget {
  const VoiceoverRecorder({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Obx(() {
        final isRecording = controller.isRecordingVoiceover.value;
        final hasVoiceover = controller.hasVoiceover;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Voiceover',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasVoiceover)
                  TextButton(
                    onPressed: () => controller.discardVoiceover(),
                    child: const Text(
                      'Discard',
                      style: TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Recording status
            if (isRecording) ...[
              // Animated recording indicator
              _RecordingIndicator(
                durationMs: controller.voiceoverDurationMs.value,
              ),
              const SizedBox(height: 16),
              const Text(
                'Recording voiceover...',
                style: TextStyle(color: Colors.orangeAccent, fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                'Speak clearly into your microphone',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ] else if (hasVoiceover) ...[
              // Voiceover recorded
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.mic, color: Colors.orangeAccent, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Voiceover recorded',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            _formatDuration(controller.voiceoverDurationMs.value),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // Play preview
                    IconButton(
                      onPressed: () {
                        // Preview voiceover
                      },
                      icon: const Icon(Icons.play_circle, color: Colors.orangeAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Volume control
              Row(
                children: [
                  const Icon(Icons.volume_up, size: 16, color: Colors.white54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.orangeAccent,
                        inactiveTrackColor: Colors.white12,
                        thumbColor: Colors.white,
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      ),
                      child: Slider(
                        value: controller.voiceoverVolume.value,
                        onChanged: (v) => controller.setVoiceoverVolume(v),
                      ),
                    ),
                  ),
                  Text(
                    '${(controller.voiceoverVolume.value * 100).round()}%',
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ] else ...[
              // Empty state
              const Icon(Icons.mic_none, color: Colors.white24, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Tap the button below to add a voiceover',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your voiceover will be recorded over the video',
                style: TextStyle(color: Colors.white24, fontSize: 11),
              ),
            ],
            const SizedBox(height: 24),
            // Record / Stop button
            GestureDetector(
              onTap: () {
                if (isRecording) {
                  // Stop recording - path & duration would come from platform
                  controller.stopVoiceoverRecording('voiceover_temp.m4a', 5000);
                } else {
                  controller.startVoiceoverRecording();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isRecording ? 56 : 64,
                height: isRecording ? 56 : 64,
                decoration: BoxDecoration(
                  color: isRecording ? Colors.redAccent : Colors.orangeAccent,
                  shape: isRecording ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: isRecording ? BorderRadius.circular(12) : null,
                  boxShadow: [
                    BoxShadow(
                      color: (isRecording ? Colors.redAccent : Colors.orangeAccent)
                          .withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: isRecording ? 28 : 32,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isRecording ? 'Tap to stop' : (hasVoiceover ? 'Re-record' : 'Tap to record'),
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        );
      }),
    );
  }

  String _formatDuration(int ms) {
    final seconds = (ms / 1000).round();
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min}:${sec.toString().padLeft(2, '0')}';
  }
}

class _RecordingIndicator extends StatelessWidget {
  final int durationMs;

  const _RecordingIndicator({required this.durationMs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatTime(durationMs),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  String _formatTime(int ms) {
    final seconds = (ms / 1000).round();
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
