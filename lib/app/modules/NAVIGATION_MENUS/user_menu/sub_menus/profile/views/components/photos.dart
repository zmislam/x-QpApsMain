import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../controllers/profile_controller.dart';

class PhotosComponent extends StatelessWidget {
  const PhotosComponent({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding:
              EdgeInsetsDirectional.symmetric(vertical: 12, horizontal: 16),
          child: Text('My Photos'.tr,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: PRIMARY_COLOR),
          ),
        ),
        // ========================= album card ==================
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => Flexible(
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.PHOTOS_GALLERY);
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Column(
                        children: [
                          controller.photoList.value.isNotEmpty
                              ? Image(
                                  height: 100,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    controller.photoList.value.first.media
                                            ?.formatedPostUrl ??
                                        '',
                                  ),
                                )
                              : const Image(
                                  height: 100,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  image: AssetImage(AppAssets.DEFAULT_IMAGE),
                                ),
                          Text('Photos'.tr,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Obx(
                () => Flexible(
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.ALBUMS_GALLERY);
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Column(
                        children: [
                          Image(
                            height: 100,
                            width: 120,
                            fit: BoxFit.cover,
                            image:
                                controller.profilePicturesList.value.isNotEmpty
                                    ? NetworkImage(
                                        controller.profilePicturesList.value
                                                .first.media?.formatedPostUrl ??
                                            '',
                                      )
                                    : const AssetImage(AppAssets.DEFAULT_IMAGE)
                                        as ImageProvider,
                          ),
                          Text('Albums'.tr,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Obx(
                () => Flexible(
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.VIDEOS_GALLERY);
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Column(
                        children: [
                          Image(
                              height: 100,
                              width: 120,
                              fit: BoxFit.cover,
                              image: controller.videoList.value.isNotEmpty
                                  ? NetworkImage((controller
                                          .videoList
                                          .value
                                          .first
                                          .videoThumbnail
                                          ?.formatedThumbnailUrl ??
                                      ''))
                                  : const AssetImage(AppAssets.DEFAULT_IMAGE)),
                          Text('Video'.tr,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Text('All Photos'.tr,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PRIMARY_COLOR),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => controller.isLoadingUserPhoto.value == true &&
                  controller.isFetchingPhotos.value == false
              ? ShimmarLoadingView()
              : GridView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16, vertical: 0),
                  itemCount: controller.photoList.value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.7),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => SingleImage(
                              imgURL:
                                  ('${controller.photoList.value[index].media}')
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
                          placeholder: const AssetImage(
                              'assets/image/default_image.png'),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
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
                  child: Container(
                    width: Get.width / 3,
                    height: 157,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withValues(alpha: 0.9)),
                  )),
            );
          }),
    );
  }
}
