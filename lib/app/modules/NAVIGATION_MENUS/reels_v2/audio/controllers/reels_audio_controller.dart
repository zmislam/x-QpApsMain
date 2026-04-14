import 'package:get/get.dart';
import '../../models/reel_sound_model.dart';
import '../../services/reels_v2_sound_service.dart';

/// Reels V2 Audio Controller — manages music library, sound selection,
/// audio trim, voiceover, sound effects, and saved sounds.
class ReelsAudioController extends GetxController {
  final ReelsV2SoundService _soundService = ReelsV2SoundService();

  // ─── State ─────────────────────────────────────────────
  final RxList<ReelSoundModel> trendingSounds = <ReelSoundModel>[].obs;
  final RxList<ReelSoundModel> searchResults = <ReelSoundModel>[].obs;
  final RxList<ReelSoundModel> savedSounds = <ReelSoundModel>[].obs;
  final RxList<ReelSoundModel> recentSounds = <ReelSoundModel>[].obs;
  final RxList<String> soundEffectCategories = <String>[].obs;
  final RxList<ReelSoundModel> soundEffects = <ReelSoundModel>[].obs;

  // Browse categories
  final RxList<String> genres = <String>[
    'Pop', 'Hip Hop', 'R&B', 'Electronic', 'Rock', 'Latin',
    'Country', 'Jazz', 'Classical', 'Indie', 'K-Pop', 'Afrobeats',
  ].obs;
  final RxList<String> moods = <String>[
    'Happy', 'Sad', 'Energetic', 'Chill', 'Romantic', 'Dark',
    'Motivational', 'Funny', 'Dramatic', 'Peaceful',
  ].obs;

  // Selected sound
  final Rx<ReelSoundModel?> selectedSound = Rx<ReelSoundModel?>(null);
  final RxBool isPlaying = false.obs;

  // Trim state
  final RxInt trimStartMs = 0.obs;
  final RxInt trimEndMs = 0.obs;
  final RxInt trimDurationMs = 15000.obs; // default 15s

  // Audio mix
  final RxDouble originalVolume = 1.0.obs;
  final RxDouble musicVolume = 0.8.obs;
  final RxDouble voiceoverVolume = 0.0.obs;

  // Voiceover
  final RxBool isRecordingVoiceover = false.obs;
  final RxString? voiceoverPath = RxString('');
  final RxInt voiceoverDurationMs = 0.obs;

  // Loading states
  final RxBool isLoadingTrending = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoadingSaved = false.obs;

  // Search
  final RxString searchQuery = ''.obs;
  final RxString selectedGenre = ''.obs;
  final RxString selectedMood = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      fetchTrendingSounds(),
      fetchSavedSounds(),
      _loadSoundEffectCategories(),
    ]);
  }

  // ─── Browse / Fetch ─────────────────────────────────────

  Future<void> fetchTrendingSounds() async {
    isLoadingTrending.value = true;
    try {
      final sounds = await _soundService.getTrendingSounds();
      trendingSounds.assignAll(sounds);
    } catch (_) {
      // Handle silently
    } finally {
      isLoadingTrending.value = false;
    }
  }

  Future<void> searchSounds(String query) async {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }
    isSearching.value = true;
    try {
      final sounds = await _soundService.searchSounds(query);
      searchResults.assignAll(sounds);
    } catch (_) {
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> fetchSoundsByGenre(String genre) async {
    selectedGenre.value = genre;
    isSearching.value = true;
    try {
      final sounds = await _soundService.getSoundsByGenre(genre);
      searchResults.assignAll(sounds);
    } catch (_) {
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> fetchSoundsByMood(String mood) async {
    selectedMood.value = mood;
    isSearching.value = true;
    try {
      final sounds = await _soundService.getSoundsByMood(mood);
      searchResults.assignAll(sounds);
    } catch (_) {
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> fetchSavedSounds() async {
    isLoadingSaved.value = true;
    try {
      final sounds = await _soundService.getSavedSounds();
      savedSounds.assignAll(sounds);
    } catch (_) {
      // Handle silently
    } finally {
      isLoadingSaved.value = false;
    }
  }

  Future<void> _loadSoundEffectCategories() async {
    soundEffectCategories.assignAll([
      'Transitions', 'Comedy', 'Nature', 'Action',
      'Horror', 'Ambient', 'UI', 'Animals',
      'Musical', 'Weather',
    ]);
  }

  Future<void> fetchSoundEffects(String category) async {
    try {
      final effects = await _soundService.getSoundEffects(category);
      soundEffects.assignAll(effects);
    } catch (_) {
      soundEffects.clear();
    }
  }

  // ─── Sound Selection ────────────────────────────────────

  void selectSound(ReelSoundModel sound) {
    selectedSound.value = sound;
    trimStartMs.value = 0;
    final duration = sound.durationMs ?? 30000;
    trimEndMs.value = duration.clamp(0, trimDurationMs.value);
    isPlaying.value = false;
  }

  void clearSelectedSound() {
    selectedSound.value = null;
    isPlaying.value = false;
    trimStartMs.value = 0;
    trimEndMs.value = 0;
  }

  void togglePlayback() {
    isPlaying.value = !isPlaying.value;
    // Actual playback handled by audio player widget
  }

  // ─── Trim ───────────────────────────────────────────────

  void setTrimRange(int startMs, int endMs) {
    final soundDuration = selectedSound.value?.durationMs ?? 90000;
    trimStartMs.value = startMs.clamp(0, soundDuration);
    trimEndMs.value = endMs.clamp(startMs, soundDuration);
  }

  void setTrimDuration(int durationMs) {
    trimDurationMs.value = durationMs.clamp(15000, 90000);
    // Re-clamp end to new duration
    final maxEnd = trimStartMs.value + trimDurationMs.value;
    final soundDuration = selectedSound.value?.durationMs ?? 90000;
    trimEndMs.value = maxEnd.clamp(trimStartMs.value, soundDuration);
  }

  int get trimmedDurationMs => trimEndMs.value - trimStartMs.value;

  // ─── Audio Mix ──────────────────────────────────────────

  void setOriginalVolume(double v) => originalVolume.value = v.clamp(0.0, 1.0);
  void setMusicVolume(double v) => musicVolume.value = v.clamp(0.0, 1.0);
  void setVoiceoverVolume(double v) => voiceoverVolume.value = v.clamp(0.0, 1.0);

  // ─── Voiceover ──────────────────────────────────────────

  void startVoiceoverRecording() {
    isRecordingVoiceover.value = true;
    voiceoverDurationMs.value = 0;
    // Actual recording handled by platform plugin
  }

  void stopVoiceoverRecording(String path, int durationMs) {
    isRecordingVoiceover.value = false;
    voiceoverPath?.value = path;
    voiceoverDurationMs.value = durationMs;
    voiceoverVolume.value = 1.0;
  }

  void discardVoiceover() {
    voiceoverPath?.value = '';
    voiceoverDurationMs.value = 0;
    voiceoverVolume.value = 0.0;
    isRecordingVoiceover.value = false;
  }

  bool get hasVoiceover =>
      voiceoverPath?.value != null && voiceoverPath!.value.isNotEmpty;

  // ─── Save / Unsave ─────────────────────────────────────

  Future<void> toggleSaveSound(ReelSoundModel sound) async {
    try {
      if (sound.isSaved == true) {
        await _soundService.unsaveSound(sound.id!);
        sound.isSaved = false;
        savedSounds.removeWhere((s) => s.id == sound.id);
      } else {
        await _soundService.saveSound(sound.id!);
        sound.isSaved = true;
        savedSounds.add(sound);
      }
      // Refresh the lists
      trendingSounds.refresh();
      searchResults.refresh();
    } catch (_) {
      // Handle silently
    }
  }

  // ─── Use Sound from Reel ───────────────────────────────

  void useSoundFromReel(String soundId, String? soundTitle) {
    // Navigate to camera with this sound pre-selected
    // Actual navigation handled by caller
    selectedSound.value = ReelSoundModel(
      id: soundId,
      title: soundTitle ?? 'Original Sound',
    );
  }
}
