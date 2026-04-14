import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_editor_controller.dart';

/// Transition picker between clips.
/// Shows a small icon between adjacent clips in the timeline.
/// Tap to select transition type: fade, slide, zoom, dissolve, swipe.
class TransitionPicker extends StatelessWidget {
  final int clipIndex;

  const TransitionPicker({
    super.key,
    required this.clipIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTransitionSheet(context),
      child: Container(
        width: 28,
        height: 28,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[600]!, width: 0.5),
        ),
        child: Obx(() {
          final ctrl = Get.find<ReelsEditorController>();
          final clip = ctrl.clips[clipIndex];
          return Icon(
            _transitionIcon(clip.transition),
            color: clip.transition != TransitionType.none
                ? Colors.blueAccent
                : Colors.white38,
            size: 14,
          );
        }),
      ),
    );
  }

  void _showTransitionSheet(BuildContext context) {
    final ctrl = Get.find<ReelsEditorController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transition',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final current = ctrl.clips[clipIndex].transition;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: TransitionType.values.map((t) {
                      final isActive = current == t;
                      return GestureDetector(
                        onTap: () {
                          ctrl.setClipTransition(clipIndex, t);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.blueAccent.withValues(alpha: 0.2)
                                : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _transitionIcon(t),
                                color: isActive
                                    ? Colors.blueAccent
                                    : Colors.white60,
                                size: 24,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _transitionLabel(t),
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.blueAccent
                                      : Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _transitionIcon(TransitionType type) {
    switch (type) {
      case TransitionType.none:
        return Icons.remove;
      case TransitionType.fade:
        return Icons.gradient;
      case TransitionType.slide:
        return Icons.swap_horiz;
      case TransitionType.zoom:
        return Icons.zoom_in;
      case TransitionType.dissolve:
        return Icons.blur_on;
    }
  }

  String _transitionLabel(TransitionType type) {
    switch (type) {
      case TransitionType.none:
        return 'None';
      case TransitionType.fade:
        return 'Fade';
      case TransitionType.slide:
        return 'Slide';
      case TransitionType.zoom:
        return 'Zoom';
      case TransitionType.dissolve:
        return 'Dissolve';
    }
  }
}
