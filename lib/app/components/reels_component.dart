import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:quantum_possibilities_flutter/app/utils/logger/logger.dart';
import 'smart_text.dart';
import '../extension/string/string_image_path.dart';
import 'package:video_player/video_player.dart';
import '../config/constants/api_constant.dart';
import '../data/app_settings_data.dart';
import '../data/login_creadential.dart';
import '../models/app_settings_model.dart';
import '../models/user.dart';
import '../modules/NAVIGATION_MENUS/reels/controllers/reels_controller.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_comment_model.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_model.dart';
import '../routes/app_pages.dart';
import '../routes/profile_navigator.dart';
import '../services/audio_player_service.dart';
import '../utils/copy_to_clipboard_utils.dart';
import '../utils/url_utils.dart';
import 'button.dart';
import 'image.dart';

class ReelsComponent extends StatefulWidget {
  final bool isLiked;

  final CarouselController carouselController;
  final ReelsModel reelsModel;
  final LoginCredential loginCredentials;
  final VoidCallback onPressedLike;
  final VoidCallback onPressedViewReact;
  final VoidCallback onPressedShareReels;
  final VoidCallback onPressedViewProfile;
  final VoidCallback onPressedReelsEye;
  final VoidCallback onPressedReport;
  final VoidCallback onTapDelete;
  final VoidCallback onTapEditReel;
  final VideoPlayerController? externalController;
  final VoidCallback onPressedComment;

  const ReelsComponent({
    super.key,
    required this.carouselController,
    required this.loginCredentials,
    required this.isLiked,
    required this.reelsModel,
    required this.onPressedLike,
    required this.onPressedViewReact,
    required this.onPressedShareReels,
    required this.onPressedReport,
    required this.onPressedComment,
    required this.onTapDelete,
    required this.onTapEditReel,
    required this.onPressedViewProfile,
    required this.onPressedReelsEye,
    this.externalController,
  });

  @override
  State<ReelsComponent> createState() => ReelsComponentState();
}

class ReelsComponentState extends State<ReelsComponent>
    with TickerProviderStateMixin {
  final ReelsController reelsController = Get.find();

  VideoPlayerController? videoPlayerControllerInternal;
  bool createdInternalController = false;

  VideoPlayerController? get activeVideoController =>
      widget.externalController ?? videoPlayerControllerInternal;

  late GifController gifController;
  late final AppSettingsData appSettingsData;
  late AppSettingsModel appSettingsModel;

  ReelsCommentModel? reelsCommentModel;
  UserModel? userModel;

  TextEditingController commentController = TextEditingController();
  TextEditingController commentReplyController = TextEditingController();
  final AudioPlayerService audioPlayerService = AudioPlayerService();

  bool isPlayingFlag = true;
  bool _wasPlayingBeforePause = false;
  VoidCallback? videoControllerListener;

  @override
  void initState() {
    super.initState();
    gifController = GifController(vsync: this);
    appSettingsData = AppSettingsData();
    appSettingsModel = appSettingsData.getAppSettingsData();

    ever(reelsController.shouldPauseReels, (shouldPause) {
      if (mounted) {
        if (shouldPause) {
          _wasPlayingBeforePause =
              activeVideoController?.value.isPlaying ?? false;
          _pauseEverything(callSetState: false);
          setState(() {});
        } else {
          if (_wasPlayingBeforePause) {
            _resumePlayback();
          }
          _wasPlayingBeforePause = false;
        }
      }
    });

    if (widget.externalController != null) {
      attachListenerToController(widget.externalController!);
      maybeStartAudioForController(widget.externalController!);
    } else {
      createInternalNetworkController();
    }
  }

  Future<void> createInternalNetworkController() async {
    createdInternalController = true;
    final String videoPath = widget.reelsModel.video ?? '';
    final Uri uri = Uri.parse('${ApiConstant.SERVER_IP_PORT}/uploads/reels/$videoPath');
    Log.i(uri.toString());
    final controller = VideoPlayerController.networkUrl(uri);
    videoPlayerControllerInternal = controller;

    try {
      await controller.initialize();

      if (!mounted) {
        // detach any listener just in case and return
        // (we did not attach yet, but keep this safe)
        return;
      }

      // Attach listener AFTER initialize to avoid initialize-event race.
      attachListenerToController(controller);

      setState(() {
        controller
          ..setLooping(true)
          ..setVolume(appSettingsData.getAppSettingsData().reelsSoundEnable == true ? 1 : 0)
          ..play();

        if (appSettingsData.getAppSettingsData().reelsSoundEnable == true) {
          final audioFile = widget.reelsModel.reelsDataModel?.audioModel?.audio_file;
          if (audioFile != null && audioFile.isNotEmpty) {
            audioPlayerService.playUrlSource(
                '${ApiConstant.SERVER_IP_PORT}/uploads/audio/$audioFile');
          }
        }
      });
    } catch (e) {
      debugPrint('Error initializing internal video player: $e');
    }
  }


  // default: allow setState (true)
  void _pauseEverything({bool callSetState = true}) {
    debugPrint('🛑 Pausing reel component');
    final controller = activeVideoController;

    if (controller != null && controller.value.isPlaying) {
      try {
        controller.pause();
        debugPrint('   ✓ Video paused');
      } catch (e) {
        debugPrint('   ✗ Error pausing video: $e');
      }
    }

    try {
      gifController.stop();
      debugPrint('   ✓ GIF stopped');
    } catch (e) {
      debugPrint('   ✗ Error stopping GIF: $e');
    }

    try {
      audioPlayerService.stop();
      debugPrint('   ✓ Audio stopped');
    } catch (e) {
      debugPrint('   ✗ Error stopping audio: $e');
    }

    // Only call setState when caller explicitly allows it and widget is mounted.
    if (callSetState && mounted) {
      try {
        setState(() {});
      } catch (e) {
        debugPrint('Ignored setState in _pauseEverything: $e');
      }
    }
  }

  void _resumePlayback() {
    final controller = activeVideoController;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      controller.setVolume(
          appSettingsData.getAppSettingsData().reelsSoundEnable == true ? 1 : 0);
      controller.play();
    } catch (e) {
      debugPrint('   ✗ Error resuming video: $e');
    }

    try {
      gifController.repeat(period: const Duration(milliseconds: 800));
    } catch (e) {
      debugPrint('   ✗ Error resuming GIF: $e');
    }

    try {
      maybeStartAudioForController(controller);
    } catch (e) {
      debugPrint('   ✗ Error resuming audio: $e');
    }

    if (mounted) {
      try {
        setState(() {});
      } catch (e) {
        debugPrint('Ignored setState in _resumePlayback: $e');
      }
    }
  }


  @override
  void didUpdateWidget(covariant ReelsComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.externalController != widget.externalController) {
      detachListenerFromController(oldWidget.externalController);

      if (widget.externalController != null) {
        if (createdInternalController && videoPlayerControllerInternal != null) {
          try {
            videoPlayerControllerInternal!.pause();
          } catch (_) {}
          try {
            videoPlayerControllerInternal!.dispose();
          } catch (_) {}
          videoPlayerControllerInternal = null;
          createdInternalController = false;
        }
        attachListenerToController(widget.externalController!);
        maybeStartAudioForController(widget.externalController!);
      } else {
        // external removed -> create internal fallback
        createInternalNetworkController();
      }
    }
  }

  void attachListenerToController(VideoPlayerController controller) {
    videoControllerListener = () {
      if (mounted) setState(() {});
    };
    controller.addListener(videoControllerListener!);
  }

  void detachListenerFromController(VideoPlayerController? controller) {
    if (controller != null && videoControllerListener != null) {
      try {
        controller.removeListener(videoControllerListener!);
      } catch (_) {}
    }
    videoControllerListener = null;
  }



  void maybeStartAudioForController(VideoPlayerController controller) {
    final audioFile = widget.reelsModel.reelsDataModel?.audioModel?.audio_file;
    if (audioFile != null &&
        appSettingsData.getAppSettingsData().reelsSoundEnable == true &&
        controller.value.isInitialized &&
        controller.value.isPlaying) {
      audioPlayerService.playUrlSource(
          '${ApiConstant.SERVER_IP_PORT}/uploads/audio/$audioFile');
    }
  }
  @override
  void dispose() {
    _pauseEverything();

    // detach listener from external AND internal controllers
    detachListenerFromController(widget.externalController);
    detachListenerFromController(videoPlayerControllerInternal);

    if (createdInternalController && videoPlayerControllerInternal != null) {
      try {
        videoPlayerControllerInternal!.pause();
      } catch (_) {}
      try {
        videoPlayerControllerInternal!.dispose();
      } catch (_) {}
      videoPlayerControllerInternal = null;
      createdInternalController = false;
    }

    audioPlayerService.stop();
    commentController.dispose();
    commentReplyController.dispose();
    super.dispose();
  }


  Widget buildVideoArea() {
    final controller = activeVideoController;
    final hasVideo = (widget.reelsModel.video != null && widget.reelsModel.video!.isNotEmpty);

    if (!hasVideo && (widget.reelsModel.image?.isNotEmpty ?? false)) {
      final imageUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/${widget.reelsModel.image?.first}';
      Log.i(imageUrl);
      return Positioned.fill(
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.black),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            height: Get.height,
            width: Get.width,
          ),
        ),
      );
    }

    if (controller != null && controller.value.isInitialized) {
      final Size videoSize = controller.value.size;
      // if (aspectRatioValue > 1.5) {
        return Positioned.fill(
          child: FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.cover,
            child: SizedBox(
              height: videoSize.height,
              width: videoSize.width,
              child: VideoPlayer(controller),
            ),
          ),
        );
    }

    // fallback spinner
    return Positioned.fill(
      child: Container(
        color: Colors.black,
      ),
    );
  }

  void togglePlayPause() {
    final c = activeVideoController;
    if (c == null) return;

    if (c.value.isPlaying) {
      try { c.pause(); } catch (_) {}
      try { gifController.stop(); } catch (_) {}
      try { audioPlayerService.stop(); } catch (_) {}
    } else {
      try { c.play(); } catch (_) {}
      try { gifController.repeat(period: const Duration(milliseconds: 800)); } catch (_) {}
      try { maybeStartAudioForController(c); } catch (_) {}
    }

    if (mounted) setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final controller = activeVideoController;
    final emojiSrc = widget.reelsModel.reelsDataModel?.reelsEmojiModel?.emojiSrc;
    final isGif = emojiSrc != null && emojiSrc.toLowerCase().endsWith('.gif');
    final hasVideo = (widget.reelsModel.video != null && widget.reelsModel.video!.isNotEmpty);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: togglePlayPause,
      child: Stack(
        children: [
          buildVideoArea(),
          Center(
            child: IconButton(
              onPressed: togglePlayPause,
              icon: Icon(
                (activeVideoController?.value.isPlaying ?? false) ? Icons.pause : Icons.play_arrow,
                // (activeVideoController?.value.isPlaying ?? false) ? Icons.pause : Icons.play_arrow,
                size: 40,
                color: (activeVideoController?.value.isPlaying ?? false) ? Colors.transparent :  Colors.transparent,
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: (!hasVideo)
                ? const SizedBox()
                : (activeVideoController != null)
                ? VideoProgressIndicator(activeVideoController!, allowScrubbing: true)
                : const SizedBox(),
          ),

          if (emojiSrc != null)
            Positioned(
              left: widget.reelsModel.reelsDataModel?.reelsEmojiModel?.positionX ?? 0,
              top: widget.reelsModel.reelsDataModel?.reelsEmojiModel?.positionY ?? 0,
              child: isGif
                  ? Transform.scale(
                scale: widget.reelsModel.reelsDataModel?.reelsEmojiModel?.emojiScale?.toDouble() ?? 1.0,
                child: Gif(
                  height: 64,
                  width: 64,
                  fps: 30,
                  autostart: Autostart.loop,
                  controller: gifController,
                  image: NetworkImage('${ApiConstant.SERVER_IP_PORT}/assets/sticker/$emojiSrc'),
                ),
              )
                  : Transform.scale(
                scale: widget.reelsModel.reelsDataModel?.reelsEmojiModel?.emojiScale?.toDouble() ?? 1.0,
                child: PrimaryNetworkImage(
                  height: 64,
                  width: 64,
                  imageUrl: widget.reelsModel.reelsDataModel?.reelsEmojiModel?.emojiType == 'emoji'
                      ? '${ApiConstant.SERVER_IP_PORT}/assets/emoji/$emojiSrc'
                      : '${ApiConstant.SERVER_IP_PORT}/assets/sticker/$emojiSrc',
                ),
              ),
            ),

          Positioned(
            top: 50,
            right: Get.width - 60,
            child: InkWell(
                onTap: () {
                  audioPlayerService.stop();
                  if (activeVideoController != null) {
                    try {
                      activeVideoController!.setVolume(0);
                    } catch (_) {}
                  }
                  Get.toNamed(Routes.LIVE_REELS);
                },
                child: Image.asset(
                  'assets/image/live.png',
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 25,
                  width: 25,
                )),
          ),

          Positioned(
            top: 50,
            left: Get.width - 120,
            child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.ADVANCE_SEARCH);
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 25,
                )),
          ),

          Positioned(
            top: 50,
            left: Get.width - 60,
            child: InkWell(
                onTap: () {
                  audioPlayerService.stop();
                  if (activeVideoController != null) {
                    try {
                      activeVideoController!.setVolume(0);
                    } catch (_) {}
                  }
                  Get.toNamed(Routes.CUSTOM_CAMERA);
                },
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 25,
                )),
          ),

          if (widget.reelsModel.reelsDataModel?.reelsTextModel?.reelsText != null)
            Positioned(
              left: widget.reelsModel.reelsDataModel?.reelsTextModel?.textPositionX ?? 0,
              top: widget.reelsModel.reelsDataModel?.reelsTextModel?.textPositionY ?? 0,
              child: Transform.scale(
                scale: widget.reelsModel.reelsDataModel?.reelsTextModel?.textScale?.toDouble() ?? 1.0,
                child: Container(
                  color: widget.reelsModel.reelsDataModel?.reelsTextModel?.textBgColor != null
                      ? Color(widget.reelsModel.reelsDataModel!.reelsTextModel!.textBgColor!)
                      : Colors.transparent,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.reelsModel.reelsDataModel?.reelsTextModel?.reelsText ?? '',
                    style: TextStyle(
                      color: widget.reelsModel.reelsDataModel?.reelsTextModel?.textColor != null
                          ? Color(widget.reelsModel.reelsDataModel!.reelsTextModel!.textColor!)
                          : Colors.transparent,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            left: 20,
            bottom: 56,
            child: SizedBox(
              width: Get.width * 0.75,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    widget.reelsModel.repost_from_user == null
                        ? const SizedBox()
                        : Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          ProfileNavigator.navigateToProfile(
                              username: widget.reelsModel.repost_from_user?.username ?? '',
                              isFromReels: 'false');
                        },
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(vertical: 4, horizontal: 4),
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/repost.svg',
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                        '${widget.reelsModel.repost_from_user?.first_name} ${widget.reelsModel.repost_from_user?.last_name}'.tr,
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                    TextSpan(text: ' reposted this video'.tr, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400))
                                  ]),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    (widget.reelsModel.reactions ?? []).isEmpty
                        ? const SizedBox()
                        : Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: widget.onPressedViewReact,
                        child: Wrap(
                          children: [
                            const SizedBox(width: 8),
                            for (int i = 0; i < (widget.reelsModel.reactions?.take(2).length ?? 0); i++)
                              Align(
                                widthFactor: 0.5,
                                child: CircleAvatar(
                                  radius: 12,
                                  child: NetworkCircleAvatar(
                                    imageUrl: (widget.reelsModel.reactions?[i].reacted_user?.profile_pic?.formatedProfileUrl ?? ''.formatedProfileUrl),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 15),
                            if (widget.reelsModel.reactions!.isNotEmpty)
                              Text(
                                widget.reelsModel.reactions![0].reacted_user?.first_name ?? '',
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            if (widget.reelsModel.reaction_count! >= 2) ...[
                              Text(' and '.tr, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                              Text((widget.reelsModel.reaction_count! - 1).toString(), style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                              Text(' Others '.tr, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                            if (widget.reelsModel.reaction_count! >= 1) ...[
                              Text(' React This Reel'.tr, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                            ]
                          ],
                        ),
                      ),
                    ),

                    (widget.reelsModel.link == null || widget.reelsModel.link == '')
                        ? const SizedBox()
                        : Padding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
                      child: TextButton(
                        onPressed: () async {
                          UriUtils.launchUrlInBrowser(widget.reelsModel.link ?? '');
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            backgroundColor: Colors.black45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        child: Row(
                          children: [
                            const Icon(Icons.link, color: Colors.white, size: 20),
                            const SizedBox(width: 4),
                            Text('View Link'.tr, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        try {
                          activeVideoController?.setVolume(0);
                        } catch (_) {}
                        audioPlayerService.stop();
                        widget.onPressedViewProfile();
                      },
                      child: Row(
                        children: [
                          NetworkCircleAvatar(
                            imageUrl: (widget.reelsModel.reel_user?.page_id?.isNotEmpty ?? false)
                                ? (widget.reelsModel.reel_user?.profile_pic?.formatedProfileUrl ?? ''.formatedProfileUrl)
                                : (widget.reelsModel.reel_user?.profile_pic?.formatedProfileUrl ?? ''.formatedProfileUrl),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180,
                                child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: '${widget.reelsModel.reel_user?.first_name ?? '.tr'} ${widget.reelsModel.reel_user?.last_name ?? ''}',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                                    (widget.reelsModel.location == null || widget.reelsModel.location == '')
                                        ? const TextSpan(text: '')
                                        : TextSpan(text: ' is at ${widget.reelsModel.location ?? '.tr'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white)),
                                  ]),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    widget.reelsModel.reels_privacy == '' || widget.reelsModel.reels_privacy == null || widget.reelsModel.reels_privacy == 'null'
                                        ? 'Public'
                                        : '${widget.reelsModel.reels_privacy.toString().capitalizeFirst}',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    widget.reelsModel.reels_privacy == 'public'
                                        ? Icons.public
                                        : widget.reelsModel.reels_privacy == 'null'
                                        ? Icons.public
                                        : widget.reelsModel.reels_privacy == 'friends'
                                        ? Icons.group
                                        : widget.reelsModel.reels_privacy == 'private'
                                        ? Icons.lock
                                        : Icons.public,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    (widget.reelsModel.description ?? '').isEmpty
                        ? const SizedBox()
                        : Padding(
                      padding: const EdgeInsetsDirectional.only(top: 10, end: 10),
                      child: SizedBox(
                        width: Get.width - 20,
                        child: SmartText(
                          '${widget.reelsModel.description}'.tr,
                          expandText: 'See more',
                          maxLines: 2,
                          collapseText: 'See less',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    (widget.reelsModel.reel_user?.id == widget.loginCredentials.getUserData().id && widget.reelsModel.campaign_id == null)
                        ? PrimaryButton(
                        verticalPadding: 10,
                        horizontalPadding: 15,
                        fontSize: 15,
                        onPressed: () {
                          Get.toNamed(Routes.BOOST_REELS, arguments: widget.reelsModel.id);
                        },
                        text: 'Boost Now'.tr)
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ),

          Positioned(
              right: 20,
              bottom: 40,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        appSettingsModel.reelsSoundEnable = !appSettingsModel.reelsSoundEnable;
                        appSettingsData.saveAppSettingsData(appSettingsModel);
                        if (appSettingsData.getAppSettingsData().reelsSoundEnable == true) {
                          try {
                            activeVideoController?.setVolume(1);
                          } catch (_) {}
                          final audioFile = widget.reelsModel.reelsDataModel?.audioModel?.audio_file;
                          if (audioFile != null && audioFile.isNotEmpty) {
                            audioPlayerService.playUrlSource('${ApiConstant.SERVER_IP_PORT}/uploads/audio/$audioFile');
                          }
                        } else {
                          try {
                            activeVideoController?.setVolume(0);
                          } catch (_) {}
                          audioPlayerService.stop();
                        }
                      });
                    },
                    icon: Icon(
                      appSettingsData.getAppSettingsData().reelsSoundEnable == true ? Icons.volume_up : Icons.volume_off,
                      size: 25,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 15),
                  IconButton(
                    onPressed: widget.onPressedLike,
                    icon: Icon(
                      Icons.thumb_up_alt_outlined,
                      size: 25,
                      color: widget.isLiked == true ? Colors.blue : Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '${widget.reelsModel.reaction_count}'.tr,
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 15),
                  IconButton(
                    onPressed: widget.onPressedComment,
                    icon: Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 25,
                    ),
                  ),
                  Text(
                    '${widget.reelsModel.comment_count}'.tr,
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                      onTap: widget.onPressedShareReels,
                      child: Column(
                        children: [
                          Image.asset('assets/icon/create_post/share.png', height: 30, width: 30, color: Colors.white.withValues(alpha: 0.7)),
                          Text('${widget.reelsModel.total_share_count ?? 0}'.tr, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                        ],
                      )),
                  const SizedBox(height: 30),
                  InkWell(onTap: widget.onPressedReelsEye, child: Image.asset('assets/icon/create_post/eye_tracking.png', height: 20, width: 20)),
                  const SizedBox(height: 10),
                  PopupMenuButton<int>(
                    color: Colors.transparent,
                    offset: const Offset(-50, -100),
                    iconColor: Colors.white,
                    icon: const Icon(Icons.more_horiz),
                    itemBuilder: (context) {
                      return [
                        if (widget.loginCredentials.getUserData().id == widget.reelsModel.reel_user?.id)
                          PopupMenuItem<int>(
                            value: 1,
                            onTap: widget.onTapEditReel,
                            child: Text('Edit'.tr, style: const TextStyle(color: Colors.white)),
                          ),
                        if (widget.loginCredentials.getUserData().id == widget.reelsModel.reel_user?.id)
                          PopupMenuItem<int>(
                            value: 1,
                            onTap: widget.onTapDelete,
                            child: Text('Delete'.tr, style: const TextStyle(color: Colors.white)),
                          ),
                        PopupMenuItem<int>(
                          onTap: () {
                            CopyToClipboardUtils.copyToClipboard('${ApiConstant.SERVER_IP}/reels?reels_id=${widget.reelsModel.id}', 'Link');
                          },
                          value: 3,
                          child: Text('Copy Link'.tr, style: const TextStyle(color: Colors.white)),
                        ),
                        if (widget.loginCredentials.getUserData().id != widget.reelsModel.reel_user?.id)
                          PopupMenuItem<int>(
                            value: 3,
                            onTap: widget.onPressedReport,
                            child: Text('Report'.tr, style: const TextStyle(color: Colors.white)),
                          ),
                      ];
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
