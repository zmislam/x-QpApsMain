import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../extension/string/string_image_path.dart';
import 'profile_photos_view.dart';
import '../controllers/albums_gallery_controller.dart';
import 'cover_photos_view.dart';
import '../../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../../components/simmar_loader.dart';
import 'create_album_view.dart';

class AlbumsGalleryView extends GetView<AlbumsGalleryController> {
  const AlbumsGalleryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Your Albums'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => CreateAlbumView(
                        controller: controller,
                      ));
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image(
                        height: 100,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Image(
                            height: 100,
                            width: 120,
                            fit: BoxFit.cover,
                            image: AssetImage(AppAssets.DEFAULT_IMAGE),
                          );
                        },
                        image: const AssetImage(AppAssets.CREATE_ALBUM),
                      ),
                      Text('Albums'.tr,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.getProfilePictures();
                  Get.to(() => ProfilePhotosView(
                        controller: controller,
                      ));
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image(
                        height: 100,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Image(
                            height: 100,
                            width: 120,
                            fit: BoxFit.cover,
                            image: AssetImage(AppAssets.DEFAULT_IMAGE),
                          );
                        },
                        image: NetworkImage(
                            (controller.userModel.profile_pic ?? '')
                                .formatedProfileUrl),
                      ),
                      Text('Profile pictures'.tr,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.getCoverPhotos();
                  Get.to(() => CoverPhotosView(
                        controller: controller,
                      ));
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image(
                        height: 100,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Image(
                            height: 100,
                            width: 120,
                            fit: BoxFit.cover,
                            image: AssetImage(AppAssets.DEFAULT_IMAGE),
                          );
                        },
                        image: NetworkImage(
                            (controller.userModel.cover_pic ?? '')
                              ..formatedProfileUrl),
                      ),
                      Text('Cover Photos'.tr,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

Widget ShimmarLoadingView() {
  return SizedBox(
    height: Get.height,
    child: GridView.builder(
        physics: const ScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.9)),
                )),
          );
        }),
  );
}
