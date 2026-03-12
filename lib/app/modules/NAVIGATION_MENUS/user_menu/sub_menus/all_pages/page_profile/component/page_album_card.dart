import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/custom_cached_image_view.dart';
import '../controllers/page_profile_controller.dart';

import 'album_gallery_view.dart';
import 'page_photos_view.dart';

class PageAlbumCard extends StatelessWidget {
  const PageAlbumCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PageProfileController controller = Get.find();
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => const PhotosView());
          },
          child: SizedBox(
            height: 130,
            width: 120,
            child: Column(
              children: [
                CustomCachedNetworkImage(
                    height: 100,
                    width: 120,
                    imageUrl: ((controller.pageProfileModel.value?.pageDetails
                                ?.profilePic ??
                            '')
                        .formatedProfileUrl)),
                Text('Photos'.tr,
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
            Get.to(() => const AlbumGalleryView());
          },
          child: SizedBox(
            height: 130,
            width: 120,
            child: Column(
              children: [
                CustomCachedNetworkImage(
                    height: 100,
                    width: 120,
                    imageUrl: ((controller.pageProfileModel.value?.pageDetails
                                ?.coverPic ??
                            '')
                        .formatedProfileUrl)),
                Text('Albums'.tr,
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
