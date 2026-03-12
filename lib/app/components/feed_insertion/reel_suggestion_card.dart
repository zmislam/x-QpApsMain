import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../extension/string/string_image_path.dart';
import '../../repository/edgerank_repository.dart';
import '../../routes/app_pages.dart';

/// Horizontally scrollable reel suggestion carousel for feed insertions.
/// Renders reel thumbnails with play icon, author name, and like count overlay.
class ReelSuggestionCard extends StatefulWidget {
  const ReelSuggestionCard({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<ReelSuggestionCard> createState() => _ReelSuggestionCardState();
}

class _ReelSuggestionCardState extends State<ReelSuggestionCard> {
  late List<Map<String, dynamic>> suggestions;
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    suggestions = List<Map<String, dynamic>>.from(
      (widget.data['suggestions'] ?? []).map(
        (e) => Map<String, dynamic>.from(e as Map),
      ),
    );
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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: FeedDesignTokens.textSecondary(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.visibility_off_outlined,
                  color: FeedDesignTokens.textPrimary(context)),
              title: Text('Hide this suggestion'.tr,
                  style: TextStyle(color: FeedDesignTokens.textPrimary(context))),
              subtitle: Text('Stop seeing reel suggestions here'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                EdgeRankRepository()
                    .dismissInsertion(insertionType: 'reel_suggestion')
                    .catchError((_) {});
                setState(() => _hidden = true);
              },
            ),
            ListTile(
              leading: Icon(Icons.not_interested_outlined,
                  color: FeedDesignTokens.textPrimary(context)),
              title: Text('Not interested'.tr,
                  style: TextStyle(color: FeedDesignTokens.textPrimary(context))),
              subtitle: Text('See fewer suggestions like this'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      color: FeedDesignTokens.textSecondary(context))),
              onTap: () {
                Navigator.pop(context);
                EdgeRankRepository()
                    .dismissInsertion(insertionType: 'reel_suggestion')
                    .catchError((_) {});
                setState(() => _hidden = true);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hidden || suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      color: FeedDesignTokens.cardBg(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Card separator ───
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),

          // ─── Title ───
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FeedDesignTokens.cardPaddingH, 14,
              FeedDesignTokens.cardPaddingH, 10,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.movie_outlined,
                  size: 20,
                  color: FeedDesignTokens.brand(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Reels For You'.tr,
                    style: TextStyle(
                      fontSize: FeedDesignTokens.nameSize,
                      fontWeight: FontWeight.w700,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.REELS),
                  child: Text(
                    'See All'.tr,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.brand(context),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Three-dot menu
                InkWell(
                  onTap: _showMoreOptions,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
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

          // ─── Horizontal reel cards ───
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: FeedDesignTokens.cardPaddingH,
              ),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final item = suggestions[index];
                return _ReelCard(item: item);
              },
            ),
          ),

          const SizedBox(height: 4),

          // ─── Card separator ───
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),
        ],
      ),
    );
  }
}

class _ReelCard extends StatelessWidget {
  const _ReelCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    // Author info — can be a nested object or flat fields
    final author = item['user_id'];
    String authorName = '';
    if (author is Map) {
      final first = _capitalize((author['first_name'] ?? '').toString());
      final last = _capitalize((author['last_name'] ?? '').toString());
      authorName = '$first $last'.trim();
    }

    final likeCount = item['like_count'] ?? item['likes']?.length ?? 0;

    // Thumbnail: prefer dedicated thumbnail, fall back to video URL
    final thumbnail = (item['thumbnail'] ?? item['video_thumbnail'] ?? '').toString();
    final videoUrl = (item['video_url'] ?? item['video'] ?? '').toString();
    final thumbSrc = thumbnail.isNotEmpty
        ? thumbnail.formatedProfileReelUrl
        : videoUrl.isNotEmpty
            ? videoUrl.formatedReelUrl
            : '';

    return GestureDetector(
      onTap: () {
        final reelId = item['_id'] ?? '';
        if (reelId.isNotEmpty) {
          Get.toNamed(Routes.REELS, arguments: {'reel_id': reelId});
        }
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: FeedDesignTokens.inputBg(context),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ─── Thumbnail ───
            if (thumbSrc.isNotEmpty)
              Image.network(
                thumbSrc,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.black87,
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
              )
            else
              Container(
                color: Colors.black87,
                child: const Icon(
                  Icons.movie,
                  color: Colors.white54,
                  size: 40,
                ),
              ),

            // ─── Gradient overlay ───
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),

            // ─── Play icon (center) ───
            Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            // ─── Bottom overlay: author + likes ───
            Positioned(
              bottom: 10,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (authorName.isNotEmpty)
                    Text(
                      authorName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 4, color: Colors.black54),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (likeCount is int && likeCount > 0) ...[
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite,
                          size: 12,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '$likeCount',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
