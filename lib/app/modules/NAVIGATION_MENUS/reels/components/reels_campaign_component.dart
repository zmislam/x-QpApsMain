import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../utils/url_utils.dart';
import '../../../../data/app_settings_data.dart';
import '../../../../models/app_settings_model.dart';
import '../../../../components/image.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../models/user.dart';
import '../controllers/reels_controller.dart';
import '../model/reels_campaign_model.dart';
import '../model/reels_comment_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../config/constants/color.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

class ReelsCampaignComponent extends StatefulWidget {
  final bool isLiked;
  //bool isVolumeOff;

  final CarouselController carouselController;
  final ReelsCampaignResults reelsCampaignModel;

  final VoidCallback onPressedLike;
  final VoidCallback onPressedViewReact;
  final VoidCallback onPressedShareReels;
  final VoidCallback onPressedViewProfile;
  final VoidCallback onPressedMessanger;
  final VoidCallback onPressedReelsEye;

  final VoidCallback onPressedComment;
  final VoidCallback onPressedReportReelsCampaign;
//  final Map<String , dynamic> data;
  const ReelsCampaignComponent({
    super.key,
    required this.carouselController,
    required this.isLiked,
    //required this.isVolumeOff,
    required this.reelsCampaignModel,
    required this.onPressedLike,
    required this.onPressedViewReact,
    required this.onPressedShareReels,
    required this.onPressedComment,
    required this.onPressedReportReelsCampaign,
    required this.onPressedMessanger,
    required this.onPressedViewProfile,
    required this.onPressedReelsEye,
    //  required this.data,
  });

  @override
  State<ReelsCampaignComponent> createState() => _ReelsCampaignComponentState();
}

class _ReelsCampaignComponentState extends State<ReelsCampaignComponent> {
  ReelsController videoController = Get.find();
  late VideoPlayerController _controller;
  ReelsCommentModel? reelsCommentModel;
  // ReelsComment? commentModel;
  UserModel? userModel;

  TextEditingController commentController = TextEditingController();
  TextEditingController commentReplyController = TextEditingController();
  late final AppSettingsData appSettingsData;
  late AppSettingsModel appSettingsModel;

  @override
  void initState() {
    super.initState();
    appSettingsData = AppSettingsData();
    appSettingsModel = appSettingsData.getAppSettingsData();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        '${ApiConstant.SERVER_IP_PORT}/uploads/adsStorage/${widget.reelsCampaignModel.video}'))
      ..initialize().then((_) {
        setState(() {
          if (appSettingsData.getAppSettingsData().reelsSoundEnable == true) {
            _controller.setVolume(1); // Unmute
          } else {
            _controller.setVolume(0);
          }
        });
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Rx<bool> isPlaying = true.obs;

    return Stack(
      children: [
        Container(
          color: Colors.black,
          height: Get.height,
          width: Get.width,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Center(
                child: SizedBox(
                  // aspectRatio: _controller.value.aspectRatio,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              Center(
                child: IconButton(
                  onPressed: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                    isPlaying.value = !isPlaying.value;
                  },
                  icon: Obx(
                    () => isPlaying.value
                        ? const Icon(
                            Icons.pause,
                            size: 40,
                            color: Colors.transparent,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
          ),
        ),
        Positioned(
          bottom: 50,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: widget.onPressedViewProfile,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.PAGE_PROFILE,
                              arguments: widget.reelsCampaignModel.reelsCampaign
                                  ?.page?.pageUserName);
                        },
                        child: NetworkCircleAvatar(
                            imageUrl: (widget.reelsCampaignModel.reelsCampaign
                                        ?.page?.profilePic ??
                                    '')
                                .formatedProfileUrl),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.PAGE_PROFILE,
                                      arguments: widget.reelsCampaignModel
                                          .reelsCampaign?.page?.pageUserName);
                                },
                                child: Text(
                                  widget.reelsCampaignModel.reelsCampaign?.page
                                          ?.pageName?.capitalizeFirst ??
                                      '',
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.verified,
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  if (widget.reelsCampaignModel.reelsCampaign
                                          ?.page?.isFollowed ==
                                      false) {
                                    videoController.followPage(widget
                                            .reelsCampaignModel
                                            .reelsCampaign
                                            ?.page
                                            ?.id ??
                                        '');
                                  } else {
                                    videoController.unfollow(widget
                                            .reelsCampaignModel
                                            .reelsCampaign
                                            ?.page
                                            ?.id ??
                                        '');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    widget.reelsCampaignModel.reelsCampaign
                                                ?.page?.isFollowed ==
                                            false
                                        ? 'Follow'
                                        : 'Following',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: Get.width - 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ReadMoreText('${widget.reelsCampaignModel.description}'.tr,
                          // maxLines: 2,
                          trimExpandedText: '   See Less',
                          trimLength: 50,
                          trimLines: 2,
                          trimCollapsedText: 'See More',

                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              UriUtils.launchUrlInBrowser(widget
                                      .reelsCampaignModel
                                      .reelsCampaign
                                      ?.websiteUrl ??
                                  'https://google.com/');
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: PRIMARY_COLOR,
                              textStyle: TextStyle(fontSize: 16),
                            ),
                            child: Text(
                              widget.reelsCampaignModel.reelsCampaign
                                      ?.callToAction?.capitalizeFirst ??
                                  'Learn More',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text('Sponsored'.tr,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 20,
            bottom: 20,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      appSettingsModel.reelsSoundEnable =
                          !appSettingsModel.reelsSoundEnable;
                      appSettingsData.saveAppSettingsData(appSettingsModel);
                      if (appSettingsData
                              .getAppSettingsData()
                              .reelsSoundEnable ==
                          true) {
                        _controller.setVolume(1); // Unmute
                      } else {
                        _controller.setVolume(0);
                      }
                    });
                  },
                  icon: Icon(
                    appSettingsData.getAppSettingsData().reelsSoundEnable ==
                            true
                        ? Icons.volume_up
                        : Icons.volume_off,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: widget.onPressedLike,
                  icon: Icon(
                    Icons.thumb_up,
                    size: 30,
                    color: widget.isLiked == true ? Colors.blue : Colors.white,
                  ),
                ),
                Text('${widget.reelsCampaignModel.reactionCount}'.tr,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: widget.onPressedComment,
                  icon: const Icon(
                    Icons.mode_comment,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                Text('${(widget.reelsCampaignModel.commentCount ?? 0) + (widget.reelsCampaignModel.replyCount ?? 0)}'.tr,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 20),
                InkWell(
                    onTap: widget.onPressedShareReels,
                    child: Image.asset('assets/icon/create_post/share.png',
                        height: 30, width: 30, color: Colors.white)),
                const SizedBox(height: 20),
                InkWell(
                    onTap: widget.onPressedReelsEye,
                    child: Image.asset(
                      'assets/icon/create_post/eye_tracking.png',
                      height: 20,
                      width: 20,
                    )),
                const SizedBox(height: 20),
                InkWell(
                    onTap: widget.onPressedMessanger,
                    child: Image.asset('assets/icon/create_post/messenger.png',
                        height: 30, width: 30, color: Colors.white)),
                const SizedBox(height: 20),
                PopupMenuButton(
                    color: Colors.transparent,
                    offset: const Offset(-50, -100),
                    iconColor: Colors.white,
                    icon: const Icon(Icons.more_horiz),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                            value: 1,
                            // row has two child icon and text.
                            child: Text('Delete'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: widget.onPressedReportReelsCampaign,

                            value: 1,
                            // row has two child icon and text.
                            child: Text('Report'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]),
                Text(
                  '',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ))
      ],
    );
  }
}
