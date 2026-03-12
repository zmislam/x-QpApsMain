import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../components/button.dart';
import '../../../../../components/image.dart';
import '../../../../../components/share/share_sheet_widget.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../data/post_local_data.dart';
import '../../../../../routes/profile_navigator.dart';
import '../../../../../utils/bottom_sheet.dart';
import '../../multiple_image/views/multiple_image_view.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../components/comment/comment_component.dart';
import '../../../../../components/post/post.dart';
import '../../../../../models/post.dart';
import '../../../../../routes/app_pages.dart';

class OtherFeedComponent extends StatelessWidget {
  final OthersProfileController controller;
  const OtherFeedComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: [
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.postList.value.length,
              itemBuilder: (context, postIndex) {
                PostModel postModel = controller.postList.value[postIndex];

                return PostCard(
                  onTapBlockUser: () {
                    controller.blockFriends(postModel.user_id?.id ?? '');
                  },
                  onSixSeconds: () {},
                  model: postModel,
                  onSelectReaction: (reaction) {
                    controller.reactOnPost(
                      postModel: postModel,
                      reaction: reaction,
                      index: postIndex,
                    );
                  },
                  onTapViewOtherProfile: postModel.event_type == 'relationship'
                      ? () {
                          ProfileNavigator.navigateToProfile(
                              username:
                                  postModel.lifeEventId?.toUserId?.username ??
                                      '',
                              isFromReels: 'false');
                        }
                      : null,
                  onTapShareViewOtherProfile: postModel.post_type == 'Shared'
                      ? () {
                          ProfileNavigator.navigateToProfile(
                              username: postModel.share_post_id?.lifeEventId
                                      ?.toUserId?.username ??
                                  '',
                              isFromReels: 'false');
                        }
                      : null,
                  onPressedComment: () {
                    Get.bottomSheet(
                      backgroundColor: Theme.of(context).cardTheme.color,
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
                                  'comment_type':
                                      commentReplayModel.comment_type,
                                  'image_video':
                                      commentReplayModel.image_or_video,
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
                          userModel: controller.currentUserModel,
                          onTapSendComment: () {
                            controller.commentOnPost(postIndex, postModel);
                          },
                          onTapReplayComment: (
                              {required commentReplay, required comment_id, required file}) {
                            controller.commentReply(
                              comment_id: comment_id,
                              replies_comment_name: commentReplay,
                              post_id: postModel.id ?? '',
                              postIndex: postIndex,
                              file: file,
                            );
                          },
                          onSelectCommentReaction: (reaction, commentId) {
                            controller.commentReaction(
                              postIndex: postIndex,
                              reaction_type: reaction,
                              post_id: postModel.id ?? '',
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
                                postModel.id ?? '',
                                commentId,
                                commentRepliesId);
                          },
                          onTapViewReactions: () {
                            Get.toNamed(Routes.REACTIONS,
                                arguments: postModel.id);
                          },
                        ),
                      ),
                      // backgroundColor: Colors.white,
                      isScrollControlled: true,
                    );
                  },
                  onTapBodyViewMoreMedia: () {
                    Get.to(MultipleImageView(postModel: postModel));
                  },
                  onTapViewReactions: () {
                    Get.toNamed(Routes.REACTIONS, arguments: postModel.id);
                  },
                  onPressedShare: () {
                    showDraggableScrollableBottomSheet(context,
                        child: ShareSheetWidget(
                            report_id_key: 'post_id',
                            userId: postModel.user_id?.id ?? '',
                            postId: postModel.id));

                    // Get.bottomSheet(
                    //   backgroundColor: Theme.of(context).cardTheme.color,
                    //   SingleChildScrollView(
                    //     child: Column(
                    //       children: [
                    //         const SizedBox(
                    //           height: 10,
                    //         ),
                    //         Container(
                    //           padding: const EdgeInsets.symmetric(
                    //               vertical: 10, horizontal: 10),
                    //           child: Row(
                    //             children: [
                    //               NetworkCircleAvatar(
                    //                   imageUrl: (LoginCredential()
                    //                               .getUserData()
                    //                               .profile_pic ??
                    //                           '')
                    //                       .formatedProfileUrl),
                    //               const SizedBox(
                    //                 width: 5,
                    //               ),
                    //               Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text('${LoginCredential().getUserData().first_name} ${LoginCredential().getUserData().last_name}'.tr,
                    //                     style: TextStyle(
                    //                         fontSize: 16,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                   Container(
                    //                     height: 25,
                    //                     width: Get.width / 4,
                    //                     decoration: BoxDecoration(
                    //                         border: Border.all(
                    //                             color: PRIMARY_COLOR, width: 1),
                    //                         borderRadius:
                    //                             BorderRadius.circular(5)),
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceEvenly,
                    //                       children: [
                    //                         Obx(
                    //                           () => controller.dropdownValue
                    //                                       .value ==
                    //                                   'Public'
                    //                               ? const Icon(
                    //                                   Icons.public,
                    //                                   color: PRIMARY_COLOR,
                    //                                   size: 15,
                    //                                 )
                    //                               : controller.dropdownValue
                    //                                           .value ==
                    //                                       'Friends'
                    //                                   ? const Icon(
                    //                                       Icons.group,
                    //                                       color: PRIMARY_COLOR,
                    //                                       size: 15,
                    //                                     )
                    //                                   : const Icon(
                    //                                       Icons.lock,
                    //                                       color: PRIMARY_COLOR,
                    //                                       size: 15,
                    //                                     ),
                    //                         ),
                    //                         Obx(() => DropdownButton<String>(
                    //                               value: controller
                    //                                   .dropdownValue.value,
                    //                               icon: const Icon(
                    //                                 Icons.arrow_drop_down,
                    //                                 color: PRIMARY_COLOR,
                    //                               ),
                    //                               elevation: 16,
                    //                               style: TextStyle(
                    //                                   color: PRIMARY_COLOR),
                    //                               underline: Container(
                    //                                 height: 2,
                    //                                 color: Colors.transparent,
                    //                               ),
                    //                               onChanged: (String? value) {
                    //                                 controller.dropdownValue
                    //                                     .value = value!;
                    //                                 controller.postPrivacy
                    //                                     .value = value;
                    //                               },
                    //                               items: privacyList.map<
                    //                                       DropdownMenuItem<
                    //                                           String>>(
                    //                                   (String value) {
                    //                                 return DropdownMenuItem<
                    //                                     String>(
                    //                                   value: value,
                    //                                   child: Text(
                    //                                     value,
                    //                                     style: TextStyle(
                    //                                         fontSize: 12,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .w400),
                    //                                   ),
                    //                                 );
                    //                               }).toList(),
                    //                             )),
                    //                       ],
                    //                     ),
                    //                   )
                    //                 ],
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 200,
                    //           child: TextField(
                    //             controller: controller.descriptionController,
                    //             maxLines: 10,
                    //             decoration: InputDecoration(
                    //               fillColor:
                    //                   Theme.of(context).scaffoldBackgroundColor,
                    //               filled: true,
                    //               border: InputBorder.none,
                    //               hintText: 'What’s on your mind ${controller.profileModel.value?.first_name ?? '.tr'}?',
                    //             ),
                    //             onChanged: (value) {
                    //               debugPrint(
                    //                   'Update model status code on chage.............${controller.descriptionController.text}');
                    //             },
                    //           ),
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.only(
                    //                   right: 8.0, top: 10),
                    //               child: SizedBox(
                    //                 height: 45,
                    //                 child: PrimaryButton(
                    //                   onPressed: () async {
                    //                     Get.back();
                    //                     await controller.shareUserPost(
                    //                         postModel.id.toString());
                    //                   },
                    //                   text: 'Share Now'.tr,
                    //                   fontSize: 14,
                    //                   verticalPadding: 10,
                    //                   horizontalPadding: 20,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //          Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             Padding(
                    //               padding: EdgeInsets.only(left: 15.0),
                    //               child: Text('Share to'.tr,
                    //                 style: TextStyle(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 20),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         const SizedBox(
                    //           height: 15,
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Image(
                    //               height: 30,
                    //               color: Theme.of(context).iconTheme.color,
                    //               image: const AssetImage(
                    //                   'assets/image/facebook-logo.png'),
                    //             ),
                    //             Image(
                    //               height: 30,
                    //               color: Theme.of(context).iconTheme.color,
                    //               image: const AssetImage(
                    //                   'assets/image/messenger-logo.png'),
                    //             ),
                    //             Image(
                    //               height: 30,
                    //               color: Theme.of(context).iconTheme.color,
                    //               image: const AssetImage(
                    //                   'assets/image/twitter-logo.png'),
                    //             ),
                    //             Image(
                    //               height: 30,
                    //               color: Theme.of(context).iconTheme.color,
                    //               image: const AssetImage(
                    //                   'assets/image/whatsapp-logo.png'),
                    //             ),
                    //           ],
                    //         ),
                    //         const SizedBox(
                    //           height: 50,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   // backgroundColor: Colors.white,
                    // );
                  },
                );
              },
            ),
          ),
          controller.isLoadingNewsFeed.value
              ? Container(
                  height: 40,
                  width: Get.width,
                  color: Colors.white,
                  child: Image.asset(
                    'assets/other/loading_profile.gif',
                    height: 40,
                    width: Get.width,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
