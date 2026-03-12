import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../components/simmar_loader.dart';
import '../../../../../../../../components/single_image.dart';
import '../../../../../../../../config/constants/app_assets.dart';
import '../../../models/profile_cover_albums_model.dart';
import '../controllers/albums_gallery_controller.dart';

class ProfilePhotosView extends StatelessWidget {
  const ProfilePhotosView({
    super.key,
    required this.controller,
  });

  final AlbumsGalleryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Text(
            textAlign: TextAlign.center,
            'Profile Photos',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Obx(
                  () => controller.isLoadingProfilePhoto.value == true
                      ? ShimmarLoadingView()
                      : GridView.builder(
                          controller: controller.profilePicScrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 0.7,
                                  crossAxisSpacing: 0.7),
                          itemCount:
                              controller.profilePicturesList.value.length,
                          itemBuilder: (context, index) {
                            ProfilPicturesemodel profilPicturesemodel =
                                controller.profilePicturesList.value[index];

                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(SingleImage(
                                      imgURL:
                                          ('${controller.profilePicturesList.value[index].media}')
                                              .formatedPostUrl,
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: FadeInImage(
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return const Image(
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            AppAssets.DEFAULT_IMAGE,
                                          ),
                                        );
                                      },
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          ('${controller.profilePicturesList.value[index].media}')
                                              .formatedPostUrl),
                                      placeholder: const AssetImage(
                                          'assets/image/default_image.png'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: PopupMenuButton(
                                      color: Colors.white,
                                      offset: const Offset(-50, 30),
                                      iconColor: Colors.black,
                                      icon: const Icon(
                                        Icons.more_vert_rounded,
                                      ),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              onTap: () {
                                                showDeleteAlertDialogs(
                                                  context: context,
                                                  deletingItemType: 'Photo',
                                                  onDelete: () {
                                                    controller.deletePhotos(
                                                        profilPicturesemodel
                                                                .id ??
                                                            '', profilPicturesemodel
                                                                .key ?? '');
                                                  },
                                                  onCancel: () {
                                                    Get.back();
                                                  },
                                                );
                                              },
                                              value: 1,
                                              child: Text('Delete'.tr,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ]),
                                )
                              ],
                            );
                          }),
                ),
              )
            ],
          ),
        )));
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
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.9)),
                )),
          );
        }),
  );
}
