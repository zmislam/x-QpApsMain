/// Reels V2 API Constants
/// All V2 endpoints use the `/v2/reels/` prefix.
class ReelConstants {
  ReelConstants._();

  // === API Endpoints (relative to base URL) ===
  static const String v2Base = 'v2/reels';

  // Feed
  static const String feedForYou = '$v2Base/feed/for-you';
  static const String feedFollowing = '$v2Base/feed/following';
  static const String feedTrending = '$v2Base/feed/trending';
  static String feedHashtag(String tag) => '$v2Base/feed/hashtag/$tag';
  static String feedSound(String soundId) => '$v2Base/feed/sound/$soundId';
  static String feedLocation(String locId) => '$v2Base/feed/location/$locId';
  static String feedTopic(String topicId) => '$v2Base/feed/topic/$topicId';
  static String feedRelated(String reelId) => '$v2Base/feed/related/$reelId';
  static const String feedChallenges = '$v2Base/feed/challenges';

  // CRUD
  static const String createReel = v2Base;
  static String getReel(String id) => '$v2Base/$id';
  static String updateReel(String id) => '$v2Base/$id';
  static String deleteReel(String id) => '$v2Base/$id';
  static String userReels(String userId) => '$v2Base/user/$userId';
  static const String drafts = '$v2Base/drafts';
  static const String schedule = '$v2Base/schedule';

  // Interactions
  static String addReaction(String id) => '$v2Base/$id/reaction';
  static String removeReaction(String id) => '$v2Base/$id/reaction';
  static String getReactions(String id) => '$v2Base/$id/reactions';
  static String addComment(String id) => '$v2Base/$id/comment';
  static String getComments(String id) => '$v2Base/$id/comments';
  static String editComment(String cid) => '$v2Base/comment/$cid';
  static String deleteComment(String cid) => '$v2Base/comment/$cid';
  static String replyComment(String cid) => '$v2Base/comment/$cid/reply';
  static String pinComment(String cid) => '$v2Base/comment/$cid/pin';
  static String commentReaction(String cid) => '$v2Base/comment/$cid/reaction';
  static String commentReplies(String cid) => '$v2Base/comment/$cid/replies';
  static String toggleBookmark(String id) => '$v2Base/$id/bookmark';
  static String shareReel(String id) => '$v2Base/$id/share';
  static String downloadReel(String id) => '$v2Base/$id/download';
  static String notInterested(String id) => '$v2Base/$id/not-interested';
  static String reportReel(String id) => '$v2Base/$id/report';
  static String followAuthor(String id) => '$v2Base/$id/follow-author';

  // Sounds
  static const String trendingSounds = '$v2Base/sound/trending';
  static const String soundLibrary = '$v2Base/sound/library';
  static const String searchSounds = '$v2Base/sound/search';
  static const String savedSounds = '$v2Base/sound/saved';
  static const String soundEffects = '$v2Base/sound/effects';
  static String soundDetail(String id) => '$v2Base/sound/$id';
  static String soundReels(String id) => '$v2Base/sound/$id/reels';
  static String toggleSaveSound(String id) => '$v2Base/sound/$id/save';

  // Remix
  static const String createRemix = '$v2Base/remix';
  static String remixChain(String id) => '$v2Base/$id/remix-chain';
  static String remixes(String id) => '$v2Base/$id/remixes';

  // Collections
  static const String collections = '$v2Base/collection';
  static String updateCollection(String id) => '$v2Base/collection/$id';
  static String deleteCollection(String id) => '$v2Base/collection/$id';
  static String addToCollection(String id) => '$v2Base/collection/$id/add';
  static String removeFromCollection(String id) => '$v2Base/collection/$id/remove';
  static String collectionReels(String id) => '$v2Base/collection/$id/reels';

  // Analytics
  static const String analyticsOverview = '$v2Base/analytics/overview';
  static String reelInsights(String id) => '$v2Base/analytics/$id';
  static String retentionCurve(String id) => '$v2Base/analytics/$id/retention';
  static const String audienceDemographics = '$v2Base/analytics/audience';
  static const String topReels = '$v2Base/analytics/top';
  static const String growth = '$v2Base/analytics/growth';
  static const String earnings = '$v2Base/analytics/earnings';
  static const String exportAnalytics = '$v2Base/analytics/export';

  // Tracking
  static const String trackView = '$v2Base/tracking/view';
  static const String trackWatchTime = '$v2Base/tracking/watch-time';
  static const String trackImpression = '$v2Base/tracking/impression';

  // Series
  static String userSeries(String userId) => '$v2Base/series/user/$userId';
  static const String createSeries = '$v2Base/series';
  static String updateSeries(String id) => '$v2Base/series/$id';
  static String deleteSeries(String id) => '$v2Base/series/$id';
  static String seriesReels(String id) => '$v2Base/series/$id/reels';

  // Settings
  static const String settings = '$v2Base/settings';
  static const String hiddenWords = '$v2Base/settings/hidden-words';
  static const String likedReels = '$v2Base/liked';
  static const String watchHistory = '$v2Base/history';

  // Upload
  static const String uploadChunk = '$v2Base/upload/chunk';
  static const String uploadProcess = '$v2Base/upload/process';
  static String uploadStatus(String id) => '$v2Base/upload/status/$id';

  // Admin
  static const String adminConfig = '$v2Base/admin/config';
  static const String adminReports = '$v2Base/admin/reports';
  static const String adminStats = '$v2Base/admin/stats';
  static String adminReviewReport(String id) => '$v2Base/admin/reports/$id';
  static String adminForceRemove(String id) => '$v2Base/admin/reel/$id';

  // Sponsored Reels
  static const String sponsoredServe = 'campaigns-v2/serve';
  static String sponsoredImpression(String id) => 'campaigns-v2/$id/impression';
  static String sponsoredClick(String id) => 'campaigns-v2/$id/click';
  static String sponsoredFeedback(String id) => 'campaigns-v2/$id/feedback';
  static String sponsoredReaction(String id) => 'campaigns-v2/$id/reaction';
  static String sponsoredComment(String id) => 'campaigns-v2/$id/comment';
  static String sponsoredComments(String id) => 'campaigns-v2/$id/comments';
  static String sponsoredWhyThisAd(String id) => 'campaigns-v2/$id/targeting';

  // Boost
  static const String boostCreate = 'campaigns-v2/boost';
  static const String boostList = 'campaigns-v2/boost/list';
  static String boostAnalytics(String id) => 'campaigns-v2/boost/$id/analytics';
  static String boostAction(String id) => 'campaigns-v2/boost/$id/action';
  static String boostDetail(String id) => 'campaigns-v2/boost/$id';

  // Feed merge config
  static const int sponsoredInterval = 6; // 1 ad per N organic reels

  // === Preload Config ===
  static const int preloadWindowSize = 5; // 2 prev + current + 2 next
  static const int preloadBefore = 2;
  static const int preloadAfter = 2;

  // === Pagination ===
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
  static const int commentsPageSize = 20;

  // === Video Config ===
  static const int maxVideoLengthMs = 90000; // 90 seconds
  static const int minVideoLengthMs = 3000; // 3 seconds
  static const double defaultAspectRatio = 9 / 16;

  // === Cache Keys ===
  static const String cacheForYou = 'rv2_feed_foryou';
  static const String cacheFollowing = 'rv2_feed_following';
  static const String cacheTrending = 'rv2_feed_trending';
  static const String cacheReelDetail = 'rv2_reel_';
  static const int cacheFeedTtlSeconds = 120;
  static const int cacheDetailTtlSeconds = 600;

  // === Socket Events ===
  static const String socketNamespace = '/reels-v2';
  static const String socketStartViewing = 'start-viewing-v2';
  static const String socketStopViewing = 'stop-viewing-v2';
  static const String socketTrackView = 'track-view-v2';
  static const String socketTrackWatchTime = 'track-watch-time-v2';
  static const String socketLiveComment = 'live-comment';
  static const String socketNewComment = 'new-comment-v2';
  static const String socketLiveReaction = 'live-reaction';
  static const String socketNewReaction = 'new-reaction-v2';
}
