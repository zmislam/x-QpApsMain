import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../components/simmar_loader.dart';
import '../../../components/single_image.dart';
import '../../../config/constants/app_assets.dart';
import '../controllers/global_search_controller.dart';

class PhotoSearch extends GetView<GlobalSearchController> {
  const PhotoSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoadingPhoto.value == true
        ? ShimmarLoadingView()
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.photoList.value.length,
            //controller.photoModel.value?.posts?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.7),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Get.to(() => SingleImage(
                        imgURL: ('${controller.photoList.value[index].media}')
                            .formatedPostUrl,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FadeInImage(
                    imageErrorBuilder: (context, error, stackTrace) {
                      return const Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          AppAssets.DEFAULT_IMAGE,
                        ),
                      );
                    },
                    width: Get.width / 3,
                    height: 157,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        ('${controller.photoList.value[index].media}')
                            .formatedPostUrl),
                    placeholder:
                        const AssetImage('assets/image/default_image.png'),
                  ),
                ),
              );
            },
          ));
  }

  Widget ShimmarLoadingView() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.7),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: Get.width / 3,
                  height: 157,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.9)),
                )),
          );
        });
  }
}
