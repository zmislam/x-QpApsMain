import 'package:get/get.dart';
import '../../services/reels_v2_api_service.dart';
import '../../utils/reel_constants.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../models/api_response.dart';

class ReelsSettingsController extends GetxController {
  final ReelsV2ApiService _apiService = ReelsV2ApiService();
  final ApiCommunication _api = ApiCommunication();

  // ─── Autoplay ──────────────────────────────────────────
  /// Values: 'on', 'wifi_only', 'off'
  final autoplaySetting = 'on'.obs;

  // ─── Data Saver ────────────────────────────────────────
  final dataSaverEnabled = false.obs;

  // ─── Auto-Captions ────────────────────────────────────
  final autoCaptionsEnabled = false.obs;

  // ─── Caption Translation ──────────────────────────────
  final captionTranslationEnabled = false.obs;

  // ─── Content Preferences ──────────────────────────────
  final availableTopics = <String>[].obs;
  final selectedTopics = <String>[].obs;

  // ─── Hidden Words ─────────────────────────────────────
  final hiddenWords = <String>[].obs;

  // ─── Notification Preferences ─────────────────────────
  final notifLikes = true.obs;
  final notifComments = true.obs;
  final notifMentions = true.obs;
  final notifFollows = true.obs;
  final notifRemixes = true.obs;
  final notifCollabRequests = true.obs;
  final notifMilestones = true.obs;

  // ─── Watch History ────────────────────────────────────
  final watchHistory = <dynamic>[].obs;
  final isLoadingHistory = false.obs;

  // ─── Liked Reels ──────────────────────────────────────
  final likedReels = <dynamic>[].obs;
  final isLoadingLiked = false.obs;

  // ─── General ──────────────────────────────────────────
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  // ─── Load Settings ────────────────────────────────────

  Future<void> loadSettings() async {
    isLoading.value = true;
    try {
      final ApiResponse res = await _api.doGetRequest(
        apiEndPoint: ReelConstants.settings,
      );
      if (res.isSuccessful && res.data != null) {
        final data = res.data as Map<String, dynamic>;
        autoplaySetting.value = data['autoplay'] ?? 'on';
        dataSaverEnabled.value = data['dataSaver'] ?? false;
        autoCaptionsEnabled.value = data['autoCaptions'] ?? false;
        captionTranslationEnabled.value = data['captionTranslation'] ?? false;
        availableTopics.value = List<String>.from(data['availableTopics'] ?? []);
        selectedTopics.value = List<String>.from(data['selectedTopics'] ?? []);
        hiddenWords.value = List<String>.from(data['hiddenWords'] ?? []);

        // Notification prefs
        final notifs = data['notifications'] as Map<String, dynamic>? ?? {};
        notifLikes.value = notifs['likes'] ?? true;
        notifComments.value = notifs['comments'] ?? true;
        notifMentions.value = notifs['mentions'] ?? true;
        notifFollows.value = notifs['follows'] ?? true;
        notifRemixes.value = notifs['remixes'] ?? true;
        notifCollabRequests.value = notifs['collabRequests'] ?? true;
        notifMilestones.value = notifs['milestones'] ?? true;
      }
    } catch (_) {}
    isLoading.value = false;
  }

  // ─── Save Settings ────────────────────────────────────

  Future<void> _saveSettings() async {
    await _api.doPutRequest(
      apiEndPoint: ReelConstants.settings,
      requestData: {
        'autoplay': autoplaySetting.value,
        'dataSaver': dataSaverEnabled.value,
        'autoCaptions': autoCaptionsEnabled.value,
        'captionTranslation': captionTranslationEnabled.value,
        'selectedTopics': selectedTopics,
        'notifications': {
          'likes': notifLikes.value,
          'comments': notifComments.value,
          'mentions': notifMentions.value,
          'follows': notifFollows.value,
          'remixes': notifRemixes.value,
          'collabRequests': notifCollabRequests.value,
          'milestones': notifMilestones.value,
        },
      },
    );
  }

  // ─── Autoplay ─────────────────────────────────────────

  void setAutoplay(String value) {
    autoplaySetting.value = value;
    _saveSettings();
  }

  // ─── Data Saver ───────────────────────────────────────

  void toggleDataSaver(bool value) {
    dataSaverEnabled.value = value;
    _saveSettings();
  }

  // ─── Auto-Captions ───────────────────────────────────

  void toggleAutoCaptions(bool value) {
    autoCaptionsEnabled.value = value;
    _saveSettings();
  }

  // ─── Caption Translation ─────────────────────────────

  void toggleCaptionTranslation(bool value) {
    captionTranslationEnabled.value = value;
    _saveSettings();
  }

  // ─── Content Preferences ─────────────────────────────

  void toggleTopic(String topic) {
    if (selectedTopics.contains(topic)) {
      selectedTopics.remove(topic);
    } else {
      selectedTopics.add(topic);
    }
    _saveSettings();
  }

  // ─── Hidden Words ────────────────────────────────────

  Future<void> addHiddenWord(String word) async {
    if (word.trim().isEmpty || hiddenWords.contains(word.trim())) return;
    hiddenWords.add(word.trim());
    await _api.doPostRequest(
      apiEndPoint: ReelConstants.hiddenWords,
      requestData: {'words': hiddenWords},
    );
  }

  Future<void> removeHiddenWord(String word) async {
    hiddenWords.remove(word);
    await _api.doPutRequest(
      apiEndPoint: ReelConstants.hiddenWords,
      requestData: {'words': hiddenWords},
    );
  }

  // ─── Notifications ───────────────────────────────────

  void setNotifPref(String key, bool value) {
    switch (key) {
      case 'likes':
        notifLikes.value = value;
        break;
      case 'comments':
        notifComments.value = value;
        break;
      case 'mentions':
        notifMentions.value = value;
        break;
      case 'follows':
        notifFollows.value = value;
        break;
      case 'remixes':
        notifRemixes.value = value;
        break;
      case 'collabRequests':
        notifCollabRequests.value = value;
        break;
      case 'milestones':
        notifMilestones.value = value;
        break;
    }
    _saveSettings();
  }

  // ─── Watch History ───────────────────────────────────

  Future<void> loadWatchHistory() async {
    isLoadingHistory.value = true;
    try {
      final ApiResponse res = await _api.doGetRequest(
        apiEndPoint: ReelConstants.watchHistory,
      );
      if (res.isSuccessful && res.data != null) {
        watchHistory.value = res.data as List<dynamic>;
      }
    } catch (_) {}
    isLoadingHistory.value = false;
  }

  Future<void> clearWatchHistory() async {
    await _api.doDeleteRequest(
      apiEndPoint: ReelConstants.watchHistory,
    );
    watchHistory.clear();
  }

  // ─── Liked Reels ────────────────────────────────────

  Future<void> loadLikedReels() async {
    isLoadingLiked.value = true;
    try {
      final ApiResponse res = await _api.doGetRequest(
        apiEndPoint: ReelConstants.likedReels,
      );
      if (res.isSuccessful && res.data != null) {
        likedReels.value = res.data as List<dynamic>;
      }
    } catch (_) {}
    isLoadingLiked.value = false;
  }
}
