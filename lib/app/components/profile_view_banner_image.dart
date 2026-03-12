import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../config/constants/app_assets.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/albums_gallery/controllers/albums_gallery_controller.dart';
import 'single_image.dart';

class PrifileViewBannerImage extends StatelessWidget {
  final String banner;
  final String profilePic;

  final bool enableImageUpload;
  final Callback profileImageUpload;
  final Callback coverImageUpload;
  final VoidCallback removeCoverPhoto;
  final VoidCallback removeProfilePhoto;

  const PrifileViewBannerImage({
    super.key,
    required this.banner,
    required this.profilePic,
    required this.enableImageUpload,
    required this.profileImageUpload,
    required this.coverImageUpload,
    required this.removeCoverPhoto,
    required this.removeProfilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(AlbumsGalleryController());

    return SizedBox(
      height: 305,
      child: Stack(
        children: [
          Positioned(
            child: InkWell(
              onTap: () {
                Get.to(() => SingleImage(imgURL: banner));
              },
              child: Image.network(
                banner,
                width: Get.width,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Image(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      AppAssets.DEFAULT_IMAGE,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 30,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 180,
            right: 30,
            child: Visibility(
              visible: enableImageUpload,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () {
                    Get.bottomSheet(Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                Get.to(() => SingleImage(imgURL: banner));
                              },
                              child:  Row(
                                children: [
                                  Image(
                                      height: 25,
                                      width: 25,
                                      image: AssetImage(AppAssets.VIEW_PHOTO)),
                                  SizedBox(width: 8),
                                  Text('View Cover Photo'.tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextButton(
                              onPressed: () {
                                coverImageUpload();

                                Get.back();
                              },
                              child: Row(
                                children: [
                                  Image(
                                      height: 25,
                                      width: 25,
                                      image: AssetImage(AppAssets.UPLOAD_ICON)),
                                  SizedBox(width: 8),
                                  Text('Upload Cover Photo'.tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextButton(
                              onPressed: () {
                                removeCoverPhoto();
                                Get.back();
                              },
                              child: Row(
                                children: [
                                  Image(
                                      height: 25,
                                      width: 25,
                                      image: AssetImage(AppAssets.REMOVE_ICON)),
                                  SizedBox(width: 8),
                                  Text('Remove Photo'.tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: Get.width / 3.2,
            bottom: 5,
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => SingleImage(imgURL: profilePic));
                  },
                  child: Container(
                      height: 156,
                      width: 156,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              profilePic,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 4,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          width: double.maxFinite,
                          height: 256,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            profilePic,
                          ),
                          errorBuilder: (context, error, stackTrace) {
                            return const Image(
                              image: AssetImage(AppAssets.DEFAULT_IMAGE),
                            );
                          },
                        ),
                      )),
                ),
                Visibility(
                  visible: enableImageUpload,
                  child: Positioned(
                      right: 15,
                      bottom: 15,
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          onPressed: () {
                            Get.bottomSheet(Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();

                                        Get.to(() =>
                                            SingleImage(imgURL: profilePic));
                                      },
                                      child: Row(
                                        children: [
                                          Image(
                                              height: 25,
                                              width: 25,
                                              image: AssetImage(
                                                  AppAssets.VIEW_PHOTO)),
                                          SizedBox(width: 8),
                                          Text('View Profile Photo'.tr,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        profileImageUpload();
                                        Get.back();
                                      },
                                      child: Row(
                                        children: [
                                          Image(
                                              height: 25,
                                              width: 25,
                                              image: AssetImage(
                                                  AppAssets.UPLOAD_ICON)),
                                          SizedBox(width: 8),
                                          Text('Upload Profile Photo'.tr,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        removeProfilePhoto();
                                      },
                                      child:  Row(
                                        children: [
                                          Image(
                                              height: 25,
                                              width: 25,
                                              image: AssetImage(
                                                  AppAssets.REMOVE_ICON)),
                                          SizedBox(width: 8),
                                          Text('Remove Photo'.tr,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
