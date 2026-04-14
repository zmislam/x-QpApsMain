import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_feed_controller.dart';
import '../controllers/reel_player_controller.dart';
import '../utils/reel_enums.dart';
import '../widgets/player/reel_player_widget.dart';
import '../widgets/player/reel_loading_shimmer.dart';
import '../widgets/player/reel_gesture_layer.dart';
import '../widgets/player/reel_overlay.dart';
import '../widgets/player/reel_volume_brightness.dart';

/// Feed view for a specific feed type (For You, Following, Trending).
/// Contains the vertical PageView that allows swiping through reels.
class ReelsFeedView extends StatelessWidget {
  final ReelFeedType feedType;

  const ReelsFeedView({super.key, required this.feedType});

  @override
  Widget build(BuildContext context) {
    final feedController = Get.find<ReelsFeedController>();
    final playerController = Get.find<ReelPlayerController>();

    return Obx(() {
      if (feedController.isLoading.value && feedController.reels.isEmpty) {
        return const ReelLoadingShimmer();
      }

      if (feedController.reels.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.video_library_outlined,
                  color: Colors.white38, size: 64),
              const SizedBox(height: 16),
              Text(
                _emptyMessage(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => feedController.refreshCurrentFeed(),
                child: const Text('Refresh',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }

      return PageView.builder(
        controller: feedController.pageController,
        scrollDirection: Axis.vertical,
        itemCount: feedController.reels.length,
        onPageChanged: (index) {
          feedController.onPageChanged(index);
          playerController.playReel(index, feedController.reels[index]);
        },
        itemBuilder: (context, index) {
          final reel = feedController.reels[index];

          return Stack(
            fit: StackFit.expand,
            children: [
              // Volume/brightness gesture wrapper → Gesture layer → Video player
              ReelVolumeBrightness(
                child: ReelGestureLayer(
                  reelId: reel.id ?? '',
                  index: index,
                  child: ReelPlayerWidget(reel: reel, index: index),
                ),
              ),

              // UI Overlay (author, caption, sound, action bar, seekbar)
              ReelOverlay(reel: reel, index: index),

              // Loading more indicator at bottom
              if (index == feedController.reels.length - 1)
                Obx(() {
                  if (feedController.isLoadingMore.value) {
                    return const Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
            ],
          );
        },
      );
    });
  }

  String _emptyMessage() {
    switch (feedType) {
      case ReelFeedType.following:
        return 'Follow people to see their reels here';
      case ReelFeedType.trending:
        return 'No trending reels right now';
      default:
        return 'No reels to show';
    }
  }
}
