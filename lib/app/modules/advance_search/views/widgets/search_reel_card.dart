// =============================================================================
// Search Reel Card — 2-column grid cell for reels search results
// =============================================================================
// Layout: [Thumbnail with optional sound icon & likes overlay]
//         [Creator avatar] Creator Name  TimeAgo
//         Caption text...
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../config/constants/api_constant.dart';
import '../../models/search_result_models.dart';

class SearchReelCard extends StatelessWidget {
  final SearchReelResult reel;
  final VoidCallback onTap;

  const SearchReelCard({
    super.key,
    required this.reel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 0.7,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Thumbnail image
                  reel.thumbnail != null && reel.thumbnail!.isNotEmpty
                      ? Image.network(
                          reel.thumbnail!.startsWith('http')
                              ? reel.thumbnail!
                              : '${ApiConstant.SERVER_IP_PORT}/${reel.thumbnail}',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                            child: const Icon(Icons.play_circle_outline, size: 48, color: Colors.white70),
                          ),
                        )
                      : Container(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                          child: const Icon(Icons.play_circle_outline, size: 48, color: Colors.white70),
                        ),

                  // Sound icon badge (bottom right of thumbnail)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.volume_up, size: 14, color: Colors.white),
                    ),
                  ),

                  // Likes overlay (bottom left of thumbnail)
                  if (reel.likesCount > 0)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.thumb_up, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              _formatCount(reel.likesCount),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Reel icon badge (top right)
                  if (reel.thumbnail != null)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.videocam, size: 14, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Creator row
          if (reel.user != null)
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: reel.user!.profilePic != null && reel.user!.profilePic!.isNotEmpty
                      ? NetworkImage(
                          reel.user!.profilePic!.startsWith('http')
                              ? reel.user!.profilePic!
                              : '${ApiConstant.SERVER_IP_PORT}/${reel.user!.profilePic}',
                        )
                      : null,
                  child: reel.user!.profilePic == null || reel.user!.profilePic!.isEmpty
                      ? const Icon(Icons.person, size: 14)
                      : null,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${reel.user!.fullName}  ${_timeAgo(reel.createdAt)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 4),

          // Caption
          if (reel.title != null || reel.description != null)
            Text(
              reel.title ?? reel.description ?? '',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 365) return '${diff.inDays ~/ 365}y';
      if (diff.inDays > 30) return '${diff.inDays ~/ 7}w';
      if (diff.inDays > 7) return '${diff.inDays ~/ 7}w';
      if (diff.inDays > 0) return '${diff.inDays}d';
      if (diff.inHours > 0) return '${diff.inHours}h';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m';
      return 'now';
    } catch (_) {
      return '';
    }
  }
}
