import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../extension/string/string.dart';
import '../../../../../../models/location_model.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../edit_post/controllers/edit_post_controller.dart';
import '../../../../../edit_post/views/edit_check_in.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../components/button.dart';
import '../controllers/reels_description_controller.dart';

class ReelsDescriptionView extends GetView<ReelsDescriptionController> {
  const ReelsDescriptionView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        // backgroundColor: Colors.white,
        // ============================== appbar section =======================
        appBar: AppBar(
          // backgroundColor: Colors.white,
          title: Text('Edit Description'.tr,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(
              vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.reelsDataModel.value?.file == null
                  ? Container(
                      height: 200,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.teal,
                          border: Border.all(color: Colors.teal, width: 1)),
                      child: const Icon(
                        Icons.photo,
                        color: Colors.white,
                        size: 100,
                      ),
                    )
                  : controller.reelsDataModel.value!.file!.path
                          .toLowerCase()
                          .endsWithAny(
                              ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])
                      ? Container(
                          height: 200,
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal, width: 1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: controller
                                  .videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(
                                  controller.videoPlayerController!),
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          width: 180,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.teal, width: 1),
                              image: DecorationImage(
                                  image: FileImage(File(controller
                                      .reelsDataModel.value!.file!.path)),
                                  fit: BoxFit.cover)),
                        ),
              const SizedBox(height: 20),
              // ================================ reels description field section ================================
              TextFormField(
                minLines: 2,
                controller: controller.reelDescriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  hintStyle:
                      TextStyle(color: Colors.black.withValues(alpha: 0.4)),
                  hintText: 'Writing a long description can help get 3x more views on average.'.tr,
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),
              // ========================= add location section =============================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      Get.lazyPut(() => EditPostController());
                      controller.locationName.value =
                          await Get.to(() => EditCheckIn())
                              as AllLocation;
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                size: 24,
                              ),
                              Text('Add Location'.tr,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, size: 20)
                        ],
                      ),
                    ),
                  ),
                  Obx(() => controller.locationName.value?.locationName == null
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Chip(
                              side: BorderSide.none,
                              color: WidgetStatePropertyAll(
                                  Colors.grey.withValues(alpha: 0.4)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide.none),
                              label: Text(
                                controller.locationName.value?.locationName ??
                                    '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ))
                ],
              ),
              const SizedBox(height: 12),
              // ================================== add link section ====================================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      showAddLinkSheet(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 24,
                              ),
                              Text('Add Link'.tr,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, size: 20)
                        ],
                      ),
                    ),
                  ),
                  Obx(() => controller.linkAddress.value.isEmpty
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Chip(
                              side: BorderSide.none,
                              color: WidgetStatePropertyAll(
                                  Colors.grey.withValues(alpha: 0.4)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide.none),
                              label: Text(
                                controller.linkAddress.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ))
                ],
              ),
              const SizedBox(height: 12),
              // ====================================== privacy status section ======================================
              InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    showPrivacySheet(context);
                  },
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                controller.selectedPrivacy.value?.icon,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                controller
                                        .selectedPrivacy.value?.privacyStatus ??
                                    '',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 20)
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Allow Comment'.tr, style: TextStyle(fontSize: 16)),
                    Obx(
                      () => Switch(
                          activeColor: Colors.teal,
                          inactiveThumbColor: Colors.white,
                          value: controller.isAllowComment.value,
                          onChanged: (val) => controller.toggleComment()),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: Get.width,
                child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Obx(
                      () => PrimaryButton(
                          backgroundColor:
                              controller.isPublishReelPostCalled.value == true
                                  ? Colors.grey.shade200
                                  : PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(5),
                          onPressed: () async {
                            if (controller.isPublishReelPostCalled.value ==
                                true) {
                              return;
                            } else {
                              controller.onTapPublihReelsPost();
                            }
                          },
                          text: 'Post This Reel'.tr,
                          fontSize: 16,
                          verticalPadding: 16,
                          textColor:
                              controller.isPublishReelPostCalled.value == true
                                  ? Colors.grey
                                  : Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =================================== privacy status bottom sheet ======================================
  void showPrivacySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows bottom sheet to resize when the keyboard appears
      // backgroundColor: Colors.white, // Ensures rounded corners look good
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4, // Adjust based on requirement
        minChildSize: 0.3,
        maxChildSize: 0.9, // Allows it to expand when typing
        expand: false, // Prevents full-screen behavior
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: SingleChildScrollView(
            controller: scrollController, // Allows dragging the sheet
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Prevents unnecessary space
              children: [
                // ========================= top bar =================================
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 5,
                    width: 30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Privacy'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(
                      controller.privacyList.value.length,
                      (index) => InkWell(
                            onTap: () {
                              controller.selectedPrivacyStatus(index);
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: 12, horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(controller.privacyList.value[index].icon,
                                      size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    controller.privacyList.value[index]
                                            .privacyStatus ??
                                        '',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =================================== add link bottom sheet ======================================
  void showAddLinkSheet(BuildContext context) {
    Get.bottomSheet(
        isScrollControlled: true,
        // backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Prevents unnecessary space
              children: [
                // ========================= top bar =================================
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 5,
                    width: 30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Add Link'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                TextFormField(
                  maxLines: 1,
                  controller: controller.addLinkController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.black.withValues(alpha: 0.5),
                            width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.black.withValues(alpha: 0.5),
                            width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 1)),
                    errorBorder: InputBorder.none,
                    hintStyle:
                        TextStyle(color: Colors.black.withValues(alpha: 0.4)),
                    hintText: 'Write link address'.tr,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    controller.writeLink();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('Add Link'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
