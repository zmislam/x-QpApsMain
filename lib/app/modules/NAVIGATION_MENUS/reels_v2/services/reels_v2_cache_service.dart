import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reel_v2_model.dart';
import '../utils/reel_constants.dart';

/// Local cache service for Reels V2.
/// Uses SharedPreferences for lightweight JSON caching.
/// Mirrors backend Redis cache pattern with rv2_ prefix keys.
class ReelsV2CacheService {
  static const String _prefix = 'rv2_';

  // ─── Feed Cache ─────────────────────────────────────────

  /// Cache a feed response (list of reels + cursor).
  Future<void> cacheFeed(
    String feedKey,
    List<ReelV2Model> reels,
    String? nextCursor,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'reels': reels.map((r) => r.toMap()).toList(),
      'next_cursor': nextCursor,
      'cached_at': DateTime.now().toIso8601String(),
    };
    await prefs.setString('$_prefix$feedKey', json.encode(data));
  }

  /// Get cached feed. Returns null if expired or not found.
  Future<CachedFeed?> getCachedFeed(String feedKey) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$feedKey');
    if (raw == null) return null;

    final data = json.decode(raw) as Map<String, dynamic>;
    final cachedAt = DateTime.tryParse(data['cached_at'] ?? '');
    if (cachedAt == null) return null;

    // Check TTL
    final age = DateTime.now().difference(cachedAt).inSeconds;
    if (age > ReelConstants.cacheFeedTtlSeconds) {
      await prefs.remove('$_prefix$feedKey');
      return null;
    }

    final reelsList = (data['reels'] as List? ?? [])
        .map((e) => ReelV2Model.fromMap(e as Map<String, dynamic>))
        .toList();

    return CachedFeed(
      reels: reelsList,
      nextCursor: data['next_cursor'] as String?,
    );
  }

  // ─── Reel Detail Cache ──────────────────────────────────

  /// Cache a single reel detail.
  Future<void> cacheReelDetail(ReelV2Model reel) async {
    if (reel.id == null) return;
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'reel': reel.toMap(),
      'cached_at': DateTime.now().toIso8601String(),
    };
    await prefs.setString(
      '$_prefix${ReelConstants.cacheReelDetail}${reel.id}',
      json.encode(data),
    );
  }

  /// Get cached reel detail. Returns null if expired or not found.
  Future<ReelV2Model?> getCachedReelDetail(String reelId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix${ReelConstants.cacheReelDetail}$reelId');
    if (raw == null) return null;

    final data = json.decode(raw) as Map<String, dynamic>;
    final cachedAt = DateTime.tryParse(data['cached_at'] ?? '');
    if (cachedAt == null) return null;

    final age = DateTime.now().difference(cachedAt).inSeconds;
    if (age > ReelConstants.cacheDetailTtlSeconds) {
      await prefs.remove('$_prefix${ReelConstants.cacheReelDetail}$reelId');
      return null;
    }

    return ReelV2Model.fromMap(data['reel'] as Map<String, dynamic>);
  }

  // ─── Invalidation ───────────────────────────────────────

  /// Invalidate all feed caches.
  Future<void> invalidateAllFeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('${_prefix}rv2_feed_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Invalidate a specific feed cache.
  Future<void> invalidateFeed(String feedKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$feedKey');
  }

  /// Invalidate a specific reel detail cache.
  Future<void> invalidateReelDetail(String reelId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix${ReelConstants.cacheReelDetail}$reelId');
  }

  /// Clear all V2 caches.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}

/// Cached feed result.
class CachedFeed {
  final List<ReelV2Model> reels;
  final String? nextCursor;

  CachedFeed({required this.reels, this.nextCursor});
}
