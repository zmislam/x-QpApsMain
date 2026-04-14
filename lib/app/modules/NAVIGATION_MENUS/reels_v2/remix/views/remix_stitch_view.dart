import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_remix_controller.dart';
import '../widgets/remix_source_preview.dart';

/// Remix Stitch View — use first 1-5s of another reel, then record your response.
class RemixStitchView extends GetView<ReelsRemixController> {
  const RemixStitchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Stitch'),
        actions: [
          Obx(() => controller.hasRecorded.value
              ? TextButton(
                  onPressed: () {
                    // Navigate to publish
                  },
                  child: const Text('Next',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          // ─── Stitch Duration Selector ──────────────
          _buildDurationSelector(),

          // ─── Video Preview Area ────────────────────
          Expanded(
            child: Obx(() {
              if (!controller.hasRecorded.value) {
                // Show source preview with clip indicator
                return Stack(
                  children: [
                    RemixSourcePreview(
                      videoController: controller.sourceVideoController,
                      authorName: controller.originalAuthorName.value,
                      authorAvatar: controller.originalAuthorAvatar.value,
                    ),
                    // Clip indicator overlay
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        color: Colors.black26,
                        child: Obx(() => FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  controller.stitchDurationSec.value / 5.0,
                              child: Container(color: Colors.red),
                            )),
                      ),
                    ),
                    // Duration label
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(() => Text(
                              'First ${controller.stitchDurationSec.value}s',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            )),
                      ),
                    ),
                  ],
                );
              }
              // After recording: show combined preview
              return Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 48),
                      SizedBox(height: 8),
                      Text('Stitch recorded',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              );
            }),
          ),

          // ─── Record Button ─────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(() => Text(
                        controller.isRecording.value
                            ? 'Recording your response...'
                            : controller.hasRecorded.value
                                ? 'Tap Next to continue'
                                : 'Record after the clip',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      )),
                  const SizedBox(height: 12),
                  Obx(() => GestureDetector(
                        onTap: controller.isRecording.value
                            ? controller.stopRecording
                            : controller.hasRecorded.value
                                ? null
                                : controller.startRecording,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: controller.hasRecorded.value
                                  ? Colors.grey
                                  : Colors.white,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width:
                                  controller.isRecording.value ? 28 : 56,
                              height:
                                  controller.isRecording.value ? 28 : 56,
                              decoration: BoxDecoration(
                                color: controller.hasRecorded.value
                                    ? Colors.grey
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(
                                  controller.isRecording.value ? 4 : 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Clip length: ',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          ...List.generate(5, (i) {
            final sec = i + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Obx(() => ChoiceChip(
                    label: Text('${sec}s'),
                    selected: controller.stitchDurationSec.value == sec,
                    onSelected: (_) => controller.setStitchDuration(sec),
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: controller.stitchDurationSec.value == sec
                          ? Colors.white
                          : Colors.white70,
                      fontSize: 12,
                    ),
                  )),
            );
          }),
        ],
      ),
    );
  }
}
