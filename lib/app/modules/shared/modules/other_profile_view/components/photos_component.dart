import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import 'other_albums_component.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../components/single_image.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';

class OtherPhotosComponent extends StatelessWidget {
  final OthersProfileController controller;
  const OtherPhotosComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          Text('Albums'.tr,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PRIMARY_COLOR),
          ),
          const SizedBox(height: 10),
          OtherAlbumsComponent(
            userName: controller.username??'',
          ),
          const SizedBox(height: 10),
          Text('All Photos'.tr,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PRIMARY_COLOR),
          ),
          Obx(
            () => GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.photoList.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Get.to(SingleImage(
                      imgURL: (
                          '${controller.photoList.value[index].media}').formatedPostUrl,
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: FadeInImage(
                      imageErrorBuilder: (context, error, stackTrace) {
                        return const Image(
                          fit: BoxFit.cover,
                          image: AssetImage(AppAssets.DEFAULT_IMAGE),
                        );
                      },
                      width: Get.width / 3,
                      height: 157,
                      fit: BoxFit.cover,
                      image: NetworkImage((
                          '${controller.photoList.value[index].media}').formatedPostUrl),
                      placeholder:
                          const AssetImage('assets/image/default_image.png'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
