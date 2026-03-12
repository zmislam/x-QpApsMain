import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../component/other_cover_photos_view.dart';
import '../../component/other_media_gallery_view.dart';
import '../../component/other_profile_picture_view.dart';
import '../../others_album_gallery/controller/others_album_gallery_controller.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/album_model.dart';
import '../../../controller/other_profile_controller.dart';

class OtherPhotosGalleryView extends GetView<OthersProfileController> {
  const OtherPhotosGalleryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    OthersAlbumGalleryController othersAlbumGalleryController =
        Get.put(OthersAlbumGalleryController());
    othersAlbumGalleryController.username = controller.username ?? '';
    controller.getOtherAlbums();

    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Your Photos'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          leading: const BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          controller.view.value = 0;
                          controller.getOtherPhotos();
                          controller.buttonview.value = 'Photos';
                        },
                        child: Text('Photos of you'.tr,
                            style: TextStyle(
                                color: controller.view.value == 0
                                    ? PRIMARY_COLOR
                                    : Colors.black))),
                    TextButton(
                        onPressed: () {
                          controller.view.value = 1;
                          controller.getOtherAlbums();
                          controller.buttonview.value = 'Albums';
                        },
                        child: Text('Albums'.tr,
                            style: TextStyle(
                                color: controller.view.value == 1
                                    ? PRIMARY_COLOR
                                    : Colors.black))),
                  ],
                ),
              ),

              const Divider(),

              //-----------------------------------------PHOTOS OF YOU ---------------------------//
              Obx(
                () => Visibility(
                  visible: controller.view.value == 0,
                  child: Expanded(
                      child: GridView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.photoList.value.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 0.7),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Get.to(SingleImage(
                            imgURL:
                                ('${controller.photoList.value[index].media}')
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
                                ('${controller.photoList.value[index].media}')
                                    .formatedPostUrl),
                            placeholder: const AssetImage(
                                'assets/image/default_image.png'),
                          ),
                        ),
                      );
                    },
                  )),
                ),
              ),

              //------------------------------------------ALBUMS---------------------------------------//
              Obx(
                () => Visibility(
                  visible: controller.view.value == 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.getProfilePictures();
                          Get.to(() => OtherProfilePictureView(
                                controller: othersAlbumGalleryController,
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
                                    ('${controller.profileModel.value?.profile_pic}')
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
                          othersAlbumGalleryController.getCoverPhotos();
                          Get.to(() => OtherCoverPhotosView(
                                controller: othersAlbumGalleryController,
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
                                    ('${controller.profileModel.value?.cover_pic}')
                                        .formatedProfileUrl),
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
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(
                  () => controller.isLoadingUserPhoto.value == true
                      ? ShimmarLoadingView()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: GridView.builder(
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 0.7,
                              crossAxisSpacing: 7,
                            ),
                            itemCount: controller.albumsList.value.length,
                            itemBuilder: (context, index) {
                              AlbumModel albumModel =
                                  controller.albumsList.value[index];
                              return Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      othersAlbumGalleryController
                                          .getMediaPhotos(albumModel.id ?? '');
                                      Get.to(() => OtherMediaGalleryView(
                                            controller:
                                                othersAlbumGalleryController,
                                            albumModel: albumModel,
                                          ));
                                    },
                                    child: SizedBox(
                                      height: 130,
                                      width: 120,
                                      child: Column(
                                        children: [
                                          FadeInImage(
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return const Image(
                                                height: 100,
                                                width: 120,
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    AppAssets.DEFAULT_IMAGE),
                                              );
                                            },
                                            height: 100,
                                            width: 120,
                                            fit: BoxFit.cover,
                                            placeholder: const AssetImage(
                                                AppAssets.DEFAULT_IMAGE),
                                            image: NetworkImage(
                                                (albumModel.medias?.fileName ??
                                                        '')
                                                    .formatedPostUrl),
                                          ),
                                          Text(
                                            albumModel.title ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ));
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
