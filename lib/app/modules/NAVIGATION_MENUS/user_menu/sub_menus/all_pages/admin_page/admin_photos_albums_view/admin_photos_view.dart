import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../components/custom_cached_image_view.dart';
import '../../../../../../../config/constants/app_assets.dart';
import 'admin_cover_photos_view.dart';
import 'admin_profile_picture_view.dart';
import '../controller/admin_page_controller.dart';
import '../model/admin_media_model.dart';
import '../../../../../../../config/constants/color.dart';

import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import 'admin_create_album_view.dart';
import 'admins_media_gallery_view.dart';

class AdminPhotosView extends StatelessWidget {
  const AdminPhotosView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdminPageController controller = Get.find();

    return SafeArea(
      child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              '${controller.pageProfileModel.value?.pageDetails?.pageName?.capitalizeFirst}\'s Photos',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
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
                            controller.albumTabIndex.value = 0;
                            controller.getPagePhotos(controller.pageProfileModel
                                    .value?.pageDetails?.pageUserName ??
                                '');
                            controller.buttonview.value = 'Photos of you';
                          },
                          child: Text('Photos of ${controller.pageProfileModel.value?.pageDetails?.pageName?.capitalizeFirst}'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: controller.buttonview.value ==
                                        'Photos of you'
                                    ? PRIMARY_COLOR
                                    : Colors.black,
                              ))),
                      TextButton(
                          onPressed: () {
                            controller.albumTabIndex.value = 1;
                            controller.getPageAlbums(controller
                                    .pageProfileModel.value?.pageDetails?.id ??
                                '');
                            controller.buttonview.value = 'Albums';
                          },
                          child: Text('Albums'.tr,
                              style: TextStyle(
                                  color: controller.buttonview.value == 'Albums'
                                      ? PRIMARY_COLOR
                                      : Colors.black))),
                    ],
                  ),
                ),

                const Divider(),

                //-----------------------------------------PHOTOS OF YOU ---------------------------//
                Obx(
                  () => Visibility(
                    visible: controller.buttonview.value == 'Photos of you' &&
                        controller.albumTabIndex.value == 0,
                    child: Expanded(
                        child: controller.isLoadingUserPhoto.value == true
                            ? ShimmarLoadingView()
                            : GridView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    controller.pagePhotosList.value.length,

                                //controller.photoModel.value?.posts?.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.7),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(SingleImage(
                                        imgURL:
                                            ('${controller.pagePhotosList.value[index].media}')
                                                .formatedPostUrl,
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: FadeInImage(
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
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
                                            ('${controller.pagePhotosList.value[index].media}')
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
                    visible: controller.buttonview.value == 'Albums',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => AdminCreateAlbumView(
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
                                      image:
                                          AssetImage(AppAssets.DEFAULT_IMAGE),
                                    );
                                  },
                                  image:
                                      const AssetImage(AppAssets.CREATE_ALBUM),
                                ),
                                Text('Albums'.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.getProfilePictures(controller
                                    .pageProfileModel.value?.pageDetails?.id ??
                                '');
                            Get.to(() => AdminProfilePictureView(
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
                                      image:
                                          AssetImage(AppAssets.DEFAULT_IMAGE),
                                    );
                                  },
                                  image: NetworkImage((controller
                                              .pageProfileModel
                                              .value
                                              ?.pageDetails
                                              ?.profilePic ??
                                          '')
                                      .formatedProfileUrl),
                                ),
                                Text('Profile pictures'.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await controller.getCoverPhotos(controller
                                    .pageProfileModel.value?.pageDetails?.id ??
                                '');
                            Get.to(() => AdminCoverPhotosView(
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
                                      image:
                                          AssetImage(AppAssets.DEFAULT_IMAGE),
                                    );
                                  },
                                  image: NetworkImage((controller
                                              .pageProfileModel
                                              .value
                                              ?.pageDetails
                                              ?.coverPic ??
                                          '')
                                      .formatedPostUrl),
                                ),
                                Text('Cover Photos'.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Obx(
                    () => Visibility(
                      visible: controller.buttonview.value == 'Albums',
                      child: controller.isLoadingAlbums.value == true &&
                              controller.buttonview.value == 'Albums'
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
                                itemCount:
                                    controller.mediaAlbumList.value.length,
                                itemBuilder: (context, index) {
                                  PageMediaModel pageMediaModel =
                                      controller.mediaAlbumList.value[index];
                                  return Stack(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            // controller.getPageAlbums(
                                            //     controller
                                            //             .pageProfileModel
                                            //             .value
                                            //             ?.pageDetails
                                            //             ?.id ??
                                            //         '');
                                            Get.to(() => AdminsMediaGalleryView(
                                                  pageMediaModel:
                                                      pageMediaModel,
                                                  controller: controller,
                                                ));
                                          },
                                          child: SizedBox(
                                            height: 130,
                                            width: 120,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                CustomCachedNetworkImage(
                                                    height: 100,
                                                    imageUrl: (pageMediaModel
                                                                .medias
                                                                ?.fileName ??
                                                            '')
                                                        .formatedPostUrl),

                                                const SizedBox(
                                                    height:
                                                        4), // Add some spacing
                                                Text(
                                                  pageMediaModel.title ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign
                                                      .center, // Center the text
                                                ),
                                              ],
                                            ),
                                          )),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: const Image(
                                              height: 22,
                                              width: 22,
                                              image:
                                                  AssetImage(AppAssets.MORE)),
                                          onPressed: () {
                                            Get.bottomSheet(
                                              Container(
                                                height: 100,
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        showDeleteAlertDialogs(
                                                          context: context,
                                                          deletingItemType:
                                                              'Album',
                                                          onDelete: () {
                                                            controller.deleteAlbum(
                                                                pageMediaModel
                                                                        .id ??
                                                                    '');

                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          onCancel: () {
                                                            Get.back();
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8),
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8),
                                                                  child: Text('Delete'.tr,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height,
      child: GridView.builder(
          physics: const ScrollPhysics(),
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.7),
          itemBuilder: (BuildContext context, index) {
            return ShimmerLoader(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width / 3,
                    height: 157,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withValues(alpha: 0.9)),
                  )),
            );
          }),
    );
  }
}
