import '../../../../services/api_communication.dart';
import '../../../../models/api_response.dart';
import '../models/reel_sound_model.dart';
import '../utils/reel_constants.dart';

/// Reels V2 Sound API Service — search, browse, save, trending sounds.
class ReelsV2SoundService {
  final ApiCommunication _api = ApiCommunication();

  // ─── Trending ────────────────────────────────────────────

  Future<List<ReelSoundModel>> getTrendingSounds({int limit = 20}) async {
    try {
      final response = await _api.doGetRequest(
        apiEndPoint: '${ReelConstants.trendingSounds}?limit=$limit',
      );
      if (response.data != null && (response.data as Map)['sounds'] != null) {
        return ((response.data as Map)['sounds'] as List)
            .map((e) => ReelSoundModel.fromMap(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // ─── Search ─────────────────────────────────────────────

  Future<List<ReelSoundModel>> searchSounds(String query, {int limit = 20}) async {
    try {
      final encoded = Uri.encodeComponent(query);
      final response = await _api.doGetRequest(
        apiEndPoint: '${ReelConstants.searchSounds}?q=$encoded&limit=$limit',
      );
      if (response.data != null && (response.data as Map)['sounds'] != null) {
        return ((response.data as Map)['sounds'] as List)
            .map((e) => ReelSoundModel.fromMap(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // ─── Browse by Genre ────────────────────────────────────

  Future<List<ReelSoundModel>> getSoundsByGenre(String genre, {int limit = 20}) async {
    try {
      final encoded = Uri.encodeComponent(genre);
      final response = await _api.doGetRequest(
        apiEndPoint: '${ReelConstants.soundLibrary}?genre=$encoded&limit=$limit',
      );
      if (response.data != null && (response.data as Map)['sounds'] != null) {
        return ((response.data as Map)['sounds'] as List)
            .map((e) => ReelSoundModel.fromMap(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // ─── Browse by Mood ─────────────────────────────────────

  Future<List<ReelSoundModel>> getSoundsByMood(String mood, {int limit = 20}) async {
    try {
      final encoded = Uri.encodeComponent(mood);
      final response = await _api.doGetRequest(
        apiEndPoint: '${ReelConstants.soundLibrary}?mood=$encoded&limit=$limit',
      );
      if (response.data != null && (response.data as Map)['sounds'] != null) {
        return ((response.data as Map)['sounds'] as List)
            .map((e) => ReelSoundModel.fromMap(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // ─── Saved Sounds ───────────────────────────────────────

  Future<List<ReelSoundModel>> getSavedSounds() async {
    try {
      final response = await _api.doGetRequest(
        apiEndPoint: ReelConstants.savedSounds,
      );
      if (response.data != null && (response.data as Map)['sounds'] != null) {
        return ((response.data as Map)['sounds'] as List)
            .map((e) => ReelSoundModel.fromMap(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> saveSound(String soundId) async {
    try {
      await _api.doPostRequest(
        apiEndPoint: ReelConstants.toggleSaveSound(soundId),
        requestData: {},
      );
    } catch (_) {}
  }

  Future<void> unsaveSound(String soundId) async {
    try {
      await _api.doDeleteRequest(
        apiEndPoint: ReelConstants.toggleSaveSound(soundId),
      );
    } catch (_) {}
  }

  // ─── Sound Details ──────────────────────────────────────

  Future<ReelSoundModel?> getSoundById(String soundId) async {
    try {
      final response = await _api.doGetRequest(
        apiEndPoint: ReelConstants.soundDetail(soundId),
      );
      if (response.data != null && (response.data as Map)['sound'] != null) {
        return ReelSoundModel.fromMap((response.data as Map)['sound']);
      }
    } catch (_) {}
    return null;
  }

  // ─── Reels by Sound ────────────────────────────────────

  Future<ApiResponse> getReelsBySound(String soundId, {String? cursor, int limit = 12}) async {
    return await _api.doGetRequest(
      apiEndPoint:
          '${ReelConstants.soundReels(soundId)}?limit=$limit${cursor != null ? '&cursor=$cursor' : ''}',
    );
  }

  // ─── Sound Effects ─────────────────────────────────────

  Future<List<ReelSoundModel>> getSoundEffects(String category, {int limit = 20}) async {
    try {
      final encoded = Uri.encodeComponent(category);
      final response = await _api.doGetRequest(
        apiEndPoint: '${ReelConstants.soundEffects}?category=$encoded&limit=$limit',
      );
      if (response.data != null && (response.data as Map)['effects'] != null) {
        return ((response.data as Map)['effects'] as List)
            .map((e) => ReelSoundModel.fromMap(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
