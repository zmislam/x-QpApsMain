import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/sponsored_reel_model.dart';
import '../services/reels_ad_serve_service.dart';
import '../../../../../utils/url_utils.dart';

/// Controller for sponsored reel logic — ad loading, tracking,
/// frequency capping, and feed merge coordination.
class ReelsSponsoredController extends GetxController {
  late final ReelsAdServeService _adService;

  // ─── State ─────────────────────────────────────────────
  final RxList<SponsoredReelModel> sponsoredReels = <SponsoredReelModel>[].obs;
  final RxBool isLoading = false.obs;

  // Impression dedup — track which ads have already fired impressions
  final Set<String> _impressionsFired = {};

  // Frequency cap tracker per user session
  final Map<String, int> _frequencyTracker = {};

  // Merge config
  static const int sponsoredInterval = 6; // 1 ad every 6 organic reels

  @override
  void onInit() {
    super.onInit();
    _adService = ReelsAdServeService();
  }

  /// Load sponsored reels from the ad serve endpoint.
  Future<void> loadSponsoredReels({int limit = 3}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final ads = await _adService.fetchSponsoredReels(limit: limit);

      // Apply frequency cap filter
      final filtered = ads.where((ad) {
        final id = ad.campaignId ?? ad.id ?? '';
        final shown = _frequencyTracker[id] ?? 0;
        return shown < ad.frequencyCap;
      }).toList();

      sponsoredReels.assignAll(filtered);
    } catch (e) {
      debugPrint('[SponsoredCtrl] Error loading ads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get the next sponsored reel for a given organic feed index.
  /// Returns null if no ad should be placed at this index.
  SponsoredReelModel? getAdForIndex(int organicIndex) {
    if (sponsoredReels.isEmpty) return null;
    if (organicIndex <= 0) return null;

    // Place an ad every [sponsoredInterval] organic reels
    if ((organicIndex + 1) % sponsoredInterval != 0) return null;

    final adIndex = ((organicIndex + 1) ~/ sponsoredInterval - 1) % sponsoredReels.length;
    if (adIndex >= sponsoredReels.length) return null;

    final ad = sponsoredReels[adIndex];
    // Check frequency cap
    final id = ad.campaignId ?? ad.id ?? '';
    final shown = _frequencyTracker[id] ?? 0;
    if (shown >= ad.frequencyCap) return null;

    return ad;
  }

  /// Auto-track impression when a sponsored reel is viewed >= 1s.
  void onSponsoredReelViewed(SponsoredReelModel ad) {
    final adId = ad.id ?? '';
    if (adId.isEmpty || _impressionsFired.contains(adId)) return;

    _impressionsFired.add(adId);

    // Increment frequency tracker
    final campaignId = ad.campaignId ?? adId;
    _frequencyTracker[campaignId] = (_frequencyTracker[campaignId] ?? 0) + 1;

    // Fire impression beacon
    _adService.trackImpression(adId);
  }

  /// Handle CTA tap — track click + open destination.
  Future<void> onCtaTapped(SponsoredReelModel ad) async {
    final adId = ad.id ?? '';
    if (adId.isNotEmpty) {
      _adService.trackClick(adId);
    }

    final url = ad.ctaUrl;
    if (url != null && url.isNotEmpty) {
      UriUtils.launchUrlInBrowser(url);
    }
  }

  /// Handle "Hide Ad" action.
  Future<void> hideAd(SponsoredReelModel ad) async {
    final adId = ad.id ?? '';
    if (adId.isEmpty) return;

    await _adService.sendFeedback(adId, 'hide');

    // Remove from local list
    sponsoredReels.removeWhere((a) => a.id == adId);
  }

  /// Handle "Not Interested" feedback.
  Future<void> markNotInterested(SponsoredReelModel ad) async {
    final adId = ad.id ?? '';
    if (adId.isEmpty) return;

    await _adService.sendFeedback(adId, 'not_interested');
    sponsoredReels.removeWhere((a) => a.id == adId);
  }

  /// Handle "Report Ad" feedback.
  Future<void> reportAd(SponsoredReelModel ad) async {
    final adId = ad.id ?? '';
    if (adId.isEmpty) return;

    await _adService.sendFeedback(adId, 'report');
    sponsoredReels.removeWhere((a) => a.id == adId);
  }

  /// Get targeting reason for "Why this ad?" display.
  Future<String?> getTargetingReason(String adId) async {
    return _adService.getTargetingReason(adId);
  }

  /// React on a sponsored reel.
  Future<void> reactOnAd(SponsoredReelModel ad, String reaction) async {
    final adId = ad.id ?? '';
    if (adId.isEmpty) return;

    await _adService.reactOnAd(adId, reaction);
    // Update local state
    final idx = sponsoredReels.indexWhere((a) => a.id == adId);
    if (idx != -1) {
      sponsoredReels[idx] = sponsoredReels[idx].copyWith(
        userReaction: reaction,
        likeCount: sponsoredReels[idx].likeCount + 1,
      );
    }
  }

  /// Comment on a sponsored reel.
  Future<void> commentOnAd(SponsoredReelModel ad, String text) async {
    final adId = ad.id ?? '';
    if (adId.isEmpty) return;

    await _adService.commentOnAd(adId, text);
    final idx = sponsoredReels.indexWhere((a) => a.id == adId);
    if (idx != -1) {
      sponsoredReels[idx] = sponsoredReels[idx].copyWith(
        commentCount: sponsoredReels[idx].commentCount + 1,
      );
    }
  }
}
