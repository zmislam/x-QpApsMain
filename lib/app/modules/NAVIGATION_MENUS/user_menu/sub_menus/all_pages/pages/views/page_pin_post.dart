import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../shared/modules/post_comment_page/views/post_comment_page_view.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../../components/post/post_shimer_loader.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../../../../../../../utils/bottom_sheet.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../../../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../../page_profile/controllers/page_profile_controller.dart';

class PagePinPostCard extends StatelessWidget {
  const PagePinPostCard({super.key, required this.controller});

  final PageProfileController controller;

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 10,
          color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
        ),
        const SizedBox(
          height: 10,
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 10,
          color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.pinnedPostList.value.length,
            itemBuilder: (BuildContext context, int postIndex) {
              PostModel model = controller.pinnedPostList.value[postIndex];
              return controller.isLoadingNewsFeed.value == true
                  ? const PostShimerLoader()
                  : PostCard(
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
                          key: model.key ?? '',
                        );
                      },
                      onTapViewOtherProfile: model.event_type == 'relationship'
                          ? () {
                              ProfileNavigator.navigateToProfile(
                                  username:
                                      model.lifeEventId?.toUserId?.username ??
                                          '',
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
                      onTapEditPost: () {
                        Get.back();
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
                      onTapBookMardPost: () {
                        controller.bookmarkPost(
                            model.id.toString(), model.post_privacy.toString());
                      },
                      onTapCopyPost: () async {
                        await Clipboard.setData(
                            ClipboardData(text: '$baseUrl${model.id}'.tr));
                        Get.back();
                        showSuccessSnackkbar(
                            message: 'Your link copied to clipboard');
                      },
                    );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Others Post'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        Obx(() => controller.isLoadingNewsFeed.value == true
            ? const PostShimerLoader()
            : Container())
      ],
    );
  }
}
