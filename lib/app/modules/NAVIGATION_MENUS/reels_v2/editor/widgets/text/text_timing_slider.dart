import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_editor_controller.dart';

/// Dual-handle timing slider for text overlay visibility.
/// Controls when text appears and disappears on the timeline.
class TextTimingSlider extends StatelessWidget {
  final double startTime;
  final double endTime;
  final ValueChanged<double> onStartChanged;
  final ValueChanged<double> onEndChanged;

  const TextTimingSlider({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ReelsEditorController>();
    final maxDuration = ctrl.totalDuration;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[900],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appears: ${_formatTime(startTime)}',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const Text(
                'Text Timing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Disappears: ${_formatTime(endTime)}',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Range slider
          RangeSlider(
            values: RangeValues(
              startTime.clamp(0.0, maxDuration),
              endTime.isInfinite ? maxDuration : endTime.clamp(0.0, maxDuration),
            ),
            min: 0,
            max: maxDuration > 0 ? maxDuration : 1.0,
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.grey[700],
            labels: RangeLabels(
              _formatTime(startTime),
              _formatTime(endTime),
            ),
            onChanged: (values) {
              onStartChanged(values.start);
              onEndChanged(values.end);
            },
          ),
          // Duration indicator
          Text(
            'Duration: ${_formatTime((endTime.isInfinite ? maxDuration : endTime) - startTime)}',
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  String _formatTime(double seconds) {
    if (seconds.isInfinite) return 'End';
    final mins = (seconds / 60).floor();
    final secs = (seconds % 60).toStringAsFixed(1);
    return mins > 0 ? '$mins:${secs.padLeft(4, '0')}' : '${secs}s';
  }
}
