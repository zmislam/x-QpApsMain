import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../controllers/group_profile_controller.dart';
import '../custom_widgets/custom_downloadable_text_widget.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../utils/file.dart';

class GroupProfileFilesComponent extends StatelessWidget {
  final GroupProfileController controller;

  const GroupProfileFilesComponent({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    controller.fetchGroupFiles(); // Ensure files are fetched

    return Obx(
      () => SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20),
            child: Text('Group Files'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: PRIMARY_COLOR,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
            child: InkWell(
              onTap: () {
                Get.toNamed(
                  Routes.GROUP_FILES_UPLOAD,
                  arguments: controller.allGroupModel,
                );
              },
              child: Container(
                // height:Get.height/3,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 10),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon/group_profile/upload.png',
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 15),
                    Text('Upload Files'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
          ),
          if (controller.fileItemsList.value.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('No files available'.tr,
                  style: TextStyle(
                      fontSize: 30,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children:
                    controller.fileItemsList.value.reversed.map((fileItem) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              Image.asset(
                                getFileIconAsset(fileItem.media),
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DownloadableTextDoc(
                                  docFileName: fileItem.media,
                                  fileUrl:
                                      (fileItem.media ?? '').formatedPostUrl,
                                ),
                              ),
                              if (controller.groupRole.value == 'admin' ||
                                  fileItem.postId?.userId ==
                                      controller.loginCredential
                                          .getUserData()
                                          .id)
                                PopupMenuButton(
                                  color: Colors.white,
                                  offset: const Offset(-50, 0),
                                  iconColor: Colors.grey,
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        onTap: () {
                                          controller
                                              .deleteGroupFilesPost(
                                                  mediaId: fileItem.id)
                                              .whenComplete(
                                                  () => controller.update());
                                        },
                                        value: 1,
                                        child: Text('Delete'.tr,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ];
                                  },
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ]),
      ),
    );
  }
}
