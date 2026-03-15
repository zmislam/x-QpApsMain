import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/post/post_shimer_loader.dart';

import '../../../../../../shared/modules/post_comment_page/views/post_comment_page_view.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../../../../../../../utils/bottom_sheet.dart';
import '../../../../../../../utils/copy_to_clipboard_utils.dart';
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
        // ======================= post list section ==========================
        Obx(() => controller.isLoadingNewsFeed.value == true
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: PostShimerLoaderGeneral(),
              )
            : Container()),
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
