import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../enum/live_post_type_enum.dart';

import '../../../data/post_local_data.dart';

class GoLiveController extends GetxController with WidgetsBindingObserver {
  // ========================== camera variables ===============================
  List<CameraDescription> cameras = <CameraDescription>[];
  Rx<CameraController?> cameraController = Rx(null);
  Rx<int> currentCameraIndex = 1.obs;
  Rx<bool> isCameraInitialaized = Rx(false);
  LivePostTypeEnum livePostTypeEnum = LivePostTypeEnum.ON_TIMELINE;

  // ========================== switch camera ==================================

// ========================== switch camera ==================================
  Future<void> switchCamera() async {
    try {
      // Set camera as not initialized during switch
      isCameraInitialaized.value = false;
      update();

      // Dispose of current controller
      await cameraController.value?.dispose();
      cameraController.value = null;

      // Switch to the other camera (front/back toggle)
      currentCameraIndex.value = currentCameraIndex.value == 0 ? 1 : 0;

      // Small delay to ensure disposal is complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Reinitialize with new camera
      await initializeCamera();
    } catch (e) {
      debugPrint('Error switching camera: $e');
      isCameraInitialaized.value = false;
      update();
    }
  }

// ========================== initialize camera ==============================
  Future<void> initializeCamera() async {
    try {
      // Get available cameras if not already loaded
      if (cameras.isEmpty) {
        cameras = await availableCameras();
      }

      // Ensure we have cameras available
      if (cameras.isEmpty) {
        debugPrint('No cameras available');
        return;
      }

      // Find front camera for initial setup (or use index 0 if front not found)
      if (currentCameraIndex.value == -1) {
        // First time initialization - find front camera
        for (int i = 0; i < cameras.length; i++) {
          if (cameras[i].lensDirection == CameraLensDirection.front) {
            currentCameraIndex.value = i;
            break;
          }
        }
        // If no front camera found, use first available
        if (currentCameraIndex.value == -1) {
          currentCameraIndex.value = 0;
        }
      }

      // Ensure index is valid
      if (currentCameraIndex.value >= cameras.length) {
        currentCameraIndex.value = 0;
      }

      // Create new camera controller
      cameraController.value = CameraController(
        cameras[currentCameraIndex.value],
        ResolutionPreset.medium,
        enableAudio: false, // Add this if you don't need audio
      );

      // Initialize the controller
      await cameraController.value!.initialize();

      // Apply camera settings
      await cameraController.value!.lockCaptureOrientation();
      await cameraController.value!.setFocusMode(FocusMode.auto);

      // Update UI
      isCameraInitialaized.value = true;
      cameraController.refresh();
      update();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      isCameraInitialaized.value = false;
      update();
    }
  }

// ========================== Additional helper method ====================
  void initializeCameraOnStart() {
    // Set initial index to -1 to trigger front camera search
    currentCameraIndex.value = -1;
    initializeCamera();
  }

  // ========================= screen overlay utils ============================
  void screenOverlayUtils() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light));
  }

  RxString dropdownValue = privacyList.first.obs;
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    screenOverlayUtils();
    WidgetsBinding.instance.addObserver(this);
    // initializeCamera();
    initializeCameraOnStart();
  }

  @override
  void onClose() {
    super.onClose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    WidgetsBinding.instance.removeObserver(this);
    cameraController.value?.dispose();
  }
}
