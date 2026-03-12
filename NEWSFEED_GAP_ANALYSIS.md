# Mobile Newsfeed — Gap Analysis & Implementation Plan

**Date:** March 6, 2026  
**Reference:** qp-web newsfeed (fully implemented) vs quantum_possibilities_flutter (mobile)  
**Scope:** "For You" tab — EdgeRank V2 infinite scrolling feed

---

## 1. Current State Summary

### What's Already Implemented (Matches Web)

| Feature | Mobile File(s) | Status |
|---|---|---|
| EdgeRank V2 API (`GET /api/edgerank/feed`) | `edgerank_repository.dart` | ✅ |
| Cursor-based pagination (`nextCursor` / `hasMore`) | `edgerank_feed_controller.dart` | ✅ |
| Session seed for deterministic ordering | `edgerank_feed_controller.dart` | ✅ |
| `for_you` feed mode | `edgerank_feed_controller.dart` | ✅ |
| Post deduplication by `_id` | `edgerank_feed_controller.dart` | ✅ |
| Feed insertions (friend/group/page suggestions) | `edgerank_repository.dart` + `feed_insertion_widget.dart` | ✅ |
| Insertion anchoring by post ID | `edgerank_repository.dart` | ✅ |
| Pull-to-refresh (reset cursor + session seed) | `edgerank_feed_controller.dart` | ✅ |
| ScrollController listener (500px from bottom) | `home_controller.dart` | ✅ |
| `_isLoadingMore` mutex guard | `home_controller.dart` | ✅ |
| Empty load safety valve (`_emptyLoadCount > 3`) | `home_controller.dart` | ✅ |
| `hasMorePosts` pagination gate | `edgerank_feed_controller.dart` | ✅ |
| WhyShown badge rendering | `post.dart` (component) | ✅ |
| Engagement tracking (`POST /api/edgerank/track`) | `edgerank_repository.dart` | ✅ |
| Optimistic post CRUD (prepend/remove/update) | `edgerank_feed_controller.dart` | ✅ |
| "You're all caught up!" end-of-feed message | `home_view.dart` | ✅ |
| Pagination loading spinner | `home_view.dart` | ✅ |

---

## 2. Gaps Found

### GAP 1 — `feedExhausted` Permanent Stop Flag ⚠️ HIGH

**Web behavior:**  
Web uses a separate `feedExhausted` boolean (distinct from `hasMore`). It's only set to `true` when `hasMore === false AND posts.length === 0` — meaning all 4 backend waterfall stages (personalized → extended → discovery → global) returned nothing. This is the **primary gate** that permanently stops scrolling.

**Mobile behavior:**  
Mobile only uses `hasMorePosts` (from API) + `_emptyLoadCount > 3` (local counter). The `_emptyLoadCount` approach is imprecise — it could trigger prematurely if 3 stage transitions happen to return 0 posts each (normal during waterfall boundary), or it could miss the actual exhaustion point.

**Impact:** Scroll can stop too early or too late. Users may see "You're all caught up!" while there are still posts in later stages.

**Files affected:**
- `lib/app/controllers/edgerank_feed_controller.dart`
- `lib/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart`
- `lib/app/modules/NAVIGATION_MENUS/home/views/home_view.dart`

---

### GAP 2 — `hasMore` Safety Net ⚠️ HIGH

**Web behavior:**  
When the API returns `hasMore: false` but **also returns posts** in the same response, web **overrides** `hasMore` back to `true`. This handles a backend edge case where the waterfall stage transition didn't execute properly — the backend said "no more" but clearly there were still posts. This keeps scroll alive for one more attempt so the backend can self-correct on the next request.

```javascript
// Web safety net (usePostContext.jsx)
if (!hasMorePosts && newPosts.length > 0) {
   console.log('Backend said hasMore=false but returned posts — keeping scroll alive');
   setHasMore(true);
}
```

**Mobile behavior:**  
Mobile blindly trusts the API's `hasMore` value. If the backend sends `hasMore: false` with posts still arriving, the scroll permanently stops.

**Impact:** Infinite scroll can die prematurely on stage transitions, especially between Stages 1→2 or 2→3.

**Files affected:**
- `lib/app/controllers/edgerank_feed_controller.dart`

---

### GAP 3 — Error Retry with Exponential Backoff ⚠️ HIGH

**Web behavior:**  
On API error, web retries up to 3 times with exponential backoff (1s → 2s → 4s). Counter resets on success. Only after all 3 retries fail does it attempt a fallback.

```javascript
// Web retry (usePostContext.jsx)
if (feedRetryCountRef.current < MAX_FEED_RETRIES) {
   const retryDelay = Math.pow(2, feedRetryCountRef.current) * 1000;
   feedRetryCountRef.current++;
   setTimeout(() => getNewsfeedPost(...), retryDelay);
   return;
}
```

**Mobile behavior:**  
Mobile's `_triggerLoadMore()` catches errors with `debugPrint('Load more error: $e')` and does nothing — no retry, no backoff, no recovery. The scroll appears to stop silently.

**Impact:** A single transient network error (timeout, 502, connection drop) permanently kills infinite scroll until the user manually pulls to refresh.

**Files affected:**
- `lib/app/controllers/edgerank_feed_controller.dart`
- `lib/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart`

---

### GAP 4 — Legacy API Fallback ⬜ MEDIUM

**Web behavior:**  
After 3 failed EdgeRank retries, web falls back to the legacy endpoint `GET /api/get-all-users-posts-v2?pageNo=N&pageSize=10` to ensure the user still sees content.

**Mobile behavior:**  
Mobile has the legacy `getPostsLegacy()` method in `home_controller.dart` (line 429) but it's **never called** as a fallback — it's dead code.

**Impact:** If EdgeRank API is down or misbehaving, mobile users see zero content with no recovery path.

**Files affected:**
- `lib/app/controllers/edgerank_feed_controller.dart`
- `lib/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart`

---

### GAP 5 — Sponsored Ads from EdgeRank Response ⬜ MEDIUM

**Web behavior:**  
Web extracts `sponsoredAds[]` from the EdgeRank API response, anchors each ad to a post ID by position index (same as insertions), and renders them inline in the feed — either as a `PostCard` with "Sponsored" label (for boosted posts) or as a `SponsoredPostCard`.

```javascript
// Web sponsored ads (usePostContext.jsx)
const apiSponsoredAds = responseData?.sponsoredAds || [];
// ... anchor to post IDs, store in state, render after matching post
```

**Mobile behavior:**  
Zero handling. The `sponsoredAds` field in the EdgeRank API response is completely ignored. The mobile `EdgeRankFeedResponse` class doesn't parse it, the controller doesn't store it, and the view doesn't render it. A `grep` for "sponsoredAd" across the entire `lib/` directory returns zero results.

**Impact:** No monetization through in-feed sponsored posts on mobile. Revenue gap.

**Files affected:**
- `lib/app/repository/edgerank_repository.dart` — parse `sponsoredAds`
- `lib/app/controllers/edgerank_feed_controller.dart` — store `sponsoredAdsMap`
- `lib/app/modules/NAVIGATION_MENUS/home/views/home_view.dart` — render inline
- New file: `lib/app/models/sponsored_ad_model.dart`
- New file: `lib/app/components/sponsored_ad/sponsored_ad_widget.dart`

---

### GAP 6 — Scroll Listener Throttle ⬜ LOW

**Web behavior:**  
Web uses a 100ms `setTimeout` throttle on scroll events to prevent excessive function calls.

**Mobile behavior:**  
Mobile's `_scrollListener()` fires on every pixel of scroll movement. Flutter's physics engine can fire this very rapidly during fast flings.

**Impact:** Minor — the `_isLoadingMore` mutex already prevents double API calls. But unnecessary function execution during rapid scrolling is wasteful.

**Files affected:**
- `lib/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart`

---

### GAP 7 — Algorithm Metadata Storage ⬜ LOW

**Web behavior:**  
Web stores `algorithmVersion` and `feedMeta` (processing time, cache hit, candidate count, A/B test group) from the API's `meta` field for debugging and analytics.

**Mobile behavior:**  
Mobile parses `meta` from the API but doesn't store or expose it anywhere.

**Impact:** No feed analytics or debugging capability on mobile. Not user-facing.

**Files affected:**
- `lib/app/controllers/edgerank_feed_controller.dart`

---

## 3. Implementation Plan

### Phase 1: Infinite Scroll Robustness (Gaps 1–3) — HIGH Priority

These three changes work together to ensure the feed never stops prematurely and recovers from errors gracefully.

#### Step 1.1 — Add `feedExhausted` + `hasMore` Safety Net

**File:** `lib/app/controllers/edgerank_feed_controller.dart`

**Changes:**
1. Add new observable: `final RxBool feedExhausted = false.obs;`
2. In `fetchEdgeRankFeed()`, after updating `hasMorePosts`, add exhaustion detection:
   ```dart
   // True feed exhaustion: API said no more AND returned nothing
   if (!feedData.hasMore && feedData.posts.isEmpty) {
     feedExhausted.value = true;
   }
   // Safety net: API said no more but DID return posts → keep scroll alive
   else if (!feedData.hasMore && feedData.posts.isNotEmpty) {
     hasMorePosts.value = true; // Override — let one more request check
   }
   ```
3. In `refreshEdgeRankFeed()`, add: `feedExhausted.value = false;`
4. In `fetchEdgeRankFeed()` guard clause, change:
   ```dart
   // Before:
   if (!hasMorePosts.value && !isInitial) return;
   // After:
   if (feedExhausted.value && !isInitial) return;
   ```

**Estimated:** ~15 lines changed

#### Step 1.2 — Add Error Retry with Exponential Backoff

**File:** `lib/app/controllers/edgerank_feed_controller.dart`

**Changes:**
1. Add private state:
   ```dart
   int _feedRetryCount = 0;
   static const int _maxRetries = 3;
   ```
2. In `fetchEdgeRankFeed()` catch block, add retry logic:
   ```dart
   catch (e) {
     debugPrint('EdgeRank feed fetch error: $e');
     if (_feedRetryCount < _maxRetries) {
       final delay = Duration(seconds: math.pow(2, _feedRetryCount).toInt());
       _feedRetryCount++;
       debugPrint('[EdgeRank] Retrying in ${delay.inSeconds}s (attempt $_feedRetryCount/$_maxRetries)');
       await Future.delayed(delay);
       isLoadingFeed.value = false; // unlock before retry
       return fetchEdgeRankFeed(isInitial: isInitial);
     }
     debugPrint('[EdgeRank] Max retries reached');
   }
   ```
3. On success (before `finally`): `_feedRetryCount = 0;`
4. In `refreshEdgeRankFeed()`: `_feedRetryCount = 0;`

**Estimated:** ~20 lines changed

#### Step 1.3 — Update Scroll Listener

**File:** `lib/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart`

**Changes:**
1. Remove `_emptyLoadCount` variable and all references
2. Replace `_emptyLoadCount > 3` check with `feedExhausted.value`:
   ```dart
   void _scrollListener() {
     if (_isLoadingMore) return;
     if (feedExhausted.value) return;       // ← replaces _emptyLoadCount > 3
     if (!hasMorePosts.value) return;
     if (postScrollController.position.pixels >=
         postScrollController.position.maxScrollExtent - 500) {
       _triggerLoadMore();
     }
   }
   ```
3. Simplify `_triggerLoadMore()` — remove `_emptyLoadCount` tracking:
   ```dart
   Future<void> _triggerLoadMore() async {
     if (_isLoadingMore) return;
     _isLoadingMore = true;
     try {
       await loadMoreEdgeRankPosts();
     } catch (e) {
       debugPrint('Load more error: $e');
     } finally {
       _isLoadingMore = false;
     }
   }
   ```
4. Add 100ms throttle with `Timer`:
   ```dart
   Timer? _scrollThrottle;
   
   void _scrollListener() {
     _scrollThrottle?.cancel();
     _scrollThrottle = Timer(const Duration(milliseconds: 100), () {
       if (_isLoadingMore) return;
       if (feedExhausted.value) return;
       if (!hasMorePosts.value) return;
       if (postScrollController.position.pixels >=
           postScrollController.position.maxScrollExtent - 500) {
         _triggerLoadMore();
       }
     });
   }
   ```
5. In `onClose()`: `_scrollThrottle?.cancel();`

**Estimated:** ~25 lines changed

#### Step 1.4 — Update "All Caught Up" UI

**File:** `lib/app/modules/NAVIGATION_MENUS/home/views/home_view.dart`

**Changes:**
Update the end-of-feed condition to use `feedExhausted` for a more definitive message:
```dart
// Before:
if (!controller.hasMorePosts.value && controller.edgeRankPosts.isNotEmpty)
  // "You're all caught up!"

// After:
if (controller.feedExhausted.value && controller.edgeRankPosts.isNotEmpty)
  // "You're all caught up!"
```

**Estimated:** ~2 lines changed

---

### Phase 2: Legacy API Fallback (Gap 4) — MEDIUM Priority

**File:** `lib/app/controllers/edgerank_feed_controller.dart`

**Changes:**
After max retries exhausted in `fetchEdgeRankFeed()`, call the legacy endpoint:
```dart
debugPrint('[EdgeRank] Max retries reached, trying legacy fallback');
_feedRetryCount = 0;
try {
  // Delegate to HomeController's existing getPostsLegacy()
  // This uses /api/get-all-users-posts-v2 with page-based pagination
  await _fallbackToLegacy();
} catch (fallbackErr) {
  debugPrint('[EdgeRank] Legacy fallback also failed: $fallbackErr');
}
```

This requires a callback/method reference to `HomeController.getPostsLegacy()` since the mixin can't directly call it. Options:
- Abstract method `Future<void> onFeedFallback()` that `HomeController` overrides
- Or simply inline the legacy API call in the mixin

**Estimated:** ~15 lines changed

---

### Phase 3: Sponsored Ads (Gap 5) — MEDIUM Priority

#### Step 3.1 — Create Model

**New file:** `lib/app/models/sponsored_ad_model.dart`

```dart
class SponsoredAdModel {
  final int position;
  final String type;         // "sponsored"
  final Map<String, dynamic> data;  // campaign data, media, etc.
  String? anchorPostId;       // set by client after anchoring

  SponsoredAdModel({
    required this.position,
    required this.type,
    required this.data,
    this.anchorPostId,
  });

  factory SponsoredAdModel.fromMap(Map<String, dynamic> map) => ...;
}
```

**Estimated:** ~30 lines

#### Step 3.2 — Parse in Repository

**File:** `lib/app/repository/edgerank_repository.dart`

**Changes:**
1. Add `List<SponsoredAdModel> sponsoredAds` to `EdgeRankFeedResponse`
2. In `getEdgeRankFeed()`, parse `data['sponsoredAds']`:
   ```dart
   final rawAds = data['sponsoredAds'] as List? ?? [];
   for (final rawAd in rawAds) {
     final ad = SponsoredAdModel.fromMap(Map<String, dynamic>.from(rawAd));
     if (ad.position < posts.length) {
       ad.anchorPostId = posts[ad.position].id;
     }
     sponsoredAds.add(ad);
   }
   ```

**Estimated:** ~20 lines changed

#### Step 3.3 — Store in Controller

**File:** `lib/app/controllers/edgerank_feed_controller.dart`

**Changes:**
1. Add: `final RxMap<String, SponsoredAdModel> sponsoredAdsMap = <String, SponsoredAdModel>{}.obs;`
2. In `fetchEdgeRankFeed()`, after parsing:
   ```dart
   for (final ad in feedData.sponsoredAds) {
     if (ad.anchorPostId != null) {
       sponsoredAdsMap[ad.anchorPostId!] = ad;
     }
   }
   ```
3. In `refreshEdgeRankFeed()`: `sponsoredAdsMap.clear();`

**Estimated:** ~10 lines changed

#### Step 3.4 — Render in View

**File:** `lib/app/modules/NAVIGATION_MENUS/home/views/home_view.dart`

**Changes:**
After each `PostCard` (and after the existing `FeedInsertionWidget` check), add:
```dart
if (controller.sponsoredAdsMap.containsKey(postModel.id))
  Padding(
    padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
    child: SponsoredAdWidget(
      ad: controller.sponsoredAdsMap[postModel.id]!,
    ),
  ),
```

**New file:** `lib/app/components/sponsored_ad/sponsored_ad_widget.dart`
- For boosted posts: render as a `PostCard` with "Sponsored" overlay
- For external ads: render campaign image/video with CTA button

**Estimated:** ~50 lines (widget) + ~5 lines (view)

---

### Phase 4: Polish (Gap 6–7) — LOW Priority

Already included in Step 1.3 (throttle). Algorithm metadata storage is optional — implement only if analytics dashboard needs it.

---

## 4. Execution Summary

| Phase | Steps | Est. Lines | Priority | Dependencies |
|---|---|---|---|---|
| **Phase 1** | Steps 1.1–1.4 | ~62 lines | HIGH | None |
| **Phase 2** | Fallback | ~15 lines | MEDIUM | Phase 1 (retry logic) |
| **Phase 3** | Steps 3.1–3.4 | ~115 lines | MEDIUM | None (independent) |
| **Phase 4** | Throttle + metadata | ~10 lines | LOW | None |
| **Total** | | ~202 lines | | |

### File Change Summary

| File | Phases | Type |
|---|---|---|
| `lib/app/controllers/edgerank_feed_controller.dart` | 1, 2, 3 | Modify |
| `lib/app/modules/.../home/controllers/home_controller.dart` | 1, 2 | Modify |
| `lib/app/modules/.../home/views/home_view.dart` | 1, 3 | Modify |
| `lib/app/repository/edgerank_repository.dart` | 3 | Modify |
| `lib/app/models/sponsored_ad_model.dart` | 3 | **New** |
| `lib/app/components/sponsored_ad/sponsored_ad_widget.dart` | 3 | **New** |

---

## 5. Testing Checklist

### Phase 1 Testing
- [ ] Scroll to bottom of feed → new posts load seamlessly
- [ ] Scroll through all 4 backend stages → eventually shows "You're all caught up!"
- [ ] Turn off network mid-scroll → feed retries 3 times then stops gracefully
- [ ] Turn network back on → pull-to-refresh recovers full feed
- [ ] Backend returns `hasMore: false` with posts → scroll continues for one more attempt
- [ ] Backend returns `hasMore: false` with 0 posts → scroll permanently stops
- [ ] Rapid flinging → no duplicate API calls, no jank

### Phase 2 Testing
- [ ] Kill EdgeRank API → after 3 retries, legacy endpoint delivers posts
- [ ] Legacy endpoint also fails → graceful empty state, no crash

### Phase 3 Testing
- [ ] Feed contains sponsored ads from API → ads render inline at correct positions
- [ ] Boosted posts render as normal post cards with "Sponsored" label
- [ ] Sponsored ads survive pagination (anchored by post ID, not by index)
- [ ] Pull-to-refresh clears old ads and loads new ones
