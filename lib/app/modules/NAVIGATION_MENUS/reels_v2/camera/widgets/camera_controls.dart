import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_camera_controller.dart';

/// Main camera controls — record button (press/hold/hands-free),
/// undo segment, and proceed to editor.
class CameraControls extends StatelessWidget {
  final ReelsCameraController controller;

  const CameraControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recording = controller.isRecording.value;
      final handsFree = controller.isHandsFreeMode.value;
      final hasSegments = controller.hasSegments;
      final atLimit = controller.isAtLimit;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Undo last segment
          _ControlButton(
            icon: Icons.undo,
            label: 'Undo',
            visible: hasSegments && !recording,
            onTap: controller.undoLastSegment,
          ),

          // Record button
          GestureDetector(
            onTap: () {
              if (atLimit) return;
              if (handsFree) {
                controller.toggleRecording();
              } else {
                controller.toggleRecording();
              }
            },
            onLongPressStart: handsFree
                ? null
                : (_) {
                    if (!atLimit) controller.startRecording();
                  },
            onLongPressEnd: handsFree
                ? null
                : (_) {
                    controller.stopRecording();
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: recording ? 80 : 72,
              height: recording ? 80 : 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: recording ? Colors.red : Colors.white,
                  width: 4,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: recording ? 28 : 56,
                  height: recording ? 28 : 56,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(recording ? 6 : 28),
                  ),
                ),
              ),
            ),
          ),

          // Proceed to editor
          _ControlButton(
            icon: Icons.check,
            label: 'Next',
            visible: hasSegments && !recording,
            onTap: controller.proceedToEditor,
            accent: true,
          ),
        ],
      );
    });
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool visible;
  final bool accent;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.visible,
    required this.onTap,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: !visible,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent ? Colors.blue : Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
