import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:quantum_possibilities_flutter/app/services/api_communication.dart';
import 'package:quantum_possibilities_flutter/app/utils/logger/logger.dart';
import 'smart_text.dart';
import '../extension/string/string_image_path.dart';
import 'package:video_player/video_player.dart';
import '../config/constants/api_constant.dart';
import '../config/constants/app_assets.dart';
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
  final Function(String reactionType) onPressedReaction;
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
    required this.onPressedReaction,
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

  /// Safe wrapper — silently no-ops if the element is already defunct.
  void _safeSetState([VoidCallback? fn]) {
    if (!mounted) return;
    try {
      setState(fn ?? () {});
    } catch (_) {
      // Element became defunct between mounted check and setState
    }
  }

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
  bool _controllerWasInitialized = false;

  // ─── Reaction Picker State ────────────────────────────────────────────────
  bool _showReactionPicker = false;

  // ─── Double-Tap Like Animation ────────────────────────────────────────────
  bool _showDoubleTapHeart = false;
  Offset _doubleTapPosition = Offset.zero;

  // ─── Play/Pause Icon Fade ──────────────────────────────────────────────
  bool _showPlayPauseIcon = false;
  Timer? _playPauseTimer;

  // ─── Follow State ─────────────────────────────────────────────────────
  bool _isFollowing = false;
  bool _followLoading = false;

  // ─── Playback Speed ──────────────────────────────────────────────────────
  double _playbackSpeed = 1.0;
  static const List<double> _speedOptions = [0.5, 1.0, 1.5, 2.0];

  // ─── GetX Worker (must be cancelled on dispose) ───────────────────────────
  Worker? _pauseWorker;

  @override
  void initState() {
    super.initState();
    gifController = GifController(vsync: this);
    appSettingsData = AppSettingsData();
    appSettingsModel = appSettingsData.getAppSettingsData();
    _isFollowing = widget.reelsModel.is_from_friend == true ||
        widget.reelsModel.is_from_followed_page == true;

    _pauseWorker = ever(reelsController.shouldPauseReels, (shouldPause) {
      if (mounted) {
        if (shouldPause) {
          _wasPlayingBeforePause =
              activeVideoController?.value.isPlaying ?? false;
          _pauseEverything(callSetState: false);
          _safeSetState();
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
      // Auto-play the preloaded external controller
      if (widget.externalController!.value.isInitialized) {
        widget.externalController!
          ..setLooping(true)
          ..setVolume(appSettingsModel.reelsSoundEnable == true ? 1 : 0)
          ..play();
        // Defer reactive mutation to avoid "markNeedsBuild() called during build"
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) reelsController.isReelPlaying.value = true;
        });
      }
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

      _safeSetState(() {
        controller
          ..setLooping(true)
          ..setVolume(appSettingsData.getAppSettingsData().reelsSoundEnable == true ? 1 : 0)
          ..play();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) reelsController.isReelPlaying.value = true;

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

    if (callSetState) {
      _safeSetState();
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) reelsController.isReelPlaying.value = true;
    });

    _safeSetState();
  }


  @override
  void didUpdateWidget(covariant ReelsComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync follow state when the model is updated from outside
    final newFollowing = widget.reelsModel.is_from_friend == true ||
        widget.reelsModel.is_from_followed_page == true;
    if (newFollowing != _isFollowing) {
      _isFollowing = newFollowing;
    }

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
        // Auto-play the new external controller
        if (widget.externalController!.value.isInitialized) {
          widget.externalController!
            ..setLooping(true)
            ..setVolume(appSettingsData.getAppSettingsData().reelsSoundEnable == true ? 1 : 0)
            ..play();
          // Defer reactive mutation to avoid "markNeedsBuild() called during build"
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) reelsController.isReelPlaying.value = true;
          });
        }
        maybeStartAudioForController(widget.externalController!);
      } else {
        // external removed -> create internal fallback
        createInternalNetworkController();
      }
    }
  }

  void attachListenerToController(VideoPlayerController controller) {
    _controllerWasInitialized = controller.value.isInitialized;
    videoControllerListener = () {
      // Only rebuild when the controller first initializes (loading → video).
      // VideoProgressIndicator handles its own per-frame updates internally.
      // Play/pause icon is managed by togglePlayPause()'s own setState calls.
      if (!_controllerWasInitialized && controller.value.isInitialized) {
        _controllerWasInitialized = true;
        _safeSetState();
      }
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
    _controllerWasInitialized = false;
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
    _pauseWorker?.dispose();
    _pauseEverything(callSetState: false);

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
    _playPauseTimer?.cancel();
    gifController.dispose();
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

    // fallback: show first image frame if available, else black
    final firstImage = (widget.reelsModel.image != null && widget.reelsModel.image!.isNotEmpty)
        ? widget.reelsModel.image!.first
        : null;
    if (firstImage != null && firstImage.isNotEmpty) {
      return Positioned.fill(
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.black),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: '${ApiConstant.SERVER_IP_PORT}/uploads/reels/$firstImage',
                fit: BoxFit.cover,
                height: Get.height,
                width: Get.width,
              ),
              const CircularProgressIndicator(color: Colors.white38, strokeWidth: 2),
            ],
          ),
        ),
      );
    }
    return Positioned.fill(
      child: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white38, strokeWidth: 2),
        ),
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
      reelsController.isReelPlaying.value = false;
    } else {
      try { c.play(); } catch (_) {}
      try { gifController.repeat(period: const Duration(milliseconds: 800)); } catch (_) {}
      try { maybeStartAudioForController(c); } catch (_) {}
      reelsController.isReelPlaying.value = true;
    }

    // Show play/pause icon briefly then fade out
    _playPauseTimer?.cancel();
    _safeSetState(() => _showPlayPauseIcon = true);
    _playPauseTimer = Timer(const Duration(milliseconds: 600), () {
      _safeSetState(() => _showPlayPauseIcon = false);
    });
  }

  Future<void> _toggleFollow() async {
    if (_followLoading) return;
    final userId = widget.reelsModel.reel_user?.id ?? '';
    if (userId.isEmpty) return;

    _safeSetState(() => _followLoading = true);
    final api = ApiCommunication();
    final response = await api.doPostRequest(
      apiEndPoint: 'follower-unfollow-request',
      requestData: {
        'follower_user_id': userId,
        'follow_unfollow_status': _isFollowing ? 0 : 1,
      },
    );
    if (response.isSuccessful && mounted) {
      final newFollowing = !_isFollowing;
      _safeSetState(() => _isFollowing = newFollowing);

      // Persist follow state into reelsModelList so it survives widget rebuilds
      final list = reelsController.reelsModelList.value;
      final updatedList = List<ReelsModel>.from(list);
      for (int i = 0; i < updatedList.length; i++) {
        if (updatedList[i].reel_user?.id == userId) {
          updatedList[i] = updatedList[i].copyWith(
            is_from_friend: newFollowing,
          );
        }
      }
      reelsController.reelsModelList.value = updatedList;
    }
    _safeSetState(() => _followLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    final emojiSrc = widget.reelsModel.reelsDataModel?.reelsEmojiModel?.emojiSrc;
    final isGif = emojiSrc != null && emojiSrc.toLowerCase().endsWith('.gif');
    final hasVideo = (widget.reelsModel.video != null && widget.reelsModel.video!.isNotEmpty);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: togglePlayPause,
      onDoubleTapDown: (details) {
        _doubleTapPosition = details.localPosition;
      },
      onDoubleTap: () {
        if (!widget.isLiked) {
          widget.onPressedLike();
        }
        HapticFeedback.lightImpact();
        _safeSetState(() => _showDoubleTapHeart = true);
      },
      child: Stack(
        children: [
          buildVideoArea(),
          // ── Play/Pause fade icon ──
          Center(
            child: AnimatedOpacity(
              opacity: _showPlayPauseIcon ? 1.0 : 0.0,
              duration: Duration(milliseconds: _showPlayPauseIcon ? 0 : 300),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(
                  (activeVideoController?.value.isPlaying ?? false) ? Icons.play_arrow : Icons.pause,
                  size: 44,
                  color: Colors.white,
                ),
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
            top: 46,
            right: 16,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.REELS_SEARCH);
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 26,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
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
                    size: 26,
                  ),
                ),
              ],
            ),
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
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
                          ),
                          // Follow button — only show for other users' reels
                          if (widget.reelsModel.reel_user?.id != widget.loginCredentials.getUserData().id)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: _followLoading
                                  ? const SizedBox(
                                      width: 20, height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : InkWell(
                                      onTap: _toggleFollow,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _isFollowing ? Colors.white24 : Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _isFollowing ? 'Following' : 'Follow',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _isFollowing ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
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
                  // ─── Sound Toggle ─────────────────────────────────────────
                  IconButton(
                    onPressed: () {
                      _safeSetState(() {
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
                  const SizedBox(height: 10),
                  // ─── Like Button (tap = like, long-press = reaction picker) ──
                  GestureDetector(
                    onTap: widget.onPressedLike,
                    onLongPress: () {
                      HapticFeedback.mediumImpact();
                      _safeSetState(() => _showReactionPicker = true);
                    },
                    child: Column(
                      children: [
                        Icon(
                          widget.isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                          size: 25,
                          color: widget.isLiked ? Colors.blue : Colors.white.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.reelsModel.reaction_count}'.tr,
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // ─── Comment ──────────────────────────────────────────────
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
                  const SizedBox(height: 15),
                  // ─── Share ────────────────────────────────────────────────
                  InkWell(
                      onTap: widget.onPressedShareReels,
                      child: Column(
                        children: [
                          Image.asset('assets/icon/create_post/share.png', height: 30, width: 30, color: Colors.white.withValues(alpha: 0.7)),
                          Text('${widget.reelsModel.total_share_count ?? 0}'.tr, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                        ],
                      )),
                  const SizedBox(height: 15),
                  // ─── Bookmark / Save ──────────────────────────────────────
                  Obx(() {
                    final isBookmarked = reelsController.bookmarkedReelIds.contains(widget.reelsModel.id);
                    return GestureDetector(
                      onTap: () => reelsController.toggleBookmark(widget.reelsModel.id ?? ''),
                      child: Column(
                        children: [
                          Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: isBookmarked ? Colors.amber : Colors.white.withValues(alpha: 0.7),
                            size: 25,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBookmarked ? 'Saved'.tr : 'Save'.tr,
                            style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 15),
                  // ─── Views (Eye) ──────────────────────────────────────────
                  InkWell(onTap: widget.onPressedReelsEye, child: Image.asset('assets/icon/create_post/eye_tracking.png', height: 20, width: 20)),
                  const SizedBox(height: 10),
                  // ─── More Options ─────────────────────────────────────────
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () => _showMoreOptionsSheet(context),
                  ),
                ],
              )),

          // ─── Reaction Picker Overlay ──────────────────────────────────────
          if (_showReactionPicker)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _safeSetState(() => _showReactionPicker = false),
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 160),
                    child: _buildReactionPicker(),
                  ),
                ),
              ),
            ),

          // ─── Double-Tap Heart Animation ───────────────────────────────────
          if (_showDoubleTapHeart)
            Positioned(
              left: _doubleTapPosition.dx - 40,
              top: _doubleTapPosition.dy - 40,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                onEnd: () => _safeSetState(() => _showDoubleTapHeart = false),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value < 0.7 ? 1.0 : (1.0 - value) / 0.3,
                    child: Transform.scale(
                      scale: 0.5 + value * 0.5,
                      child: const Icon(Icons.favorite, color: Colors.red, size: 80),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════ Reaction Picker ═══════════════════════════════════

  Widget _buildReactionPicker() {
    final reactions = [
      {'type': 'like', 'asset': AppAssets.LIKE_ICON},
      {'type': 'love', 'asset': AppAssets.LOVE_ICON},
      {'type': 'haha', 'asset': AppAssets.HAHA_ICON},
      {'type': 'wow', 'asset': AppAssets.WOW_ICON},
      {'type': 'sad', 'asset': AppAssets.SAD_ICON},
      {'type': 'angry', 'asset': AppAssets.ANGRY_ICON},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((r) {
          return GestureDetector(
            onTap: () {
              _safeSetState(() => _showReactionPicker = false);
              widget.onPressedReaction(r['type'] as String);
              HapticFeedback.lightImpact();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Image.asset(r['asset'] as String, height: 36, width: 36),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════ More Options Sheet ════════════════════════════════

  void _showMoreOptionsSheet(BuildContext context) {
    final isAuthor = widget.loginCredentials.getUserData().id == widget.reelsModel.reel_user?.id;
    final reelId = widget.reelsModel.id ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 6),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // ─── Feedback Section ───────────────────────────────────
                if (!isAuthor) ...[
                  _moreOptionTile(
                    ctx, Icons.add_circle_outline, 'Interested'.tr,
                    subtitle: 'Show more like this'.tr,
                    onTap: () { Navigator.pop(ctx); reelsController.sendFeedback(reelId, 'interested'); },
                  ),
                  _moreOptionTile(
                    ctx, Icons.remove_circle_outline, 'Not interested'.tr,
                    subtitle: 'Show less like this'.tr,
                    onTap: () { Navigator.pop(ctx); reelsController.sendFeedback(reelId, 'not_interested'); },
                  ),
                  const Divider(height: 1),
                ],
                // ─── Actions Section ────────────────────────────────────
                Obx(() {
                  final isSaved = reelsController.bookmarkedReelIds.contains(reelId);
                  return _moreOptionTile(
                    ctx, isSaved ? Icons.bookmark : Icons.bookmark_border,
                    isSaved ? 'Unsave reel'.tr : 'Save reel'.tr,
                    onTap: () { Navigator.pop(ctx); reelsController.toggleBookmark(reelId); },
                  );
                }),
                _moreOptionTile(
                  ctx, Icons.collections_bookmark_outlined, 'View saved reels'.tr,
                  onTap: () { Navigator.pop(ctx); Get.toNamed(Routes.SAVED_REELS); },
                ),
                _moreOptionTile(
                  ctx, Icons.link, 'Copy link'.tr,
                  onTap: () {
                    Navigator.pop(ctx);
                    CopyToClipboardUtils.copyToClipboard(
                      '${ApiConstant.SERVER_IP}/reels?reels_id=$reelId', 'Link');
                  },
                ),
                if (isAuthor)
                  _moreOptionTile(
                    ctx, Icons.edit, 'Edit'.tr,
                    onTap: () { Navigator.pop(ctx); widget.onTapEditReel(); },
                  ),
                if (isAuthor)
                  _moreOptionTile(
                    ctx, Icons.delete_outline, 'Delete'.tr,
                    onTap: () { Navigator.pop(ctx); widget.onTapDelete(); },
                  ),
                if (!isAuthor) ...[
                  _moreOptionTile(
                    ctx, Icons.flag_outlined, 'Report'.tr,
                    onTap: () { Navigator.pop(ctx); widget.onPressedReport(); },
                  ),
                  _moreOptionTile(
                    ctx, Icons.visibility_off_outlined, 'Hide reel'.tr,
                    onTap: () { Navigator.pop(ctx); reelsController.hideReel(reelId); },
                  ),
                ],
                const Divider(height: 1),
                // ─── Playback Section ───────────────────────────────────
                _moreOptionTile(
                  ctx, Icons.speed, 'Playback speed'.tr,
                  trailing: Text(
                    '${_playbackSpeed}x',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  onTap: () { Navigator.pop(ctx); _showPlaybackSpeedSheet(context); },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _moreOptionTile(BuildContext ctx, IconData icon, String title, {
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  // ═══════════════════════ Playback Speed Sheet ═════════════════════════════

  void _showPlaybackSpeedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Playback speed'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ..._speedOptions.map((speed) => ListTile(
              leading: speed == _playbackSpeed
                  ? const Icon(Icons.check, color: Colors.blue)
                  : const SizedBox(width: 24),
              title: Text('${speed}x${speed == 1.0 ? " (Normal)" : ""}'),
              onTap: () {
                _safeSetState(() => _playbackSpeed = speed);
                activeVideoController?.setPlaybackSpeed(speed);
                Navigator.pop(ctx);
              },
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
