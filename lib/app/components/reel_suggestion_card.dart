import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/constants/api_constant.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_model.dart';
import '../routes/app_pages.dart';

/// A horizontal carousel card that displays suggested reels in the newsfeed.
///
/// This card is inserted between posts as a feed insertion. Each card
/// shows up to [reels.length] reel thumbnails in a horizontal scroll.
/// Tapping a thumbnail navigates to the [SuggestedReelsView] viewer.
class ReelSuggestionCard extends StatelessWidget {
  /// List of suggested reels to display in the carousel.
  final List<ReelsModel> reels;

  /// Callback when the user dismisses (closes) this card.
  final VoidCallback? onDismiss;

  const ReelSuggestionCard({
    super.key,
    required this.reels,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (reels.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                const Icon(Icons.play_circle_outline,
                    size: 20, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Suggested Reels',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                if (onDismiss != null)
                  GestureDetector(
                    onTap: onDismiss,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ─── Horizontal Carousel ───────────────────────────────────
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: reels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final reel = reels[index];
                return _ReelSuggestionItem(
                  reel: reel,
                  onTap: () {
                    // Navigate to the suggested reels viewer
                    final allIds = reels.map((r) => r.id ?? '').toList();
                    Get.toNamed(
                      Routes.SUGGESTED_REELS,
                      arguments: {
                        'reelIds': allIds,
                        'startReelId': reel.id ?? '',
                      },
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// A single reel thumbnail item in the suggestion carousel.
class _ReelSuggestionItem extends StatelessWidget {
  final ReelsModel reel;
  final VoidCallback onTap;

  const _ReelSuggestionItem({
    required this.reel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Build thumbnail URL
    final thumbnail = reel.reelsDataModel?.video_thumbnail ?? '';
    final video = reel.video ?? '';
    final thumbnailUrl = thumbnail.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/reels/thumbnails/$thumbnail'
        : video.isNotEmpty
            ? '${ApiConstant.SERVER_IP_PORT}/uploads/reels/$video'
            : '';

    final profilePic = reel.reel_user?.profile_pic ?? '';
    final profileUrl = profilePic.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/$profilePic'
        : '';

    final creatorName =
        '${reel.reel_user?.first_name ?? ''} ${reel.reel_user?.last_name ?? ''}'
            .trim();
    final viewCount = reel.view_count ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.play_arrow,
                                    color: Colors.white54, size: 30),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.videocam_off,
                                    color: Colors.white54, size: 30),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.play_arrow,
                                  color: Colors.white54, size: 30),
                            ),
                          ),

                    // Gradient overlay at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // View count badge
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Row(
                        children: [
                          const Icon(Icons.play_arrow,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            _formatCount(viewCount),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Play icon center
                    Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white.withOpacity(0.8),
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ── Creator Info ──
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 10,
                  backgroundImage: profileUrl.isNotEmpty
                      ? CachedNetworkImageProvider(profileUrl)
                      : null,
                  backgroundColor: Colors.grey[600],
                  child: profileUrl.isEmpty
                      ? const Icon(Icons.person, size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 6),
                // Name
                Expanded(
                  child: Text(
                    creatorName.isNotEmpty ? creatorName : 'Unknown',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
