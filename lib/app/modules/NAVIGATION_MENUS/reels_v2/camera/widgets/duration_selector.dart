import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_camera_controller.dart';

/// Duration limit selector — 15 / 30 / 60 / 90 seconds.
class DurationSelector extends StatelessWidget {
  final ReelsCameraController controller;

  const DurationSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: controller.availableDurations.map((duration) {
            final isSelected =
                controller.durationLimitSeconds.value == duration;
            final label = '${duration}s';

            return GestureDetector(
              onTap: () => controller.setDurationLimit(duration),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }
}
