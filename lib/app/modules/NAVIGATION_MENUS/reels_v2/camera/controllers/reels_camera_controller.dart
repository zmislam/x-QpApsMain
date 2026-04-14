import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/reel_draft_model.dart';

/// Reels V2 camera controller.
/// Manages: camera preview, multi-segment recording, speed control,
/// countdown timer, flash, zoom, hands-free, gallery picker.
class ReelsCameraController extends GetxController with GetTickerProviderStateMixin {
  CameraController? cameraController;
  List<CameraDescription> _cameras = [];

  // ─── Camera State ──────────────────────────────────────
  final RxBool isInitialized = false.obs;
  final RxBool isRecording = false.obs;
  final RxBool isFrontCamera = true.obs;
  final RxBool isHandsFreeMode = false.obs;

  // ─── Flash ─────────────────────────────────────────────
  final Rx<FlashMode> flashMode = FlashMode.off.obs;

  // ─── Zoom ──────────────────────────────────────────────
  final RxDouble currentZoom = 1.0.obs;
  final RxDouble minZoom = 1.0.obs;
  final RxDouble maxZoom = 1.0.obs;

  // ─── Duration Limit ────────────────────────────────────
  final RxInt durationLimitSeconds = 60.obs;
  final List<int> availableDurations = [15, 30, 60, 90];

  // ─── Speed ─────────────────────────────────────────────
  final RxDouble recordingSpeed = 1.0.obs;
  final List<double> availableSpeeds = [0.3, 0.5, 1.0, 2.0, 3.0];

  // ─── Countdown Timer ───────────────────────────────────
  final RxInt countdownSeconds = 0.obs;
  final RxBool isCountingDown = false.obs;
  Timer? _countdownTimer;

  // ─── Segments ──────────────────────────────────────────
  final RxList<RecordingSegment> segments = <RecordingSegment>[].obs;
  final RxDouble totalRecordedSeconds = 0.0.obs;
  Timer? _recordingTimer;
  double _currentSegmentDuration = 0.0;

  // ─── Gallery ───────────────────────────────────────────
  final RxList<XFile> selectedGalleryFiles = <XFile>[].obs;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    cameraController?.dispose();
    super.onClose();
  }

  // ═══════════════════════════════════════════════════════
  // CAMERA INIT
  // ═══════════════════════════════════════════════════════

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      // Default to front camera
      final frontCam = _cameras.firstWhereOrNull(
        (c) => c.lensDirection == CameraLensDirection.front,
      );

      await _setupCamera(frontCam ?? _cameras.first);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _setupCamera(CameraDescription camera) async {
    cameraController?.dispose();
    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await cameraController!.initialize();
      minZoom.value = await cameraController!.getMinZoomLevel();
      maxZoom.value = await cameraController!.getMaxZoomLevel();
      currentZoom.value = 1.0;
      isInitialized.value = true;
    } catch (e) {
      debugPrint('Camera setup error: $e');
      isInitialized.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════
  // CAMERA SWITCH
  // ═══════════════════════════════════════════════════════

  Future<void> toggleCamera() async {
    if (_cameras.length < 2 || isRecording.value) return;
    isFrontCamera.value = !isFrontCamera.value;

    final target = _cameras.firstWhereOrNull((c) =>
        c.lensDirection ==
        (isFrontCamera.value
            ? CameraLensDirection.front
            : CameraLensDirection.back));

    if (target != null) {
      isInitialized.value = false;
      await _setupCamera(target);
    }
  }

  // ═══════════════════════════════════════════════════════
  // FLASH
  // ═══════════════════════════════════════════════════════

  Future<void> toggleFlash() async {
    if (cameraController == null) return;

    final modes = [FlashMode.off, FlashMode.torch, FlashMode.auto];
    final currentIndex = modes.indexOf(flashMode.value);
    final nextMode = modes[(currentIndex + 1) % modes.length];

    await cameraController!.setFlashMode(nextMode);
    flashMode.value = nextMode;
  }

  // ═══════════════════════════════════════════════════════
  // ZOOM
  // ═══════════════════════════════════════════════════════

  Future<void> setZoom(double zoom) async {
    final clamped = zoom.clamp(minZoom.value, maxZoom.value);
    await cameraController?.setZoomLevel(clamped);
    currentZoom.value = clamped;
  }

  /// Pinch zoom handler delta
  Future<void> handlePinchZoom(double scale) async {
    final newZoom = (currentZoom.value * scale).clamp(minZoom.value, maxZoom.value);
    await setZoom(newZoom);
  }

  // ═══════════════════════════════════════════════════════
  // DURATION & SPEED
  // ═══════════════════════════════════════════════════════

  void setDurationLimit(int seconds) {
    if (availableDurations.contains(seconds) && !isRecording.value) {
      durationLimitSeconds.value = seconds;
    }
  }

  void setRecordingSpeed(double speed) {
    if (availableSpeeds.contains(speed) && !isRecording.value) {
      recordingSpeed.value = speed;
    }
  }

  // ═══════════════════════════════════════════════════════
  // COUNTDOWN TIMER
  // ═══════════════════════════════════════════════════════

  void startCountdown(int seconds) {
    if (isRecording.value || isCountingDown.value) return;

    countdownSeconds.value = seconds;
    isCountingDown.value = true;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownSeconds.value--;
      if (countdownSeconds.value <= 0) {
        timer.cancel();
        isCountingDown.value = false;
        startRecording();
      }
    });
  }

  void cancelCountdown() {
    _countdownTimer?.cancel();
    isCountingDown.value = false;
    countdownSeconds.value = 0;
  }

  // ═══════════════════════════════════════════════════════
  // RECORDING
  // ═══════════════════════════════════════════════════════

  Future<void> startRecording() async {
    if (cameraController == null || isRecording.value) return;
    if (totalRecordedSeconds.value >= durationLimitSeconds.value) return;

    try {
      await cameraController!.startVideoRecording();
      isRecording.value = true;
      _currentSegmentDuration = 0.0;

      // Track recording time
      _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        _currentSegmentDuration += 0.1;
        final adjustedDuration = _currentSegmentDuration / recordingSpeed.value;
        final newTotal = _calculateTotalDuration() + adjustedDuration;

        totalRecordedSeconds.value = newTotal;

        // Auto-stop at limit
        if (newTotal >= durationLimitSeconds.value) {
          stopRecording();
        }
      });
    } catch (e) {
      debugPrint('Start recording error: $e');
      isRecording.value = false;
    }
  }

  Future<void> stopRecording() async {
    if (cameraController == null || !isRecording.value) return;

    _recordingTimer?.cancel();
    isRecording.value = false;

    try {
      final file = await cameraController!.stopVideoRecording();
      final adjustedDuration = _currentSegmentDuration / recordingSpeed.value;

      segments.add(RecordingSegment(
        filePath: file.path,
        durationSeconds: adjustedDuration,
        speed: recordingSpeed.value,
      ));

      totalRecordedSeconds.value = _calculateTotalDuration();
    } catch (e) {
      debugPrint('Stop recording error: $e');
    }
  }

  /// Tap toggle for hands-free mode
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  void toggleHandsFreeMode() {
    isHandsFreeMode.value = !isHandsFreeMode.value;
  }

  // ═══════════════════════════════════════════════════════
  // SEGMENTS
  // ═══════════════════════════════════════════════════════

  /// Undo last segment
  void undoLastSegment() {
    if (segments.isEmpty || isRecording.value) return;

    final removed = segments.removeLast();
    // Clean up temporary file
    try {
      File(removed.filePath).deleteSync();
    } catch (_) {}

    totalRecordedSeconds.value = _calculateTotalDuration();
  }

  double _calculateTotalDuration() {
    double total = 0;
    for (final segment in segments) {
      total += segment.durationSeconds;
    }
    return total;
  }

  /// Get normalized segment widths for the progress bar (0.0–1.0 each)
  List<double> getSegmentWidths() {
    if (durationLimitSeconds.value == 0) return [];
    return segments
        .map((s) => s.durationSeconds / durationLimitSeconds.value)
        .toList();
  }

  /// Get current recording progress (0.0–1.0)
  double get currentProgress =>
      totalRecordedSeconds.value / durationLimitSeconds.value;

  bool get hasSegments => segments.isNotEmpty;

  bool get isAtLimit =>
      totalRecordedSeconds.value >= durationLimitSeconds.value;

  // ═══════════════════════════════════════════════════════
  // GALLERY PICKER
  // ═══════════════════════════════════════════════════════

  Future<void> pickFromGallery({bool multiSelect = true}) async {
    try {
      if (multiSelect) {
        final files = await _imagePicker.pickMultipleMedia();
        if (files.isNotEmpty) {
          selectedGalleryFiles.addAll(files);
        }
      } else {
        final file = await _imagePicker.pickVideo(
          source: ImageSource.gallery,
        );
        if (file != null) {
          selectedGalleryFiles.add(file);
        }
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  void removeGalleryFile(int index) {
    if (index >= 0 && index < selectedGalleryFiles.length) {
      selectedGalleryFiles.removeAt(index);
    }
  }

  // ═══════════════════════════════════════════════════════
  // PROCEED TO EDITOR
  // ═══════════════════════════════════════════════════════

  /// Proceed with recorded segments or gallery selections to the editing phase.
  void proceedToEditor() {
    if (segments.isEmpty && selectedGalleryFiles.isEmpty) return;

    final draft = ReelDraftModel(
      segments: segments.map((s) => s.filePath).toList(),
      galleryFiles: selectedGalleryFiles.map((f) => f.path).toList(),
      durationLimit: durationLimitSeconds.value,
      speed: recordingSpeed.value,
    );

    Get.toNamed('/reels-v2/editor', arguments: draft);
  }

  /// Reset camera state for new recording session.
  void resetSession() {
    // Clean up temp segment files
    for (final segment in segments) {
      try {
        File(segment.filePath).deleteSync();
      } catch (_) {}
    }
    segments.clear();
    selectedGalleryFiles.clear();
    totalRecordedSeconds.value = 0;
    _currentSegmentDuration = 0;
    recordingSpeed.value = 1.0;
    isHandsFreeMode.value = false;
    cancelCountdown();
  }
}

/// A recorded video segment.
class RecordingSegment {
  final String filePath;
  final double durationSeconds;
  final double speed;

  RecordingSegment({
    required this.filePath,
    required this.durationSeconds,
    required this.speed,
  });
}
