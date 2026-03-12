import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'video_play_widget/ad_video_palyer.dart';
import 'video_play_widget/post_video_player.dart';

import '../../utils/custom_controllers/video_payer_state_controller.dart';

class CustomVideoPlayerUpdated extends StatefulWidget {
  final String videoLink;
  final String postId;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;
  final Function videoSoundSetupUpdate;
  final VideoPlayerStateController videoPlayerStateController;

  const CustomVideoPlayerUpdated(
      {super.key,
      required this.videoLink,
      required this.postId,
      this.adVideoLink,
      this.campaignWebUrl,
      this.campaignName,
      this.campaignDescription,
      this.actionButtonText,
      this.campaignCallToAction,
      required this.videoSoundSetupUpdate,
      required this.videoPlayerStateController});

  @override
  State<CustomVideoPlayerUpdated> createState() =>
      _CustomVideoPlayerUpdatedState();
}

class _CustomVideoPlayerUpdatedState extends State<CustomVideoPlayerUpdated> {
  @override
  void initState() {
    // add video init if not complete
    if (!widget.videoPlayerStateController.addAlreadyInitComplete) {
      widget.videoPlayerStateController.videoAdControllerInit();
    }

    widget.videoPlayerStateController.addListener(
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );
    super.initState();
  }

  void returnFromVideoView() {
    /// Is it required? ------------------------
    // if (widget.videoPlayerController.value.position.inSeconds > 0 && widget.videoPlayerController.value.position.inSeconds != widget.videoPlayerController.value.duration.inSeconds) {
    //   widget.videoPlayerController.play();
    // } else {
    //   widget.videoPlayerController.pause();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        returnFromVideoView();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: IconButton(
            onPressed: () {
              returnFromVideoView();
              Get.back();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
        body: Center(
          child: widget.videoPlayerStateController.playAddVideo &&
                  widget.videoPlayerStateController.addAlreadyInitComplete
              //================================================================ Advertisement Video =================================
              ? AdVideoPlayer(
                  campaignWebUrl: widget.campaignWebUrl,
                  campaignName: widget.campaignName,
                  campaignDescription: widget.campaignDescription,
                  actionButtonText: widget.actionButtonText,
                  campaignCallToAction: widget.campaignCallToAction ?? () {},
                  videoPlayerStateController: widget.videoPlayerStateController,
                )
              //================================================================ Post Video =================================

              : PostVideoPlayer(
                  videoPlayerStateController: widget.videoPlayerStateController,
                  videoSoundSetupUpdate: widget.videoSoundSetupUpdate,
                  showControls: true,
                ),
        ),
      ),
    );
  }
}
