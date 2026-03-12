import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/post/post_shimer_loader.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../../../../../../../utils/bottom_sheet.dart';
import '../../../../../../../utils/copy_to_clipboard_utils.dart';
import '../../../../../../../utils/url_utils.dart';
import '../controllers/page_profile_controller.dart';
import '../../../../../../../components/comment/comment_component.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../shared/modules/multiple_image/views/multiple_image_view.dart';

class PageFeedComponent extends StatelessWidget {
  const PageFeedComponent({super.key, required this.controller});
  final PageProfileController controller;
  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';
  return Obx((){
    if (controller.isLoadingNewsFeed.value && controller.postList.value.isEmpty) {
      return SliverToBoxAdapter(child: PostShimerLoaderGeneral());
    }

    if (controller.postList.value.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(child: Text("No posts found")),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          PostModel model = controller.postList.value[index];
          return PostCard(
            onTapBlockUser: () {},
            onSixSeconds: () {},
            index: index,
            model: model,
            viewType: 'profile',
            onTapPinPost: () {
              controller.pinAndUnpinPost(model.pinPost == true ? 0 : 1,
                  model.id.toString(), index);
            },
            adVideoLink:
            controller.videoAdList.value.elementAtOrNull(index) !=
                null
                ? (controller
                .videoAdList
                .value[controller.currentAdIndex.value]
                .campaignCoverPic?[0] ??
                '')
                .formatedAdsUrl
                : null,
            campaignWebUrl:
            controller.videoAdList.value.elementAtOrNull(index) !=
                null
                ? (controller
                .videoAdList
                .value[controller.currentAdIndex.value]
                .websiteUrl ??
                '')
                : null,
            campaignName:
            controller.videoAdList.value.elementAtOrNull(index) !=
                null
                ? (controller
                .videoAdList
                .value[controller.currentAdIndex.value]
                .campaignName
                ?.capitalizeFirst ??
                '')
                : null,
            campaignDescription:
            controller.videoAdList.value.elementAtOrNull(index) !=
                null
                ? (controller
                .videoAdList
                .value[controller.currentAdIndex.value]
                .description ??
                '')
                : null,
            campaignCallToAction: () async {
              controller.videoAdList.value.elementAtOrNull(index) !=
                  null
                  ? UriUtils.launchUrlInBrowser(controller
                  .videoAdList
                  .value[controller.currentAdIndex.value]
                  .websiteUrl ??
                  '')
                  : null;
            },
            onSelectReaction: (reaction) {
              controller.reactOnPost(
                postModel: model,
                reaction: reaction,
                index: index,
                key: model.key ?? '',
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
                  username: model.share_post_id?.lifeEventId
                      ?.toUserId?.username ??
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
                          commentModel.post_id ?? '', index);
                    },
                    onCommentReplayEdit: (commentReplayModel) async {
                      await Get.toNamed(Routes.EDIT_REPLY_POST_COMMENT,
                          arguments: {
                            'reply_comment':
                            commentReplayModel.replies_comment_name,
                            'replay_post_id': commentReplayModel.post_id,
                            'comment_replay_id': commentReplayModel.id,
                            'comment_type':
                            commentReplayModel.comment_type,
                            'image_video':
                            commentReplayModel.image_or_video,
                            'key': commentReplayModel.key,
                          });
                      controller.updatePostList(
                          commentReplayModel.post_id ?? '', index);
                    },
                    onCommentDelete: (commentModel) {
                      controller.commentDelete(commentModel.id ?? '',
                          commentModel.post_id ?? '', index);
                    },
                    onCommentReplayDelete: (replyId, postId) {
                      controller.replyDelete(replyId, postId, index);
                    },
                    commentController: controller.commentController,
                    postModel: controller.postList.value[index],
                    userModel: controller.userModel,
                    onTapSendComment: () {
                      controller.commentOnPost(index, model);
                    },
                    onTapReplayComment: (
                        {required commentReplay, required comment_id, required String file}) {
                      controller.commentReply(
                          comment_id: comment_id,
                          replies_comment_name: commentReplay,
                          post_id: model.id ?? '',
                          postIndex: index,
                          file: file
                      );
                    },
                    onSelectCommentReaction: (reaction, commentId) {
                      controller.commentReaction(
                        postIndex: index,
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
                      controller.commentReplyReaction(index, reaction,
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
              Get.back();
              // controller.onTapEditPost(model);
            },
            onPressedShare: () {
              String sharePostId = '';
              if (model.share_post_id?.id == null) {
                sharePostId = model.id ?? '';
              } else {
                sharePostId = model.share_post_id?.id ?? '';
              }
              showDraggableScrollableBottomSheet(context,
                  child: ShareSheetWidget(
                      report_id_key: 'post_id',
                      campaignId: model.campaign_id?.id ?? '',
                      userId: model.user_id?.id ?? '',
                      postId: sharePostId));
            },
            onTapHidePost: () {
              // controller.hidePost(1, model.id.toString(), postIndex);
            },
            // onTapBookMardPost: () {
            //   // controller.bookmarkPost(
            //   //     model.id.toString(), model.post_privacy.toString());
            // },
            onTapCopyPost: () async {
              CopyToClipboardUtils.copyToClipboard(
                  '$baseUrl${model.id}', 'Link');
              Get.back();
            },
          );
        },
        childCount: controller.postList.value.length,
      ),
    );
  });
  }
}
// controller.postList.value.clear();
//     return SliverList(
//         delegate: SliverChildListDelegate(
//       [
//         //==================================================== Post ListView===========================================//1
//
//         Obx(() {
//           debugPrint('Page Feed No Post Triggered');
//           if (controller.isLoadingNewsFeed.value) {
//             return const PostShimerLoaderGeneral();
//           } else if (controller.postList.value.isEmpty) {
//             return Center(
//               child: Text('No posts found'.tr,
//                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               ),
//             );
//           } else {
//             return ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               // controller: controller.postScrollController,
//               shrinkWrap: true,
//               itemCount: controller.postList.value.length,
//               itemBuilder: (BuildContext context, int postIndex) {
//                 PostModel model = controller.postList.value[postIndex];
//                 return PostCard(
//                   onTapBlockUser: () {},
//                   onSixSeconds: () {},
//                   index: postIndex,
//                   model: model,
//                   viewType: 'profile',
//                   onTapPinPost: () {
//                     controller.pinAndUnpinPost(model.pinPost == true ? 0 : 1,
//                         model.id.toString(), postIndex);
//                   },
//                   adVideoLink:
//                       controller.videoAdList.value.elementAtOrNull(postIndex) !=
//                               null
//                           ? (controller
//                                       .videoAdList
//                                       .value[controller.currentAdIndex.value]
//                                       .campaignCoverPic?[0] ??
//                                   '')
//                               .formatedAdsUrl
//                           : null,
//                   campaignWebUrl:
//                       controller.videoAdList.value.elementAtOrNull(postIndex) !=
//                               null
//                           ? (controller
//                                   .videoAdList
//                                   .value[controller.currentAdIndex.value]
//                                   .websiteUrl ??
//                               '')
//                           : null,
//                   campaignName:
//                       controller.videoAdList.value.elementAtOrNull(postIndex) !=
//                               null
//                           ? (controller
//                                   .videoAdList
//                                   .value[controller.currentAdIndex.value]
//                                   .campaignName
//                                   ?.capitalizeFirst ??
//                               '')
//                           : null,
//                   campaignDescription:
//                       controller.videoAdList.value.elementAtOrNull(postIndex) !=
//                               null
//                           ? (controller
//                                   .videoAdList
//                                   .value[controller.currentAdIndex.value]
//                                   .description ??
//                               '')
//                           : null,
//                   campaignCallToAction: () async {
//                     controller.videoAdList.value.elementAtOrNull(postIndex) !=
//                             null
//                         ? UriUtils.launchUrlInBrowser(controller
//                                 .videoAdList
//                                 .value[controller.currentAdIndex.value]
//                                 .websiteUrl ??
//                             '')
//                         : null;
//                   },
//                   onSelectReaction: (reaction) {
//                     controller.reactOnPost(
//                       postModel: model,
//                       reaction: reaction,
//                       index: postIndex,
//                     );
//                   },
//                   onTapViewOtherProfile: model.event_type == 'relationship'
//                       ? () {
//                           ProfileNavigator.navigateToProfile(
//                               username:
//                                   model.lifeEventId?.toUserId?.username ?? '',
//                               isFromReels: 'false');
//                         }
//                       : null,
//                   onTapShareViewOtherProfile: model.post_type == 'Shared'
//                       ? () {
//                           ProfileNavigator.navigateToProfile(
//                               username: model.share_post_id?.lifeEventId
//                                       ?.toUserId?.username ??
//                                   '',
//                               isFromReels: 'false');
//                         }
//                       : null,
//                   onPressedComment: () {
//                     Get.bottomSheet(
//                       Obx(
//                         () => CommentComponent(
//                           onCommentEdit: (commentModel) async {
//                             await Get.toNamed(Routes.EDIT_POST_COMMENT,
//                                 arguments: {
//                                   'post_comment': commentModel.comment_name,
//                                   'post_id': commentModel.post_id,
//                                   'comment_id': commentModel.id,
//                                   'comment_type': commentModel.comment_type,
//                                   'image_video': commentModel.image_or_video
//                                 });
//                             controller.updatePostList(
//                                 commentModel.post_id ?? '', postIndex);
//                           },
//                           onCommentReplayEdit: (commentReplayModel) async {
//                             await Get.toNamed(Routes.EDIT_REPLY_POST_COMMENT,
//                                 arguments: {
//                                   'reply_comment':
//                                       commentReplayModel.replies_comment_name,
//                                   'replay_post_id': commentReplayModel.post_id,
//                                   'comment_replay_id': commentReplayModel.id,
//                                   'comment_type':
//                                       commentReplayModel.comment_type,
//                                   'image_video':
//                                       commentReplayModel.image_or_video
//                                 });
//                             controller.updatePostList(
//                                 commentReplayModel.post_id ?? '', postIndex);
//                           },
//                           onCommentDelete: (commentModel) {
//                             controller.commentDelete(commentModel.id ?? '',
//                                 commentModel.post_id ?? '', postIndex);
//                           },
//                           onCommentReplayDelete: (replyId, postId) {
//                             controller.replyDelete(replyId, postId, postIndex);
//                           },
//                           commentController: controller.commentController,
//                           postModel: controller.postList.value[postIndex],
//                           userModel: controller.userModel,
//                           onTapSendComment: () {
//                             controller.commentOnPost(postIndex, model);
//                           },
//                           onTapReplayComment: (
//                               {required commentReplay, required comment_id, required String file}) {
//                             controller.commentReply(
//                               comment_id: comment_id,
//                               replies_comment_name: commentReplay,
//                               post_id: model.id ?? '',
//                               postIndex: postIndex,
//                               file: file
//                             );
//                           },
//                           onSelectCommentReaction: (reaction, commentId) {
//                             controller.commentReaction(
//                               postIndex: postIndex,
//                               reaction_type: reaction,
//                               post_id: model.id ?? '',
//                               comment_id: commentId,
//                             );
//                           },
//                           onSelectCommentReplayReaction: (
//                             reaction,
//                             commentId,
//                             commentRepliesId,
//                           ) {
//                             controller.commentReplyReaction(postIndex, reaction,
//                                 model.id ?? '', commentId, commentRepliesId);
//                           },
//                           onTapViewReactions: () {
//                             Get.toNamed(Routes.REACTIONS, arguments: model.id);
//                           },
//                         ),
//                       ),
//                       // backgroundColor: Colors.white,
//                       isScrollControlled: true,
//                     );
//                   },
//                   onTapBodyViewMoreMedia: () {
//                     Get.to(MultipleImageView(postModel: model));
//                   },
//                   onTapViewReactions: () {
//                     Get.toNamed(Routes.REACTIONS, arguments: model.id);
//                   },
//                   onTapEditPost: () {
//                     Get.back();
//                     // controller.onTapEditPost(model);
//                   },
//                   onPressedShare: () {
//                     String sharePostId = '';
//                     if (model.share_post_id?.id == null) {
//                       sharePostId = model.id ?? '';
//                     } else {
//                       sharePostId = model.share_post_id?.id ?? '';
//                     }
//                     showDraggableScrollableBottomSheet(context,
//                         child: ShareSheetWidget(
//                             report_id_key: 'post_id',
//                             campaignId: model.campaign_id?.id ?? '',
//                             userId: model.user_id?.id ?? '',
//                             postId: sharePostId));
//                   },
//                   onTapHidePost: () {
//                     // controller.hidePost(1, model.id.toString(), postIndex);
//                   },
//                   // onTapBookMardPost: () {
//                   //   // controller.bookmarkPost(
//                   //   //     model.id.toString(), model.post_privacy.toString());
//                   // },
//                   onTapCopyPost: () async {
//                     CopyToClipboardUtils.copyToClipboard(
//                         '$baseUrl${model.id}', 'Link');
//                     Get.back();
//                   },
//                 );
//               },
//             );
//           }
//         }),
//         // Obx(
//         //   () {
//         //     print('Loading Build Triggered'); // Debugging
//         //     return controller.isLoadingNewsFeed.value
//         //         ? const PostShimerLoader()
//         //         : Container();
//         //   },
//         // ),
//       ],
//     ));
