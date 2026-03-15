import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/share/share_sheet_widget.dart';
import '../../../../../routes/profile_navigator.dart';
import '../../../../../utils/bottom_sheet.dart';
import '../../multiple_image/views/multiple_image_view.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../config/constants/color.dart';
import '../../post_comment_page/views/post_comment_page_view.dart';
import '../../../../../components/post/post.dart';
import '../../../../../models/post.dart';
import '../../../../../routes/app_pages.dart';

class OtherFeedComponent extends StatelessWidget {
  final OthersProfileController controller;
  const OtherFeedComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    Get.to(
                      () => PostCommentPageView(
                        postId: postModel.id ?? '',
                        initialPostModel: postModel,
                      ),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 250),
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
          Obx(() => controller.isLoadingNewsFeed.value
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: PRIMARY_COLOR,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      );
  }
}
