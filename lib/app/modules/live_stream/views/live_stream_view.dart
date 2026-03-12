import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../components/live_stream/live_stream_comment.dart';
import '../../../config/constants/app_assets.dart';
import 'package:rtmp_broadcaster/camera.dart';

import '../controllers/live_stream_controller.dart';
import '../widgets/live_bottom_widget.dart';
import '../widgets/live_top_widget.dart';

class LiveStreamView extends GetView<LiveStreamController> {
  const LiveStreamView({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI to be fully immersive and stay that way
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top], // Keep all overlays hidden
    );

    return SafeArea(
      top: false,
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          controller.endLiveSession();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          // ========================== body section =============================
          body: Stack(
            alignment: Alignment.center,
            children: [
              // ====================== camera preview section ===================
              // Obx(() => controller.isInitDone.value
              //     ? LayoutBuilder(
              //         builder: (context, constraints) {
              //           final screenSize = constraints.biggest;
              //           final scale = 1 /
              //               (controller.cameraController!.value.aspectRatio *
              //                   (screenSize.width / screenSize.height));
              //
              //           return Transform.scale(
              //             scale: scale,
              //             child: Center(
              //                 child: AspectRatio(
              //               // I was getting 3x Zoom Then Mr Shishir vai told me to / by 3...
              //               aspectRatio:
              //                   controller.cameraController!.value.aspectRatio / 3,
              //               child: CameraPreview(controller.cameraController!),
              //             )),
              //           );
              //         },
              //       )
              //     : Container(
              //         color: Colors.transparent,
              //       )),

              Obx(() => controller.isInitDone.value
                  ? Transform.scale(
                      scale: controller.scale.value,
                      child: Center(child: CameraPreview(controller.cameraController!)),
                    )
                  : Container(
                      color: Colors.transparent,
                    )),

              // ====================== top section ==============================
              Positioned(
                top: 20,
                right: 12,
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.switchCamera();
                            },
                            icon: Image.asset(
                              AppAssets.SWITCH_CAMERA_ICON,
                              color: Theme.of(context).colorScheme.surface,
                              height: 25,
                              width: 25,
                            )),
                        LiveTopWidget(
                          joinUserCount: (controller.listViewModel.value?.viewers ?? []).length.toString(),
                        ),
                      ],
                    )),
              ),
              // ====================== live stream comment ======================
              Positioned(
                bottom: 100,
                left: 12,
                child: Obx(() {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (controller.scrollController.hasClients) {
                      // Step 2: Scroll to the end when new items are added
                      controller.scrollController.animateTo(
                        controller.scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                  return controller.liveCommentList.value.isEmpty
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(bottom: 12),
                          child: Text('Comment will start from here...'.tr,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                        )
                      : LiveStreamComment(scrollController: controller.scrollController, commentList: controller.liveCommentList.value);
                }),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: LiveBottomWidget(
                  onBottomWidgetToggle: () {
                    controller.isBottomWidgetOpen.toggle(); // Toggle the state
                  },
                  onShareTap: () => controller.liveShare(),
                  textEditingController: controller.commentController,
                  focusNode: controller.commentFocusNode,
                  shareCount: controller.shareCount.value,
                  onFieldSubmitted: (value) {
                    controller.sendLiveStreamComment(reelsId: controller.postModelForReels.id, postId: controller.postModelForTimeLine.id);
                  },
                  streamEndFunction: () {
                    controller.endLiveSession();
                  },
                ),
              )
            ],
          ),
          // ========================= live bottom action section =======================
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    debugPrint('888888888888888888888888888888888888888888888888888888888888');
    // debugPrint(controller.cameraController == null);
    // debugPrint(!controller.isControllerInitialized.value!);
    // debugPrint(controller.cameraController!.value.previewSize);
    debugPrint('888888888888888888888888888888888888888888888888888888888888');

    if (controller.cameraController == null || !controller.isControllerInitialized.value!) {
      return Text('Tap a camera'.tr,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      // I was getting 3x Zoom Then Mr Shishir vai told me to / by 3...
      aspectRatio: controller.cameraController!.value.aspectRatio / 3,
      child: CameraPreview(controller.cameraController!),
    );
  }
}
