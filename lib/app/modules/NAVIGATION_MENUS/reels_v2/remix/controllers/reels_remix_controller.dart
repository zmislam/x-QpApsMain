import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../services/reels_v2_api_service.dart';
import '../../models/reel_v2_model.dart';
import '../../models/reel_remix_model.dart';

/// Reels V2 Remix Controller — manages duet, stitch, and green screen remix.
class ReelsRemixController extends GetxController {
  final ReelsV2ApiService _apiService = ReelsV2ApiService();

  // ─── Source Reel ─────────────────────────────────────
  Rx<ReelV2Model?> sourceReel = Rx<ReelV2Model?>(null);
  VideoPlayerController? sourceVideoController;

  // ─── Remix Type ──────────────────────────────────────
  final RxString remixType = 'duet'.obs; // duet | stitch | greenScreen
  final RxBool isRecording = false.obs;
  final RxBool hasRecorded = false.obs;

  // ─── Layout (for duet) ──────────────────────────────
  final RxString layout = 'side-by-side'.obs; // side-by-side | top-bottom | pip

  // ─── Stitch Settings ────────────────────────────────
  final RxInt stitchDurationSec = 5.obs; // 1-5 seconds of source
  static const int minStitchSec = 1;
  static const int maxStitchSec = 5;

  // ─── Audio Mix ──────────────────────────────────────
  final RxDouble sourceVolume = 1.0.obs;
  final RxDouble recordingVolume = 1.0.obs;
  final RxBool muteOriginal = false.obs;

  // ─── Remix Chain ────────────────────────────────────
  final RxList<ReelRemixModel> remixChain = <ReelRemixModel>[].obs;
  final RxBool isLoadingChain = false.obs;

  // ─── Collab Attribution ─────────────────────────────
  final Rx<String?> originalAuthorName = Rx<String?>(null);
  final Rx<String?> originalAuthorAvatar = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _loadSourceReel(args);
    }
  }

  @override
  void onClose() {
    sourceVideoController?.dispose();
    super.onClose();
  }

  // ─── Load Source ────────────────────────────────────

  void _loadSourceReel(Map<String, dynamic> args) {
    if (args['sourceReel'] != null) {
      sourceReel.value = ReelV2Model.fromMap(args['sourceReel']);
    }
    if (args['remixType'] != null) {
      remixType.value = args['remixType'] as String;
    }

    final reel = sourceReel.value;
    if (reel?.videoUrl != null) {
      sourceVideoController = VideoPlayerController.networkUrl(
        Uri.parse(reel!.videoUrl!),
      )..initialize().then((_) {
          update();
        });
    }

    // Set attribution
    originalAuthorName.value = args['authorName'] as String?;
    originalAuthorAvatar.value = args['authorAvatar'] as String?;
  }

  // ─── Layout ─────────────────────────────────────────

  void setLayout(String newLayout) {
    layout.value = newLayout;
  }

  // ─── Stitch Duration ────────────────────────────────

  void setStitchDuration(int seconds) {
    stitchDurationSec.value = seconds.clamp(minStitchSec, maxStitchSec);
  }

  // ─── Audio ──────────────────────────────────────────

  void setSourceVolume(double volume) {
    sourceVolume.value = volume.clamp(0.0, 1.0);
    sourceVideoController?.setVolume(volume);
  }

  void setRecordingVolume(double volume) {
    recordingVolume.value = volume.clamp(0.0, 1.0);
  }

  void toggleMuteOriginal() {
    muteOriginal.value = !muteOriginal.value;
    sourceVideoController?.setVolume(muteOriginal.value ? 0 : sourceVolume.value);
  }

  // ─── Recording ──────────────────────────────────────

  void startRecording() {
    isRecording.value = true;
    // Play source video alongside recording
    sourceVideoController?.play();
  }

  void stopRecording() {
    isRecording.value = false;
    hasRecorded.value = true;
    sourceVideoController?.pause();
  }

  // ─── Submit Remix ───────────────────────────────────

  Future<void> submitRemix({
    required String recordedVideoPath,
  }) async {
    final reel = sourceReel.value;
    if (reel == null) return;

    try {
      final data = {
        'source_reel_id': reel.id,
        'remix_type': remixType.value,
        'layout': layout.value,
        'source_volume': sourceVolume.value,
        'recording_volume': recordingVolume.value,
        'recorded_video_path': recordedVideoPath,
        if (remixType.value == 'stitch')
          'stitch_duration_sec': stitchDurationSec.value,
      };

      await _apiService.createRemix(data);
      Get.snackbar('Success', 'Remix created!');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create remix');
    }
  }

  // ─── Remix Chain ────────────────────────────────────

  Future<void> loadRemixChain(String reelId) async {
    isLoadingChain.value = true;
    try {
      final response = await _apiService.getRemixChain(reelId);
      if (response.data != null && (response.data as Map)['chain'] != null) {
        remixChain.value = ((response.data as Map)['chain'] as List)
            .map((e) => ReelRemixModel.fromMap(e))
            .toList();
      }
    } catch (_) {}
    isLoadingChain.value = false;
  }
}
