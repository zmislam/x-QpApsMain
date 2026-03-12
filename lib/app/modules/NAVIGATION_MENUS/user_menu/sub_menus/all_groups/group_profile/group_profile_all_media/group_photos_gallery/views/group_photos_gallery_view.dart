import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../../../components/simmar_loader.dart';
import '../../../../../../../../../components/single_image.dart';
import '../../../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../../../config/constants/color.dart';
import '../../../components/custom_bottomsheet.dart';
import '../../../components/custom_report_bottomsheet.dart';
import '../../group_albums_gallery/controllers/group_albums_gallery_controller.dart';
import '../../group_albums_gallery/views/group_cover_photos_view.dart';
import '../../group_albums_gallery/views/group_create_album_view.dart';
import '../../group_albums_gallery/views/group_edit_album.dart';
import '../../group_albums_gallery/views/group_media_gallery_view.dart';
import '../../models/group_album_model.dart';
import '../controllers/group_photos_gallery_controller.dart';

class GroupPhotosGalleryView extends GetView<GroupPhotosGalleryController> {
  const GroupPhotosGalleryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GroupAlbumsGalleryController albumsGalleryController =
        Get.put(GroupAlbumsGalleryController());

    return SafeArea(
      child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Group Photos'.tr,
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
                            controller.viewNumber.value = 0;
                            controller.getGroupPhotos();
                            controller.buttonview.value = 'Photos of you';
                          },
                          child: Text('Photos of ${controller.allGroupModel.value?.groupName?.capitalizeFirst}'.tr,
                              style: TextStyle(
                                color: controller.buttonview.value ==
                                        'Photos of you'
                                    ? PRIMARY_COLOR
                                    : Colors.black,
                              ))),
                      TextButton(
                          onPressed: () {
                            controller.viewNumber.value = 1;
                            controller.getGroupAlbums();
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
                    visible: controller.buttonview.value == 'Photos of you',
                    child: Expanded(
                        child: controller.isLoadingUserPhoto.value == true
                            ? ShimmarLoadingView()
                            : GridView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.photoList.value.length,

                                //controller.photoModel.value?.posts?.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.7),
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      InkWell(
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
                                                ('${controller.photoList.value[index].media}')
                                                    .formatedPostUrl),
                                            placeholder: const AssetImage(
                                                'assets/image/default_image.png'),
                                          ),
                                        ),
                                      ),
                                      controller.groupProfileController
                                                  .groupRole.value !=
                                              'admin'
                                          ? const SizedBox()
                                          : Positioned(
                                              top:
                                                  5, // Adjust positioning as needed
                                              right:
                                                  5, // Ensure button is at the top-right corner
                                              child: InkWell(
                                                child: const Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                ),
                                                onTap: () {
                                                  showCustomBottomSheet(
                                                    isAdminOrModerator: controller
                                                                .groupProfileController
                                                                .groupRole
                                                                .value ==
                                                            'admin'
                                                        ? true
                                                        : false,
                                                    context: context,
                                                    onDelete: () {
                                                      showDeleteAlertDialogs(
                                                        context: context,
                                                        deletingItemType:
                                                            'Photo',
                                                        onDelete: () {
                                                          controller.deletePhotos(
                                                              controller
                                                                      .photoList
                                                                      .value[
                                                                          index]
                                                                      .id ??
                                                                  '', controller
                                                              .photoList
                                                              .value[
                                                          index]
                                                              .key ?? '');
                                                          Get.back();
                                                        },
                                                        onCancel: () {
                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                    onReport: () async {
                                                      await controller
                                                          .groupProfileController
                                                          .getReports();
                                                      CustomReportBottomSheet
                                                          .showReportOptions(
                                                        context: context,
                                                        pageReportList: controller
                                                            .groupProfileController
                                                            .pageReportList
                                                            .value,
                                                        selectedReportType: controller
                                                            .groupProfileController
                                                            .selectedReportType,
                                                        selectedReportId: controller
                                                            .groupProfileController
                                                            .selectedReportId,
                                                        reportDescription: controller
                                                            .groupProfileController
                                                            .reportDescription,
                                                        onCancel: () {
                                                          Get.back();
                                                        },
                                                        reportAction: (String
                                                                report_type_id,
                                                            String report_type,
                                                            String page_id,
                                                            String
                                                                description) {
                                                          controller.groupProfileController.reportAPost(
                                                              report_type:
                                                                  report_type,
                                                              description:
                                                                  description,
                                                              post_id: controller
                                                                      .photoList
                                                                      .value[
                                                                          index]
                                                                      .id ??
                                                                  '',
                                                              report_type_id:
                                                                  report_type_id);
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              )),
                                    ],
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
                            Get.to(() => GroupCreateAlbumView(
                                  controller: albumsGalleryController,
                                  // allGroupModel: controller.allGroupModel!,
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
                        // InkWell(
                        //   onTap: () {
                        //     // controller.getProfilePictures();

                        //     albumsGalleryController.getProfilePictures();
                        //     Get.to(() => GroupCoverPhotosView(
                        //           controller: albumsGalleryController,
                        //         ));
                        //   },
                        //   child: Container(
                        //     height: 120,
                        //     width: 120,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         Image(
                        //           height: 100,
                        //           width: 120,
                        //           fit: BoxFit.cover,
                        //           errorBuilder: (context, error, stackTrace) {
                        //             return const Image(
                        //               height: 100,
                        //               width: 120,
                        //               fit: BoxFit.cover,
                        //               image:
                        //                   AssetImage(AppAssets.DEFAULT_IMAGE),
                        //             );
                        //           },
                        //           image: NetworkImage(getFormatedProfileUrl(
                        //               controller.userModel.profile_pic ?? '')),
                        //         ),
                        //         Text(
                        //           'Profile pictures',
                        //           style: TextStyle(
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.w600),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        InkWell(
                          onTap: () {
                            albumsGalleryController.getGroupCoverPhotos();
                            Get.to(() => GroupCoverPhotosView(
                                  controller: albumsGalleryController,
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
                                  image: NetworkImage((controller.allGroupModel
                                              .value?.groupCoverPic ??
                                          '')
                                      .formatedGroupProfileUrl),
                                ),
                                Text('Cover Photos'.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                Expanded(
                                  child: Obx(
                                    () =>
                                        controller.isLoadingUserPhoto.value ==
                                                    true &&
                                                controller.buttonview.value ==
                                                    'Albums'
                                            ? ShimmarLoadingView()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 20),
                                                child: GridView.builder(
                                                  physics:
                                                      const ScrollPhysics(),
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    mainAxisSpacing: 0.7,
                                                    crossAxisSpacing: 7,
                                                  ),
                                                  itemCount: controller
                                                      .albumsList.value.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    GroupAlbumModel albumModel =
                                                        controller.albumsList
                                                            .value[index];
                                                    return Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            albumsGalleryController
                                                                .getMediaPhotos(
                                                                    albumModel
                                                                            .id ??
                                                                        '');
                                                            Get.to(() =>
                                                                GroupMediaGalleryView(
                                                                  controller:
                                                                      albumsGalleryController,
                                                                  albumModel:
                                                                      albumModel,
                                                                ));
                                                          },
                                                          child: SizedBox(
                                                            height: 130,
                                                            width: 120,
                                                            child: Column(
                                                              children: [
                                                                FadeInImage(
                                                                  imageErrorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return const Image(
                                                                      height:
                                                                          100,
                                                                      width:
                                                                          120,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: AssetImage(
                                                                          AppAssets
                                                                              .DEFAULT_IMAGE),
                                                                    );
                                                                  },
                                                                  height: 100,
                                                                  width: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  placeholder:
                                                                      const AssetImage(
                                                                          AppAssets
                                                                              .DEFAULT_IMAGE),
                                                                  image: NetworkImage(
                                                                      (albumModel.medias?.fileName ??
                                                                              '')
                                                                          .formatedPostUrl),
                                                                ),
                                                                Text(
                                                                  albumModel
                                                                          .title ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                image: AssetImage(
                                                                    AppAssets
                                                                        .MORE)),
                                                            onPressed: () {
                                                              Get.bottomSheet(
                                                                Container(
                                                                  height: 100,
                                                                  width: double
                                                                      .infinity,
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Get.back();
                                                                          Get.to(
                                                                              () => GroupEditAlbum(
                                                                                    controller: GroupAlbumsGalleryController(),
                                                                                  ),
                                                                              arguments: albumModel);
                                                                        },
                                                                        child:
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.edit,
                                                                                size: 20,
                                                                              ),
                                                                              SizedBox(width: 8),
                                                                              Text('Edit album'.tr,
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          showDeleteAlertDialogs(
                                                                            context:
                                                                                context,
                                                                            deletingItemType:
                                                                                'Photo',
                                                                            onDelete:
                                                                                () {
                                                                              controller.deleteAlbum(albumModel.id ?? '');
                                                                              Get.back();
                                                                            },
                                                                            onCancel:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: 10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(left: 8),
                                                                                    child: Icon(
                                                                                      Icons.delete,
                                                                                      size: 20,
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(left: 8),
                                                                                    child: Text('Delete'.tr,
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                        ),
                      ],
                    ),
                  ),
                )
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
