import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/video_player/live/details_live_video_player.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../components/live_stream/live_stream_comment.dart';
import '../../../models/live/live_stream_view_model.dart';
import '../../../models/post.dart';
import '../../../routes/profile_navigator.dart';
import '../controllers/audience_live_stream_preview_controller.dart';
import '../widgets/audience_live_bottom_widget.dart';
import '../widgets/audience_live_top_widget.dart';

class AudienceLiveStreamPreviewView
    extends GetView<AudienceLiveStreamPreviewController> {
    AudienceLiveStreamPreviewView({super.key});

  int getLiveViewCount({
    required LiveStreamViewModel liveStreamModel,
    required PostModel postModel,
  }) {
    if (liveStreamModel.postId == postModel.id) {
      return (liveStreamModel.viewers ?? []).length;
    } else {
      return postModel.view_count ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SafeArea(
      top: true,
      child: Obx(
        () => controller.isLiveEnd.value
            ?   Scaffold(
                backgroundColor: Colors.black,
                resizeToAvoidBottomInset: false,
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.symmetric(horizontal: 32),
                        child: Text('No Live Available'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.black,
                extendBody: true,
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    // ============================== Full-screen video player =================
                    SizedBox(
                      height: size.height,
                      width: size.width,
                      child: DetailsLiveVideoPlayer(
                        hasLive:
                            (controller.postModel.value?.post_type == 'live') &&
                                (controller.postModel.value?.is_live == true),
                        videoSrc: ((controller.postModel.value?.post_type ==
                                    'live') &&
                                (controller.postModel.value?.is_live == true))
                            ? (
                                controller.postModel.value?.url ?? '').formatedLiveStreamViewUrl
                            : (controller
                                    .postModel.value?.media?.first.media ??
                                '').formatedVideoUrl,
                      ),
                    ),

                    // =========================== Top section ==========================
                    Positioned(
                      top: 20,
                      left: 12,
                      right: 12,
                      child: Obx(
                        () => AudienceLiveTopWidget(
                          onTapProfileView: () {
                            ProfileNavigator.navigateToProfile(
                                username: controller
                                        .postModel.value?.user_id?.username ??
                                    '',
                                isFromReels: 'false');
                          },
                          hasFollow: controller.isFollow.value,
                          reactionCount: controller.reactionCount.value,
                          currentUser: controller.postModel.value?.user_id,
                          joinUserCount: getLiveViewCount(
                            liveStreamModel:
                                controller.liveStreamViewer.value ??
                                    LiveStreamViewModel(),
                            postModel:
                                controller.postModel.value ?? PostModel(),
                          ),
                          onLiveEnd: () {
                            Get.back();
                          },
                          onTapFollow: () {
                            controller.followUserInLiveStream();
                          },
                        ),
                      ),
                    ),

                    // =========================== Animated reactions ==========================
                    ...controller.reactions.value,

                    // =========================== Live stream comment section =================
                    Positioned(
                      bottom:
                          200, // Adjust this value to avoid overlap with the bottom widget
                      left: 0,
                      right: 0,
                      child: Obx(() {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (controller.scrollController.hasClients) {
                            // Scroll to the end when new items are added
                            controller.scrollController.animateTo(
                              controller
                                  .scrollController.position.minScrollExtent,
                              duration:   Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                        return SizedBox(
                          height: 200, // Adjust height as needed
                          child: controller.liveCommentList.value.isEmpty
                              ? ListView(
                                  physics:   NeverScrollableScrollPhysics(),
                                  children:   [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          top: 320,
                                          bottom: 12),
                                      child: Text('Comment will start from here...'.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                )
                              : LiveStreamComment(
                                  scrollController: controller.scrollController,
                                  commentList: controller.liveCommentList.value,
                                ),
                        );
                      }),
                    ),

                    // ========================= Live bottom action section =================
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: AudienceLiveBottomWidget(
                        postModel: controller.postModel.value,
                        onMessaegeTap: () {},
                        onShareTap: () {},
                        onSendComment: () => controller.sendLiveStreamComment(),
                        onSelectReaction: (reaction) {
                          controller.reactOnPost(
                              reaction: reaction,
                              postModel:
                                  controller.postModel.value ?? PostModel());
                        },
                        textEditingController: controller.commentController,
                        focusNode: controller.commentFocusNode,
                        shareCount: '0',
                        onFieldSubmitted: (value) {
                          controller.sendLiveStreamComment();
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
