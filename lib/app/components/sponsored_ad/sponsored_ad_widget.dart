import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/constants/api_constant.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../models/sponsored_ad_model.dart';

/// Renders a sponsored ad card inline in the feed.
///
/// For boosted page posts, the parent view renders a normal PostCard with
/// "Sponsored" label instead of using this widget. This widget handles
/// non-boosted campaign ads (external ads with CTA).
class SponsoredAdWidget extends StatelessWidget {
  final SponsoredAdModel ad;

  const SponsoredAdWidget({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coverUrl = ad.coverMedia.isNotEmpty
        ? _formatMediaUrl(ad.coverMedia.first)
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: FeedDesignTokens.cardBg(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: "Sponsored" label ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
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
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ad.campaignName != null)
                        Text(
                          ad.campaignName!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 2),
                      Text(
                        'Sponsored',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Description ──
          if (ad.description != null && ad.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                ad.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // ── Cover media ──
          if (coverUrl != null)
            AspectRatio(
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
            ),

          // ── CTA button ──
          if (ad.websiteUrl != null && ad.websiteUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _launchUrl(ad.websiteUrl!),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'Learn More',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF307777),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Format a media path into a full URL.
  String _formatMediaUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '${ApiConstant.SERVER_IP_PORT}/$cleanPath';
  }

  /// Launch the ad's website URL in the browser.
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
