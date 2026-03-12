import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/custom_cached_image_view.dart';
import 'admin_gallery_view.dart';
import '../controller/admin_page_controller.dart';
import 'admin_photos_view.dart';

class AdminAlbumCard extends StatelessWidget {
  const AdminAlbumCard({super.key, required this.controller});
  final AdminPageController controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.to(const AdminPhotosView());
          },
          child: SizedBox(
            height: 130,
            width: 120,
            child: Column(
              children: [
                CustomCachedNetworkImage(
                  onTapPic: (){},
                    height: 100,
                    width: 120,
                    imageUrl: ((controller
                            .pageProfileModel.value?.pageDetails?.profilePic ??
                        '').formatedProfileUrl)),
               
                Text(
                  overflow: TextOverflow.ellipsis,
                  'Photos',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () {
            Get.to(() => const AdminGalleryView());
          },
          child: SizedBox(
            height: 130,
            width: 120,
            child: Column(
              children: [
                CustomCachedNetworkImage(
                  onTapPic: (){},
                    height: 100,
                    width: 120,
                    imageUrl: ((controller
                            .pageProfileModel.value?.pageDetails?.coverPic ??
                        '').formatedProfileUrl)),
                Text('Albums'.tr,
                  overflow: TextOverflow.ellipsis,
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
