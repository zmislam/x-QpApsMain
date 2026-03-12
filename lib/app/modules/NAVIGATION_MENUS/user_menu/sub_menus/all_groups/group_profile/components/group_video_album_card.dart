import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../routes/app_pages.dart';
import '../controllers/group_profile_controller.dart';

class GroupVideoAlbumsCard extends StatelessWidget {
  const GroupVideoAlbumsCard({super.key, required this.controller});
  final GroupProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Photos Card
          Expanded(
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.GROUP_PHOTOS_GALLERY,
                    arguments: controller.allGroupModel);
              },
              child: SizedBox(
                height: 120,
                width: 120,
                child: Column(
                  children: [
                    controller.photoList.value.isNotEmpty
                        ? Image.network(
                            height: 80,
                            width: 120,
                            (
                                controller.photoList.value.last.media ?? '').formatedPostUrl,
                            fit: BoxFit.cover,
                          )
                        : const Image(
                            fit: BoxFit.cover,
                            image: AssetImage(AppAssets.DEFAULT_IMAGE),
                          ),
                    const SizedBox(height: 4),
                    Text('Photos'.tr,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Albums Card
          Expanded(
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.GROUP_ALBUMS_GALLERY,
                    arguments: controller.allGroupModel);
              },
              child: SizedBox(
               height: 120,
               width: 120,
               child: Column(
                 children: [
                   controller.groupProfileAlbumList.value.isNotEmpty
                       ? Image.network(
                           height: 80,
                           width: 120,
                           (
                               controller.groupProfileAlbumList.value.first.media ?? '').formatedPostUrl,
                           fit: BoxFit.cover,
                         )
                       : const Image(
                        height: 80,
                           width: 120,
                           fit: BoxFit.cover,
                           image: AssetImage(AppAssets.DEFAULT_IMAGE),
                         ),
                   const SizedBox(height: 4),
                   Text('Albums'.tr,
                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                   ),
                 ],
               ),
                          ),
            ),
          ),
          // Videos Card
          // InkWell(
          //   onTap: () {
          //     Get.toNamed(Routes.GROUP_VIDEOS_GALLERY,
          //         arguments: controller.allGroupModel);
          //   },
          //   child: const SizedBox(
          //     height: 120,
          //     width: 120,
          //     child: Column(
          //       children: [
          //         Image(
          //           fit: BoxFit.cover,
          //           image: AssetImage(AppAssets.DEFAULT_IMAGE),
          //         ),
          //         SizedBox(height: 4),
          //         Text(
          //           'Videos',
          //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        
        ],
      ),
    );
  }
}
