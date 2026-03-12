import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../controllers/group_profile_controller.dart';
import 'custom_bottomsheet.dart';
import 'custom_report_bottomsheet.dart';
import 'group_photo_album_card.dart';

class GroupProfileMediaComponent extends StatelessWidget {
  const GroupProfileMediaComponent({super.key, required this.controller});

  final GroupProfileController controller;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('Group Media'.tr,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: PRIMARY_COLOR),
          ),
        ),
        const SizedBox(height: 10),
        GroupPhotoAlbumsCard(
          controller: controller,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('All Group Photos'.tr,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PRIMARY_COLOR),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => controller.isLoadingUserPhoto.value == true
              ? ShimmarLoadingView()
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.photoList.value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        // The photo with an InkWell for tapping
                        InkWell(
                          onTap: () {
                            Get.to(() => SingleImage(
                                  imgURL:
                                      ('${controller.photoList.value[index].media}'
                                          .formatedGroupProfileUrl),
                                ));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 10),
                            child: SizedBox(
                              width: Get.width / 3,
                              height: 157,
                              child: FadeInImage(
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                                  );
                                },
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    ('${controller.photoList.value[index].media}'
                                        .formatedPostUrl)),
                                placeholder: const AssetImage(
                                    'assets/image/default_image.png'),
                              ),
                            ),
                          ),
                        ),

                        // The three-dot vertical button
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: const Icon(Icons.more_vert_rounded,
                                color: Colors.white),
                            onPressed: () {
                              showCustomBottomSheet(
                                isAdminOrModerator:
                                    controller.groupRole.value == 'admin'
                                        ? true
                                        : false,
                                context: context,
                                onDelete: () {
                                  showDeleteAlertDialogs(
                                    context: context,
                                    deletingItemType: 'Photo',
                                    onDelete: () {
                                      controller.deletePhotos(controller
                                              .photoList.value[index].id ??
                                          '', controller.postList.value[index].key ?? '');
                                      Get.back();
                                    },
                                    onCancel: () {
                                      Get.back();
                                    },
                                  );
                                },
                                onReport: () async {
                                  await controller.getReports();
                                  CustomReportBottomSheet.showReportOptions(
                                    context: context,
                                    pageReportList:
                                        controller.pageReportList.value,
                                    selectedReportType:
                                        controller.selectedReportType,
                                    selectedReportId:
                                        controller.selectedReportId,
                                    reportDescription:
                                        controller.reportDescription,
                                    onCancel: () {
                                      Get.back();
                                    },
                                    reportAction: (String report_type_id,
                                        String report_type,
                                        String page_id,
                                        String description) {
                                      controller.reportAPost(
                                          report_type: report_type,
                                          description: description,
                                          post_id: controller
                                                  .photoList.value[index].id ??
                                              '',
                                          report_type_id: report_type_id);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
        )
      ]),
    );
  }

  Widget ShimmarLoadingView() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
        });
  }
}
