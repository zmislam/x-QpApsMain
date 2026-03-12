import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/feed_design_tokens.dart';
import '../config/constants/app_assets.dart';
import '../extension/string/string_image_path.dart';
import '../models/merge_story.dart';

class MyDayCard extends StatelessWidget {
  const MyDayCard({
    super.key,
    required this.storyMergeModel,
    required this.onTapStoryCard,
  });

  final StoryMergeModel storyMergeModel;
  final VoidCallback onTapStoryCard;

  @override
  Widget build(BuildContext context) {
    // If no stories, fallback (shouldn't happen for MyDayCard usually)
    final String storyImageUrl = (storyMergeModel.stories?.isNotEmpty == true)
        ? (storyMergeModel.stories![0].media ?? '').formatedStoreUrlLive
        : '';

    return InkWell(
      onTap: onTapStoryCard,
      borderRadius: BorderRadius.circular(FeedDesignTokens.storyCardRadius),
      child: Container(
        width: FeedDesignTokens.storyCardWidth,
        height: FeedDesignTokens.storyCardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(FeedDesignTokens.storyCardRadius),
          color: Colors.grey.shade200, // Placeholder color
          image: storyImageUrl.isNotEmpty
              ? DecorationImage(
                  image: CachedNetworkImageProvider(storyImageUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            // Gradient Overlay for text readability
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(FeedDesignTokens.storyCardRadius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),

            // Top-left Avatar with blue ring
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2), // Blue ring width
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: FeedDesignTokens.brand(context),
                ),
                child: Container(
                  height: FeedDesignTokens.storyAvatarSize, // 36
                  width: FeedDesignTokens.storyAvatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2), // White gap
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: (storyMergeModel.profile_pic ?? '').formatedProfileUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey.shade300),
                      errorWidget: (context, url, error) => const Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ),

            // User Name at bottom
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                '${storyMergeModel.first_name ?? ''} ${storyMergeModel.last_name ?? ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
