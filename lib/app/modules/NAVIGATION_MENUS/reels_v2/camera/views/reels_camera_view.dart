import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_camera_controller.dart';
import '../widgets/camera_controls.dart';
import '../widgets/segment_progress_bar.dart';
import '../widgets/duration_selector.dart';
import '../widgets/recording_timer_overlay.dart';
import '../widgets/gallery_picker_button.dart';
import '../widgets/zoom_slider.dart';

/// Full-screen camera view for Reels V2 recording.
class ReelsCameraView extends GetView<ReelsCameraController> {
  const ReelsCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white54),
          );
        }

        if (controller.noCameraAvailable.value) {
          return _buildNoCameraFallback(context);
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            // Camera preview (full-screen)
            _buildCameraPreview(),

            // Top bar: close, flash, timer, switch camera
            _buildTopBar(context),

            // Segment progress bar at top
            Positioned(
              top: MediaQuery.of(context).padding.top + 56,
              left: 16,
              right: 16,
              child: SegmentProgressBar(controller: controller),
            ),

            // Countdown overlay
            if (controller.isCountingDown.value)
              RecordingTimerOverlay(
                seconds: controller.countdownSeconds.value,
                onCancel: controller.cancelCountdown,
              ),

            // Zoom slider (center-right)
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height * 0.3,
              bottom: MediaQuery.of(context).size.height * 0.3,
              child: ZoomSlider(controller: controller),
            ),

            // Bottom controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomControls(context),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCameraPreview() {
    final cam = controller.cameraController;
    if (cam == null || !cam.value.isInitialized) {
      return const SizedBox.expand(child: ColoredBox(color: Colors.black));
    }

    return GestureDetector(
      onScaleUpdate: (details) {
        controller.handlePinchZoom(details.scale);
      },
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: cam.value.previewSize?.height ?? 1,
            height: cam.value.previewSize?.width ?? 1,
            child: CameraPreview(cam),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          _CircleButton(
            icon: Icons.close,
            onTap: () {
              if (controller.hasSegments) {
                _showDiscardDialog(context);
              } else {
                Get.back();
              }
            },
          ),

          Row(
            children: [
              // Flash toggle
              Obx(() => _CircleButton(
                    icon: _flashIcon(controller.flashMode.value),
                    onTap: controller.toggleFlash,
                  )),
              const SizedBox(width: 12),

              // Timer selector
              _CircleButton(
                icon: Icons.timer,
                onTap: () => _showTimerPicker(context),
              ),
              const SizedBox(width: 12),

              // Switch camera
              _CircleButton(
                icon: Icons.flip_camera_ios,
                onTap: controller.toggleCamera,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Speed selector row
            Obx(() {
              if (controller.isRecording.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SpeedSelector(controller: controller),
              );
            }),

            // Duration selector
            Obx(() {
              if (controller.isRecording.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DurationSelector(controller: controller),
              );
            }),

            // Main controls row: gallery | record | proceed
            CameraControls(controller: controller),

            // Gallery picker button
            Obx(() {
              if (controller.isRecording.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: GalleryPickerButton(controller: controller),
              );
            }),
          ],
        ),
      ),
    );
  }

  IconData _flashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.torch:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      default:
        return Icons.flash_off;
    }
  }

  void _showTimerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Countdown Timer',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TimerOption(label: 'Off', onTap: () => Navigator.pop(context)),
                _TimerOption(label: '3s', onTap: () {
                  Navigator.pop(context);
                  controller.startCountdown(3);
                }),
                _TimerOption(label: '10s', onTap: () {
                  Navigator.pop(context);
                  controller.startCountdown(10);
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: const Text('Discard recording?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'You have unsaved segments. Discard and go back?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.resetSession();
              Get.back();
            },
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCameraFallback(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
                const Spacer(),
                const Text(
                  'Create Reel',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                const SizedBox(width: 28),
              ],
            ),
          ),
          const Spacer(),
          const Icon(Icons.videocam_off_outlined, color: Colors.white38, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Camera not available',
            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select a video from your gallery instead',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => controller.pickFromGallery(),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Choose from Gallery'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _TimerOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TimerOption({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white12,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _SpeedSelector extends StatelessWidget {
  final ReelsCameraController controller;

  const _SpeedSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: controller.availableSpeeds.map((speed) {
            final isSelected = controller.recordingSpeed.value == speed;
            final label = speed == 1.0 ? '1x' : '${speed}x';

            return GestureDetector(
              onTap: () => controller.setRecordingSpeed(speed),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }
}
