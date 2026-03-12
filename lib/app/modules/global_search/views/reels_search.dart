import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../config/constants/app_assets.dart';
import '../../../routes/app_pages.dart';
import '../../../components/simmar_loader.dart';
import '../controllers/global_search_controller.dart';

class ReelsSearch extends GetView<GlobalSearchController> {
  const ReelsSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoadingReels.value == true
        ? ShimmarLoadingView()
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 10, right: 10),
            scrollDirection: Axis.vertical,
            itemCount: controller.reelsList.value.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 0.6,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 7.0, bottom: 0.0),
                child: SizedBox(
                    height: 250,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.OTHER_USER_VIDEO, arguments: {
                          'reelsID': controller.reelsList.value[index].id,
                          'username': ''
                        });
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 7, right: 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: FadeInImage(
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Image(
                                    height: 400,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      AppAssets.DEFAULT_IMAGE,
                                    ),
                                  );
                                },
                                // width: Get.width / 3,
                                height: 400,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    ('${controller.reelsList.value[index].video_thumbnail}')
                                        .formatedProfileReelUrl),
                                placeholder: const AssetImage(
                                    'assets/image/default_image.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 20,
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                children: [
                                  Text(
                                    ('${controller.reelsList.value[index].description}'),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  // const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        ('${controller.reelsList.value[index].viewCount}'),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
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
