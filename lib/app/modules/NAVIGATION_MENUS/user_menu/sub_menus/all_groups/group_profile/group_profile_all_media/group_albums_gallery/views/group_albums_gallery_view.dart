import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../controllers/group_albums_gallery_controller.dart';
import 'group_cover_photos_view.dart';
import 'group_media_gallery_view.dart';
import '../../models/group_album_model.dart';
import '../../../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../../../components/simmar_loader.dart';
import 'group_create_album_view.dart';
import 'group_edit_album.dart';

class GroupAlbumsGalleryView extends GetView<GroupAlbumsGalleryController> {
  const GroupAlbumsGalleryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double imageheight = 140;
    const double imageWidth = 140;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Group Albums'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment:
                controller.groupProfileController.groupRole.value != 'admin'
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceEvenly,
            children: [
              ////////////////     ////////////////////Create Album//////////////////////////////////////////////////
              controller.groupProfileController.groupRole.value != 'admin'
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        Get.to(() => GroupCreateAlbumView(
                              controller: controller,
                              // allGroupModel:
                              // //     controller.groupProfileController.allGroupModel.value ??
                              //         AllGroupModel(),
                            ));
                      },
                      child: Column(
                        children: [
                          Image(
                            height: imageheight,
                            width: imageWidth,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Image(
                                height: imageheight,
                                width: imageWidth,
                                fit: BoxFit.fill,
                                image: AssetImage(AppAssets.DEFAULT_IMAGE),
                              );
                            },
                            image: const AssetImage(
                              AppAssets.CREATE_ALBUM,
                            ),
                          ),
                          Text('Albums'.tr,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
              ////////////////     ///////////////////Group Cover Photos//////////////////////////////////////////////////

              Padding(
                padding:
                    controller.groupProfileController.groupRole.value != 'admin'
                        ? const EdgeInsets.all(10.0)
                        : const EdgeInsets.all(0.0),
                child: InkWell(
                  onTap: () {
                    controller.getGroupCoverPhotos();
                    Get.to(() => GroupCoverPhotosView(
                          controller: controller,
                        ));
                  },
                  child: Column(
                    children: [
                      Image(
                        height: imageheight,
                        width: imageWidth,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Image(
                            height: imageheight,
                            width: imageWidth,
                            fit: BoxFit.cover,
                            image: AssetImage(AppAssets.DEFAULT_IMAGE),
                          );
                        },
                        image: NetworkImage(
                            (controller.allGroupModel.value?.groupCoverPic ??
                                    '')
                                .formatedGroupProfileUrl),
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
          ////////////////     ///////////////////All Group Album Lsit//////////////////////////////////////////////////

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
                          crossAxisCount: 2,
                          mainAxisSpacing: 17,
                          crossAxisSpacing: 30,
                        ),
                        itemCount: controller.albumsList.value.length,
                        itemBuilder: (context, index) {
                          GroupAlbumModel albumModel =
                              controller.albumsList.value[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  controller
                                      .getMediaPhotos(albumModel.id ?? '');
                                  Get.to(() => GroupMediaGalleryView(
                                        controller: controller,
                                        albumModel: albumModel,
                                      ));
                                },
                                child: Stack(
                                  children: [
                                    FadeInImage(
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return const Image(
                                          height: imageheight,
                                          width: imageWidth,
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              AppAssets.DEFAULT_IMAGE),
                                        );
                                      },
                                      height: imageheight,
                                      width: imageWidth,
                                      fit: BoxFit.cover,
                                      placeholder: const AssetImage(
                                          AppAssets.DEFAULT_IMAGE),
                                      image: NetworkImage(
                                          (albumModel.medias?.fileName ?? '')
                                              .formatedPostUrl),
                                    ),
                                    controller.groupProfileController.groupRole
                                                .value ==
                                            'admin'
                                        ? Positioned(
                                            top: 0,
                                            right: 5,
                                            child: IconButton(
                                              icon: const Image(
                                                  height: 22,
                                                  width: 22,
                                                  image: AssetImage(
                                                      AppAssets.MORE)),
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
                                                          onTap: () {
                                                            Get.back();
                                                            Get.to(
                                                                () =>
                                                                    GroupEditAlbum(
                                                                      controller:
                                                                          controller,
                                                                    ),
                                                                arguments:
                                                                    albumModel);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 5,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.edit,
                                                                  size: 20,
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Text('Edit album'.tr,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
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
                                                                    albumModel
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
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              8),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              8),
                                                                      child:
                                                                          Text('Delete'.tr,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
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
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  albumModel.title ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
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
