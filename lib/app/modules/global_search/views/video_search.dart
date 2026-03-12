import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../components/simmar_loader.dart';
import '../../../components/video_player/video_player.dart';
import '../controllers/global_search_controller.dart';

class VideoSearch extends GetView<GlobalSearchController> {
  const VideoSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoadingVideo.value == true
        ? ShimmarLoadingView()
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: controller.videoList.value.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: SizedBox(
                  height: 250,
                  child: VideoPlay(
                      videoLink: ('${controller.videoList.value[index].media}')
                          .formatedPostUrl),
                ),
              );
            },
          ));
  }

  Widget ShimmarLoadingView() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: Get.width,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.9)),
                )),
          );
        });
  }
}
