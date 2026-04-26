import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../extension/string/string_image_path.dart';
import '../models/feed_insertion_model.dart';
import '../models/post.dart';
import '../models/sponsored_ad_model.dart';
import '../repository/edgerank_repository.dart';
import '../utils/image_utils.dart';

/// GetX mixin that manages EdgeRank feed state with cursor-based pagination.
///
/// Mix this into any controller that needs to display the EdgeRank feed
/// (currently HomeController).
mixin EdgeRankFeedMixin on GetxController {
  // ─── Public Observables ──────────────────────────────────
  final RxList<PostModel> edgeRankPosts = <PostModel>[].obs;
  final RxList<FeedInsertionModel> feedInsertions = <FeedInsertionModel>[].obs;
  final RxBool hasMorePosts = true.obs;
  final RxBool isLoadingFeed = false.obs;
  final RxBool isRefreshingFeed = false.obs;

  /// Current feed mode: 'for_you', 'friends_first', or 'latest'.
  final RxString currentFeedMode = 'for_you'.obs;

  /// True when all 4 backend waterfall stages returned nothing.
  /// This is the primary gate that permanently stops infinite scrolling.
  final RxBool feedExhausted = false.obs;

  /// Map of postId → FeedInsertionModel for quick lookup during rendering.
  final RxMap<String, FeedInsertionModel> insertionMap =
      <String, FeedInsertionModel>{}.obs;

  /// Map of postId → SponsoredAdModel for inline sponsored ad rendering.
  final RxMap<String, SponsoredAdModel> sponsoredAdsMap =
      <String, SponsoredAdModel>{}.obs;

  // ─── Private State ───────────────────────────────────────
  final EdgeRankRepository _edgeRankRepo = EdgeRankRepository();
  String? _nextCursor;
  int _sessionSeed = DateTime.now().millisecondsSinceEpoch;

  /// Error retry state for exponential backoff.
  int _feedRetryCount = 0;
  static const int _maxRetries = 3;

  /// Tracks consecutive batches where ALL posts were filtered by dedup.
  /// After [_maxConsecutiveEmptyDedup] such batches, we treat as exhausted.
  int _consecutiveEmptyDedupCount = 0;
  static const int _maxConsecutiveEmptyDedup = 5;

  /// Prefetch safeguards to reduce redundant network and cache churn.
  static const int _maxPrefetchPostsPerBatch = 8;
  static const int _maxTrackedPrefetchUrls = 500;
  final Set<String> _prefetchedImageUrls = <String>{};

  // ─── Feed Fetch ──────────────────────────────────────────

  /// Fetch the EdgeRank feed.
  ///
  /// If [isInitial] is true, shows the main loading state.
  /// If [forceRecallAPI] is true, bypasses cache.
  Future<void> fetchEdgeRankFeed({
    bool isInitial = false,
    bool? forceRecallAPI,
  }) async {
    if (isLoadingFeed.value) return;
    // Use feedExhausted as primary permanent stop gate
    if (feedExhausted.value && !isInitial) return;
    if (!hasMorePosts.value && !isInitial) return;

    isLoadingFeed.value = true;

    try {
      final response = await _edgeRankRepo.getEdgeRankFeed(
        limit: 20,
        cursor: isInitial ? null : _nextCursor,
        feedMode: currentFeedMode.value,
        sessionSeed: isInitial ? _sessionSeed : null,
        forceRecallAPI: forceRecallAPI,
      );

      if (response.isSuccessful && response.data is EdgeRankFeedResponse) {
        final feedData = response.data as EdgeRankFeedResponse;

        if (isInitial) {
          edgeRankPosts.clear();
          feedInsertions.clear();
          insertionMap.clear();
          sponsoredAdsMap.clear();
        }

        // Filter duplicates
        final existingIds = edgeRankPosts.map((p) => p.id).toSet();
        final newPosts = feedData.posts
            .where((p) => p.id != null && !existingIds.contains(p.id))
            .toList();

        debugPrint('[EdgeRank] Received ${feedData.posts.length} posts, '
            '${newPosts.length} new after dedup, hasMore=${feedData.hasMore}, '
            'cursor=${feedData.nextCursor != null ? "present" : "null"}, '
            'stage=${feedData.meta['feedStage'] ?? 'unknown'}');

        edgeRankPosts.addAll(newPosts);

        // ── Pre-fetch images for smoother scrolling ──
        _prefetchPostImages(newPosts);

        // Process insertions — anchor to post IDs
        for (final insertion in feedData.insertions) {
          if (insertion.anchorPostId != null) {
            insertionMap[insertion.anchorPostId!] = insertion;
          }
        }
        feedInsertions.addAll(feedData.insertions);

        // Process sponsored ads — anchor to post IDs
        for (final ad in feedData.sponsoredAds) {
          if (ad.anchorPostId != null) {
            sponsoredAdsMap[ad.anchorPostId!] = ad;
          }
        }

        // Update pagination cursor (always advance even on dedup batches)
        _nextCursor = feedData.nextCursor;
        hasMorePosts.value = feedData.hasMore;

        // ── Feed exhaustion detection ──
        //
        // Aligned with web behaviour: only truly exhaust when the backend
        // returns NO posts AND says hasMore=false AND provides no cursor
        // (all 4 waterfall stages are empty).
        //
        // When the page yields zero *new unique* posts (empty API response
        // during a stage transition, or all posts were already in the list),
        // we auto-retry transparently so the cursor can advance through
        // overlapping content or stage boundaries.  The safety counter
        // _consecutiveEmptyDedupCount prevents runaway retries.

        final bool gotNewUniquePosts = newPosts.isNotEmpty;
        final bool apiReturnedPosts = feedData.posts.isNotEmpty;
        final bool backendHasMore =
            feedData.hasMore || feedData.nextCursor != null;

        if (gotNewUniquePosts) {
          // ── Normal: new unique posts added to the list ──
          _consecutiveEmptyDedupCount = 0;
          if (!feedData.hasMore && feedData.nextCursor != null) {
            // Backend said hasMore=false but gave us a cursor for the
            // next stage — keep scroll alive for one more round.
            hasMorePosts.value = true;
          }
          debugPrint('[EdgeRank] Added ${newPosts.length} new posts '
              '(total: ${edgeRankPosts.length}, hasMore=${feedData.hasMore})');
        } else if (!backendHasMore && !apiReturnedPosts) {
          // ── True exhaustion: all waterfall stages returned nothing ──
          feedExhausted.value = true;
          debugPrint('[EdgeRank] Feed exhausted — all stages empty, '
              'no cursor');
        } else {
          // ── No new unique posts, but more content might exist ──
          // Either the API returned posts that are all duplicates, or
          // the API returned an empty page during a stage transition
          // but signalled hasMore / provided a cursor to the next stage.
          _consecutiveEmptyDedupCount++;
          debugPrint('[EdgeRank] Empty effective page '
              '(apiPosts=${feedData.posts.length}, newAfterDedup=0, '
              'consecutive=$_consecutiveEmptyDedupCount'
              '/$_maxConsecutiveEmptyDedup, '
              'hasMore=${feedData.hasMore}, '
              'cursor=${feedData.nextCursor != null})');

          if (_consecutiveEmptyDedupCount >= _maxConsecutiveEmptyDedup) {
            // Safety valve — too many empty pages in a row
            feedExhausted.value = true;
            debugPrint('[EdgeRank] Feed exhausted — $_maxConsecutiveEmptyDedup '
                'consecutive empty-effective batches');
          } else if (backendHasMore) {
            // Auto-retry transparently with the new cursor.
            // The scroll listener won't fire on its own because no new
            // content was added, so the scroll position hasn't changed.
            // Ensure hasMorePosts is true so the recursive call's guard
            // doesn't block the retry (hasMore may be false while the
            // cursor points to a new stage).
            hasMorePosts.value = true;
            debugPrint('[EdgeRank] Auto-retrying with advanced cursor');
            isLoadingFeed.value = false;
            await Future.delayed(const Duration(milliseconds: 300));
            return fetchEdgeRankFeed();
          } else {
            // Backend says done, no cursor — genuinely exhausted
            feedExhausted.value = true;
            debugPrint('[EdgeRank] Feed exhausted — backend done, '
                'all received posts were duplicates');
          }
        }

        // Reset retry counter on success
        _feedRetryCount = 0;
      } else {
        debugPrint('EdgeRank feed fetch failed: ${response.message}');
      }
    } catch (e) {
      debugPrint('EdgeRank feed fetch error: $e');
      // ── Error retry with exponential backoff ──
      if (_feedRetryCount < _maxRetries) {
        final delay = Duration(seconds: math.pow(2, _feedRetryCount).toInt());
        _feedRetryCount++;
        debugPrint('[EdgeRank] Retrying in ${delay.inSeconds}s '
            '(attempt $_feedRetryCount/$_maxRetries)');
        isLoadingFeed.value = false; // Unlock before retry
        await Future.delayed(delay);
        return fetchEdgeRankFeed(isInitial: isInitial);
      }
      debugPrint('[EdgeRank] Max retries reached ($_maxRetries)');
      // Trigger legacy fallback if available
      await onEdgeRankFallback();
    } finally {
      isLoadingFeed.value = false;
      isRefreshingFeed.value = false;
    }
  }

  /// Pull-to-refresh: reset everything and fetch fresh.
  Future<void> refreshEdgeRankFeed() async {
    isRefreshingFeed.value = true;
    _nextCursor = null;
    _sessionSeed = DateTime.now().millisecondsSinceEpoch;
    hasMorePosts.value = true;
    feedExhausted.value = false;
    _feedRetryCount = 0;
    _consecutiveEmptyDedupCount = 0;
    _prefetchedImageUrls.clear();
    sponsoredAdsMap.clear();
    await fetchEdgeRankFeed(isInitial: true, forceRecallAPI: true);
  }

  /// Switch feed mode (for_you / friends_first / latest).
  /// Resets all pagination state and fetches fresh.
  Future<void> switchFeedMode(String mode) async {
    if (currentFeedMode.value == mode) return;
    currentFeedMode.value = mode;
    isRefreshingFeed.value = true;
    _nextCursor = null;
    _sessionSeed = DateTime.now().millisecondsSinceEpoch;
    hasMorePosts.value = true;
    feedExhausted.value = false;
    _feedRetryCount = 0;
    _consecutiveEmptyDedupCount = 0;
    _prefetchedImageUrls.clear();
    sponsoredAdsMap.clear();
    await fetchEdgeRankFeed(isInitial: true, forceRecallAPI: true);
  }

  /// Load next page of posts (infinite scroll trigger).
  Future<void> loadMoreEdgeRankPosts() async {
    if (feedExhausted.value) return;
    if (!hasMorePosts.value || isLoadingFeed.value) return;
    await fetchEdgeRankFeed();
  }

  /// Override this in the controller to provide legacy API fallback
  /// when EdgeRank fails after max retries.
  Future<void> onEdgeRankFallback() async {
    // Default: no-op. HomeController overrides this.
  }

  // ─── Optimistic Updates ──────────────────────────────────

  /// Insert a new post at the top of the feed (after create post).
  void prependPostToFeed(PostModel post) {
    edgeRankPosts.insert(0, post);
  }

  /// Remove a post from the feed (after delete/hide).
  void removePostFromFeed(String postId) {
    edgeRankPosts.removeWhere((p) => p.id == postId);
    insertionMap.remove(postId);
  }

  /// Replace a post in the feed (after edit/comment update).
  void updatePostInFeed(PostModel updatedPost) {
    final index = edgeRankPosts.indexWhere((p) => p.id == updatedPost.id);
    if (index != -1) {
      edgeRankPosts[index] = updatedPost;
    }
  }

  // ─── Engagement Tracking ─────────────────────────────────

  /// Track a user engagement action for the EdgeRank algorithm.
  Future<void> trackFeedEngagement(
    String action, {
    String? postId,
    List<String>? postIds,
  }) async {
    try {
      await _edgeRankRepo.trackEngagement(
        action,
        postId: postId,
        postIds: postIds,
        feedMode: currentFeedMode.value,
      );
    } catch (e) {
      debugPrint('Engagement tracking failed: $e');
    }
  }

  // ─── Image Pre-fetching ──────────────────────────────────

  /// Pre-fetch images of each new post into the CachedNetworkImage
  /// disk & memory cache so they display instantly when scrolled into view.
  void _prefetchPostImages(List<PostModel> posts) {
    final context = Get.context;
    if (context == null || posts.isEmpty) return;

    for (final post in posts.take(_maxPrefetchPostsPerBatch)) {
      // Prefetch author profile pic
      final profilePic = post.user_id?.profile_pic?.formatedProfileUrl;
      if (profilePic != null && profilePic.isNotEmpty) {
        _prefetchNetworkImage(context, profilePic);
      }

      final mediaList = post.media;
      if (mediaList == null || mediaList.isEmpty) continue;

      // Prefetch up to 2 images per post for faster rendering
      int prefetched = 0;
      for (final media in mediaList) {
        if (prefetched >= 2) break;
        final filename = media.media;
        if (filename == null || filename.isEmpty) continue;
        if (!isImageUrl(filename)) continue;

        if (_prefetchNetworkImage(context, filename.formatedPostUrl)) {
          prefetched++;
        }
      }
    }
  }

  bool _prefetchNetworkImage(BuildContext context, String url) {
    if (url.isEmpty || _prefetchedImageUrls.contains(url)) {
      return false;
    }

    if (_prefetchedImageUrls.length >= _maxTrackedPrefetchUrls) {
      _prefetchedImageUrls.clear();
    }
    _prefetchedImageUrls.add(url);

    precacheImage(
      CachedNetworkImageProvider(url),
      context,
      // Missing/expired media should not surface as noisy Flutter errors.
      onError: (_, __) {},
    );
    return true;
  }
}
