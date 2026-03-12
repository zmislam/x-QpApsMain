import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/string/string.dart';
import '../../../routes/app_pages.dart';
import 'package:video_player/video_player.dart';

class CustomCameraController extends GetxController
    with WidgetsBindingObserver {
  Rx<XFile?> imageFile = Rx(null);
  Rx<XFile?> videoFile = Rx(null);
  Rx<bool> isShowSpeed = false.obs;
  Rx<bool> isPhoto = false.obs;
  Rx<bool> isFifteenSec = false.obs;
  Rx<bool> isSixtySec = false.obs;
  Rx<bool> isRecording = false.obs;
  Rx<double> progress = 0.0.obs;
  Timer? timer;
  Rx<String> seletedPrivacy = 'public'.obs;

  List<double> videoSpeed = [2.0, 1.5, 1, 0.5, 0.25];
  Rx<double> selectedVideoSpeed = Rx(-1);

  // ======================== camera's variables ===============================
  Rx<CameraController?> cameraController = Rx(null);
  List<CameraDescription>? cameras;
  Rx<int> currentCameraIndex = 0.obs;
  Rx<bool> isCameraInitialaized = Rx(false);

  // ======================== initialize camera ================================
  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isEmpty) return;

      cameraController.value = CameraController(
          cameras![currentCameraIndex.value], ResolutionPreset.veryHigh);
      await cameraController.value?.initialize();
      await cameraController.value?.lockCaptureOrientation();
      await cameraController.value?.setFocusMode(FocusMode.auto);
      cameraController.refresh();
      isCameraInitialaized.value = true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  // ======================== switch camera ====================================
  Future<void> switchCamera() async {
    currentCameraIndex.value =
        (currentCameraIndex.value + 1) % (cameras!.length);
    cameraController.value?.dispose();
    initializeCamera();
  }

  Future<void> startVideoRecording() async {
    try {
      await cameraController.value?.startVideoRecording();

      isRecording.value = true;
      progress.value = 0.0;

      // Start progress timer for 15 seconds
      timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        progress += 0.1 / 15; // Increment progress
        if (progress >= 1.0) {
          progress.value = 1.0;
          timer.cancel();
        }
      });

      // Stop recording after 15 seconds
      Future.delayed(const Duration(seconds: 15), () async {
        if (isRecording.value) {
          await stopVideoRecording();
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> startSixtySecVideoRecording() async {
    try {
      await cameraController.value?.startVideoRecording();

      isRecording.value = true;
      progress.value = 0.0;

      // Start progress timer for 60 seconds
      timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        progress += 0.1 / 60; // Increment progress
        if (progress >= 1.0) {
          progress.value = 1.0;
          timer.cancel();
        }
      });

      // Stop recording after 15 seconds
      Future.delayed(const Duration(seconds: 60), () async {
        if (isRecording.value) {
          await stopVideoRecording();
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopVideoRecording() async {
    try {
      videoFile.value = await cameraController.value?.stopVideoRecording();

      isRecording.value = false;
      progress.value = 0.0;
      timer?.cancel();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> capturePhoto() async {
    if (cameraController.value!.value.isInitialized) {
      try {
        final image = await cameraController.value?.takePicture();
        imageFile.value = image;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Rx<bool> isFlashOn = false.obs;

  Future<void> toggleFlash() async {
    try {
      if (isFlashOn.value) {
        await cameraController.value?.setFlashMode(FlashMode.off);
      } else {
        await cameraController.value?.setFlashMode(FlashMode.torch);
      }

      isFlashOn.value = !isFlashOn.value;
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    isPhoto.value = true;
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
    cameraController.value?.dispose();
    timer?.cancel();
  }

  Rx<XFile?> pickImageFile = Rx(null);
  Rx<XFile?> pickVideoFile = Rx(null);
  double videoEndTime = 0.00;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic',
        'heif', // Image Formats
        'mp4', 'mov', 'avi', 'wmv', 'flv', 'mkv', 'webm', 'm4v',
        '3gp' // Video Formats
      ],
    );

    if (result != null) {
      if (result.xFiles.single.path
          .toLowerCase()
          .endsWithAny(['.mp4', '.mov', '.avi', '.mkv', '.flv', '.wmv'])) {
        pickVideoFile.value = result.xFiles.single;
        await getVideoDuration(result.xFiles.single.path).then((duration) {
          videoEndTime = duration ?? 180;
        });

        await Get.toNamed(
          Routes.CREATE_REELS,
          arguments: [pickVideoFile.value, null, videoEndTime],
        );
        pickVideoFile.value = null;
      } else if (result.xFiles.single.path.toLowerCase().endsWithAny(
          ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic', 'heif'])) {
        pickImageFile.value = result.xFiles.single;
        await Get.toNamed(
          Routes.CREATE_REELS,
          arguments: [pickImageFile.value, null, null],
        );
      }
    }
  }

  // Get Video Duration Func
  Future<double?> getVideoDuration(String filePath) async {
    VideoPlayerController controller =
        VideoPlayerController.file(File(filePath));
    await controller.initialize();
    Duration? duration = controller.value.duration;
    if (duration.inSeconds > 180) {
      return (duration.inSeconds.toDouble());
    }
    debugPrint('Video Duration::::::::::::::$duration');
    await controller.dispose();
    return duration.inSeconds.toDouble();
  }
}
