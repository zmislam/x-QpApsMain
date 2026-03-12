import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/button.dart';

import '../../../../../../../routes/app_pages.dart';
import '../controllers/create_multi_image_story_controller.dart';
import '../model/create_story_data_model.dart';

class CreateMultiImageStoryView
    extends GetView<CreateMultiImageStoryController> {
  const CreateMultiImageStoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios, size: 20)),
          title: Text('Preview'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Expanded(
                flex: 2,
                child: ListView.separated(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  itemCount: controller.sotrydDataModelList.value.length + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //* ========================= Add new image button =====================================

                    if (index == controller.sotrydDataModelList.value.length) {
                      return GestureDetector(
                        onTap: () async {
                          controller.pickMoreImage();
                        },
                        child: Container(
                          width: Get.width * 0.8,
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).cardTheme.color,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_library_outlined, size: 32),
                                SizedBox(height: 12),
                                Text('Add More'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // ================================ image file ===============================
                    CreateStoryDataModel storyDataModel =
                        controller.sotrydDataModelList.value[index];

                    // ================================ show picked image ========================
                    return GestureDetector(
                      onTap: () async {
                        dynamic data = await Get.toNamed(
                          Routes.CREATE_IMAGE_STORY,
                          arguments: [storyDataModel.file, true],
                        );
                        CreateStoryDataModel? createStoryDataModel = data;
                        if (createStoryDataModel != null) {
                          controller.sotrydDataModelList.value[index] =
                              createStoryDataModel;
                          controller.sotrydDataModelList.refresh();
                        }
                      },
                      child: Container(
                        width: Get.width * 0.8,
                        padding: const EdgeInsetsDirectional.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(storyDataModel.file),
                            fit: BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ======================= top action buttons =============================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // =================== clear button ===================================
                                IconButton(
                                  onPressed: () {
                                    controller.sotrydDataModelList.value
                                        .removeAt(index);
                                    controller.sotrydDataModelList.refresh();
                                  },
                                  icon: const SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black26,
                                      ),
                                      child: Icon(Icons.clear,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                                // =================== edit button ====================================
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.black26),
                                  onPressed: () async {
                                    dynamic data = await Get.toNamed(
                                      Routes.CREATE_IMAGE_STORY,
                                      arguments: [storyDataModel.file, true],
                                    );
                                    CreateStoryDataModel? createStoryDataModel =
                                        data;
                                    if (createStoryDataModel != null) {
                                      controller.sotrydDataModelList
                                          .value[index] = createStoryDataModel;
                                      controller.sotrydDataModelList.refresh();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit,
                                            color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text('Edit'.tr,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ============================ bottom action buttons =============================
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 16, end: 16, bottom: 20),
              child: SizedBox(
                width: Get.width,
                child: PrimaryButton(
                    fontSize: 14,
                    onPressed: () {
                      controller.onPressShare();
                    },
                    text: 'Create Multiple Story'.tr),
              ),
            )
          ],
        ),
      ),
    );
  }
}
