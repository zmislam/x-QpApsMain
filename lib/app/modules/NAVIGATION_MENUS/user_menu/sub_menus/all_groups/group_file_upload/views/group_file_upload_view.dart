import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../components/dropdown.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../utils/file.dart';
import '../controllers/group_file_upload_controller.dart';

class GroupFileUploadView extends GetView<GroupFileUploadController> {
  const GroupFileUploadView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.descriptionController.clear();

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: () {
                            Get.back();
                          }),
                      const SizedBox(
                        width: 70,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Group Files Upload',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    'File Upload',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    textAlign: TextAlign.center,
                    'Add Your File Here',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: DottedBorder(
                      options: RectDottedBorderOptions(
                        color: PRIMARY_COLOR,
                        strokeWidth: 2,
                        dashPattern: const [8, 4],
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icon/group_profile/file_upload.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 16),
                            Text('Upload Files'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                controller.pickFiles();
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: PRIMARY_COLOR, width: 1),
                                ),
                              ),
                              child: Text('Browse Files'.tr,
                                style: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('File Description'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: FOCUSED_BORDER,
                      hintText: ' Enter Your Description Here...'.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return Visibility(
                      visible: controller.coverPhotoError.value.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          controller.coverPhotoError.value,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() {
                    return Visibility(
                      visible: controller.files.value.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Picked Files'.tr,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.files.value.length,
                            itemBuilder: (BuildContext context, int index) {
                              File file = controller.files.value[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            PRIMARY_GREY_DIVIDER_COLOR), // Red border with width 2
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                  ),
                                  child: ListTile(
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    leading: Image.asset(
                                      getFileIconAsset(file.path),
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      file.path.split('/').last,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color: Color(0xFF858585),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        controller.files.value.removeAt(index);
                                        controller.files.refresh();
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: controller.isSaveButtonEnabled.value == true
                              ? Colors.grey
                              : PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {
                          if (controller.formKey.currentState?.validate() ??
                              false) {
                            if (controller.files.value.isEmpty) {
                              controller.coverPhotoError.value =
                                  'Please add at least one file';
                            } else {
                              controller.coverPhotoError.value = '';
                              controller.uploadFiles();
                            }
                          }
                        },
                        child: Text('SUBMIT'.tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
