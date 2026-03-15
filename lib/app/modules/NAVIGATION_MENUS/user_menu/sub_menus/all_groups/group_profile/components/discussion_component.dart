import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/button.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../utils/url_utils.dart';

import '../../../../../../shared/modules/post_comment_page/views/post_comment_page_view.dart';
import '../../../../../../../components/custom_alert_dialog.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../../../../../../../utils/bottom_sheet.dart';
import '../../../../../../../utils/copy_to_clipboard_utils.dart';
import '../../../../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../controllers/group_profile_controller.dart';
import 'write_status_component.dart';

class GroupProfileDiscussionComponent extends StatelessWidget {
  final GroupProfileController controller;

  const GroupProfileDiscussionComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';

    // ! [controller.getGroupPosts()] this is called from init
    // ! Calling this here creates issue
    // controller.postList.value.clear();
    // controller.getGroupPosts();
    return SliverList(
      delegate: SliverChildListDelegate([
        GroupProfileWritePostComponent(
          controller: controller,
        ),
        Obx(
          () => controller.isLoadingNewsFeed.value == false &&
                  controller.postList.value.isEmpty
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: Text(
                      'No post to show'.tr,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(
                    controller.postList.value.length,
                    (postIndex) {
                      PostModel postModel =
                          controller.postList.value[postIndex];

                      return PostCard(
                        onTapBlockUser: () {
                          // controller.blockFriends(postModel.user_id?.id??'');
                          Get.dialog(
                            CustomAlertDialog(
                              icon: Icons.app_blocking,
                              title: 'Block User'.tr,
                              description:
                                  'Are you sure you want to block this user? The user won\'t be able to interact with you or see your profile',
                              cancelButtonText: 'Cancel',
                              confirmButtonText: 'Block',
                              onCancel: () {
                                Get.back();
                              },
                              onConfirm: () {
                                Get.back();
                                Get.back();
                                // Call the method to block the user
                                controller
                                    .blockFriends(postModel.user_id?.id ?? '');
                              },
                            ),
                          );
                        },
                        onSixSeconds: () {},
                        adVideoLink: controller.videoAdList.value
                                    .elementAtOrNull(postIndex) !=
                                null
                            ? (controller
                                        .videoAdList
                                        .value[controller.currentAdIndex.value]
                                        .campaignCoverPic?[0] ??
                                    '')
                                .formatedAdsUrl
                            : null,
                        campaignWebUrl: controller.videoAdList.value
                                    .elementAtOrNull(postIndex) !=
                                null
                            ? (controller
                                    .videoAdList
                                    .value[controller.currentAdIndex.value]
                                    .websiteUrl ??
                                '')
                            : null,
                        campaignName: controller.videoAdList.value
                                    .elementAtOrNull(postIndex) !=
                                null
                            ? (controller
                                    .videoAdList
                                    .value[controller.currentAdIndex.value]
                                    .campaignName
                                    ?.capitalizeFirst ??
                                '')
                            : null,
                        campaignDescription: controller.videoAdList.value
                                    .elementAtOrNull(postIndex) !=
                                null
                            ? (controller
                                    .videoAdList
                                    .value[controller.currentAdIndex.value]
                                    .description ??
                                '')
                            : null,
                        campaignCallToAction: () async {
                          controller.videoAdList.value
                                      .elementAtOrNull(postIndex) !=
                                  null
                              ? UriUtils.launchUrlInBrowser(
                                  (controller
                                          .videoAdList
                                          .value[
                                              controller.currentAdIndex.value]
                                          .websiteUrl ??
                                      ''),
                                )
                              : null;
                        },
                        model: postModel,
                        onSelectReaction: (reaction) {
                          controller.reactOnPost(
                            postModel: postModel,
                            reaction: reaction,
                            index: postIndex,
                            key: postModel.key ?? '',
                          );
                          debugPrint(reaction);
                        },
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
                          Get.toNamed(Routes.REACTIONS,
                              arguments: postModel.id);
                        },
                        onTapViewPostHistory: () {
                          Get.back();
                          Get.toNamed(Routes.EDIT_HISTORY,
                              arguments: postModel.id);
                        },
                        onTapEditPost: () {
                          Get.back();
                          controller.onTapEditPost(postModel);
                        },
                        onTapHidePost: () {
                          controller.hidePost(
                              1, postModel.id.toString(), postIndex);
                        },
                        onTapBookMardPost: () {
                          controller.bookmarkPost(postModel.id.toString(),
                              postModel.post_privacy.toString(), postIndex);
                        },
                        onTapRemoveBookMardPost: () {
                          controller.removeBookmarkPost(
                              postModel.bookmark?.id ?? '', postIndex);
                        },
                        onTapCopyPost: () async {
                          CopyToClipboardUtils.copyToClipboard(
                              '$baseUrl${postModel.id}', 'Post');
                          Get.back();
                        },
                        onTapViewOtherProfile:
                            postModel.event_type == 'relationship'
                                ? () {
                                    ProfileNavigator.navigateToProfile(
                                        username: postModel.lifeEventId
                                                ?.toUserId?.username ??
                                            '',
                                        isFromReels: 'false');
                                  }
                                : null,
                        onTapShareViewOtherProfile:
                            postModel.post_type == 'Shared'
                                ? () {
                                    ProfileNavigator.navigateToProfile(
                                        username: postModel
                                                .share_post_id
                                                ?.lifeEventId
                                                ?.toUserId
                                                ?.username ??
                                            '',
                                        isFromReels: 'false');
                                  }
                                : null,

                        /* ============Share Post BottoSheet ==========*/
                        onPressedShare: () {
                          String sharePostId = '';
                          if (postModel.share_post_id?.id == null) {
                            sharePostId = postModel.id ?? '';
                          } else {
                            sharePostId = postModel.share_post_id?.id ?? '';
                          }
                          showDraggableScrollableBottomSheet(context,
                              child: ShareSheetWidget(
                                  report_id_key: 'post_id',
                                  campaignId: postModel.campaign_id?.id ?? '',
                                  userId: postModel.user_id?.id ?? '',
                                  postId: sharePostId));
                        },
                      );
                    },
                  ),
                ),
        ),
        Obx(() => controller.isLoadingNewsFeed.value
            ? const GroupDiscussionComponentShimmerLoader()
            : const SizedBox())
      ]),
    );
  }
}

class GroupDiscussionComponentShimmerLoader extends StatelessWidget {
  const GroupDiscussionComponentShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  ShimmerLoader(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const CircleAvatar(
                        radius: 19,
                        backgroundColor: Color.fromARGB(255, 45, 185, 185),
                        child: CircleAvatar(
                          radius: 17,
                          backgroundImage:
                              AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoader(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border:
                                    Border.all(color: Colors.white, width: 0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              width: Get.width - 100,
                            ),
                            const SizedBox(height: 7),
                            Container(
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border:
                                    Border.all(color: Colors.white, width: 0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              width: Get.width / 2,
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ShimmerLoader(
              child: Container(
                width: double.maxFinite,
                height: 256,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.LIKE_ICON,
                    text: 'Like'.tr,
                    onPressed: () {},
                  ),
                ),
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.COMMENT_ACTION_ICON,
                    text: 'Comment'.tr,
                    onPressed: () {},
                  ),
                ),
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.SHARE_ACTION_ICON,
                    text: 'Share'.tr,
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
