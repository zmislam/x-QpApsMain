import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../config/constants/app_assets.dart';
import 'admin_cover_photos_view.dart';
import 'admins_media_gallery_view.dart';
import '../controller/admin_page_controller.dart';
import '../model/admin_media_model.dart';
import '../../../../../../../components/simmar_loader.dart';
import 'admin_create_album_view.dart';
import 'admin_profile_picture_view.dart';

class AdminGalleryView extends StatelessWidget {
  const AdminGalleryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdminPageController adminPageController = Get.find();
    adminPageController.getPageAlbums(
        adminPageController.pageProfileModel.value?.pageDetails?.id ?? '');
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          '${adminPageController.pageProfileModel.value?.pageDetails?.pageName?.capitalizeFirst}\'s Albums',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => AdminCreateAlbumView(
                          controller: adminPageController,
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
                    adminPageController.getProfilePictures(adminPageController
                            .pageProfileModel.value?.pageDetails?.id ??
                        '');
                    Get.to(() => AdminProfilePictureView(
                          controller: adminPageController,
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
                          image: NetworkImage((adminPageController
                                      .pageProfileModel
                                      .value
                                      ?.pageDetails
                                      ?.profilePic ??
                                  '')
                              .formatedProfileUrl),
                        ),
                        Text('Profile Pictures'.tr,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    adminPageController.getCoverPhotos(adminPageController
                            .pageProfileModel.value?.pageDetails?.id ??
                        '');
                    Get.to(() => AdminCoverPhotosView(
                          controller: adminPageController,
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
                          image: NetworkImage((adminPageController
                                      .pageProfileModel
                                      .value
                                      ?.pageDetails
                                      ?.coverPic ??
                                  '')
                              .formatedPostUrl),
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
            Expanded(
              child: Obx(
                () => adminPageController.isLoadingAlbums.value == true
                    ? ShimmarLoadingView()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: GridView.builder(
                          physics: const ScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount:
                              adminPageController.mediaAlbumList.value.length,
                          itemBuilder: (context, index) {
                            PageMediaModel pageMediaModel =
                                adminPageController.mediaAlbumList.value[index];
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    adminPageController.getPageAlbums(
                                        adminPageController.pageProfileModel
                                                .value?.pageDetails?.id ??
                                            '');
                                    Get.to(() => AdminsMediaGalleryView(
                                          pageMediaModel: pageMediaModel,
                                          controller: adminPageController,
                                        ));
                                  },
                                  child: SizedBox(
                                    height: 140,
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
                                          image: NetworkImage((pageMediaModel
                                                      .medias?.fileName ??
                                                  '')
                                              .formatedPostUrl),
                                        ),
                                        Text(
                                          pageMediaModel.title ?? '',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 10,
                                  child: IconButton(
                                    icon: const Image(
                                        height: 22,
                                        width: 22,
                                        image: AssetImage(AppAssets.MORE)),
                                    onPressed: () {
                                      Get.bottomSheet(
                                        Container(
                                          height: 80,
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              // InkWell(
                                              //   onTap: () {
                                              //     Get.back();
                                              //     // Get.to(() => AdminEditAlbum(
                                              //     //       controller:
                                              //     //           adminPageController,
                                              //     //     ));
                                              //     // Get.to(
                                              //     //     () => AdminE(
                                              //     //           controller:
                                              //     //               controller,
                                              //     //         ),
                                              //     //     arguments: albumModel);
                                              //   },
                                              //   child:
                                              //   const Padding(
                                              //     padding: EdgeInsets.only(
                                              //       left: 5,
                                              //     ),
                                              //     child: Row(
                                              //       children: [
                                              //         Icon(
                                              //           Icons.edit,
                                              //           size: 20,
                                              //         ),
                                              //         SizedBox(width: 8),
                                              //         Text(
                                              //           'Edit album',
                                              //           style: TextStyle(
                                              //             fontSize: 14,
                                              //             fontWeight:
                                              //                 FontWeight.w600,
                                              //             color: Colors.black,
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              InkWell(
                                                onTap: () async {
                                                  showDeleteAlertDialogs(
                                                    context: context,
                                                    deletingItemType: 'Album',
                                                    onDelete: () {
                                                      adminPageController
                                                          .deleteAlbum(
                                                              pageMediaModel
                                                                      .id ??
                                                                  '');

                                                      Get.back();
                                                    },
                                                    onCancel: () {
                                                      Get.back();
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Icon(
                                                              Icons.delete,
                                                              size: 20,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Text('Delete'.tr,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
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
          ],
        ),
      ),
    );
  }
}

Widget ShimmarLoadingView() {
  return SizedBox(
    height: Get.height,
    child: GridView.builder(
        physics: const ScrollPhysics(),
        itemCount: 18,
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
