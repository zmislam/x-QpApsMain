import 'package:flutter/material.dart';
import '../models/viral_content_models.dart';
import 'viral_badge.dart';

/// Trending post card for [TrendingFeedView].
/// Shows post thumbnail, viral badge, score, metrics, author.
/// All tier labels/multipliers from API — not hardcoded.
class TrendingCard extends StatelessWidget {
  final TrendingPost post;
  final VoidCallback? onTap;
  final VoidCallback? onBadgeTap;

  const TrendingCard({
    super.key,
    required this.post,
    this.onTap,
    this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail + badge
            if (post.thumbnail != null) _thumbnail(),
            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: post.authorAvatar != null
                            ? NetworkImage(post.authorAvatar!)
                            : null,
                        child: post.authorAvatar == null
                            ? Text(
                                post.authorName.isNotEmpty
                                    ? post.authorName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(fontSize: 12),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          post.authorName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (post.thumbnail == null)
                        ViralBadge(
                          tierKey: post.viralTierKey,
                          label: post.viralLabel,
                          multiplier: post.multiplier,
                          onTap: onBadgeTap,
                        ),
                    ],
                  ),
                  if (post.textPreview != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      post.textPreview!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Metrics row
                  _metricsRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnail() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
          child: Image.network(
            post.thumbnail!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 180,
              color: Colors.grey.shade100,
              child: Icon(Icons.image,
                  size: 40, color: Colors.grey.shade300),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: ViralBadge(
            tierKey: post.viralTierKey,
            label: post.viralLabel,
            multiplier: post.multiplier,
            onTap: onBadgeTap,
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Score: ${post.viralScore.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricsRow() {
    return Row(
      children: [
        _metricItem(Icons.visibility_outlined, _formatNum(post.metrics.views)),
        const SizedBox(width: 14),
        _metricItem(Icons.share_outlined, _formatNum(post.metrics.shares)),
        const SizedBox(width: 14),
        _metricItem(
            Icons.favorite_outline, _formatNum(post.metrics.reactions)),
        const SizedBox(width: 14),
        _metricItem(
            Icons.chat_bubble_outline, _formatNum(post.metrics.comments)),
        const Spacer(),
        Text(
          '${post.metrics.engagementRate.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade600,
          ),
        ),
      ],
    );
  }

  Widget _metricItem(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(value,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
