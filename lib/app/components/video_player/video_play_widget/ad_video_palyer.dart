import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/constants/video_ad_config.dart';
import '../../../config/constants/color.dart';
import '../../../utils/custom_controllers/video_payer_state_controller.dart';
import '../../button.dart';

class AdVideoPlayer extends StatefulWidget {
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;
  final VideoPlayerStateController videoPlayerStateController;
  const AdVideoPlayer(
      {super.key,
      this.campaignWebUrl,
      this.campaignName,
      this.campaignDescription,
      this.actionButtonText,
      this.campaignCallToAction,
      required this.videoPlayerStateController});

  @override
  State<AdVideoPlayer> createState() => _AdVideoPlayerState();
}

class _AdVideoPlayerState extends State<AdVideoPlayer> {
  late int remainingSeconds;
  late Timer timer;
  bool canSkip = false;
  Timer? _visibilityDebounceTimer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = videoAdSkipButtonVisibilityTimer;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        setState(() {
          canSkip = true;
        });
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (visibilityInfo) {
        // Reducing rechecks
        _visibilityDebounceTimer?.cancel();
        _visibilityDebounceTimer = Timer(const Duration(milliseconds: 300), () {
          if (visibilityInfo.visibleFraction > videoPlayFactorOnScreen) {
            if (widget.videoPlayerStateController.addAlreadyInitComplete) {
              widget.videoPlayerStateController.addVideoPlayerController.play();
            }
          } else {
            if (widget.videoPlayerStateController.addAlreadyInitComplete) {
              widget.videoPlayerStateController.addVideoPlayerController
                  .pause();
            }
          }
        });
      },
      child: ((widget.videoPlayerStateController.addVideoPlayerController.value
              .isInitialized))
          ? Container(
              color: Colors.black,
              // height: widget.videoPlayerStateController.videoPlayerController.value.size.height,
              // width: widget.videoPlayerStateController.videoPlayerController.value.size.width,
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: widget.videoPlayerStateController
                    .addVideoPlayerController.value.aspectRatio,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: widget.videoPlayerStateController
                          .addVideoPlayerController.value.aspectRatio,
                      child: VideoPlayer(
                        widget.videoPlayerStateController
                            .addVideoPlayerController,
                      ),
                    ),

                    // Previous code.. Remove later--------------------------------------
                    if (widget.videoPlayerStateController.showSkipAddButton)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: PrimaryButton(
                            verticalPadding: 10,
                            horizontalPadding: 20,
                            fontSize: 14,
                            onPressed: () {
                              setState(() {
                                widget.videoPlayerStateController.skipAd();
                                // widget.videoPlayerStateController.addVideoPlayerController.pause();
                                // widget.videoPlayerStateController.videoPlayerController.play();
                              });
                            },
                            text: 'Skip Ad'.tr),
                      ),
                    // Previous code.. Remove later--------------------------------------

                    // Positioned(
                    //   right: 10,
                    //   top: 10,
                    //   child: GestureDetector(
                    //     onTap: (){
                    //       if(widget.videoPlayerStateController.showSkipAddButton){
                    //         setState(() {
                    //           widget.videoPlayerStateController.skipAd();
                    //           widget.videoPlayerStateController.addVideoPlayerController.pause();
                    //           widget.videoPlayerStateController.videoPlayerController.play();
                    //         });
                    //       }
                    //     },
                    //     child: CircleAvatar(
                    //       backgroundColor: Colors.white54,
                    //       child: Stack(
                    //         alignment: Alignment.center,
                    //         children: [
                    //           CircularProgressIndicator(
                    //             value: 1 - (remainingSeconds / videoAdSkipButtonVisibilityTimer),
                    //             backgroundColor: Colors.grey[300],
                    //             valueColor: const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
                    //             strokeWidth: 3,
                    //             strokeCap: StrokeCap.round,
                    //           ),
                    //           Text(
                    //             widget.videoPlayerStateController.showSkipAddButton ? 'Skip' : '$remainingSeconds',
                    //             style: const TextStyle(
                    //               fontSize: 12,
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 110,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: widget.campaignCallToAction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.campaignWebUrl.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.campaignName
                                        .toString()
                                        .capitalizeFirst ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 0),
                              Text(
                                widget.campaignDescription.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: widget.campaignCallToAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(widget.actionButtonText ?? 'Book Now'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class CircularSkipButton extends StatefulWidget {
  final int countdownSeconds;
  final VoidCallback onSkip;

  const CircularSkipButton(
      {Key? key, required this.countdownSeconds, required this.onSkip})
      : super(key: key);

  @override
  _CircularSkipButtonState createState() => _CircularSkipButtonState();
}

class _CircularSkipButtonState extends State<CircularSkipButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
