// =============================================================================
// Sponsored Ad Widget — Full Facebook-style post card for V2 campaign ads
// =============================================================================
// Renders a sponsored ad inline in the feed with full engagement features:
//   - Reaction emojis + counts (same design as regular PostFooter)
//   - Like/Comment/Share action bar (same design as regular BottomAction)
//   - Comment section (inline expandable)
//   - Reaction modal shows who reacted (Facebook-style bottom sheet)
//   - CTA button (Learn More) links to campaign website
//   - Close/dismiss button
//
// API endpoints: /api/campaigns-v2/engagement/* (separate from regular posts)
// Data comes from SponsoredAdModel (EdgeRank feed response sponsoredAds[])
//
// Created: initial stub (unknown date)
// Rewritten: 2026-03-14 — full engagement features matching regular post cards
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/constants/api_constant.dart';
import '../../config/constants/app_assets.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../models/sponsored_ad_model.dart';
import '../../repository/ad_engagement_repository.dart';
import '../../utils/post_utlis.dart';
import '../reaction_button/post_reaction_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  SponsoredAdWidget — Main widget
// ─────────────────────────────────────────────────────────────────────────────
class SponsoredAdWidget extends StatefulWidget {
  final SponsoredAdModel ad;

  const SponsoredAdWidget({super.key, required this.ad});

  @override
  State<SponsoredAdWidget> createState() => _SponsoredAdWidgetState();
}

class _SponsoredAdWidgetState extends State<SponsoredAdWidget> {
  final AdEngagementRepository _repo = AdEngagementRepository();

  // ── Engagement state ──
  Map<String, dynamic> _reactions = {}; // {like: N, love: N, ...}
  int _totalReactions = 0;
  int _commentCount = 0;
  String? _userReaction; // current user's reaction type or null
  bool _isLoadingEngagement = true;

  // ── Comments state ──
  List<Map<String, dynamic>> _comments = [];
  bool _commentsExpanded = false;
  bool _commentsLoading = false;
  bool _commentsHasMore = false;
  int _commentPage = 1;

  // ── Comment input ──
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final RxBool _hasCommentText = false.obs;

  // ── Busy flag ──
  bool _reactionBusy = false;
  bool _showFullText = false;

  String? get _adId => widget.ad.adId;

  @override
  void initState() {
    super.initState();
    _fetchEngagementData();
    _commentController.addListener(() {
      _hasCommentText.value = _commentController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _repo.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  API calls
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _fetchEngagementData() async {
    if (_adId == null) return;
    try {
      final response = await _repo.getEngagementData(_adId!);
      if (response.isSuccessful && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _reactions = Map<String, dynamic>.from(data['reactions'] ?? {});
            _totalReactions = data['total_reactions'] ?? 0;
            _commentCount = data['comment_count'] ?? 0;
            _userReaction = data['user_reaction'];
            _isLoadingEngagement = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingEngagement = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingEngagement = false);
    }
  }

  Future<void> _onReaction(String reactionType) async {
    if (_reactionBusy || _adId == null) return;
    _reactionBusy = true;

    // Optimistic update
    final prevReactions = Map<String, dynamic>.from(_reactions);
    final prevTotal = _totalReactions;
    final prevUserReaction = _userReaction;
    final isRemoving = _userReaction == reactionType;

    setState(() {
      // Remove old reaction count
      if (_userReaction != null && _reactions.containsKey(_userReaction)) {
        _reactions[_userReaction!] =
            ((_reactions[_userReaction!] as int? ?? 1) - 1).clamp(0, 999999);
      }
      // Add new reaction count (if not removing)
      if (!isRemoving) {
        _reactions[reactionType] =
            ((_reactions[reactionType] as int? ?? 0) + 1);
        _userReaction = reactionType;
      } else {
        _userReaction = null;
      }
      _totalReactions =
          _reactions.values.fold<int>(0, (s, v) => s + (v as int? ?? 0));
    });

    try {
      final response = await _repo.saveReaction(_adId!, reactionType);
      if (response.isSuccessful && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _reactions =
                Map<String, dynamic>.from(data['reactions'] ?? _reactions);
            _totalReactions = data['total_reactions'] ?? _totalReactions;
            _userReaction = data['user_reaction'];
          });
        }
      }
    } catch (_) {
      // Rollback on error
      if (mounted) {
        setState(() {
          _reactions = prevReactions;
          _totalReactions = prevTotal;
          _userReaction = prevUserReaction;
        });
      }
    } finally {
      _reactionBusy = false;
    }
  }

  Future<void> _fetchComments({bool append = false}) async {
    if (_adId == null || _commentsLoading) return;
    setState(() => _commentsLoading = true);

    try {
      final page = append ? _commentPage + 1 : 1;
      final response = await _repo.getComments(_adId!, page: page);
      if (response.isSuccessful && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final comments =
            List<Map<String, dynamic>>.from(data['comments'] ?? []);
        final pagination = data['pagination'] as Map<String, dynamic>? ?? {};
        if (mounted) {
          setState(() {
            if (append) {
              _comments.addAll(comments);
            } else {
              _comments = comments;
            }
            _commentsHasMore = pagination['hasMore'] == true;
            _commentPage = page;
            _commentsLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _commentsLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _commentsLoading = false);
    }
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _adId == null) return;

    _commentController.clear();
    _commentFocusNode.unfocus();

    try {
      final response = await _repo.saveComment(_adId!, text);
      if (response.isSuccessful && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final newComment = data['comment'] as Map<String, dynamic>?;
        if (newComment != null && mounted) {
          setState(() {
            _comments.insert(0, newComment);
            _commentCount = data['comment_count'] ?? _commentCount + 1;
          });
        }
      }
    } catch (_) {
      // silently fail
    }
  }

  void _toggleComments() {
    setState(() {
      _commentsExpanded = !_commentsExpanded;
      if (_commentsExpanded && _comments.isEmpty) {
        _fetchComments();
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coverUrl = widget.ad.coverMedia.isNotEmpty
        ? _formatMediaUrl(widget.ad.coverMedia.first)
        : null;
    final description = widget.ad.description ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: FeedDesignTokens.cardBg(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: AD badge + campaign name + "Sponsored" label + close ──
          _buildHeader(context, isDark),

          // ── Description ──
          if (description.isNotEmpty)
            _buildDescription(context, isDark, description),

          // ── Cover media ──
          if (coverUrl != null) _buildCoverMedia(coverUrl, isDark),

          // ── CTA bar (website + Learn More button) ──
          if (widget.ad.websiteUrl != null &&
              widget.ad.websiteUrl!.isNotEmpty)
            _buildCtaBar(context, isDark),

          // ── Reaction counts row ──
          _buildCountsRow(context),

          // ── Divider ──
          Divider(
            height: 1,
            thickness: 0.5,
            color: FeedDesignTokens.divider(context),
          ),

          // ── Like / Comment / Share action bar ──
          _buildActionBar(context),

          // ── Inline comments section (expandable) ──
          if (_commentsExpanded) _buildCommentsSection(context, isDark),

          // ── Post separator ──
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Header
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, bool isDark) {
    final ownerName = _getOwnerName();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          FeedDesignTokens.cardPaddingH, 12, FeedDesignTokens.cardPaddingH, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AD badge circle
          _buildAdBadge(),
          const SizedBox(width: 10),
          // Campaign name + owner + "Sponsored" label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.ad.campaignName != null)
                  Text(
                    widget.ad.campaignName!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: FeedDesignTokens.nameSize,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    if (ownerName != null) ...[
                      Text(
                        'Sponsored by ',
                        style: TextStyle(
                          fontSize: 12,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          ownerName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: FeedDesignTokens.textPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(
                          fontSize: 12,
                          color: FeedDesignTokens.textSecondary(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    // "Sponsored" pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1b74e4).withValues(alpha: 0.08),
                            const Color(0xFF6c5ce7).withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Text(
                        'Sponsored',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1b74e4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Close / dismiss button
          GestureDetector(
            onTap: () {
              // Could hook into dismissal API if needed
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 20,
                color: FeedDesignTokens.textSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdBadge() {
    return Container(
      width: FeedDesignTokens.avatarSize,
      height: FeedDesignTokens.avatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1b74e4), Color(0xFF6c5ce7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Text(
          'AD',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Description
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDescription(
      BuildContext context, bool isDark, String description) {
    const maxLen = 180;
    final truncated = description.length > maxLen && !_showFullText;
    final displayText =
        truncated ? '${description.substring(0, maxLen)}...' : description;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          FeedDesignTokens.cardPaddingH, 0, FeedDesignTokens.cardPaddingH, 8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: FeedDesignTokens.textPrimary(context),
            height: 1.4,
          ),
          children: [
            TextSpan(text: displayText),
            if (truncated)
              WidgetSpan(
                child: GestureDetector(
                  onTap: () => setState(() => _showFullText = true),
                  child: Text(
                    ' See more',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Cover Media
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCoverMedia(String coverUrl, bool isDark) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: coverUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
        ),
        errorWidget: (_, __, ___) => Container(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          child: const Icon(Icons.image_not_supported, size: 40),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  CTA Bar
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCtaBar(BuildContext context, bool isDark) {
    final url = widget.ad.websiteUrl!;
    final hostname = _getHostname(url);

    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.fromLTRB(FeedDesignTokens.cardPaddingH, 10,
            FeedDesignTokens.cardPaddingH, 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: FeedDesignTokens.divider(context),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hostname.isNotEmpty)
                    Text(
                      hostname.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        color: FeedDesignTokens.textSecondary(context),
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (widget.ad.campaignName != null)
                    Text(
                      widget.ad.campaignName!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: FeedDesignTokens.textPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF1b74e4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Learn More',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Counts Row (reaction icons + count, comment count) — matches PostFooter
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCountsRow(BuildContext context) {
    final hasAnyCounts = _totalReactions > 0 || _commentCount > 0;
    if (!hasAnyCounts && !_isLoadingEngagement) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FeedDesignTokens.cardPaddingH,
        vertical: 10,
      ),
      child: Row(
        children: [
          // Reaction icons + count (left side)
          if (_totalReactions > 0)
            Expanded(
              child: GestureDetector(
                onTap: _openReactionModal,
                child: Row(
                  children: [
                    _buildReactionIcons(),
                    const SizedBox(width: 6),
                    Text(
                      _formatCount(_totalReactions),
                      style: FeedDesignTokens.countStyle(context),
                    ),
                  ],
                ),
              ),
            )
          else
            const Spacer(),

          // Comment count (right side)
          if (_commentCount > 0)
            GestureDetector(
              onTap: _toggleComments,
              child: Text(
                '$_commentCount ${'comment'.tr}${_commentCount > 1 ? 's' : ''}',
                style: FeedDesignTokens.countStyle(context),
              ),
            ),
        ],
      ),
    );
  }

  /// Build stacked reaction icons — same design as PostFooter._buildReactionIcons()
  Widget _buildReactionIcons() {
    final reactionAssets = _getReactionAssetsFromMap(_reactions, maxCount: 3);
    if (reactionAssets.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: reactionAssets.length * 14.0 + 6,
      height: FeedDesignTokens.reactionIconSizeLarge,
      child: Stack(
        children: [
          for (int i = 0; i < reactionAssets.length; i++)
            Positioned(
              left: i * 14.0,
              child: Container(
                width: FeedDesignTokens.reactionIconSizeLarge,
                height: FeedDesignTokens.reactionIconSizeLarge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Image.asset(
                  reactionAssets[i],
                  width: FeedDesignTokens.reactionIconSize,
                  height: FeedDesignTokens.reactionIconSize,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Action Bar (Like / Comment / Share) — matches BottomAction design
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildActionBar(BuildContext context) {
    return SizedBox(
      height: FeedDesignTokens.actionBarHeight,
      child: Row(
        children: [
          // ── Like / React Button (with long-press reaction picker) ──
          Expanded(
            child: PostReactionButton(
              selectedReaction: _userReaction != null
                  ? getReactionModelAsType(_userReaction!)
                  : null,
              onChangedReaction: (reaction) {
                _onReaction(reaction.value);
              },
              isShowLikeText: false,
            ),
          ),

          // ── Comment Button ──
          Expanded(
            child: _AdActionButton(
              icon: AppAssets.COMMENT_ACTION_ICON,
              label: 'Comment'.tr,
              onTap: _toggleComments,
              context: context,
            ),
          ),

          // ── Share Button ──
          Expanded(
            child: _AdActionButton(
              icon: AppAssets.SHARE_ACTION_ICON,
              label: 'Share'.tr,
              onTap: () => _handleShare(context),
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Inline Comments Section
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCommentsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider above comments
        Divider(
          height: 1,
          thickness: 0.5,
          color: FeedDesignTokens.divider(context),
        ),

        // Comment input bar
        _buildCommentInput(context, isDark),

        // Loading indicator
        if (_commentsLoading && _comments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),

        // Comment list
        ..._comments.map((comment) =>
            _buildCommentTile(context, isDark, comment)),

        // Load more button
        if (_commentsHasMore)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () => _fetchComments(append: true),
              child: Text(
                'View more comments'.tr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: FeedDesignTokens.textSecondary(context),
                ),
              ),
            ),
          ),

        // Bottom loading for pagination
        if (_commentsLoading && _comments.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),

        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildCommentInput(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Input field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: FeedDesignTokens.inputBg(context),
                borderRadius:
                    BorderRadius.circular(FeedDesignTokens.inputBorderRadius),
              ),
              child: TextField(
                controller: _commentController,
                focusNode: _commentFocusNode,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitComment(),
                style: TextStyle(
                  fontSize: 14,
                  color: FeedDesignTokens.textPrimary(context),
                ),
                decoration: InputDecoration(
                  hintText: 'Write a comment...'.tr,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          Obx(() => _hasCommentText.value
              ? GestureDetector(
                  onTap: _submitComment,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Icon(
                      Icons.send_rounded,
                      size: 24,
                      color: FeedDesignTokens.brand(context),
                    ),
                  ),
                )
              : const SizedBox(width: 24)),
        ],
      ),
    );
  }

  Widget _buildCommentTile(
      BuildContext context, bool isDark, Map<String, dynamic> comment) {
    final user = comment['user_id'] as Map<String, dynamic>?;
    final userName = user != null
        ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
        : 'Unknown';
    final profilePic = user?['profile_pic'] ?? '';
    final avatarUrl = profilePic.isNotEmpty
        ? (profilePic.toString().startsWith('http')
            ? profilePic
            : '${ApiConstant.SERVER_IP_PORT}/uploads/$profilePic')
        : '';
    final commentText = comment['comment_text'] ?? '';
    final createdAt = comment['createdAt'] ?? '';
    final commentId = comment['_id'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: FeedDesignTokens.commentAvatarSize / 2,
            backgroundColor:
                isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            backgroundImage: avatarUrl.toString().isNotEmpty
                ? NetworkImage(avatarUrl.toString())
                : null,
            child: avatarUrl.toString().isEmpty
                ? Icon(Icons.person,
                    size: 18,
                    color: isDark
                        ? Colors.grey.shade600
                        : Colors.grey.shade400)
                : null,
          ),
          const SizedBox(width: 8),
          // Comment bubble
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.commentBubble(context),
                    borderRadius: BorderRadius.circular(
                        FeedDesignTokens.commentBubbleRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: FeedDesignTokens.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        commentText.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: FeedDesignTokens.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // Action row: time · Like · Reply
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Row(
                    children: [
                      if (createdAt.toString().isNotEmpty)
                        Text(
                          getDynamicFormatedTime(createdAt.toString()),
                          style: TextStyle(
                            fontSize: 12,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      if (createdAt.toString().isNotEmpty)
                        Text(
                          ' · ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          if (commentId.toString().isNotEmpty) {
                            _repo.saveCommentReaction(
                                commentId.toString(), 'like');
                          }
                        },
                        child: Text(
                          'Like'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _commentFocusNode.requestFocus(),
                        child: Text(
                          'Reply'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Reaction modal — shows who reacted (Facebook-style bottom sheet)
  // ─────────────────────────────────────────────────────────────────────────
  void _openReactionModal() {
    if (_adId == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AdReactionsSheet(
        adId: _adId!,
        repo: _repo,
        reactions: _reactions,
        totalReactions: _totalReactions,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Share
  // ─────────────────────────────────────────────────────────────────────────
  void _handleShare(BuildContext context) {
    final url = widget.ad.websiteUrl ?? '';
    if (url.isNotEmpty) {
      final shareUrl = url.startsWith('http') ? url : 'https://$url';
      HapticFeedback.lightImpact();
      Clipboard.setData(ClipboardData(text: shareUrl));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link copied to clipboard'.tr),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Helpers
  // ─────────────────────────────────────────────────────────────────────────

  String? _getOwnerName() {
    final owner = widget.ad.data['campaign_owner'] as Map<String, dynamic>?;
    if (owner == null) return null;
    final first = owner['first_name'] ?? '';
    final last = owner['last_name'] ?? '';
    final name = '$first $last'.trim();
    return name.isNotEmpty ? name : null;
  }

  /// Get top reaction type assets from the reactions map {like: 5, love: 3, ...}
  List<String> _getReactionAssetsFromMap(Map<String, dynamic> reactions,
      {int maxCount = 3}) {
    final entries = reactions.entries
        .where((e) => (e.value as int? ?? 0) > 0)
        .toList()
      ..sort((a, b) =>
          ((b.value as int?) ?? 0).compareTo((a.value as int?) ?? 0));

    final assets = <String>[];
    for (final entry in entries) {
      final asset = getReactionIconPath(entry.key);
      if (!assets.contains(asset)) {
        assets.add(asset);
      }
      if (assets.length >= maxCount) break;
    }
    return assets;
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  String _formatMediaUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '${ApiConstant.SERVER_IP_PORT}/$cleanPath';
  }

  String _getHostname(String url) {
    try {
      final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
      return uri.host.replaceAll('www.', '');
    } catch (_) {
      return url.length > 40 ? url.substring(0, 40) : url;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Facebook-style action button — identical design to BottomAction._ActionButton
// ─────────────────────────────────────────────────────────────────────────────
class _AdActionButton extends StatelessWidget {
  const _AdActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.context,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Ad Reactions Modal — shows who reacted (Facebook-style bottom sheet)
//  Uses V2 campaign engagement API instead of regular post reaction API
// ─────────────────────────────────────────────────────────────────────────────
class _AdReactionsSheet extends StatefulWidget {
  final String adId;
  final AdEngagementRepository repo;
  final Map<String, dynamic> reactions;
  final int totalReactions;

  const _AdReactionsSheet({
    required this.adId,
    required this.repo,
    required this.reactions,
    required this.totalReactions,
  });

  @override
  State<_AdReactionsSheet> createState() => _AdReactionsSheetState();
}

class _AdReactionsSheetState extends State<_AdReactionsSheet> {
  List<Map<String, dynamic>> _reactionUsers = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0;

  static const _reactionOrder = [
    'like', 'love', 'haha', 'wow', 'sad', 'angry'
  ];

  @override
  void initState() {
    super.initState();
    _fetchReactionUsers();
  }

  Future<void> _fetchReactionUsers() async {
    try {
      final response = await widget.repo.getReactionUsers(widget.adId);
      if (response.isSuccessful && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final reactions = data['reactions'] as List? ?? [];
        if (mounted) {
          setState(() {
            _reactionUsers = reactions
                .map((r) => Map<String, dynamic>.from(r as Map))
                .toList();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<_TabDef> _visibleTabs() {
    final tabs = <_TabDef>[
      _TabDef(type: null, label: 'All', count: _reactionUsers.length),
    ];
    for (final type in _reactionOrder) {
      final count =
          _reactionUsers.where((u) => u['reaction_type'] == type).length;
      if (count > 0) {
        tabs.add(_TabDef(type: type, label: type, count: count));
      }
    }
    return tabs;
  }

  List<Map<String, dynamic>> _filteredUsers(String? type) {
    if (type == null) return _reactionUsers;
    return _reactionUsers.where((u) => u['reaction_type'] == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF242526) : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.0,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.55, 0.85],
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),

              // Filter tabs
              if (!_isLoading) _buildFilterTabs(isDark),

              // Divider
              Divider(
                height: 1,
                thickness: 0.5,
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              ),

              // User list
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildUserList(isDark, scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterTabs(bool isDark) {
    final tabs = _visibleTabs();
    if (_selectedTabIndex >= tabs.length) _selectedTabIndex = 0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isActive = index == _selectedTabIndex;

          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? const Color(0xFF307777)
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tab.type != null) ...[
                    Image.asset(
                      getReactionIconPath(tab.type!),
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    tab.type == null ? 'All ${tab.count}' : '${tab.count}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? const Color(0xFF307777)
                          : (isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserList(bool isDark, ScrollController scrollController) {
    final tabs = _visibleTabs();
    if (_selectedTabIndex >= tabs.length) return const SizedBox.shrink();
    final filtered = _filteredUsers(tabs[_selectedTabIndex].type);

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'No reactions yet'.tr,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final user = item['user'] as Map<String, dynamic>? ?? {};
        final name =
            '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
        final profilePic = user['profile_pic'] ?? '';
        final profileUrl = profilePic.toString().isNotEmpty
            ? (profilePic.toString().startsWith('http')
                ? profilePic.toString()
                : '${ApiConstant.SERVER_IP_PORT}/uploads/$profilePic')
            : '';
        final reactionType = item['reaction_type'] ?? 'like';

        return InkWell(
          onTap: () {
            // Navigate to profile if needed
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Avatar with reaction badge
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                        ),
                        child: ClipOval(
                          child: profileUrl.isNotEmpty
                              ? Image.network(
                                  profileUrl,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.person,
                                    size: 28,
                                    color: isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 28,
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400,
                                ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFF242526)
                                : Colors.white,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF242526)
                                  : Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              getReactionIconPath(reactionType.toString()),
                              width: 16,
                              height: 16,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Name
                Expanded(
                  child: Text(
                    name.isNotEmpty ? name : 'User',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TabDef {
  final String? type;
  final String label;
  final int count;
  const _TabDef(
      {required this.type, required this.label, required this.count});
}
