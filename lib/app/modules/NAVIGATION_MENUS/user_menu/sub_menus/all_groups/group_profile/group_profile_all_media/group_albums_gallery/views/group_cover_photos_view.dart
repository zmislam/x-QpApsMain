import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../../../components/simmar_loader.dart';
import '../../../../../../../../../components/single_image.dart';
import '../../../../../../../../../config/constants/app_assets.dart';
import '../../../components/custom_bottomsheet.dart';
import '../../../components/custom_report_bottomsheet.dart';
import '../controllers/group_albums_gallery_controller.dart';

class GroupCoverPhotosView extends StatelessWidget {
  const GroupCoverPhotosView({
    super.key,
    required this.controller,
  });

  final GroupAlbumsGalleryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            textAlign: TextAlign.center,
            'Group Cover Photos',
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
                          itemCount: controller.coverPhotosList.value.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(SingleImage(
                                      imgURL:
                                          ('${controller.coverPhotosList.value[index].media}')
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
                                          ('${controller.coverPhotosList.value[index].media}')
                                              .formatedPostUrl),
                                      placeholder: const AssetImage(
                                          'assets/image/default_image.png'),
                                    ),
                                  ),
                                ),
                                controller.groupProfileController.groupRole
                                            .value !=
                                        'admin'
                                    ? const SizedBox()
                                    : Positioned(
                                        top: 10,
                                        right: 10,
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
                                                  deletingItemType: 'Photo',
                                                  onDelete: () {
                                                    controller.deletePhotos(
                                                        controller
                                                                .coverPhotosList
                                                                .value[index]
                                                                .id ??
                                                            '', controller
                                                        .coverPhotosList
                                                        .value[index]
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
                                                  reportAction:
                                                      (String report_type_id,
                                                          String report_type,
                                                          String page_id,
                                                          String description) {
                                                    controller
                                                        .groupProfileController
                                                        .reportAPost(
                                                            report_type:
                                                                report_type,
                                                            description:
                                                                description,
                                                            post_id: controller
                                                                    .coverPhotosList
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
                                        ))
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
