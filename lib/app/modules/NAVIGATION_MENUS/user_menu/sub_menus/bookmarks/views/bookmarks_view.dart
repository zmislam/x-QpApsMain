import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/comment/comment_component.dart';
import '../../../../../../components/post/post.dart';
import '../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../models/post.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../routes/profile_navigator.dart';
import '../../../../../../utils/bottom_sheet.dart';
import '../../../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../../../../home/controllers/home_controller.dart';
import '../controllers/bookmarks_controller.dart';

class BookmarksView extends GetView<BookmarksController> {
  BookmarksView({Key? key}) : super(key: key);

  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Bookmarks Post'.tr,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: controller.postList.value.length,
            itemBuilder: (BuildContext context, int postIndex) {
              PostModel model = controller.postList.value[postIndex];

              return PostCard(
                onTapBlockUser: () {},
                onSixSeconds: () {},
                index: postIndex,
                viewType: 'bookmark',
                model: model,
                onSelectReaction: (reaction) {
                  controller.reactOnPost(
                    postModel: model,
                    reaction: reaction,
                    index: postIndex,
                    key: model.key ?? '',
                  );
                },
                onTapRemoveBookMardPost: () {
                  controller.removeBookmarkPost(
                      model.bookmark?.id ?? '', postIndex);
                  homeController.refreshEdgeRankFeed();
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
                                'comment_type': commentModel.comment_type
                              });
                          controller.updatePostList(
                              commentModel.post_id ?? '', postIndex);
                        },
                        onCommentReplayEdit: (commentReplayModel) async {
                          await Get.toNamed(Routes.EDIT_POST_COMMENT,
                              arguments: {
                                'reply_comment':
                                    commentReplayModel.replies_comment_name,
                                'replay_post_id': commentReplayModel.post_id,
                                'comment_replay_id':
                                    commentReplayModel.comment_id,
                                'comment_type': commentReplayModel.comment_type
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
                  // Get.back();
                  // controller.onTapEditPost(model);
                },
                onPressedShare: () {
                  showDraggableScrollableBottomSheet(context,
                      child: ShareSheetWidget(
                          report_id_key: 'post_id',
                          userId: model.user_id?.id ?? '',
                          postId: model.id));
                },
                onTapHidePost: () {
                  controller.hidePost(1, model.id.toString(), postIndex);
                },
              );
            },
          )),
    );
  }
}
