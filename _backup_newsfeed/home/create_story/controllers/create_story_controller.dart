import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../routes/app_pages.dart';

class CreateStoryController extends GetxController {
  ImagePicker imagePicker = ImagePicker();

  void onTapCreateTextStory() {
    Get.toNamed(
      Routes.CREATE_TEXT_STORY,
    );
  }

  void onTapPickImage() async {
    final pickedImageFile = await imagePicker.pickMultiImage();

    if (pickedImageFile.isEmpty) {
    } else if (pickedImageFile.length == 1) {
      await Get.toNamed(Routes.CREATE_IMAGE_STORY,
          arguments: [File(pickedImageFile.first.path), false]);
      pickedImageFile.clear();
    } else {
      await Get.toNamed(Routes.CREATE_MULTI_IMAGE_STORY,
          arguments: pickedImageFile);
      pickedImageFile.clear();
    }
  }
}
