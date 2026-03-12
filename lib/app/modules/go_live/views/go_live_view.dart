import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/text_form_field.dart';
import '../../../data/post_local_data.dart';
import '../../../enum/live_post_type_enum.dart';
import '../widget/live_share_selection_widget.dart';

import '../../../components/button.dart';
import '../../../models/live/user_live_stream_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/go_live_controller.dart';

class GoLiveView extends GetView<GoLiveController> {
  const GoLiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // ====================== camera preview section ===================
            Obx(() => controller.isCameraInitialaized.value
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      final screenSize = constraints.biggest;
                      final scale = 1 /
                          (controller
                                  .cameraController.value!.value.aspectRatio *
                              (screenSize.width / screenSize.height));

                      return Transform.scale(
                        scale: scale,
                        child: Center(
                          child:
                              CameraPreview(controller.cameraController.value!),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.transparent,
                  )),

            // ====================== top section ==============================
            Positioned(
              top: 40,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.clear,
                          color: Colors.white, size: 20)),
                  const SizedBox(height: 8),
                  IconButton(
                      onPressed: () => controller.switchCamera(),
                      icon: const Icon(Icons.cameraswitch_outlined,
                          color: Colors.white, size: 20))
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  width: Get.width,
                  height: MediaQuery.of(context).viewInsets.bottom + 280,
                  padding: EdgeInsetsDirectional.only(
                      top: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      start: 20,
                      end: 20),
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryTextFormField(
                        controller: controller.descriptionController,
                        hinText: 'What’s on your mind? Share the details here',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                        label: 'Add Description'.tr,
                        maxLines: 2,
                        keyboardInputType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        outlineBorder: InputBorder.none,
                        inputTextStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                        labelTextStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      Row(
                        children: [
                          Text('Post On: '.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          LiveShareSelectionWidget(
                              onSelected: (LivePostTypeEnum value) {
                            controller.livePostTypeEnum = value;
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(
                            () => controller.dropdownValue.value == 'Public'
                                ? const Icon(
                                    Icons.public,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                : controller.dropdownValue.value == 'Friends'
                                    ? const Icon(
                                        Icons.group,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(() {
                            return DropdownButton<String>(
                              value: controller.dropdownValue.value,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              elevation: 16,
                              style: const TextStyle(color: Colors.white),
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? value) {
                                controller.dropdownValue.value = value!;
                              },
                              items: privacyList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: PrimaryButton(
                          verticalPadding: 12,
                          onPressed: () async {
                            if (controller.livePostTypeEnum ==
                                LivePostTypeEnum.ON_TIMELINE) {
                              await Get.toNamed(Routes.LIVE_STREAM,
                                  arguments: UserLiveStreamModel(
                                    description: controller
                                        .descriptionController.text
                                        .trim(),
                                    privacy: privacyOptions[
                                        controller.dropdownValue.value],
                                    cameraIndex:
                                        controller.currentCameraIndex.value,
                                    livePostTypeEnum:
                                        controller.livePostTypeEnum,
                                  ));
                            } else {
                              showWarningPopupForNonPremiumUsersAboutPolicy(
                                  context: context);
                            }
                          },
                          text: 'Go Live'.tr,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showWarningPopupForNonPremiumUsersAboutPolicy({
    required BuildContext context,
  }) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white70,
              title: Text('Important Note'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              content: Text('As per your current subscription, your Live stream videos will not be saved on Reels. Are you willing to proceed?'.tr,
                  style: Theme.of(context).textTheme.bodyMedium),
              actions: [
                // Close the stream -----------------------------
                PrimaryButton(
                  verticalPadding: 12,
                  // horizontalPadding: 56,
                  fontSize: 12,
                  onPressed: () async {
                    Get.back();
                    await Get.toNamed(Routes.LIVE_STREAM,
                        arguments: UserLiveStreamModel(
                          description:
                              controller.descriptionController.text.trim(),
                          privacy:
                              privacyOptions[controller.dropdownValue.value],
                          cameraIndex: controller.currentCameraIndex.value,
                          livePostTypeEnum: controller.livePostTypeEnum,
                        ));
                  },
                  text: 'Yes, Go live'.tr,
                ),

                // Cancel -----------------------------
                OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Colors.redAccent, width: 1))),
                    child: Text('Close'.tr))
              ],
            ));
  }
}
