import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/other_videos_gallery/controller/other_video_gallery_controller.dart';
import '../views/other_videos_gallery/view/other_video_gallery_view.dart';
import '../../../../../routes/app_pages.dart';

import '../../../../../config/constants/app_assets.dart';

class OtherAlbumsComponent extends StatelessWidget {
  const OtherAlbumsComponent({super.key, required this.userName});
  final String userName;
  @override
  Widget build(BuildContext context) {
    Get.put(OtherVideoGalleryController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Get.toNamed(Routes.OTHER_PHOTOS_GALLERY);
          },
          child:  SizedBox(
            height: 120,
            width: 120,
            child: Column(
              children: [
                Image(
                    height: 100,
                    width: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(AppAssets.DEFAULT_IMAGE)),
                Text('Photos'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.toNamed(
              Routes.OTHER_ALBUMS_GALLERY,
              arguments: userName,
            );
          },
          child:  SizedBox(
            height: 120,
            width: 120,
            child: Column(
              children: [
                Image(
                    height: 100,
                    width: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(AppAssets.DEFAULT_IMAGE)),
                Text('Albums'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(() => const OtherVideoGalleryView());
          },
          child:  SizedBox(
            height: 120,
            width: 120,
            child: Column(
              children: [
                Image(
                    height: 100,
                    width: 120,
                    fit: BoxFit.cover,
                    image: AssetImage(AppAssets.DEFAULT_IMAGE)),
                Text('Video'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
