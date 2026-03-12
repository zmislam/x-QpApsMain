import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../components/video_player/post/newsfeed_post_video_player.dart';
import '../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../../config/constants/app_assets.dart';
import 'upload_videos.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../../../components/simmar_loader.dart';
import '../../../../../../../../config/constants/color.dart';
import '../controllers/videos_gallery_controller.dart';
import '../model/video_model.dart';

class VideosGalleryView extends GetView<VideosGalleryController> {
  const VideosGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    VideoModel model = Get.put(VideoModel());
    controller.getVideos();
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('Videos'.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            width: Get.width,
            color: PRIMARY_COLOR,
            child: InkWell(
              onTap: () {
                Get.to(() => UploadVideos(
                      controller: controller,
                      videoModel: model,
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text('Add Videos'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.videoList.value.isEmpty &&
                      (controller.isLoadingUserVideo.value == true)
                  ? ShimmarLoadingView()
                  : controller.videoList.value.isEmpty
                      ?  Center(
                          child: Text('No videos available'.tr,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: controller.videoList.value.length,
                          itemBuilder: (context, index) {
                            VideoModel videoModel =
                                controller.videoList.value[index];
                            VideoPlayerController videoPlayerController =
                                VideoPlayerController.networkUrl(
                                    Uri.parse(videoModel.media ?? ''));
                            videoPlayerController.initialize();
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(NewsFeedPostVideoPlayer(
                                      postId: '',
                                      // isPostPreview: true,

                                      videoSrc: (videoModel.media ?? '')
                                          .formatedVideoUrl,
                                    ));
                                  },
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: videoModel
                                                            .videoThumbnail !=
                                                        null
                                                    ? NetworkImage((videoModel
                                                                .videoThumbnail ??
                                                            '')
                                                        .formatedThumbnailUrl)
                                                    : const AssetImage(AppAssets
                                                            .DEFAULT_IMAGE)
                                                        as ImageProvider,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 10,
                                  child: IconButton(
                                    icon: const Image(
                                        height: 22,
                                        width: 22,
                                        image: AssetImage(AppAssets.MORE)),
                                    onPressed: () {
                                      Get.bottomSheet(
                                        Container(
                                          height: 80,
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  showDeleteAlertDialogs(
                                                    context: context,
                                                    deletingItemType: 'Video',
                                                    onDelete: () {
                                                      controller.deletevideos(
                                                          videoModel.id ?? '', videoModel.key ?? '');

                                                      Get.back();
                                                    },
                                                    onCancel: () {
                                                      Get.back();
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Icon(
                                                              Icons.delete,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Text('Delete'.tr,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        )),
            ),
          ),
        ],
      ),
    );
  }
}

Widget ShimmarLoadingView() {
  return SizedBox(
    height: Get.height,
    child: GridView.builder(
        physics: const ScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.7),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // width: Get.width / 3,
                  // // height: 150,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  // color: Colors.grey.withValues(alpha:0.9)),
                )),
          );
        }),
  );
}
