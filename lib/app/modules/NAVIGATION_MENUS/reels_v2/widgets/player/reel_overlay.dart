import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reel_player_controller.dart';
import '../../controllers/reels_interaction_controller.dart';
import '../../models/reel_v2_model.dart';
import '../interaction/reel_action_bar.dart';
import '../interaction/reel_author_info.dart';
import '../interaction/reel_caption_area.dart';
import '../interaction/reel_sound_ticker.dart';
import 'reel_seekbar.dart';

/// Reel overlay — shows/hides all UI elements for immersive mode.
/// Contains: action bar, author info, caption, sound ticker, seekbar.
/// Single tap toggles overlay visibility.
class ReelOverlay extends StatelessWidget {
  final ReelV2Model reel;
  final int index;

  const ReelOverlay({
    super.key,
    required this.reel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final interactionController = Get.find<ReelsInteractionController>();
    final playerController = Get.find<ReelPlayerController>();

    return Obx(() {
      // Scrubber overlay (long-press state)
      if (interactionController.isScrubberVisible.value) {
        return _buildScrubberOverlay(playerController);
      }

      // Normal UI overlay (toggled by single tap)
      final isVisible = interactionController.isOverlayVisible.value;

      return AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: !isVisible,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Bottom gradient for readability
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom-left: Author + Caption + Sound
              Positioned(
                bottom: 16,
                left: 16,
                right: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReelAuthorInfo(reel: reel),
                    const SizedBox(height: 8),
                    ReelCaptionArea(
                      caption: reel.caption,
                      hashtags: reel.hashtags,
                      mentionedUserIds: reel.mentionedUserIds,
                    ),
                    const SizedBox(height: 10),
                    ReelSoundTicker(
                      soundName: reel.soundName,
                      soundArtist: reel.soundArtist,
                      thumbnailUrl: reel.thumbnailUrl,
                    ),
                  ],
                ),
              ),

              // Right side: Action bar
              Positioned(
                bottom: 80,
                right: 8,
                child: ReelActionBar(reel: reel),
              ),

              // Bottom: Seekbar
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ReelSeekbar(expanded: false),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Scrubber overlay — shown on long-press (dimmed background + expanded seekbar).
  Widget _buildScrubberOverlay(ReelPlayerController playerController) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dim background
        Container(
          color: Colors.black.withValues(alpha: 0.45),
        ),
        // Centered "Scrubbing" text
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fast_forward_rounded, color: Colors.white60, size: 32),
              SizedBox(height: 8),
              Text(
                'Scrubbing',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Expanded seekbar at bottom
        const Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: ReelSeekbar(expanded: true),
        ),
      ],
    );
  }
}
