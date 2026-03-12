import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../controller/admin_page_controller.dart';
import '../model/page_profile_picture_model.dart';

class AdminProfilePictureView extends StatelessWidget {
  const AdminProfilePictureView({
    super.key,
    required this.controller,
    // required this.userNAme,
  });

  final AdminPageController controller;

  // final String userNAme;

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
            'Profile Pictures',
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 0.7,
                                  crossAxisSpacing: 0.7),
                          itemCount:
                              controller.profilePicturesList.value.length,
                          itemBuilder: (context, index) {
                            AdminPageProfilePictureModel
                                adminPageProfilePictureModel =
                                controller.profilePicturesList.value[index];

                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(SingleImage(
                                      imgURL:
                                          ('${controller.profilePicturesList.value[index].media}')
                                              .formatedProfileUrl,
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
                                      icon: const Image(
                                          height: 22,
                                          width: 22,
                                          image: AssetImage(AppAssets.MORE)),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              onTap: () {
                                                showDeleteAlertDialogs(
                                                  context: context,
                                                  deletingItemType: 'Photo',
                                                  onDelete: () {
                                                    controller.deletePhotos(
                                                        adminPageProfilePictureModel
                                                                .id ??
                                                            '', adminPageProfilePictureModel
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
