import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class AlbumsCard extends StatelessWidget {
  const AlbumsCard({super.key, required this.controller});
  final ProfileController controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Get.toNamed(Routes.PHOTOS_GALLERY);
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
