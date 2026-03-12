import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../controller/admin_page_controller.dart';

class AdminPageViewBanner extends StatelessWidget {
  final String banner;
  final String profilePic;

  final bool enableImageUpload;
  final Callback profileImageUpload;
  final Callback coverImageUpload;

  const AdminPageViewBanner({
    super.key,
    required this.banner,
    required this.profilePic,
    required this.enableImageUpload,
    required this.profileImageUpload,
    required this.coverImageUpload,
  });

  @override
  Widget build(BuildContext context) {
    AdminPageController adminPageController = Get.find();

    return SizedBox(
      height: 305,
      child: Stack(
        children: [
          Positioned(
            child: InkWell(
              onTap: () {
                Get.to(SingleImage(
                    imgURL: (adminPageController.pageProfileModel.value
                                ?.pageDetails?.coverPic ??
                            '')
                        .formatedProfileUrl));
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
                      height: 150,
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                // Get.toNamed(
                                //   Routes.PROFILE_IMAGE_SILDER,
                                //   arguments: {
                                //     'userId':
                                //         albumsGalleryController.userModel.id,
                                //     'type': 'coverPhotos'
                                //   },
                                // );

                                Get.to(SingleImage(
                                    imgURL: (adminPageController
                                                .pageProfileModel
                                                .value
                                                ?.pageDetails
                                                ?.coverPic ??
                                            '')
                                        .formatedProfileUrl));
                              },
                              child: Row(
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
            left: 15,
            bottom: 0,
            child: Stack(
              children: [
                // CircleAvatar(
                //   radius: 30,
                //   child: Container(
                //     height: 156,
                //     width: 156,
                //     color: Colors.black,
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    Get.to(SingleImage(
                        imgURL: (adminPageController.pageProfileModel.value
                                    ?.pageDetails?.profilePic ??
                                '')
                            .formatedProfileUrl));
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
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 4,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
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
                      right: 5,
                      bottom: 10,
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
                              height: 150,
                              width: double.infinity,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        Get.to(SingleImage(
                                            imgURL: (adminPageController
                                                        .pageProfileModel
                                                        .value
                                                        ?.pageDetails
                                                        ?.profilePic ??
                                                    '')
                                                .formatedProfileUrl));
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
