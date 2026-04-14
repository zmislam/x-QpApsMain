import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_camera_controller.dart';

/// Vertical zoom slider — pinch or slide to zoom.
class ZoomSlider extends StatelessWidget {
  final ReelsCameraController controller;

  const ZoomSlider({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final min = controller.minZoom.value;
      final max = controller.maxZoom.value;
      final current = controller.currentZoom.value;

      if (max <= min) return const SizedBox.shrink();

      return Container(
        width: 36,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Zoom level indicator
            Text(
              '${current.toStringAsFixed(1)}x',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // Vertical slider
            Expanded(
              child: RotatedBox(
                quarterTurns: -1,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                  ),
                  child: Slider(
                    value: current.clamp(min, max),
                    min: min,
                    max: max,
                    onChanged: (value) => controller.setZoom(value),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // 1x label
            const Text(
              '1x',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    });
  }
}
