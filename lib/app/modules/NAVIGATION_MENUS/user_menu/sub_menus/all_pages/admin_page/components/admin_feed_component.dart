import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';

import '../../../../../../shared/modules/post_comment_page/views/post_comment_page_view.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../../components/post/post_shimer_loader.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../../../../../../../utils/bottom_sheet.dart';
import '../../../../../../../utils/copy_to_clipboard_utils.dart';
import '../../../../../../../utils/url_utils.dart';
import '../../../../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../controller/admin_page_controller.dart';
import '../view/admin_pin_post_card.dart';

class AdminFeedComponent extends StatelessWidget {
  const AdminFeedComponent({super.key, required this.controller});
  final AdminPageController controller;
  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';

    return SliverList(
        delegate: SliverChildListDelegate([
      // "What's on your mind" Row
      Row(
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
                  image: NetworkImage((controller.pageProfileModel.value
                                  ?.pageDetails?.profilePic ??
                              '')
                          .formatedProfileUrl
                      // controller.pageProfileModel.value?.pageDetails!
                      //             .profilePic !=
                      //         null
                      //     ? getFormatedProfileUrl(controller
                      //         .pageProfileModel.value!.pageDetails!.profilePic
                      //         .toString())
                      //     : 'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                      ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: controller.onTapPageCreatePost,
            child: Container(
              height: 40,
              width: Get.width - 140,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  color: Colors.grey.withValues(
                      alpha: 0.1), //Color.fromARGB(135, 238, 238, 238),
                  borderRadius: BorderRadius.circular(10)),
              child: Obx(
                () => Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "What's on your mind ${controller.pageProfileModel.value?.pageDetails?.pageName}?",
                  style: TextStyle(color: GREY_COLOR),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withValues(alpha: 0.1),
            ),
            child: IconButton(
                onPressed: () {
                  controller.onTapPageCreatePost();
                },
                icon: const Image(
                  image: AssetImage(AppAssets.Gallery_ICON),
                  height: 25,
                )),
          )
        ],
      ),

      const SizedBox(
        height: 10,
      ),
      const Divider(),
      Obx(
        () => controller.pinnedPostList.value.isNotEmpty
            ? AdminPagePinPostCard(
                controller: controller,
              )
            : Container(),
      ),

      //==================================================== Post ListView===========================================//1

      const SizedBox(
        height: 10,
      ),
      // Container(
      //   height: 10,
      //   color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha:0.3),
      // ),
      Obx(() {
        if (controller.postList.value.isEmpty &&
            controller.isLoadingNewsFeed.value == false) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('No Posts Found'.tr,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else if (controller.isLoadingNewsFeed.value) {
          return const PostShimerLoaderGeneral();
        } else {
          return ListView.builder(
            // controller: controller.postScrollController,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.postList.value.length,
            itemBuilder: (BuildContext context, int postIndex) {
              PostModel model = controller.postList.value[postIndex];
              return PostCard(
                onTapBlockUser: () {},
                onSixSeconds: () {},
                index: postIndex,
                model: model,
                viewType: 'PagePost',
                onTapPinPost: () {
                  controller.pinAndUnpinPost(model.pinPost == true ? 0 : 1,
                      model.id.toString(), postIndex);
                },
                onSelectReaction: (reaction) {
                  controller.reactOnPost(
                    postModel: model,
                    reaction: reaction,
                    index: postIndex,
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
                            username: model.share_post_id?.lifeEventId?.toUserId
                                    ?.username ??
                                '',
                            isFromReels: 'false');
                      }
                    : null,
                onPressedComment: () {
                  Get.to(
                    () => PostCommentPageView(
                      postId: model.id ?? '',
                      initialPostModel: model,
                    ),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 250),
                  );
                },
                onTapBodyViewMoreMedia: () {
                  Get.to(MultipleImageView(postModel: model));
                },
                onTapViewReactions: () {
                  Get.toNamed(Routes.REACTIONS, arguments: model.id);
                },
                onTapEditPost: () async {
                  Get.close(1);
                  await Get.toNamed(Routes.EDIT_POST, arguments: model);
                  controller.onTapEditPost(model);
                  Get.back();
                },
                onTapViewPostHistory: () {
                  Get.back();
                  Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
                },
                // onTapViewPostHistory: () {},
                adVideoLink:
                    controller.videoAdList.value.elementAtOrNull(postIndex) !=
                            null
                        ? (controller
                                    .videoAdList
                                    .value[controller.currentAdIndex.value]
                                    .campaignCoverPic?[0] ??
                                '')
                            .formatedAdsUrl
                        : null,
                campaignWebUrl:
                    controller.videoAdList.value.elementAtOrNull(postIndex) !=
                            null
                        ? (controller
                                .videoAdList
                                .value[controller.currentAdIndex.value]
                                .websiteUrl ??
                            '')
                        : null,
                campaignName:
                    controller.videoAdList.value.elementAtOrNull(postIndex) !=
                            null
                        ? (controller
                                .videoAdList
                                .value[controller.currentAdIndex.value]
                                .campaignName
                                ?.capitalizeFirst ??
                            '')
                        : null,
                campaignDescription:
                    controller.videoAdList.value.elementAtOrNull(postIndex) !=
                            null
                        ? (controller
                                .videoAdList
                                .value[controller.currentAdIndex.value]
                                .description ??
                            '')
                        : null,
                campaignCallToAction: () async {
                  // debugPrint(
                  // 'Campaign Name::::::${(controller.videoAdList.value[controller.currentAdIndex.value].campaignName?.capitalizeFirst ?? '')}');
                  controller.videoAdList.value.elementAtOrNull(postIndex) !=
                          null
                      ? UriUtils.launchUrlInBrowser(controller
                              .videoAdList
                              .value[controller.currentAdIndex.value]
                              .websiteUrl ??
                          '')
                      : null;
                  // await launchUrl(
                  //     Uri.parse(controller
                  //             .videoAdList
                  //             .value[controller.currentAdIndex.value]
                  //             .websiteUrl ??
                  //         ''),
                  //     mode: LaunchMode.externalApplication);
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
                onTapRemoveBookMardPost: () {
                  controller.removeBookmarkPost(model.id ?? '', postIndex);
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
          );
        }
      }),
    ]));
  }
}
