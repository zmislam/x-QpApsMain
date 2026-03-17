import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';

import '../../../../../../shared/modules/post_comment_page/views/post_comment_page_view.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../../components/post/post_shimer_loader.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
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

    return Obx(() {
      if (controller.isLoadingNewsFeed.value &&
          controller.postList.value.isEmpty) {
        return SliverToBoxAdapter(child: PostShimerLoaderGeneral());
      }

      // Pinned posts + Feed posts
      final List<Widget> items = [];

      // Pinned posts
      if (controller.pinnedPostList.value.isNotEmpty) {
        items.add(AdminPagePinPostCard(controller: controller));
      }

      if (controller.postList.value.isEmpty) {
        items.add(
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No Posts Found'.tr,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // First render pinned posts if present
            if (controller.pinnedPostList.value.isNotEmpty && index == 0) {
              return AdminPagePinPostCard(controller: controller);
            }

            final postIndex = controller.pinnedPostList.value.isNotEmpty
                ? index - 1
                : index;

            if (postIndex < 0 ||
                postIndex >= controller.postList.value.length) {
              return const SizedBox.shrink();
            }

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
                          username: model.share_post_id?.lifeEventId
                                  ?.toUserId?.username ??
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
                controller.videoAdList.value.elementAtOrNull(postIndex) != null
                    ? UriUtils.launchUrlInBrowser(controller
                            .videoAdList
                            .value[controller.currentAdIndex.value]
                            .websiteUrl ??
                        '')
                    : null;
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
          childCount: controller.postList.value.length +
              (controller.pinnedPostList.value.isNotEmpty ? 1 : 0),
        ),
      );
    });
  }
}
