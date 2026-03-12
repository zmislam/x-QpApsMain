import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../routes/app_pages.dart';
import '../controllers/custom_camera_controller.dart';

class CustomCameraView extends GetView<CustomCameraController> {
    CustomCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:
                    Icon(Icons.arrow_back, color: Colors.white, size: 24)),
          actions: [
            IconButton(
                onPressed: () async {
                  final Map<String, dynamic> data =
                      await Get.toNamed(Routes.STORY_SETTINGS, arguments: {
                    'selected_privacy': controller.seletedPrivacy.value
                  });
                  controller.seletedPrivacy.value = data['selected_privacy'];
                },
                icon:   Icon(Icons.settings, color: Colors.white, size: 24))
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Obx(() {
              final screenSize = MediaQuery.of(context).size;
              return controller.isCameraInitialaized.value
                  ? SizedBox(
                      width: screenSize.width,
                      height: screenSize.height,
                      child: CameraPreview(controller.cameraController.value!))
                  : Container(
                      color: Colors.red,
                    );
            }),

            // =================================================== right action section ====================================
            Positioned(
              right: 16,
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Obx(() {
                      return controller.isShowSpeed.value
                          ? Row(
                              children: [
                                Container(
                                  padding:
                                        EdgeInsetsDirectional.symmetric(
                                          vertical: 2, horizontal: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    children: List.generate(
                                        controller.videoSpeed.length, (index) {
                                      final speed =
                                          controller.videoSpeed[index];
                                      return TextButton(
                                          onPressed: () {
                                            controller.selectedVideoSpeed
                                                .value = speed;
                                            controller.isShowSpeed.value =
                                                false;
                                          },
                                          child: speed == 1.0
                                              ?   Text('Normal'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white))
                                              : Text('${speed}x'.tr,
                                                  textAlign: TextAlign.center,
                                                  style:   TextStyle(
                                                      color: Colors.white)));
                                    }),
                                  ),
                                ),
                                  SizedBox(width: 8)
                              ],
                            )
                          :   SizedBox();
                    }),
                    Container(
                      padding:   EdgeInsetsDirectional.symmetric(
                          vertical: 2, horizontal: 2),
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.switchCamera();
                            },
                            icon:   Icon(Icons.recycling,
                                size: 20, color: Colors.white),
                          ),
                            SizedBox(height: 8),
                          Obx(() {
                            return IconButton(
                              onPressed: () {
                                controller.toggleFlash();
                              },
                              icon: controller.isFlashOn.value
                                  ?   Icon(Icons.flash_on_outlined,
                                      size: 20, color: Colors.amber)
                                  :   Icon(Icons.flash_off_outlined,
                                      size: 20, color: Colors.white),
                            );
                          }),
                          Obx(() {
                            return controller.isPhoto.value
                                ?   SizedBox()
                                :   SizedBox(height: 8);
                          }),
                          Obx(() {
                            return controller.isPhoto.value
                                ?   SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.isShowSpeed.value =
                                              !controller.isShowSpeed.value;
                                        },
                                        icon: controller
                                                    .selectedVideoSpeed.value !=
                                                -1
                                            ?   Icon(Icons.speed_outlined,
                                                size: 20, color: Colors.teal)
                                            :   Icon(Icons.speed_outlined,
                                                size: 20, color: Colors.white),
                                      ),
                                      controller.selectedVideoSpeed.value == -1
                                          ?   SizedBox()
                                          :   SizedBox(height: 0),
                                      controller.selectedVideoSpeed.value == -1
                                          ?   SizedBox()
                                          : Text('${controller.selectedVideoSpeed.value}x'.tr,
                                              textAlign: TextAlign.center,
                                              style:   TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            )
                                    ],
                                  );
                          })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================== bottom action section ===================================
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                physics:   ClampingScrollPhysics(),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding:   EdgeInsetsDirectional.symmetric(
                        vertical: 16,
                      ),
                      decoration:   BoxDecoration(color: Colors.black54),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // ========================= sixty second video recoder section =====================
                                TextButton(
                                    onPressed: () {
                                      controller.isSixtySec.value = true;

                                      if (controller.isSixtySec.value) {
                                        controller.isFifteenSec.value = false;
                                        controller.isPhoto.value = false;
                                        // controller.imageFile.value = null;
                                      }
                                    },
                                    child: Text('60 SEC'.tr,
                                      textAlign: TextAlign.center,
                                      style: controller.isSixtySec.value
                                          ?   TextStyle(
                                              color: Colors.amber, fontSize: 16)
                                          :   TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                    )),

                                // ========================= fifteen second video recorder section ==================
                                TextButton(
                                    onPressed: () {
                                      controller.isFifteenSec.value = true;

                                      if (controller.isFifteenSec.value) {
                                        controller.isSixtySec.value = false;
                                        controller.isPhoto.value = false;
                                        // controller.imageFile.value = null;
                                      }
                                    },
                                    child: Text('15 SEC'.tr,
                                      textAlign: TextAlign.center,
                                      style: controller.isFifteenSec.value
                                          ?   TextStyle(
                                              color: Colors.amber, fontSize: 16)
                                          :   TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                    )),

                                // ========================= photo capture section ==================================

                                TextButton(
                                    onPressed: () {
                                      controller.isPhoto.value = true;

                                      if (controller.isPhoto.value) {
                                        controller.isSixtySec.value = false;
                                        controller.isFifteenSec.value = false;
                                        // controller.videoFile.value = null;
                                      }
                                    },
                                    child: Text('PHOTO'.tr,
                                      textAlign: TextAlign.center,
                                      style: controller.isPhoto.value
                                          ?   TextStyle(
                                              color: Colors.amber, fontSize: 16)
                                          :   TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                    ))
                              ],
                            ),
                          ),
                            SizedBox(height: 20),
                          // ================= capture button ============================
                          Obx(() {
                            return controller.isPhoto.value
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.capturePhoto();
                                        },
                                        child: Container(
                                          height: 64,
                                          width: 64,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 4)),
                                        ),
                                      ),
                                      controller.imageFile.value == null
                                          ?   SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                  SizedBox(width: 12),
                                                IconButton(
                                                    onPressed: () async {
                                                      await Get.toNamed(
                                                        Routes.CREATE_REELS,
                                                        arguments: [
                                                          controller
                                                              .imageFile.value,
                                                          null,
                                                          null,
                                                        ],
                                                      );

                                                      controller.imageFile
                                                          .value = null;
                                                    },
                                                    icon: Container(
                                                      height: 24,
                                                      width: 24,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                            BoxDecoration(
                                                              color:
                                                                  Colors.teal,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child:   Icon(
                                                          Icons.done,
                                                          size: 16,
                                                          color: Colors.white),
                                                    ))
                                              ],
                                            ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: CircularPercentIndicator(
                                          radius: 40.0,
                                          lineWidth: 5.0,
                                          percent: controller.progress.value,
                                          progressColor: Colors.red,
                                          center: GestureDetector(
                                            onTap: () async {
                                              if (controller
                                                  .isFifteenSec.value) {
                                                await controller
                                                    .startVideoRecording();
                                              } else {
                                                await controller
                                                    .startSixtySecVideoRecording();
                                              }
                                            },
                                            child: Container(
                                              height: 56,
                                              width: 56,
                                              decoration:   BoxDecoration(
                                                  color: Colors.cyan,
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller.videoFile.value == null
                                          ?   SizedBox()
                                          : Row(
                                              children: [
                                                  SizedBox(width: 12),
                                                IconButton(
                                                    onPressed: () async {
                                                      await Get.toNamed(
                                                        Routes.CREATE_REELS,
                                                        arguments: [
                                                          controller
                                                              .videoFile.value,
                                                          controller
                                                              .selectedVideoSpeed
                                                              .value,
                                                          controller
                                                                  .isFifteenSec
                                                                  .value
                                                              ? 15.0
                                                              : 60.0
                                                        ],
                                                      );

                                                      controller.videoFile
                                                          .value = null;
                                                      controller
                                                          .selectedVideoSpeed
                                                          .value = -1;
                                                    },
                                                    icon: Container(
                                                      height: 24,
                                                      width: 24,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                            BoxDecoration(
                                                              color:
                                                                  Colors.teal,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child:   Icon(
                                                          Icons.done,
                                                          size: 16,
                                                          color: Colors.white),
                                                    )),
                                              ],
                                            )
                                    ],
                                  );
                          })
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 20,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            controller.pickFile();
                          },
                          child: Container(
                            height: 64,
                            width: 64,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image:   DecorationImage(
                                    image:
                                        AssetImage('assets/image/picture.png'),
                                    fit: BoxFit.cover),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                          ),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
