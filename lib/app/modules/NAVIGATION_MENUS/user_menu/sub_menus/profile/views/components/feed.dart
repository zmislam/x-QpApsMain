import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/post/post_shimer_loader.dart';
import '../../../../../../../extension/string/string_image_path.dart';

import '../../../../../../../components/button.dart';
import '../../../../../../../components/comment/comment_component.dart';
import '../../../../../../../components/dropdown.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../data/post_local_data.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../../../../../../../utils/bottom_sheet.dart';
import '../../../../../../../utils/copy_to_clipboard_utils.dart';
import '../../../../../../../utils/post_utlis.dart';
import '../../../../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../../controllers/profile_controller.dart';

class FeedComponent extends StatelessWidget {
  const FeedComponent({super.key, required this.controller});
  final ProfileController controller;
  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';

    return SliverList(
      delegate: SliverChildListDelegate([
        // ====================== create post section ============
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 47.86,
                  width: 47.86,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        controller.profileModel.value?.profile_pic != null
                            ? (controller.profileModel.value!.profile_pic
                                    .toString())
                                .formatedProfileUrl
                            : 'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: controller.onTapCreatePost,
                child: Container(
                  height: 47.86,
                  width: Get.width - 140,
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey.withValues(
                          alpha: 0.1), //Color.fromARGB(135, 238, 238, 238),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "    What's on your mind, ${controller.userModel.first_name}?",
                    style: TextStyle(color: GREY_COLOR),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  height: 47.86,
                  width: 47.86,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                  child: IconButton(
                      onPressed: () {
                        controller.pickMediaFiles();
                      },
                      icon: const Image(
                          height: 25,
                          image: AssetImage(AppAssets.Gallery_ICON))),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 10,
          margin: const EdgeInsetsDirectional.only(bottom: 10),
          color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
        ),
        // ======================= Post filter section ===========
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Post Section'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                AppAssets.POST_FILTER_ICON,
                height: 18,
                width: 18,
                fit: BoxFit.cover,
              ),
            ),
            InkWell(
              onTap: () {
                controller.filterYear.value = '';
                controller.filterPostBy.value = '';
                controller.filterPrivacy.value = 'public';
                controller.filterTagBy.value = '';

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          scrollable: true,
                          insetPadding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          // backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          title: Row(
                            children: [
                              Text('Post Filters'.tr,
                                style: TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  color: PRIMARY_COLOR,
                                ),
                              )
                            ],
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text('Use filters to find posts on your timeline'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('This will not affect how others see your timeline'.tr,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 17,
                              ),
                              Text('Go to'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      )),
                              const SizedBox(
                                height: 10,
                              ),
                              PrimaryDropDownField(
                                  hint: 'Year',
                                  list: controller.postFilterYearList.value,
                                  onChanged: (changedValue) {
                                    controller.filterYear.value =
                                        changedValue ?? '';
                                  }),
                              const SizedBox(
                                height: 12,
                              ),
                              Text('Posted By'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      )),
                              const SizedBox(
                                height: 10,
                              ),
                              PrimaryDropDownField(
                                  hint: 'You',
                                  list: const ['You', 'Others'],
                                  onChanged: (changedValue) {
                                    controller.filterPostBy.value =
                                        changedValue ?? '';
                                  }),
                              const SizedBox(
                                height: 15,
                              ),
                              Text('Privacy'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      )),
                              const SizedBox(
                                height: 10,
                              ),
                              PrimaryDropDownField(
                                  hint: privacyList.last,
                                  list: privacyList,
                                  onChanged: (changedValue) {
                                    controller.filterPrivacy.value =
                                        getPostPrivacyValue(changedValue ?? '');
                                  }),
                              const SizedBox(
                                height: 15,
                              ),
                              Text('Tagged Post'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      )),
                              const SizedBox(
                                height: 10,
                              ),
                              PrimaryDropDownField(
                                  hint: 'All Posts',
                                  list: const [
                                    'All Posts',
                                    'Only show posts i am tagged in'
                                  ],
                                  onChanged: (changedValue) {
                                    controller.filterTagBy.value =
                                        changedValue == 'All Posts'
                                            ? 'false'
                                            : 'true';
                                  }),
                              const SizedBox(
                                height: 35,
                              ),
                              PrimaryButton(
                                onPressed: () {
                                  controller.getFilterPosts();
                                  Navigator.pop(context);
                                },
                                text: 'Filter'.tr,
                                horizontalPadding: 110,
                                verticalPadding: 15,
                              ),
                            ],
                          ));
                    });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text('Filters'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        // ========================= pin post section ==========================
        Obx(
          () => controller.pinnedPostList.value.isEmpty
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      margin:
                          const EdgeInsetsDirectional.symmetric(vertical: 10),
                      color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(
                            AppAssets.POST_PIN_ICON,
                            height: 18,
                            width: 18,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Pinned Post'.tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                      margin:
                          const EdgeInsetsDirectional.symmetric(vertical: 10),
                      color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.pinnedPostList.value.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, postIndex) {
                        PostModel model =
                            controller.pinnedPostList.value[postIndex];
                        return PostCard(
                          onTapBlockUser: () {},
                          onSixSeconds: () {},
                          index: postIndex,
                          model: model,
                          viewType: 'profile',
                          onTapPinPost: () {
                            controller.pinAndUnpinPost(
                                model.pinPost == true ? 0 : 1,
                                model.id.toString(),
                                postIndex);
                          },
                          onSelectReaction: (reaction) {
                            controller.reactOnPost(
                              postModel: model,
                              reaction: reaction,
                              index: postIndex,
                            );
                          },
                          onTapViewOtherProfile:
                              model.event_type == 'relationship'
                                  ? () {
                                      ProfileNavigator.navigateToProfile(
                                          username: model.lifeEventId?.toUserId
                                                  ?.username ??
                                              '',
                                          isFromReels: 'false');
                                    }
                                  : null,
                          onTapShareViewOtherProfile:
                              model.post_type == 'Shared'
                                  ? () {
                                      ProfileNavigator.navigateToProfile(
                                          username: model
                                                  .share_post_id
                                                  ?.lifeEventId
                                                  ?.toUserId
                                                  ?.username ??
                                              '',
                                          isFromReels: 'false');
                                    }
                                  : null,
                          onPressedComment: () {
                            Get.bottomSheet(
                              Obx(
                                () => CommentComponent(
                                  onCommentReplayEdit: (commentReplayModel) {},
                                  onCommentEdit: (commentModel) {},
                                  onCommentDelete: (commentModel) {
                                    controller.commentDelete(
                                        commentModel.id ?? '',
                                        commentModel.post_id ?? '',
                                        postIndex);
                                  },
                                  onCommentReplayDelete: (replyId, postId) {
                                    controller.replyDelete(
                                        replyId, postId, postIndex);
                                  },
                                  commentController:
                                      controller.commentController,
                                  postModel:
                                      controller.postList.value[postIndex],
                                  userModel: controller.userModel,
                                  onTapSendComment: () {
                                    controller.commentOnPost(postIndex, model);
                                  },
                                  onTapReplayComment: (
                                      {required commentReplay,
                                      required comment_id, required file}) {
                                    controller.commentReply(
                                      comment_id: comment_id,
                                      replies_comment_name: commentReplay,
                                      post_id: model.id ?? '',
                                      postIndex: postIndex,
                                      file: file,
                                    );
                                  },
                                  onSelectCommentReaction:
                                      (reaction, commentId) {
                                    controller.commentReaction(
                                      postIndex: postIndex,
                                      reaction_type: reaction,
                                      post_id: model.id ?? '',
                                      comment_id: commentId,
                                    );
                                  },
                                  onSelectCommentReplayReaction: (
                                    reaction,
                                    commentId,
                                    commentRepliesId,
                                  ) {
                                    controller.commentReplyReaction(
                                        postIndex,
                                        reaction,
                                        model.id ?? '',
                                        commentId,
                                        commentRepliesId);
                                  },
                                  onTapViewReactions: () {
                                    Get.toNamed(Routes.REACTIONS,
                                        arguments: model.id);
                                  },
                                ),
                              ),
                              // backgroundColor: Colors.white,
                              isScrollControlled: true,
                            );
                          },
                          onTapBodyViewMoreMedia: () {
                            Get.to(MultipleImageView(postModel: model));
                          },
                          onTapViewReactions: () {
                            Get.toNamed(Routes.REACTIONS, arguments: model.id);
                          },
                          onTapEditPost: () {
                            controller.onTapEditPost(model);
                          },
                          onPressedShare: () {
                            showDraggableScrollableBottomSheet(context,
                                child: ShareSheetWidget(
                                    userId: model.user_id?.id ?? '',
                                    campaignId: model.campaign_id?.id ?? '',
                                    postId: model.id));
                          },
                          onTapHidePost: () {
                            controller.hidePost(
                                1, model.id.toString(), postIndex);
                          },
                          onTapBookMardPost: () {
                            controller.bookmarkPost(model.id.toString(),
                                model.post_privacy.toString());
                          },
                          onTapCopyPost: () async {
                            CopyToClipboardUtils.copyToClipboard(
                                '${ApiConstant.SERVER_IP}/notification/${model.id}',
                                'Link');
                            Get.back();
                          },
                        );
                      },
                    )
                  ],
                ),
        ),
        // ======================= other post section ==========================
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => controller.isLoadingNewsFeed.value == true
              ? const SizedBox()
              : Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Others Post'.tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
        ),
        Obx(() => controller.isLoadingNewsFeed.value == true
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: PostShimerLoaderGeneral(),
              )
            : Container()),
        Container(
          height: 10,
          margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
          color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
        ),
        // ========================== other post list ==========================
        Obx(
          () => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.postList.value.length,
            itemBuilder: (BuildContext context, int postIndex) {
              PostModel model = controller.postList.value[postIndex];
              return PostCard(
                onTapBlockUser: () {
                  // controller.blockFriends(model.)
                },
                onSixSeconds: () {},
                index: postIndex,
                model: model,
                viewType: 'profile',
                onTapPinPost: () {
                  controller.pinAndUnpinPost(model.pinPost == true ? 0 : 1,
                      model.id.toString(), postIndex);
                },
                onSelectReaction: (reaction) {
                  controller.reactOnPost(
                    postModel: model,
                    reaction: reaction,
                    index: postIndex,
                  );
                },
                onTapViewOtherProfile: model.event_type == 'relationship'
                    ? () {
                        ProfileNavigator.navigateToProfile(
                            username:
                                model.lifeEventId?.toUserId?.username ?? '',
                            isFromReels: 'false');
                      }
                    : null,
                onTapShareViewOtherProfile: model.post_type == 'Shared'
                    ? () {
                        ProfileNavigator.navigateToProfile(
                            username: model.share_post_id?.lifeEventId?.toUserId
                                    ?.username ??
                                '',
                            isFromReels: 'false');
                      }
                    : null,
                onPressedComment: () {
                  Get.bottomSheet(
                    Obx(
                      () => CommentComponent(
                        onCommentEdit: (commentModel) async {
                          await Get.toNamed(Routes.EDIT_POST_COMMENT,
                              arguments: {
                                'post_comment': commentModel.comment_name,
                                'post_id': commentModel.post_id,
                                'comment_id': commentModel.id,
                                'comment_type': commentModel.comment_type,
                                'image_video': commentModel.image_or_video
                              });
                          controller.updatePostList(
                              commentModel.post_id ?? '', postIndex);
                        },
                        onCommentReplayEdit: (commentReplayModel) async {
                          await Get.toNamed(Routes.EDIT_REPLY_POST_COMMENT,
                              arguments: {
                                'reply_comment':
                                    commentReplayModel.replies_comment_name,
                                'replay_post_id': commentReplayModel.post_id,
                                'comment_replay_id': commentReplayModel.id,
                                'comment_type': commentReplayModel.comment_type,
                                'image_video': commentReplayModel.image_or_video,
                                'key': commentReplayModel.key,
                              });
                          controller.updatePostList(
                              commentReplayModel.post_id ?? '', postIndex);
                        },
                        onCommentDelete: (commentModel) {
                          controller.commentDelete(commentModel.id ?? '',
                              commentModel.post_id ?? '', postIndex);
                        },
                        onCommentReplayDelete: (replyId, postId) {
                          controller.replyDelete(replyId, postId, postIndex);
                        },
                        commentController: controller.commentController,
                        postModel: controller.postList.value[postIndex],
                        userModel: controller.userModel,
                        onTapSendComment: () {
                          controller.commentOnPost(postIndex, model);
                        },
                        onTapReplayComment: (
                            {required commentReplay, required comment_id, required file}) {
                          controller.commentReply(
                            comment_id: comment_id,
                            replies_comment_name: commentReplay,
                            post_id: model.id ?? '',
                            postIndex: postIndex,
                            file: file,
                          );
                        },
                        onSelectCommentReaction: (reaction, commentId) {
                          controller.commentReaction(
                            postIndex: postIndex,
                            reaction_type: reaction,
                            post_id: model.id ?? '',
                            comment_id: commentId,
                          );
                        },
                        onSelectCommentReplayReaction: (
                          reaction,
                          commentId,
                          commentRepliesId,
                        ) {
                          controller.commentReplyReaction(postIndex, reaction,
                              model.id ?? '', commentId, commentRepliesId);
                        },
                        onTapViewReactions: () {
                          Get.toNamed(Routes.REACTIONS, arguments: model.id);
                        },
                      ),
                    ),
                    // backgroundColor: Colors.white,
                    isScrollControlled: true,
                  );
                },
                onTapBodyViewMoreMedia: () {
                  Get.to(MultipleImageView(postModel: model));
                },
                onTapViewReactions: () {
                  Get.toNamed(Routes.REACTIONS, arguments: model.id);
                },
                onTapEditPost: () {
                  controller.onTapEditPost(model);
                },
                onPressedShare: () {
                  showDraggableScrollableBottomSheet(context,
                      child: ShareSheetWidget(
                          campaignId: model.campaign_id?.id ?? '',
                          userId: model.user_id?.id ?? '',
                          postId: model.id));
                },
                onTapHidePost: () {
                  controller.hidePost(1, model.id.toString(), postIndex);
                },
                onTapBookMardPost: () {
                  controller.bookmarkPost(
                      model.id.toString(), model.post_privacy.toString());
                },
                onTapCopyPost: () async {
                  CopyToClipboardUtils.copyToClipboard(
                      '$baseUrl${model.id}', 'Link');
                  Get.back();
                },
              );
            },
          ),
        ),
        Obx(() => controller.isLoadingNewsFeed.value == true
            ? const Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : Container())
      ]),
    );
  }
}
