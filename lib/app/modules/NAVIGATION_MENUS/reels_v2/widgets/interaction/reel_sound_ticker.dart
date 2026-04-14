import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reel_player_controller.dart';
import '../../utils/reel_enums.dart';

/// Sound ticker at bottom of reel — spinning disc + scrolling sound name marquee.
class ReelSoundTicker extends StatefulWidget {
  final String? soundName;
  final String? soundArtist;
  final String? thumbnailUrl;

  const ReelSoundTicker({
    super.key,
    this.soundName,
    this.soundArtist,
    this.thumbnailUrl,
  });

  @override
  State<ReelSoundTicker> createState() => _ReelSoundTickerState();
}

class _ReelSoundTickerState extends State<ReelSoundTicker>
    with TickerProviderStateMixin {
  late AnimationController _discController;
  late AnimationController _marqueeController;
  late Animation<double> _discRotation;
  late Animation<Offset> _marqueeOffset;

  @override
  void initState() {
    super.initState();

    // Spinning disc animation
    _discController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _discRotation = Tween<double>(begin: 0.0, end: 1.0).animate(_discController);

    // Marquee scroll animation
    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _marqueeOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _marqueeController,
      curve: Curves.linear,
    ));

    _discController.repeat();
    _marqueeController.repeat();
  }

  @override
  void dispose() {
    _discController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.soundName == null && widget.soundArtist == null) {
      return const SizedBox.shrink();
    }

    final playerController = Get.find<ReelPlayerController>();

    return Obx(() {
      final isPlaying = playerController.playerState.value == ReelPlayerState.playing;
      if (isPlaying) {
        if (!_discController.isAnimating) _discController.repeat();
        if (!_marqueeController.isAnimating) _marqueeController.repeat();
      } else {
        _discController.stop();
        _marqueeController.stop();
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.music_note, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          // Marquee text
          Expanded(
            child: SizedBox(
              height: 16,
              child: ClipRect(
                child: SlideTransition(
                  position: _marqueeOffset,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _soundLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          shadows: [Shadow(color: Colors.black38, blurRadius: 3)],
                        ),
                      ),
                      const SizedBox(width: 40),
                      Text(
                        _soundLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          shadows: [Shadow(color: Colors.black38, blurRadius: 3)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Spinning disc
          RotationTransition(
            turns: _discRotation,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
                image: widget.thumbnailUrl != null
                    ? DecorationImage(
                        image: NetworkImage(widget.thumbnailUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                gradient: widget.thumbnailUrl == null
                    ? const LinearGradient(
                        colors: [Color(0xFF333333), Color(0xFF111111)],
                      )
                    : null,
              ),
              child: widget.thumbnailUrl == null
                  ? const Icon(Icons.music_note, color: Colors.white54, size: 12)
                  : null,
            ),
          ),
        ],
      );
    });
  }

  String get _soundLabel {
    final parts = <String>[];
    if (widget.soundName != null) parts.add(widget.soundName!);
    if (widget.soundArtist != null) parts.add(widget.soundArtist!);
    return parts.join(' · ');
  }
}
