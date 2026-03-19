import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../config/constants/api_constant.dart';
import '../../config/constants/app_assets.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../extension/string/string_image_path.dart';
import '../../repository/edgerank_repository.dart';
import '../../routes/profile_navigator.dart';
import '../../services/api_communication.dart';
import '../../utils/post_utlis.dart';
import '../image.dart';

/// Inline sponsored ad card rendered from campaign data delivered by
/// the EdgeRank feed insertion plan.
///
/// Renders like a regular post with:
///  1. Poster header (avatar, name, "Sponsored" badge, timestamp)
///  2. Description text
///  3. Cover image
///  4. Info bar (domain + headline + CTA button)
///  5. Like / Comment / Share action buttons
class SponsoredPostCard extends StatefulWidget {
  const SponsoredPostCard({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<SponsoredPostCard> createState() => _SponsoredPostCardState();
}

class _SponsoredPostCardState extends State<SponsoredPostCard> {
  final ApiCommunication _api = ApiCommunication();
  bool _liked = false;
  bool _hidden = false;
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  bool _videoFailed = false;

  // ── Derived fields ──
  late final String _campaignId;
  late final String _headline;
  late final String _description;
  late final String _ctaLabel;
  late final String _websiteUrl;
  late final String _createdAt;
  late final String _coverImageUrl;
  late final String _videoUrl;
  late final bool _isVideo;

  // Poster info — mutable because it may be fetched async
  String _posterName = '';
  String _posterProfilePic = '';
  bool _isVerified = false;
  String _posterUsername = '';
  bool _posterLoaded = false;

  @override
  void initState() {
    super.initState();
    final data = widget.data;

    // Debug: Log the FULL received data structure
    debugPrint('[SponsoredPostCard] ========== FULL DATA ==========');
    debugPrint('[SponsoredPostCard] $data');
    debugPrint('[SponsoredPostCard] ========== END DATA ==========');
    debugPrint('[SponsoredPostCard] media: ${data['media']}');
    debugPrint('[SponsoredPostCard] creative: ${data['creative']}');
    debugPrint('[SponsoredPostCard] campaign_cover_pic: ${data['campaign_cover_pic']}');
    debugPrint('[SponsoredPostCard] website_url: ${data['website_url']}');
    debugPrint('[SponsoredPostCard] destination: ${data['destination']}');
    debugPrint('[SponsoredPostCard] call_to_action: ${data['call_to_action']}');

    _campaignId = (data['_id'] ?? '').toString();
    // Web: const campaignName = data.campaign_name || data.creative?.headline || "";
    _headline =
        (data['campaign_name'] ?? 
         (data['creative'] is Map ? data['creative']['headline'] : null) ?? 
         '').toString();
    // Web: const description = data.description || data.creative?.primary_text || data.creative?.description || "";
    _description = (data['description'] ?? 
        (data['creative'] is Map ? data['creative']['primary_text'] : null) ?? 
        (data['creative'] is Map ? data['creative']['description'] : null) ??
        '').toString();
    // Web: const ctaLabel = data.call_to_action || "Learn More";
    _ctaLabel =
        (data['call_to_action'] ?? 'Learn More')
            .toString();
    // Web: const websiteUrl = data.website_url || data.destination?.website_url || data.destination?.app_store_url || "";
    final destination = data['destination'] is Map 
        ? data['destination'] as Map 
        : {};
    _websiteUrl = (data['website_url'] ?? 
        destination['website_url'] ?? 
        destination['app_store_url'] ?? 
        '').toString();
    _createdAt = (data['createdAt'] ?? '').toString();

    debugPrint('[SponsoredPostCard] Extracted websiteUrl: $_websiteUrl, ctaLabel: $_ctaLabel');

    // Check media array first (like web version) for video/image
    // Web: const mediaItem = data.media?.[0];
    // Web: const mediaUrl = mediaItem?.media
    //        ? mediaItem.media.startsWith("http")
    //           ? mediaItem.media
    //           : `${host}/uploads/adsStorage/${mediaItem.media}`
    //        : null;
    // Web: const isVideo = mediaItem?.media_type === "video" || mediaItem?.media?.includes?.(".mp4");
    final List mediaList = data['media'] is List
        ? data['media'] as List
        : [];
    
    String mediaUrl = '';
    bool isVideo = false;
    
    if (mediaList.isNotEmpty) {
      final mediaItem = mediaList[0] is Map 
          ? Map<String, dynamic>.from(mediaList[0] as Map)
          : <String, dynamic>{};
      final mediaFile = (mediaItem['media'] ?? '').toString();
      final mediaType = (mediaItem['media_type'] ?? '').toString();
      
      if (mediaFile.isNotEmpty) {
        // Check if it's a video by media_type or file extension (like web)
        isVideo = mediaType == 'video' || mediaFile.contains('.mp4');
        
        // Build URL same as web: if starts with http use as-is, else prepend server path
        if (mediaFile.startsWith('http')) {
          mediaUrl = mediaFile;
        } else {
          mediaUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/adsStorage/$mediaFile';
        }
      }
    }
    
    // Fallback to campaign_cover_pic if no media array
    if (mediaUrl.isEmpty) {
      final List coverPics = data['campaign_cover_pic'] is List
          ? data['campaign_cover_pic'] as List
          : [];
      if (coverPics.isNotEmpty) {
        final coverFile = coverPics[0].toString();
        // Check file extension for video (like web)
        isVideo = coverFile.contains('.mp4');
        
        // Build URL same as web
        if (coverFile.startsWith('http')) {
          mediaUrl = coverFile;
        } else {
          mediaUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/adsStorage/$coverFile';
        }
      }
    }
    
    _coverImageUrl = isVideo ? '' : mediaUrl;
    _videoUrl = isVideo ? mediaUrl : '';
    _isVideo = isVideo;
    
    debugPrint('[SponsoredPostCard] Final media: isVideo=$_isVideo, coverImageUrl=$_coverImageUrl, videoUrl=$_videoUrl');
    
    // Initialize video controller if we have a video
    if (_isVideo && _videoUrl.isNotEmpty) {
      _initializeVideo();
    }

    // Try to use poster/owner data from backend (if available)
    // V2 API uses 'campaign_owner', older API uses 'poster'
    final Map<String, dynamic> owner = data['campaign_owner'] is Map
        ? Map<String, dynamic>.from(data['campaign_owner'] as Map)
        : (data['poster'] is Map
            ? Map<String, dynamic>.from(data['poster'] as Map)
            : {});

    if (owner.isNotEmpty && owner['first_name'] != null) {
      _posterName =
          '${owner['first_name'] ?? ''} ${owner['last_name'] ?? ''}'
              .trim();
      _posterProfilePic = (owner['profile_pic'] ?? '').toString();
      _isVerified = owner['isProfileVerified'] == true || owner['is_verified'] == true;
      _posterUsername = (owner['username'] ?? '').toString();
      _posterLoaded = true;
    } else {
      // Owner not available — fallback to campaign_name while we fetch
      _posterName = (data['campaign_name'] ?? 'Sponsored').toString();
      _posterLoaded = false;

      // Fetch poster info using campaign's user_id
      final String userId = (data['user_id'] ?? data['campaign_user_id'] ?? '').toString();
      if (userId.isNotEmpty) {
        _fetchPosterInfo(userId);
      } else {
        _posterLoaded = true; // No user_id to fetch, keep campaign name
      }
    }
  }

  /// Fetch the campaign creator's profile info.
  Future<void> _fetchPosterInfo(String userId) async {
    try {
      final response = await _api.doGetRequest(
        apiEndPoint: 'get-user-info/$userId',
        responseDataKey: ApiConstant.FULL_RESPONSE,
        enableLoading: false,
      );
      if (!mounted) return;
      if (response.isSuccessful && response.data != null) {
        final responseData = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};
        final userInfo = responseData['userInfo'] is Map
            ? Map<String, dynamic>.from(responseData['userInfo'] as Map)
            : <String, dynamic>{};
        if (userInfo.isNotEmpty) {
          setState(() {
            _posterName =
                '${userInfo['first_name'] ?? ''} ${userInfo['last_name'] ?? ''}'
                    .trim();
            _posterProfilePic =
                (userInfo['profile_pic'] ?? '').toString();
            _isVerified = userInfo['is_verified'] == true;
            _posterUsername = (userInfo['username'] ?? '').toString();
            _posterLoaded = true;
          });
        } else {
          setState(() => _posterLoaded = true);
        }
      } else {
        if (mounted) setState(() => _posterLoaded = true);
      }
    } catch (e) {
      debugPrint('[SponsoredPostCard] Failed to fetch poster: $e');
      if (mounted) setState(() => _posterLoaded = true);
    }
  }

  /// Initialize video player for campaign video
  Future<void> _initializeVideo() async {
    try {
      debugPrint('[SponsoredPostCard] Initializing video: $_videoUrl');
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(_videoUrl),
      );
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.setVolume(0); // Start muted
      _videoController!.play();
      if (mounted) {
        setState(() => _videoInitialized = true);
      }
    } catch (e) {
      debugPrint('[SponsoredPostCard] Video init error: $e');
      // Video failed to load - show placeholder instead
      if (mounted) {
        setState(() => _videoFailed = true);
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────
  // Campaign click tracking (mirroring web's handleClick)
  // ───────────────────────────────────────────────────────
  void _trackClick() {
    _api
        .doPostRequest(
          apiEndPoint: 'campaign/save-campaign-performance',
          requestData: {
            'campaign_id': _campaignId,
            'campaign_name': widget.data['campaign_name'] ?? '',
            'campaign_location':
                (widget.data['locations'] as List?)?.join(',') ?? '',
            'is_impressed': false,
            'is_reached': false,
            'is_clicked': true,
          },
        )
        .catchError((_) {});
  }

  // ───────────────────────────────────────────────────────
  // Actions
  // ───────────────────────────────────────────────────────
  void _onLike() {
    setState(() => _liked = !_liked);
    _trackClick();
  }

  void _onComment() {
    _trackClick();
    if (_websiteUrl.isNotEmpty) {
      _openUrl(_websiteUrl);
    }
  }

  void _onShare() {
    String url = _websiteUrl;
    if (url.isEmpty) {
      // Share just the headline if no URL
      Share.share(_headline.isNotEmpty ? _headline : _posterName);
      return;
    }
    if (!url.startsWith('http')) url = 'https://$url';
    final shareText = _headline.isNotEmpty ? '$_headline\n$url' : url;
    Share.share(shareText);
    _trackClick();
  }

  void _onDismiss() {
    EdgeRankRepository()
        .dismissInsertion(insertionType: 'sponsored', itemId: _campaignId)
        .catchError((_) {});
    setState(() => _hidden = true);
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: FeedDesignTokens.textSecondary(context)
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.visibility_off_outlined,
                  color: FeedDesignTokens.textPrimary(context)),
              title: Text('Hide this ad'.tr,
                  style: TextStyle(
                      color: FeedDesignTokens.textPrimary(context))),
              subtitle: Text('Stop seeing this ad'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                _onDismiss();
              },
            ),
            ListTile(
              leading: Icon(Icons.flag_outlined,
                  color: FeedDesignTokens.textPrimary(context)),
              title: Text('Report ad'.tr,
                  style: TextStyle(
                      color: FeedDesignTokens.textPrimary(context))),
              subtitle: Text('Tell us about a problem with this ad'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                // Could navigate to a report screen
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline,
                  color: FeedDesignTokens.textPrimary(context)),
              title: Text('Why am I seeing this ad?'.tr,
                  style: TextStyle(
                      color: FeedDesignTokens.textPrimary(context))),
              onTap: () {
                Navigator.pop(context);
                // Could show explanation
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_campaignId.isEmpty || _hidden) return const SizedBox.shrink();

    return Container(
      color: FeedDesignTokens.cardBg(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Separator ───
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),

          // ═══════════════════════════════════════════════════
          // POST HEADER — Avatar + Name + Sponsored badge
          // ═══════════════════════════════════════════════════
          Padding(
            padding: const EdgeInsets.only(
              top: FeedDesignTokens.cardPaddingV,
              left: FeedDesignTokens.cardPaddingH,
              right: FeedDesignTokens.cardPaddingH,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar — taps to profile
                GestureDetector(
                  onTap: () {
                    if (_posterUsername.isNotEmpty) {
                      ProfileNavigator.navigateToProfile(
                          username: _posterUsername);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        FeedDesignTokens.avatarSize / 2),
                    child: _posterProfilePic.isNotEmpty
                        ? RoundCornerNetworkImage(
                            imageUrl:
                                _posterProfilePic.formatedProfileUrl,
                            height: FeedDesignTokens.avatarSize,
                            width: FeedDesignTokens.avatarSize,
                          )
                        : Image.asset(
                            AppAssets.DEFAULT_PROFILE_IMAGE,
                            height: FeedDesignTokens.avatarSize,
                            width: FeedDesignTokens.avatarSize,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: FeedDesignTokens.avatarSize * 0.25),

                // Name + meta row — taps to profile
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_posterUsername.isNotEmpty) {
                        ProfileNavigator.navigateToProfile(
                            username: _posterUsername);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _posterName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: FeedDesignTokens.nameSize,
                                  color: FeedDesignTokens.textPrimary(
                                      context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (_isVerified) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: FeedDesignTokens.brand(context),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (_createdAt.isNotEmpty) ...[
                              Text(
                                getDynamicFormatedTime(_createdAt),
                                style: TextStyle(
                                  fontSize: FeedDesignTokens.timeSize,
                                  color: FeedDesignTokens.textSecondary(
                                      context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4),
                                child: Text(
                                  '·',
                                  style: TextStyle(
                                    fontSize: FeedDesignTokens.timeSize,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        FeedDesignTokens.textSecondary(
                                            context),
                                  ),
                                ),
                              ),
                            ],
                            Text(
                              'Sponsored'.tr,
                              style: TextStyle(
                                fontSize: FeedDesignTokens.timeSize,
                                color: FeedDesignTokens.textSecondary(
                                    context),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.public,
                              size: 14,
                              color: FeedDesignTokens.textSecondary(
                                  context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Three-dot menu
                InkWell(
                  onTap: _showMoreOptions,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.more_horiz,
                      size: 22,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ═══════════════════════════════════════════════════
          // DESCRIPTION TEXT — taps to open URL
          // ═══════════════════════════════════════════════════
          if (_description.isNotEmpty)
            GestureDetector(
              onTap: () {
                _trackClick();
                _openUrl(_websiteUrl);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  FeedDesignTokens.cardPaddingH,
                  10,
                  FeedDesignTokens.cardPaddingH,
                  10,
                ),
                child: Text(
                  _description,
                  style: TextStyle(
                    fontSize: 14,
                    color: FeedDesignTokens.textPrimary(context),
                    height: 1.4,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          // ═══════════════════════════════════════════════════
          // MEDIA SECTION — VIDEO or IMAGE or PLACEHOLDER
          // ═══════════════════════════════════════════════════
          if (_isVideo && _videoUrl.isNotEmpty && !_videoFailed)
            GestureDetector(
              onTap: () {
                _trackClick();
                _openUrl(_websiteUrl);
              },
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _videoInitialized && _videoController != null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_videoController!),
                          // Play/Pause overlay
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_videoController!.value.isPlaying) {
                                    _videoController!.pause();
                                  } else {
                                    _videoController!.play();
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  _videoController!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          // Mute/Unmute overlay
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_videoController!.value.volume > 0) {
                                    _videoController!.setVolume(0);
                                  } else {
                                    _videoController!.setVolume(1);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  _videoController!.value.volume > 0
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: FeedDesignTokens.inputBg(context),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: FeedDesignTokens.brand(context),
                          ),
                        ),
                      ),
              ),
            )
          // Video failed to load — show placeholder with video icon
          else if (_isVideo && _videoFailed)
            GestureDetector(
              onTap: () {
                _trackClick();
                _openUrl(_websiteUrl);
              },
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: FeedDesignTokens.inputBg(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off_outlined,
                        size: 48,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Video unavailable',
                        style: TextStyle(
                          fontSize: 13,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_coverImageUrl.isNotEmpty)
            GestureDetector(
              onTap: () {
                _trackClick();
                _openUrl(_websiteUrl);
              },
              child: Image.network(
                _coverImageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: FeedDesignTokens.inputBg(context),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: FeedDesignTokens.brand(context),
                          value: loadingProgress.expectedTotalBytes !=
                                  null
                              ? loadingProgress
                                      .cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: FeedDesignTokens.inputBg(context),
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ),
              ),
            )
          // No media available — show compact placeholder
          else if (!_isVideo && _coverImageUrl.isEmpty)
            GestureDetector(
              onTap: () {
                _trackClick();
                _openUrl(_websiteUrl);
              },
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: FeedDesignTokens.inputBg(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.campaign_outlined,
                        size: 48,
                        color: FeedDesignTokens.brand(context).withOpacity(0.5),
                      ),
                      if (_websiteUrl.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Tap to visit',
                          style: TextStyle(
                            fontSize: 13,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          // ═══════════════════════════════════════════════════
          // BOTTOM INFO BAR (domain + headline + CTA)
          // ═══════════════════════════════════════════════════
          GestureDetector(
            onTap: () {
              _trackClick();
              _openUrl(_websiteUrl);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FeedDesignTokens.cardPaddingH,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: FeedDesignTokens.inputBg(context),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_websiteUrl.isNotEmpty)
                          Text(
                            _extractDomain(_websiteUrl).toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: FeedDesignTokens.textSecondary(
                                  context),
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (_headline.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            _headline,
                            style: TextStyle(
                              fontSize: FeedDesignTokens.nameSize,
                              fontWeight: FontWeight.w600,
                              color: FeedDesignTokens.textPrimary(
                                  context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_websiteUrl.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _trackClick();
                        _openUrl(_websiteUrl);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: FeedDesignTokens.brand(context),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _ctaLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ═══════════════════════════════════════════════════
          // DIVIDER
          // ═══════════════════════════════════════════════════
          Divider(
            height: 1,
            thickness: 0.5,
            color: FeedDesignTokens.divider(context),
          ),

          // ═══════════════════════════════════════════════════
          // ACTION BAR — Like | Comment | Share
          // ═══════════════════════════════════════════════════
          SizedBox(
            height: FeedDesignTokens.actionBarHeight,
            child: Row(
              children: [
                // Like button with active state
                Expanded(
                  child: InkWell(
                    onTap: _onLike,
                    child: SizedBox(
                      height: FeedDesignTokens.actionBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _liked
                                ? AppAssets.LIKE_ICON
                                : AppAssets.LIKE_ACTION_ICON,
                            height: FeedDesignTokens.actionIconSize,
                            width: FeedDesignTokens.actionIconSize,
                            color: _liked
                                ? FeedDesignTokens.brand(context)
                                : FeedDesignTokens.textSecondary(context),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Like'.tr,
                            style: TextStyle(
                              fontSize:
                                  FeedDesignTokens.actionButtonSize,
                              fontWeight: FontWeight.w600,
                              color: _liked
                                  ? FeedDesignTokens.brand(context)
                                  : FeedDesignTokens.textSecondary(
                                      context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Comment button
                _SponsoredActionButton(
                  icon: AppAssets.COMMENT_ACTION_ICON,
                  label: 'Comment'.tr,
                  onTap: _onComment,
                ),
                // Share button
                _SponsoredActionButton(
                  icon: AppAssets.SHARE_ACTION_ICON,
                  label: 'Share'.tr,
                  onTap: _onShare,
                ),
              ],
            ),
          ),

          // ─── Post separator ───
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),
        ],
      ),
    );
  }

  /// Extract domain name from a URL for display.
  String _extractDomain(String url) {
    try {
      String clean = url;
      if (!clean.startsWith('http')) clean = 'https://$clean';
      final uri = Uri.parse(clean);
      String host = uri.host;
      if (host.startsWith('www.')) host = host.substring(4);
      return host;
    } catch (_) {
      return url;
    }
  }

  /// Open the campaign URL in the browser.
  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    String finalUrl = url.trim();
    if (!finalUrl.startsWith('http')) finalUrl = 'https://$finalUrl';
    try {
      final uri = Uri.parse(finalUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('[SponsoredPostCard] Failed to open URL: $finalUrl - $e');
    }
  }
}

/// Action button matching the regular post footer style.
class _SponsoredActionButton extends StatelessWidget {
  const _SponsoredActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: FeedDesignTokens.actionBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: FeedDesignTokens.actionIconSize,
                width: FeedDesignTokens.actionIconSize,
                color: FeedDesignTokens.textSecondary(context),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: FeedDesignTokens.actionButtonSize,
                  fontWeight: FontWeight.w600,
                  color: FeedDesignTokens.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
