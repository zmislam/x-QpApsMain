import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../shared/modules/post_comment_page/views/post_comment_page_view.dart';
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
