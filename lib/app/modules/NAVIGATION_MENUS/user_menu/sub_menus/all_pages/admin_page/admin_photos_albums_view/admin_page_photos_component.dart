import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import 'admin_album_card.dart';
import '../controller/admin_page_controller.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';

class AdminPagePhotosComponent extends StatelessWidget {
  const AdminPagePhotosComponent({super.key, required this.controller});

  final AdminPageController controller;

  @override
  Widget build(BuildContext context) {
    controller.getPagePhotos(
        controller.pageProfileModel.value?.pageDetails?.pageUserName ?? '');
    return SliverList(
        delegate: SliverChildListDelegate([
      Text('Page photos'.tr,
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 16, color: PRIMARY_COLOR),
      ),
      const SizedBox(height: 10),
      AdminAlbumCard(
        controller: controller,
      ),
      const SizedBox(height: 10),
      ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          Text('All Photos'.tr,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PRIMARY_COLOR),
          ),
          const SizedBox(height: 10),
          Obx(() => controller.isLoadingUserPhoto.value == true
              ? ShimmarLoadingView()
              : GridView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.pagePhotosList.value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.7),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => SingleImage(
                              imgURL:
                                  ('${controller.pagePhotosList.value[index].media}')
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
                              ('${controller.pagePhotosList.value[index].media}')
                                  .formatedPostUrl),
                          placeholder: const AssetImage(
                              'assets/image/default_image.png'),
                        ),
                      ),
                    );
                  },
                )),
        ],
      ),
    ]));
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
