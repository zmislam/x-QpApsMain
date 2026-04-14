import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/reels_v2_api_service.dart';
import '../../services/reels_v2_upload_service.dart';
import '../../models/reel_v2_model.dart';

/// Reels V2 Publish Controller — manages the entire publish flow:
/// caption, thumbnail, tags, privacy, scheduling, cross-post, collab, and upload.
class ReelsPublishController extends GetxController {
  final ReelsV2ApiService _apiService = ReelsV2ApiService();
  late final ReelsV2UploadService _uploadService;

  // ─── Video Data (passed from editor/camera) ──────────
  File? videoFile;
  String? editedVideoPath;
  String? soundId;
  Map<String, dynamic>? editingState;

  // ─── Caption ─────────────────────────────────────────
  final captionController = TextEditingController();
  final RxList<String> hashtags = <String>[].obs;
  final RxList<String> mentions = <String>[].obs;
  static const int maxCaptionLength = 2200;

  // ─── Thumbnail ───────────────────────────────────────
  final Rx<File?> selectedThumbnail = Rx<File?>(null);
  final Rx<File?> abThumbnailA = Rx<File?>(null);
  final Rx<File?> abThumbnailB = Rx<File?>(null);
  final RxBool useAbThumbnail = false.obs;
  final RxDouble thumbnailFramePosition = 0.0.obs;

  // ─── Location ────────────────────────────────────────
  final Rx<String?> locationId = Rx<String?>(null);
  final Rx<String?> locationName = Rx<String?>(null);

  // ─── People Tags ─────────────────────────────────────
  final RxList<Map<String, String>> taggedPeople = <Map<String, String>>[].obs;

  // ─── Topics ──────────────────────────────────────────
  final RxList<String> selectedTopicIds = <String>[].obs;
  final RxList<String> selectedTopicNames = <String>[].obs;
  static const int maxTopics = 3;

  // ─── Privacy ─────────────────────────────────────────
  final RxString privacy = 'public'.obs; // public | friends | private
  final RxString commentPermission = 'everyone'.obs; // everyone | friends | off
  final RxBool allowRemix = true.obs;
  final RxBool allowDownload = true.obs;

  // ─── Cross-Post ──────────────────────────────────────
  final RxBool crossPostToFeed = true.obs;
  final RxBool crossPostToStories = false.obs;

  // ─── Schedule ────────────────────────────────────────
  final RxBool isScheduled = false.obs;
  final Rx<DateTime?> scheduledDate = Rx<DateTime?>(null);

  // ─── Collab ──────────────────────────────────────────
  final Rx<String?> collabUserId = Rx<String?>(null);
  final Rx<String?> collabUserName = Rx<String?>(null);

  // ─── Upload State ────────────────────────────────────
  final RxBool isPublishing = false.obs;
  final RxBool isUploadingInBackground = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final Rx<String?> uploadError = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _uploadService = ReelsV2UploadService();

    // Accept data from previous screen
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      editedVideoPath = args['videoPath'] as String?;
      soundId = args['soundId'] as String?;
      editingState = args['editingState'] as Map<String, dynamic>?;
      if (editedVideoPath != null) {
        videoFile = File(editedVideoPath!);
      }
    }
  }

  @override
  void onClose() {
    captionController.dispose();
    super.onClose();
  }

  // ─── Caption Helpers ─────────────────────────────────

  void updateCaption(String text) {
    // Extract hashtags
    final hashtagRegex = RegExp(r'#(\w+)');
    hashtags.value =
        hashtagRegex.allMatches(text).map((m) => m.group(1)!).toList();

    // Extract mentions
    final mentionRegex = RegExp(r'@(\w+)');
    mentions.value =
        mentionRegex.allMatches(text).map((m) => m.group(1)!).toList();
  }

  void insertHashtag(String tag) {
    final current = captionController.text;
    captionController.text = '$current #$tag ';
    captionController.selection = TextSelection.fromPosition(
      TextPosition(offset: captionController.text.length),
    );
    updateCaption(captionController.text);
  }

  void insertMention(String username) {
    final current = captionController.text;
    captionController.text = '$current @$username ';
    captionController.selection = TextSelection.fromPosition(
      TextPosition(offset: captionController.text.length),
    );
    updateCaption(captionController.text);
  }

  // ─── Thumbnail ───────────────────────────────────────

  void selectThumbnailFromFrame(double position) {
    thumbnailFramePosition.value = position;
    // In real impl: extract frame at position from video
  }

  void selectCustomThumbnail(File file) {
    selectedThumbnail.value = file;
  }

  void setAbThumbnailA(File file) {
    abThumbnailA.value = file;
    useAbThumbnail.value = true;
  }

  void setAbThumbnailB(File file) {
    abThumbnailB.value = file;
    useAbThumbnail.value = true;
  }

  void clearAbThumbnail() {
    abThumbnailA.value = null;
    abThumbnailB.value = null;
    useAbThumbnail.value = false;
  }

  // ─── Location ────────────────────────────────────────

  void setLocation(String id, String name) {
    locationId.value = id;
    locationName.value = name;
  }

  void clearLocation() {
    locationId.value = null;
    locationName.value = null;
  }

  // ─── People Tags ─────────────────────────────────────

  void addTaggedPerson(String userId, String name) {
    if (!taggedPeople.any((p) => p['userId'] == userId)) {
      taggedPeople.add({'userId': userId, 'name': name});
    }
  }

  void removeTaggedPerson(String userId) {
    taggedPeople.removeWhere((p) => p['userId'] == userId);
  }

  // ─── Topics ──────────────────────────────────────────

  void toggleTopic(String topicId, String topicName) {
    if (selectedTopicIds.contains(topicId)) {
      final idx = selectedTopicIds.indexOf(topicId);
      selectedTopicIds.removeAt(idx);
      selectedTopicNames.removeAt(idx);
    } else if (selectedTopicIds.length < maxTopics) {
      selectedTopicIds.add(topicId);
      selectedTopicNames.add(topicName);
    }
  }

  // ─── Schedule ────────────────────────────────────────

  void setSchedule(DateTime dateTime) {
    scheduledDate.value = dateTime;
    isScheduled.value = true;
  }

  void clearSchedule() {
    scheduledDate.value = null;
    isScheduled.value = false;
  }

  // ─── Collab ──────────────────────────────────────────

  void setCollabUser(String userId, String name) {
    collabUserId.value = userId;
    collabUserName.value = name;
  }

  void removeCollab() {
    collabUserId.value = null;
    collabUserName.value = null;
  }

  // ─── Build Publish Data ──────────────────────────────

  Map<String, dynamic> _buildPublishPayload() {
    return {
      'caption': captionController.text.trim(),
      'hashtags': hashtags.toList(),
      'mentioned_user_ids': mentions.toList(),
      'tagged_people': taggedPeople
          .map((p) => {'user_id': p['userId'], 'name': p['name']})
          .toList(),
      if (locationId.value != null) 'location_id': locationId.value,
      if (locationName.value != null) 'location_name': locationName.value,
      'topic_ids': selectedTopicIds.toList(),
      'privacy': privacy.value,
      'comment_permission': commentPermission.value,
      'allow_remix': allowRemix.value,
      'allow_download': allowDownload.value,
      'cross_post_feed': crossPostToFeed.value,
      'cross_post_stories': crossPostToStories.value,
      if (soundId != null) 'sound_id': soundId,
      if (collabUserId.value != null) 'collab_author_id': collabUserId.value,
      if (isScheduled.value && scheduledDate.value != null)
        'scheduled_at': scheduledDate.value!.toIso8601String(),
    };
  }

  // ─── Publish ─────────────────────────────────────────

  Future<void> publish() async {
    if (videoFile == null && editedVideoPath == null) {
      Get.snackbar('Error', 'No video to publish');
      return;
    }

    isPublishing.value = true;
    uploadError.value = null;

    try {
      final payload = _buildPublishPayload();

      if (isScheduled.value && scheduledDate.value != null) {
        // Schedule publish
        final response = await _apiService.scheduleReel(payload);
        if (response.data != null) {
          Get.snackbar('Scheduled', 'Reel scheduled for ${scheduledDate.value}');
          _navigateAfterPublish();
        }
      } else {
        // Upload in background
        isUploadingInBackground.value = true;
        _navigateAfterPublish();

        await _uploadService.uploadReel(
          videoPath: editedVideoPath ?? videoFile!.path,
          payload: payload,
          thumbnailFile: selectedThumbnail.value,
          abThumbnailA: useAbThumbnail.value ? abThumbnailA.value : null,
          abThumbnailB: useAbThumbnail.value ? abThumbnailB.value : null,
          onProgress: (progress) {
            uploadProgress.value = progress;
          },
        );

        isUploadingInBackground.value = false;
      }
    } catch (e) {
      uploadError.value = e.toString();
      Get.snackbar('Upload Failed', 'Tap to retry',
          onTap: (_) => publish());
    } finally {
      isPublishing.value = false;
    }
  }

  // ─── Save as Draft ──────────────────────────────────

  Future<void> saveAsDraft() async {
    try {
      final draftData = _buildPublishPayload();
      draftData['video_path'] = editedVideoPath ?? videoFile?.path;
      draftData['editing_state'] = editingState;
      draftData['status'] = 'draft';

      await _apiService.saveDraft(draftData);
      Get.snackbar('Saved', 'Draft saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save draft');
    }
  }

  // ─── Auto-save on exit ──────────────────────────────

  Future<void> autoSaveDraft() async {
    // Only auto-save if there's meaningful content
    final hasCaption = captionController.text.trim().isNotEmpty;
    final hasVideo = videoFile != null || editedVideoPath != null;
    if (hasCaption || hasVideo) {
      await saveAsDraft();
    }
  }

  void _navigateAfterPublish() {
    Get.until((route) => route.isFirst);
  }
}
