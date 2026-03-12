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
import '../../../models/group_album_model.dart';
import '../../models/group_album_model.dart';
import '../controllers/group_albums_gallery_controller.dart';
import 'group_upload_photos_view.dart';

class GroupMediaGalleryView extends StatelessWidget {
  const GroupMediaGalleryView({
    super.key,
    required this.controller,
    required this.albumModel,
  });

  final GroupAlbumsGalleryController controller;
  final GroupAlbumModel albumModel;

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
            '${albumModel.title}',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  height: 50,
                  width: Get.width,
                  color: PRIMARY_COLOR,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => GroupUploadPhotosView(
                            controller: controller,
                            albumModel: albumModel,
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Add Photos'.tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(
                  () => controller.isLoadingMediaPhoto.value == true
                      ? ShimmarLoadingView()
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 0.7,
                                  crossAxisSpacing: 0.7),
                          itemCount: controller.albumPhotosList.value.length,
                          itemBuilder: (context, index) {
                            GroupProfileAlbumModel picturesemodel =
                                controller.albumPhotosList.value[index];
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(SingleImage(
                                      imgURL: ('${picturesemodel.media}')
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
                                          ('${controller.albumPhotosList.value[index].media}')
                                              .formatedPostUrl),
                                      placeholder: const AssetImage(
                                          'assets/image/default_image.png'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 10,
                                    right: 5,
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
                                                    controller.albumPhotosList
                                                            .value[index].id ??
                                                        '', controller.albumPhotosList
                                                    .value[index].key ?? '');
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
                                                                .value[index]
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
        itemCount: 12,
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
