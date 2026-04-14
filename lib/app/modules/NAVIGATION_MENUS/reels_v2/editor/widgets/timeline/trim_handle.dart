import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_editor_controller.dart';

/// Frame-accurate trim handles for a clip.
/// Left handle trims start, right handle trims end.
/// Drag horizontally to adjust trim points.
class TrimHandle extends StatelessWidget {
  final int clipIndex;
  final double clipWidth;

  const TrimHandle({
    super.key,
    required this.clipIndex,
    required this.clipWidth,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ReelsEditorController>();

    return Obx(() {
      final clip = ctrl.clips[clipIndex];
      final rawDuration = clip.durationSeconds ?? 5.0;
      // Fraction of clip trimmed from start/end
      final startFraction = clip.startTrim / rawDuration;
      final endFraction = clip.endTrim / rawDuration;

      return Stack(
        children: [
          // Dimmed left trim area
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: clipWidth * startFraction,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(7),
                ),
              ),
            ),
          ),
          // Dimmed right trim area
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: clipWidth * endFraction,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(7),
                ),
              ),
            ),
          ),
          // Left handle
          Positioned(
            left: clipWidth * startFraction - 8,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                final newStart = clip.startTrim +
                    (details.delta.dx / clipWidth) * rawDuration;
                final clamped = newStart.clamp(0.0, rawDuration - clip.endTrim - 0.1);
                ctrl.setClipTrim(clipIndex, clamped, clip.endTrim);
              },
              child: _HandleBar(isLeft: true),
            ),
          ),
          // Right handle
          Positioned(
            right: clipWidth * endFraction - 8,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                final newEnd = clip.endTrim -
                    (details.delta.dx / clipWidth) * rawDuration;
                final clamped = newEnd.clamp(0.0, rawDuration - clip.startTrim - 0.1);
                ctrl.setClipTrim(clipIndex, clip.startTrim, clamped);
              },
              child: _HandleBar(isLeft: false),
            ),
          ),
          // Active region top/bottom border
          Positioned(
            left: clipWidth * startFraction,
            right: clipWidth * endFraction,
            top: 0,
            child: Container(height: 2, color: Colors.blueAccent),
          ),
          Positioned(
            left: clipWidth * startFraction,
            right: clipWidth * endFraction,
            bottom: 0,
            child: Container(height: 2, color: Colors.blueAccent),
          ),
        ],
      );
    });
  }
}

class _HandleBar extends StatelessWidget {
  final bool isLeft;
  const _HandleBar({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: isLeft
            ? const BorderRadius.horizontal(left: Radius.circular(4))
            : const BorderRadius.horizontal(right: Radius.circular(4)),
      ),
      child: Center(
        child: Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ),
    );
  }
}
