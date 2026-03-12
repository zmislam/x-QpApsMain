import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/post/post.dart';
import '../../../routes/app_pages.dart';
import '../controllers/notification_controller.dart';

class NotificationPost extends GetView<NotificationPostController> {
  const NotificationPost({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => controller.isLoadingNewsFeed.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : PostCard(
                        onTapBlockUser: () {
                          // controller.
                        },
                        onSixSeconds: () {},
                        model: controller.postList.value[0],
                        onSelectReaction: (reaction) {
                          controller.reactOnPost(
                            postModel: controller.postList.value[0],
                            reaction: reaction,
                            index: 0,
                            key: controller.postList.value[0].key ?? '',
                          );
                          debugPrint(reaction);
                        },
                        onPressedComment: () =>
                            controller.openCommentComponent(context),
                        onPressedShare: () {},
                        onTapBodyViewMoreMedia: () {},
                        onTapViewReactions: () {
                          Get.toNamed(
                            Routes.REACTIONS,
                            arguments: controller.postList.value[0].id,
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
