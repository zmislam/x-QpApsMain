import 'package:flutter/material.dart';

import '../../../config/constants/feed_design_tokens.dart';
import '../../../models/post.dart';
import '../../../utils/post_utlis.dart';
import 'bottom_action.dart';
import 'package:get/get.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({
    super.key,
    required this.model,
    required this.onSelectReaction,
    required this.onPressedComment,
    required this.onPressedShare,
    required this.onTapViewReactions,
  });

  final PostModel model;
  final Function(String reaction) onSelectReaction;
  final VoidCallback onPressedComment;
  final VoidCallback onPressedShare;
  final VoidCallback onTapViewReactions;

  @override
  Widget build(BuildContext context) {
    if (model.user_id == null) return const SizedBox.shrink();

    final int reactionCount = model.reactionCount ?? 0;
    final int commentCount = model.totalComments ?? 0;
    final int shareCount = model.postShareCount ?? 0;
    final bool hasAnyCounts = reactionCount > 0 || commentCount > 0 || shareCount > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─── Count Row (Facebook-style) ───
        if (hasAnyCounts)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FeedDesignTokens.cardPaddingH,
              vertical: 10,
            ),
            child: Row(
              children: [
                // Reaction icons + count (left side)
                if (reactionCount > 0)
                  Expanded(
                    child: InkWell(
                      onTap: onTapViewReactions,
                      child: Row(
                        children: [
                          _buildReactionIcons(),
                          const SizedBox(width: 6),
                          Text(
                            _formatCount(reactionCount),
                            style: FeedDesignTokens.countStyle(context),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Spacer(),

                // Comments + Shares count (right side)
                Row(
                  children: [
                    if (commentCount > 0) ...[
                      InkWell(
                        onTap: onPressedComment,
                        child: Text(
                          '$commentCount ${'comment'.tr}${commentCount > 1 ? 's' : ''}',
                          style: FeedDesignTokens.countStyle(context),
                        ),
                      ),
                    ],
                    if (commentCount > 0 && shareCount > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('·',
                            style: FeedDesignTokens.countStyle(context)
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                    if (shareCount > 0)
                      Text(
                        '$shareCount ${'share'.tr}${shareCount > 1 ? 's' : ''}',
                        style: FeedDesignTokens.countStyle(context),
                      ),
                  ],
                ),
              ],
            ),
          ),

        // ─── Divider ───
        Divider(
          height: 1,
          thickness: 0.5,
          color: FeedDesignTokens.divider(context),
        ),

        // ─── Action Buttons (Like, Comment, Share) ───
        BottomAction(
          onSelectReaction: onSelectReaction,
          onPressedComment: onPressedComment,
          onPressedShare: onPressedShare,
          model: model,
        ),

        // ─── Post separator ───
        Container(
          height: FeedDesignTokens.separatorHeight,
          color: FeedDesignTokens.surfaceBg(context),
        ),
      ],
    );
  }

  /// Build stacked reaction icons (like Facebook's overlapping circles)
  Widget _buildReactionIcons() {
    // Use shared utility that checks both reactionTypeCountsByPost and
    // reactionSummary.breakdown (list may be empty from API optimization)
    final reactionAssets = getReactionAssets(model, maxCount: 3);

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

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  // Keeping for compatibility
  static TextStyle countStyle(BuildContext context) => TextStyle(
        fontSize: FeedDesignTokens.timeSize,
        color: FeedDesignTokens.textSecondary(context),
      );
}
