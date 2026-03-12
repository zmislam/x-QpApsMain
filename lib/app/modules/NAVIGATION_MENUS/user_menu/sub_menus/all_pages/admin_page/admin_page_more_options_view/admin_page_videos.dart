import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/video_player/post/newsfeed_post_video_player.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../controller/admin_page_controller.dart';
import '../model/admin_page_video_model.dart';

class AdminPageVideosView extends StatelessWidget {
  const AdminPageVideosView({super.key, required this.controller});
  final AdminPageController controller;
  @override
  Widget build(BuildContext context) {
    // Fetch videos
    controller.getVideos(
        controller.pageProfileModel.value?.pageDetails?.pageUserName ?? '');

    return Obx(
      () {
        if (controller.isLoadingUserVideo.value) {
          return ShimmarLoadingView(); // Loading state
        }

        if (controller.pageVideoList.value.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text('No videos available'.tr,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ); // Empty state
        }

        // Main content
        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: controller.pageVideoList.value.length,
          itemBuilder: (context, index) {
            AdminPageVideoModel videoModel =
                controller.pageVideoList.value[index];

            return InkWell(
              onTap: () {
                Get.to(NewsFeedPostVideoPlayer(
                  postId: '',
                  // isPostPreview: true,
                  videoSrc: (videoModel.media ?? '').formatedVideoUrl,
                ));
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        (videoModel.videoThumbnail?.formatedThumbnailUrl ??
                            ''.formatedThumbnailUrl),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget ShimmarLoadingView() {
  return SliverGrid.builder(
    itemCount: 12,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 0.7,
    ),
    itemBuilder: (BuildContext context, index) {
      return ShimmerLoader(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    },
  );
}
