import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_audio_controller.dart';

/// Audio trim slider — select 15-90s section of a song.
class AudioTrimSlider extends StatelessWidget {
  const AudioTrimSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();

    return Obx(() {
      final sound = controller.selectedSound.value;
      if (sound == null) return const SizedBox.shrink();

      final totalDuration = sound.durationMs ?? 30000;
      final startMs = controller.trimStartMs.value;
      final endMs = controller.trimEndMs.value;
      final trimmedDuration = endMs - startMs;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trim Audio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDuration(trimmedDuration),
                  style: const TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${sound.title ?? "Sound"} · ${_formatDuration(totalDuration)}',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 16),
            // Waveform placeholder with trim handles
            SizedBox(
              height: 60,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final startFraction = totalDuration > 0 ? startMs / totalDuration : 0.0;
                  final endFraction = totalDuration > 0 ? endMs / totalDuration : 1.0;

                  return Stack(
                    children: [
                      // Full waveform background
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _WaveformPainter(
                            activeStart: startFraction,
                            activeEnd: endFraction,
                          ),
                        ),
                      ),
                      // Dimmed regions
                      if (startFraction > 0)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: width * startFraction,
                          child: Container(color: Colors.black54),
                        ),
                      if (endFraction < 1.0)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          width: width * (1 - endFraction),
                          child: Container(color: Colors.black54),
                        ),
                      // Active region border
                      Positioned(
                        left: width * startFraction,
                        top: 0,
                        bottom: 0,
                        width: width * (endFraction - startFraction),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Range slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.purpleAccent,
                inactiveTrackColor: Colors.white12,
                thumbColor: Colors.white,
                overlayColor: Colors.purpleAccent.withOpacity(0.2),
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 8,
                ),
                trackHeight: 3,
              ),
              child: RangeSlider(
                values: RangeValues(
                  startMs.toDouble(),
                  endMs.toDouble(),
                ),
                min: 0,
                max: totalDuration.toDouble(),
                onChanged: (values) {
                  controller.setTrimRange(
                    values.start.round(),
                    values.end.round(),
                  );
                },
              ),
            ),
            // Time labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(startMs),
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                Text(
                  _formatDuration(endMs),
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Quick duration presets
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [15, 30, 60, 90]
                  .map((sec) => _DurationPreset(
                        seconds: sec,
                        isSelected: trimmedDuration >= (sec * 1000 - 500) &&
                            trimmedDuration <= (sec * 1000 + 500),
                        onTap: () {
                          final maxEnd = (startMs + sec * 1000)
                              .clamp(0, totalDuration);
                          controller.setTrimRange(startMs, maxEnd);
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      );
    });
  }

  String _formatDuration(int ms) {
    final seconds = (ms / 1000).round();
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min}:${sec.toString().padLeft(2, '0')}';
  }
}

class _DurationPreset extends StatelessWidget {
  final int seconds;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationPreset({
    required this.seconds,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.purpleAccent : Colors.white10,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${seconds}s',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double activeStart;
  final double activeEnd;

  _WaveformPainter({required this.activeStart, required this.activeEnd});

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 2.0;
    final gap = 1.5;
    final barCount = (size.width / (barWidth + gap)).floor();
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + gap);
      final fraction = i / barCount;
      final isActive = fraction >= activeStart && fraction <= activeEnd;

      // Simulated waveform heights
      final normalized = (i * 7 % 13 + 3) / 16;
      final height = size.height * 0.3 + size.height * 0.6 * normalized;

      final paint = Paint()
        ..color = isActive
            ? Colors.purpleAccent.withOpacity(0.8)
            : Colors.white.withOpacity(0.15)
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter old) {
    return old.activeStart != activeStart || old.activeEnd != activeEnd;
  }
}
