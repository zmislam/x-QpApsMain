import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../../components/dropdown.dart';
import '../../../models/album_model.dart';
import '../controllers/albums_gallery_controller.dart';

import '../../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../../config/constants/color.dart';

class UploadPhotosView extends StatelessWidget {
  const UploadPhotosView({
    super.key,
    required,
    required this.controller,
    required this.albumModel,
  });
  final AlbumsGalleryController controller;
  final AlbumModel albumModel;

  @override
  Widget build(BuildContext context) {
    controller.xfiles.value.clear();
    List<String> lists = ['Public', 'Friends', 'Only me'];
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upload Photos/Videos'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Get.back();
                          }),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('  Description'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.albumNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: FOCUSED_BORDER,
                      hintText: 'enter a description for the image'.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description for the image';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                              height: 35,
                              width: 35,
                              image: AssetImage(AppAssets.UPLOAD_ICON)),
                          const SizedBox(height: 10),
                          Text('Browse and choose the Photo/Video you\nwant to upload from your computer/Phone'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          IconButton(
                              onPressed: () {
                                controller.pickFiles();
                              },
                              icon: Image.asset(AppAssets.ADD_ICON)),
                        ]),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => Visibility(
                      visible: controller.xfiles.value.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        decoration: const BoxDecoration(),
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.xfiles.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            XFile xFile = controller.xfiles.value[index];

                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    image: FileImage(
                                      File(xFile.path),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      controller.xfiles.value.removeAt(index);
                                      controller.xfiles.refresh();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
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
                  const SizedBox(height: 30),
                  Text(' Privacy'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  PrimaryDropDownField(
                      hint: 'Privacy',
                      list: lists,
                      onChanged: (changedValue) {
                        controller.dropdownValue.value = changedValue ?? '';
                      }),
                  const SizedBox(height: 20),
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
                        onPressed: controller.isSaveButtonEnabled.value == false
                            ? () {
                                if (controller.formKey.currentState
                                        ?.validate() ??
                                    false) {
                                  controller.savePhotos(albumModel.id ?? '');
                                }
                              }
                            : null,
                        child: Text('Add to album'.tr,
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
