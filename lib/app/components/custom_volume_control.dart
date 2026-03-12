import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

class VolumeControlOnly extends StatelessWidget {
  const VolumeControlOnly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController.of(context);

    return GestureDetector(
      onTap: () {
        // Prevent accidental taps from interacting with the player.
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  chewieController.videoPlayerController.value.volume > 0
                      ? Icons.volume_up
                      : Icons.volume_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Toggle mute/unmute
                  final isMuted = chewieController
                          .videoPlayerController.value.volume ==
                      0;
                  chewieController.videoPlayerController
                      .setVolume(isMuted ? 1.0 : 0.0);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
