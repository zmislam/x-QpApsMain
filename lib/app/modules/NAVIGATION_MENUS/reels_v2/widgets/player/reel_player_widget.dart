import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/reel_player_controller.dart';
import '../../models/reel_v2_model.dart';
import '../../services/reels_v2_preload_service.dart';
import '../../utils/reel_enums.dart';
import 'reel_loading_shimmer.dart';

/// Core Player Widget for Reels V2.
/// Displays the video with thumbnail/shimmer fallback and buffering indicator.
/// Gesture handling and UI overlays are managed by ReelGestureLayer and ReelOverlay.
class ReelPlayerWidget extends StatelessWidget {
  final ReelV2Model reel;
  final int index;

  const ReelPlayerWidget({
    super.key,
    required this.reel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<ReelPlayerController>();
    final preloadService = Get.find<ReelsV2PreloadService>();

    return Stack(
      fit: StackFit.expand,
      children: [
        // Black background
        Container(color: Colors.black),

        // Video or Shimmer
        Obx(() {
          final isCurrentReel = playerController.currentIndex.value == index;
          final controller = preloadService.getController(index);
          final isReady = controller != null && controller.value.isInitialized;

          if (!isReady) {
            // Show thumbnail if available, otherwise shimmer
            if (reel.thumbnailUrl != null && reel.thumbnailUrl!.isNotEmpty) {
              return Image.network(
                reel.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ReelLoadingShimmer(),
              );
            }
            return const ReelLoadingShimmer();
          }

          return Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          );
        }),

        // Buffering indicator
        Obx(() {
          if (playerController.isBuffering.value &&
              playerController.currentIndex.value == index) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
