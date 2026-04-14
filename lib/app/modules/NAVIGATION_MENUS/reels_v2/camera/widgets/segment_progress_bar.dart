import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_camera_controller.dart';

/// Multi-segment recording progress bar.
/// Shows recorded segments with dividers and current recording progress.
class SegmentProgressBar extends StatelessWidget {
  final ReelsCameraController controller;

  const SegmentProgressBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final segmentWidths = controller.getSegmentWidths();
      final currentProgress = controller.currentProgress.clamp(0.0, 1.0);
      final recording = controller.isRecording.value;

      return Container(
        height: 4,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(2),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;

            return Stack(
              children: [
                // Completed segments
                Row(
                  children: [
                    for (int i = 0; i < segmentWidths.length; i++) ...[
                      Container(
                        width: (segmentWidths[i] * totalWidth).clamp(0.0, totalWidth),
                        height: 4,
                        color: Colors.red,
                      ),
                      // Segment divider (thin white line)
                      if (i < segmentWidths.length - 1)
                        Container(
                          width: 2,
                          height: 4,
                          color: Colors.white,
                        ),
                    ],
                  ],
                ),

                // Current recording indicator (pulsing if recording)
                if (recording)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: (currentProgress * totalWidth).clamp(0.0, totalWidth),
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                // Duration markers (25%, 50%, 75%)
                for (final marker in [0.25, 0.5, 0.75])
                  Positioned(
                    left: marker * totalWidth - 0.5,
                    child: Container(
                      width: 1,
                      height: 4,
                      color: Colors.white38,
                    ),
                  ),
              ],
            );
          },
        ),
      );
    });
  }
}
