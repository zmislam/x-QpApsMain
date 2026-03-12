import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../controller/admin_page_controller.dart';
import '../model/admin_media_model.dart';
import 'admin_upload_photos_view.dart';

class AdminsMediaGalleryView extends StatelessWidget {
  const AdminsMediaGalleryView({
    super.key,
    required this.controller,
    required this.pageMediaModel,
  });

  final AdminPageController controller;
  final PageMediaModel pageMediaModel;

  @override
  Widget build(BuildContext context) {
    controller.getMediaPhotos(pageMediaModel.id ?? '');
    // MediaAlbumsModel? mediaAlbumsModel;
    return RefreshIndicator(
      onRefresh: () async {
        controller.getMediaPhotos(pageMediaModel.id ?? '');
      },
      child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            // backgroundColor: Colors.white,
            leading: const BackButton(
              color: Colors.black,
            ),
            title: Text(
              textAlign: TextAlign.center,
              pageMediaModel.title ?? '',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
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
                        Get.to(() => AdminUploadPhotosView(
                              controller: controller,
                              mediaModel: pageMediaModel,
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
                Obx(
                  () => Expanded(
                    child: controller.isLoadingMediaPhoto.value == true
                        ? ShimmarLoadingView()
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, crossAxisSpacing: 0.8),
                            itemCount: controller.pageMediaList.value.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(SingleImage(
                                        imgURL:
                                            ('${controller.pageMediaList.value[index].media}')
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
                                            ('${controller.pageMediaList.value[index].media}')
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
                                        iconColor: Colors.white,
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
                                                          pageMediaModel.id ??
                                                              '', pageMediaModel.key ?? '');
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
          ))),
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
