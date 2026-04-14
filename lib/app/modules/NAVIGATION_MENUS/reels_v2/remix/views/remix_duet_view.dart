import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/reels_remix_controller.dart';
import '../widgets/remix_layout_picker.dart';
import '../widgets/remix_source_preview.dart';

/// Remix Duet View — record alongside another reel (side-by-side, top/bottom, PiP).
/// Original audio from source reel plays alongside the recording.
class RemixDuetView extends GetView<ReelsRemixController> {
  const RemixDuetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Duet'),
        actions: [
          Obx(() => controller.hasRecorded.value
              ? TextButton(
                  onPressed: () {
                    // Navigate to publish with recorded video
                  },
                  child: const Text('Next',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          // ─── Layout Picker ─────────────────────────
          RemixLayoutPicker(
            currentLayout: controller.layout,
            onLayoutChanged: controller.setLayout,
          ),

          // ─── Dual Video Area ───────────────────────
          Expanded(
            child: Obx(() => _buildDualLayout(context)),
          ),

          // ─── Audio Controls ────────────────────────
          _buildAudioControls(),

          // ─── Record Button ─────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => GestureDetector(
                    onTap: controller.isRecording.value
                        ? controller.stopRecording
                        : controller.startRecording,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: controller.isRecording.value ? 28 : 56,
                          height: controller.isRecording.value ? 28 : 56,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(
                              controller.isRecording.value ? 4 : 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualLayout(BuildContext context) {
    final layout = controller.layout.value;

    Widget sourceWidget = RemixSourcePreview(
      videoController: controller.sourceVideoController,
      authorName: controller.originalAuthorName.value,
      authorAvatar: controller.originalAuthorAvatar.value,
    );

    Widget cameraWidget = Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(Icons.videocam, color: Colors.white38, size: 48),
      ),
    );

    switch (layout) {
      case 'top-bottom':
        return Column(
          children: [
            Expanded(child: sourceWidget),
            const SizedBox(height: 2),
            Expanded(child: cameraWidget),
          ],
        );
      case 'pip':
        return Stack(
          children: [
            sourceWidget,
            Positioned(
              right: 12,
              bottom: 12,
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35 * 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: cameraWidget,
              ),
            ),
          ],
        );
      default: // side-by-side
        return Row(
          children: [
            Expanded(child: sourceWidget),
            const SizedBox(width: 2),
            Expanded(child: cameraWidget),
          ],
        );
    }
  }

  Widget _buildAudioControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black87,
      child: Row(
        children: [
          // Source volume
          const Icon(Icons.music_note, color: Colors.white54, size: 16),
          const SizedBox(width: 4),
          Expanded(
            child: Obx(() => Slider(
                  value: controller.sourceVolume.value,
                  onChanged: controller.setSourceVolume,
                  activeColor: Colors.blue,
                )),
          ),
          // Mute original toggle
          Obx(() => IconButton(
                onPressed: controller.toggleMuteOriginal,
                icon: Icon(
                  controller.muteOriginal.value
                      ? Icons.volume_off
                      : Icons.volume_up,
                  color: Colors.white70,
                  size: 20,
                ),
              )),
        ],
      ),
    );
  }
}
