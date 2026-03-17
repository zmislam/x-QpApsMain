import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/constants/api_constant.dart';
import '../../../config/constants/feed_design_tokens.dart';
import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../utils/copy_to_clipboard_utils.dart';
import '../../../utils/post_utlis.dart';
import '../../reaction_button/post_reaction_button.dart';

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

    final LoginCredential loginCredential = LoginCredential();
    final int reactionCount = model.reactionCount ?? 0;
    final int commentCount = model.totalComments ?? 0;
    final int shareCount = model.postShareCount ?? 0;
    final bool isFriendsOnly = model.post_privacy == 'friends' &&
        (loginCredential.getUserData().id != model.user_id?.id);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─── Single-row footer (Facebook-style) ───
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FeedDesignTokens.cardPaddingH,
            vertical: 8,
          ),
          child: Row(
            children: [
              // ─── Like button with count ───
              PostReactionButton(
                selectedReaction: getSelectedPostReaction(
                    model, loginCredential.getUserData().id ?? ''),
                onChangedReaction: (reaction) {
                  HapticFeedback.lightImpact();
                  onSelectReaction(reaction.value);
                },
                isShowLikeText: false,
              ),
              if (reactionCount > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    _formatCount(reactionCount),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ),

              const SizedBox(width: 16),

              // ─── Comment button with count ───
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onPressedComment();
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                    if (commentCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          _formatCount(commentCount),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ─── Share / Copy Link button with count ───
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (isFriendsOnly) {
                    CopyToClipboardUtils.copyToClipboard(
                      '${ApiConstant.SERVER_IP}/notification/${model.id}',
                      'Link',
                    );
                  } else {
                    onPressedShare();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(
                      Icons.reply_rounded,
                      size: 22,
                      color: FeedDesignTokens.textSecondary(context),
                      textDirection: TextDirection.rtl,
                    ),
                    if (shareCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          _formatCount(shareCount),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const Spacer(),

              // ─── Reaction emoji stack (right side) ───
              if (reactionCount > 0)
                GestureDetector(
                  onTap: onTapViewReactions,
                  child: _buildReactionIcons(context),
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
    );
  }

  /// Build stacked reaction icons (like Facebook's overlapping circles)
  Widget _buildReactionIcons(BuildContext context) {
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
                  border: Border.all(
                    color: FeedDesignTokens.cardBg(context),
                    width: 1.5,
                  ),
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
