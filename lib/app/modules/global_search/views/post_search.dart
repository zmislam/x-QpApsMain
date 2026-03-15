import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_search.dart';
import '../../shared/modules/post_comment_page/views/post_comment_page_view.dart';
import '../../../components/custom_alert_dialog.dart';
import '../../../components/post/post.dart';
import '../../../components/share/share_sheet_widget.dart';
import '../../../config/constants/api_constant.dart';
import '../../../models/post.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../utils/copy_to_clipboard_utils.dart';
import '../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../controllers/global_search_controller.dart';

class PostSearch extends GetWidget<GlobalSearchController> {
  const PostSearch({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';
    return Obx(
      () => controller.isLoadingFeed.value
          ? const AllSearchPostShimmerLoader()
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.postList.value.length,
              itemBuilder: (context, postIndex) {
                PostModel model = controller.postList.value[postIndex];
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
                          controller.blockFriends(model.user_id?.id ?? '');
                        },
                      ),
                    );
                  },
                  onSixSeconds: () {},
                  index: postIndex,
                  model: model,
                  viewType: 'home',
                  onTapPinPost: () {},
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
                  onTapEditPost: () {
                    Get.back();
                    controller.onTapEditPost(model);
                  },
                  onPressedShare: () {
                    showDraggableScrollableBottomSheet(context,
                        child: ShareSheetWidget(
                            report_id_key: 'post_id',
                            userId:
                                controller.loginCredential.getUserData().id ??
                                    '',
                            postId: model.id ?? ''));
                  },
                  onTapHidePost: () {
                    controller.hidePost(1, model.id.toString(), postIndex);
                  },
                  onTapBookMardPost: () {
                    controller.bookmarkPost(
                        model.id.toString(), model.post_privacy.toString());
                  },
                  onTapCopyPost: () async {
                    Get.back();

                    CopyToClipboardUtils.copyToClipboard(
                        '$baseUrl${model.id}', 'Link');
                  },
                );
              },
            ),
    );
  }
}
