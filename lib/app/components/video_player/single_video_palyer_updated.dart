import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/video_sound_controller.dart';
import 'video_play_widget/ad_video_palyer.dart';
import 'video_play_widget/post_video_player.dart';
import 'video_player_updated.dart';
import '../../utils/custom_controllers/video_payer_state_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../config/constants/video_ad_config.dart';

class SingleVideoPlayerUpdated extends StatefulWidget {
  final String videoLink;
  final String postId;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;

  const SingleVideoPlayerUpdated(
      {super.key,
      required this.videoLink,
      required this.postId,
      this.adVideoLink,
      this.campaignWebUrl,
      this.campaignName,
      this.campaignDescription,
      this.actionButtonText,
      this.campaignCallToAction});

  @override
  State<SingleVideoPlayerUpdated> createState() =>
      _SingleVideoPlayerUpdatedState();
}

class _SingleVideoPlayerUpdatedState extends State<SingleVideoPlayerUpdated> {
  final VideoPlayerStateController videoPlayerStateController =
      VideoPlayerStateController();
  bool _isBuffering = false;

  @override
  void initState() {
    // Sound config updated
    videoPlayerStateController
        .init(videoLink: widget.videoLink, adVideoLink: widget.adVideoLink)
        .then((value) {
      setState(() {});
      videoSoundSetupUpdate();
    });

    videoPlayerStateController.addListener(
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    videoPlayerStateController.videoPlayerController.addListener(() {
      if (videoPlayerStateController.videoPlayerController.value.isBuffering) {
        setState(() {
          _isBuffering = true;
        });
      } else {
        setState(() {
          _isBuffering = false;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerStateController.disposeController();
    super.dispose();
  }

  void videoSoundSetupUpdate() {
    bool isSoundOn = VideoSoundController.isMuted.value;

    videoPlayerStateController.videoPlayerController
        .setVolume(isSoundOn ? 1 : 0);

    // Ensure ad player is initialized before setting volume
    if (widget.adVideoLink != null &&
        videoPlayerStateController.addAlreadyInitComplete) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (videoPlayerStateController
            .addVideoPlayerController.value.isInitialized) {
          videoPlayerStateController.addVideoPlayerController
              .setVolume(isSoundOn ? 1 : 0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: videoPlayerStateController
              .videoPlayerController.value.aspectRatio,
          child: VisibilityDetector(
            onVisibilityChanged: (info) {
              if (info.visibleFraction > videoPlayFactorOnScreen) {
                // Add init if comes on screen
                videoPlayerStateController.videoAdControllerInit();
              }
            },
            key: UniqueKey(),
            child: Container(
              width: size.width,
              padding: EdgeInsets.zero,
              color: Colors.black,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => CustomVideoPlayerUpdated(
                        postId: widget.postId,
                        videoLink: widget.videoLink,
                        actionButtonText: widget.actionButtonText,
                        adVideoLink: widget.adVideoLink,
                        campaignCallToAction: widget.campaignCallToAction,
                        campaignDescription: widget.campaignDescription,
                        campaignName: widget.campaignName,
                        campaignWebUrl: widget.campaignWebUrl,
                        videoSoundSetupUpdate: videoSoundSetupUpdate,
                        videoPlayerStateController: videoPlayerStateController,
                      ));
                },
                child: Stack(
                  children: [
                    // Video Player
                    videoPlayerStateController.playAddVideo &&
                            videoPlayerStateController.addAlreadyInitComplete
                        //================================================================ Advertisement Video =================================
                        ? AdVideoPlayer(
                            campaignWebUrl: widget.campaignWebUrl,
                            campaignName: widget.campaignName,
                            campaignDescription: widget.campaignDescription,
                            actionButtonText: widget.actionButtonText,
                            campaignCallToAction:
                                widget.campaignCallToAction ?? () {},
                            videoPlayerStateController:
                                videoPlayerStateController,
                          )
                        //================================================================ Post Video =================================

                        : PostVideoPlayer(
                            videoPlayerStateController:
                                videoPlayerStateController,
                            videoSoundSetupUpdate: videoSoundSetupUpdate,
                            showControls: false,
                          ),

                    // Video Sound setup
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: ValueListenableBuilder<bool>(
                          valueListenable: VideoSoundController.isMuted,
                          builder: (context, isMuted, child) {
                            return IconButton(
                              onPressed: () {
                                VideoSoundController.toggleMute();
                              },
                              icon: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  isMuted ? Icons.volume_off : Icons.volume_up,
                                  size: 20,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            );
                          }),
                    ),

                    //
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isBuffering) const CircularProgressIndicator(),
      ],
    );
  }
}
