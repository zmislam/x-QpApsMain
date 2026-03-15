import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/color.dart';
import '../../../config/constants/feed_design_tokens.dart';
import '../controllers/earn_dashboard_controller.dart';

// =============================================================================
// Earn Dashboard — Premium Redesign
// =============================================================================

class EarnDashboardView extends GetView<EarnDashboardController> {
  EarnDashboardView({super.key});

  // ─── Helpers for formatting ────────────────────────────────────────────
  String _formatPoints(double val) {
    if (val == 0) return '0.00';
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(2)}K';
    if (val >= 1) return val.toStringAsFixed(2);
    // Small decimals — show meaningful digits
    final s = val.toStringAsFixed(8);
    final trimmed = s.replaceAll(RegExp(r'0+$'), '');
    final dotIdx = trimmed.indexOf('.');
    if (dotIdx == -1) return trimmed;
    final decimals = trimmed.length - dotIdx - 1;
    if (decimals < 2) return val.toStringAsFixed(2);
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = FeedDesignTokens.surfaceBg(context);
    final cardBg = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: PRIMARY_COLOR,
              strokeWidth: 2.5,
            ),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Collapsing AppBar with hero card ───────────────────────
            _buildSliverAppBar(context, isDark, cardBg, textPrimary, textSecondary),

            // ── Body sections ──────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Post Earning
                  _buildSectionHeader(
                    context,
                    icon: Icons.article_outlined,
                    title: 'Post Earning',
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 10),
                  _buildPostEarningCards(context, isDark, cardBg, textPrimary, textSecondary),
                  const SizedBox(height: 24),

                  // Activity Earning
                  _buildSectionHeader(
                    context,
                    icon: Icons.bolt_outlined,
                    title: 'Activity Earning',
                    color: const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 10),
                  _buildActivityEarningCards(context, isDark, cardBg, textPrimary, textSecondary),
                  const SizedBox(height: 24),

                  // Campaign Earning
                  _buildSectionHeader(
                    context,
                    icon: Icons.campaign_outlined,
                    title: 'Campaign Earning',
                    color: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 10),
                  _buildCampaignEarningCards(context, isDark, cardBg, textPrimary, textSecondary),
                  const SizedBox(height: 24),

                  // Profile Overview
                  _buildSectionHeader(
                    context,
                    icon: Icons.person_outline_rounded,
                    title: 'Profile Overview',
                    color: const Color(0xFF8B5CF6),
                  ),
                  const SizedBox(height: 10),
                  _buildProfileOverview(context, isDark, cardBg, textPrimary, textSecondary),
                  const SizedBox(height: 24),

                  // Top Posts
                  _buildSectionHeader(
                    context,
                    icon: Icons.emoji_events_outlined,
                    title: 'Top Performing Posts',
                    color: const Color(0xFFEF4444),
                  ),
                  const SizedBox(height: 10),
                  _buildTop3Sections(context, isDark, cardBg, textPrimary, textSecondary),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SLIVER APP BAR — Hero summary card
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSliverAppBar(
    BuildContext context,
    bool isDark,
    Color cardBg,
    Color textPrimary,
    Color textSecondary,
  ) {
    final totalPts = controller.earningPoints.value?.totalPoints ?? 0.0;
    final currentPts = controller.earningPoints.value?.currentPoints ?? 0.0;
    final withdrawPts = controller.earningPoints.value?.withdrawPoints?.points ?? 0.0;

    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      leading: IconButton(
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Earn Dashboard',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0D3D3D), const Color(0xFF1C1C1E)]
                  : [const Color(0xFF0D7377), const Color(0xFF21CBC1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ── Hero summary card ──────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Total points big display
                        Text(
                          _formatPoints(totalPts),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total Points Earned',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Current & Withdraw row
                        Row(
                          children: [
                            Expanded(
                              child: _buildHeroStat(
                                'Available',
                                _formatPoints(currentPts),
                                Icons.account_balance_wallet_outlined,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            Expanded(
                              child: _buildHeroStat(
                                'Withdrawn',
                                _formatPoints(withdrawPts),
                                Icons.arrow_upward_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SECTION HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    final textPrimary = FeedDesignTokens.textPrimary(context);
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  EARNING POINT CARD — Reusable
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPointCard({
    required BuildContext context,
    required String label,
    required double points,
    required IconData icon,
    required Color accent,
    required bool isDark,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(height: 10),
          // Value
          Text(
            _formatPoints(points),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textSecondary,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  POST EARNING
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPostEarningCards(
    BuildContext context, bool isDark, Color cardBg, Color textPrimary, Color textSecondary,
  ) {
    final ep = controller.earningPoints.value;
    if (ep == null) return _buildEmptyState('No post earning data', textSecondary);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.35,
      children: [
        _buildPointCard(
          context: context, label: 'Reactions',
          points: ep.myPostReactionPointCount?.points ?? 0.0,
          icon: Icons.favorite_outline_rounded, accent: const Color(0xFFEF4444),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
        ),
        _buildPointCard(
          context: context, label: 'Comments',
          points: ep.myPostCommentPointCount?.points ?? 0.0,
          icon: Icons.chat_bubble_outline_rounded, accent: const Color(0xFF3B82F6),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
        ),
        _buildPointCard(
          context: context, label: 'Reels Views',
          points: ep.myReelsViewPoints?.points ?? 0.0,
          icon: Icons.play_circle_outline_rounded, accent: const Color(0xFF8B5CF6),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
        ),
        _buildPointCard(
          context: context, label: 'Shares',
          points: ep.myPostSharePointCount?.points ?? 0.0,
          icon: Icons.share_outlined, accent: const Color(0xFFF59E0B),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  ACTIVITY EARNING
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildActivityEarningCards(
    BuildContext context, bool isDark, Color cardBg, Color textPrimary, Color textSecondary,
  ) {
    final ep = controller.earningPoints.value;
    if (ep == null) return _buildEmptyState('No activity data', textSecondary);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.35,
      children: [
        _buildPointCard(
          context: context, label: 'Reactions',
          points: ep.myActivityPostReactionPointCount?.points ?? 0.0,
          icon: Icons.thumb_up_outlined, accent: const Color(0xFF10B981),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
        ),
        _buildPointCard(
          context: context, label: 'Comments',
          points: ep.myActivityPostCommentPointCount?.points ?? 0.0,
          icon: Icons.mode_comment_outlined, accent: const Color(0xFF06B6D4),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
        ),
        _buildPointCard(
          context: context, label: 'Reels Views',
          points: ep.myActivityReelsViewPoints?.points ?? 0.0,
          icon: Icons.ondemand_video_rounded, accent: const Color(0xFFEC4899),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
        ),
        _buildPointCard(
          context: context, label: 'Shares',
          points: ep.myActivityPostSharePointCount?.points ?? 0.0,
          icon: Icons.reply_outlined, accent: const Color(0xFF6366F1),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  CAMPAIGN EARNING
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCampaignEarningCards(
    BuildContext context, bool isDark, Color cardBg, Color textPrimary, Color textSecondary,
  ) {
    final ep = controller.earningPoints.value;
    if (ep == null) return _buildEmptyState('No campaign data', textSecondary);

    final campaign = ep.campaignPoints;
    final items = <_CampaignItem>[
      _CampaignItem('Clicks', campaign?.campaignClickPoint ?? 0.0, Icons.touch_app_outlined, const Color(0xFFF59E0B)),
      _CampaignItem('Impressions', campaign?.campaignImpressionPoint ?? 0.0, Icons.visibility_outlined, const Color(0xFF3B82F6)),
      _CampaignItem('Reached', campaign?.campaignReachedPoint ?? 0.0, Icons.people_outline_rounded, const Color(0xFF10B981)),
      _CampaignItem('Reactions', campaign?.campaignReactionPoint ?? 0.0, Icons.favorite_outline_rounded, const Color(0xFFEF4444)),
      _CampaignItem('Comments', campaign?.campaignCommentPoint ?? 0.0, Icons.chat_bubble_outline_rounded, const Color(0xFF8B5CF6)),
      _CampaignItem('Shares', campaign?.campaignSharePoint ?? 0.0, Icons.share_outlined, const Color(0xFF06B6D4)),
      _CampaignItem('Watch 10s', campaign?.campaignWatch10SecPoint ?? 0.0, Icons.timer_outlined, const Color(0xFFEC4899)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          ...items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, size: 17, color: item.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        _formatPoints(item.points),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 62,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  PROFILE OVERVIEW
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProfileOverview(
    BuildContext context, bool isDark, Color cardBg, Color textPrimary, Color textSecondary,
  ) {
    final data = controller.earningSummary.value;
    if (data == null) return _buildEmptyState('No profile data', textSecondary);

    final stats = <_ProfileStat>[
      _ProfileStat(
        'Posts Reacted',
        '${(data.totalPostReactionCount?.isNotEmpty ?? false) ? data.totalPostReactionCount!.first.count : 0}',
        Icons.thumb_up_outlined,
        const Color(0xFF10B981),
      ),
      _ProfileStat(
        'Posts Commented',
        '${(data.totalPostCommentCount?.isNotEmpty ?? false) ? data.totalPostCommentCount!.first.count : 0}',
        Icons.chat_bubble_outline_rounded,
        const Color(0xFF3B82F6),
      ),
      _ProfileStat(
        'Posts Shared',
        '${(data.totalSharePost?.isNotEmpty ?? false) ? data.totalSharePost!.first.count : 0}',
        Icons.share_outlined,
        const Color(0xFFF59E0B),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: stats.asMap().entries.map((entry) {
          final i = entry.key;
          final stat = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: stat.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(stat.icon, size: 20, color: stat.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        stat.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      stat.value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: stat.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < stats.length - 1)
                Divider(
                  height: 1,
                  indent: 70,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.05),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TOP 3 SUMMARY SECTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTop3Sections(
    BuildContext context, bool isDark, Color cardBg, Color textPrimary, Color textSecondary,
  ) {
    final data = controller.earningTop3Summary.value;

    return Column(
      children: [
        _buildTopPostCard(
          context: context,
          title: 'Top Reacted Posts',
          icon: Icons.favorite_outline_rounded,
          accent: const Color(0xFFEF4444),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
          items: data?.top3ReactedPost
                  ?.map((p) => _TopPostData(
                        desc: p.description?.isNotEmpty == true ? p.description! : 'No Description',
                        reactions: p.reactions?.count ?? 0,
                        comments: p.comments?.count ?? 0,
                        shares: 0,
                      ))
                  .toList() ?? [],
          showShares: false,
        ),
        const SizedBox(height: 14),

        _buildTopPostCard(
          context: context,
          title: 'Top Commented Posts',
          icon: Icons.chat_bubble_outline_rounded,
          accent: const Color(0xFF3B82F6),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
          items: data?.top3CommentedPost
                  ?.map((p) => _TopPostData(
                        desc: p.description?.isNotEmpty == true ? p.description! : 'No Description',
                        reactions: p.reactions?.count ?? 0,
                        comments: p.comments?.count ?? 0,
                        shares: 0,
                      ))
                  .toList() ?? [],
          showShares: false,
        ),
        const SizedBox(height: 14),

        _buildTopPostCard(
          context: context,
          title: 'Top Shared Posts',
          icon: Icons.share_outlined,
          accent: const Color(0xFFF59E0B),
          isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
          items: data?.top3SharedPost
                  ?.map((sp) => _TopPostData(
                        desc: sp.post?.description?.isNotEmpty == true ? sp.post!.description! : 'No Description',
                        reactions: sp.post?.reactions?.count ?? 0,
                        comments: sp.post?.comments?.count ?? 0,
                        shares: sp.count ?? 0,
                      ))
                  .toList() ?? [],
          showShares: true,
        ),
        const SizedBox(height: 14),

        if (data?.top3ReelsView?.isNotEmpty == true)
          _buildTopReelsCard(
            context: context,
            isDark: isDark, cardBg: cardBg, textPrimary: textPrimary, textSecondary: textSecondary,
            items: data!.top3ReelsView!
                .map((rv) => _TopReelsData(
                      desc: rv.reels?.description?.isNotEmpty == true ? rv.reels!.description! : 'No Description',
                      views: rv.reels?.views?.count ?? rv.reels?.viewCount ?? 0,
                    ))
                .toList(),
          ),
      ],
    );
  }

  // ─── Top Post Card ─────────────────────────────────────────────────────

  Widget _buildTopPostCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color accent,
    required bool isDark,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
    required List<_TopPostData> items,
    required bool showShares,
  }) {
    if (items.isEmpty) {
      return _buildEmptyTopCard(title, icon, accent, isDark, cardBg, textPrimary, textSecondary);
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: accent),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),

          // Items
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rank badge
                      _buildRankBadge(idx),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.desc,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Stats chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _buildStatChip(Icons.favorite, '${item.reactions}', const Color(0xFFEF4444), isDark),
                                _buildStatChip(Icons.chat_bubble, '${item.comments}', const Color(0xFF3B82F6), isDark),
                                if (showShares)
                                  _buildStatChip(Icons.share, '${item.shares}', const Color(0xFFF59E0B), isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (idx < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 52,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ─── Top Reels Card ────────────────────────────────────────────────────

  Widget _buildTopReelsCard({
    required BuildContext context,
    required bool isDark,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
    required List<_TopReelsData> items,
  }) {
    const accent = Color(0xFF8B5CF6);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.play_circle_outline_rounded, size: 18, color: accent),
                const SizedBox(width: 8),
                Text(
                  'Top Reels Views',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _buildRankBadge(idx),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.desc,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textPrimary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(Icons.visibility, '${item.views}', accent, isDark),
                    ],
                  ),
                ),
                if (idx < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 52,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ─── Rank Badge ────────────────────────────────────────────────────────

  Widget _buildRankBadge(int index) {
    final colors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFC0C0C0), // Silver
      const Color(0xFFCD7F32), // Bronze
    ];
    final color = index < 3 ? colors[index] : Colors.grey;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }

  // ─── Stat Chip ─────────────────────────────────────────────────────────

  Widget _buildStatChip(IconData icon, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Empty States ──────────────────────────────────────────────────────

  Widget _buildEmptyState(String msg, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          msg,
          style: TextStyle(fontSize: 13, color: textSecondary),
        ),
      ),
    );
  }

  Widget _buildEmptyTopCard(
    String title, IconData icon, Color accent,
    bool isDark, Color cardBg, Color textPrimary, Color textSecondary,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: accent),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Text(
              'No data available yet',
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Private data classes
// =============================================================================

class _CampaignItem {
  final String label;
  final double points;
  final IconData icon;
  final Color color;
  const _CampaignItem(this.label, this.points, this.icon, this.color);
}

class _ProfileStat {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _ProfileStat(this.label, this.value, this.icon, this.color);
}

class _TopPostData {
  final String desc;
  final int reactions;
  final int comments;
  final int shares;
  const _TopPostData({
    required this.desc,
    required this.reactions,
    required this.comments,
    required this.shares,
  });
}

class _TopReelsData {
  final String desc;
  final int views;
  const _TopReelsData({required this.desc, required this.views});
}
