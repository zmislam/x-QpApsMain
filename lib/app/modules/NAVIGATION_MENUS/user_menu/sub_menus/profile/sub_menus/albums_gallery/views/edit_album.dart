import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/album_model.dart';
import '../controllers/albums_gallery_controller.dart';

import '../../../../../../../../components/dropdown.dart';
import '../../../../../../../../config/constants/color.dart';

class EditAlbum extends StatelessWidget {
  const EditAlbum({super.key, required this.controller});
  final AlbumsGalleryController controller;

  @override
  Widget build(BuildContext context) {
    AlbumModel albumModel = Get.arguments;
    controller.albumNameController.text = albumModel.title ?? '';

    List<String> lists = ['Public', 'Friends', 'Only me'];
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
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
                    Text('Edit album'.tr,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Get.back();
                        }),
                  ],
                ),
                const SizedBox(height: 20),
                Text(' Album Name'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.albumNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                    labelText: 'Album Name'.tr,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an album name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Text(' Privacy'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                PrimaryDropDownField(
                    hint: 'Privacy',
                    value: controller.dropdownValue.value,
                    list: lists,
                    onChanged: (changedValue) {
                      controller.dropdownValue.value = changedValue ?? '';
                    }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.editalbum(albumModel.id ?? '');
                      }
                    },
                    child: Text('Save album'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
