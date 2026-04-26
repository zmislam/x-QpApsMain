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
    this.useExclusiveNewsfeedDesign = false,
  });

  final PostModel model;
  final Function(String reaction) onSelectReaction;
  final VoidCallback onPressedComment;
  final VoidCallback onPressedShare;
  final VoidCallback onTapViewReactions;
  final bool useExclusiveNewsfeedDesign;

  @override
  Widget build(BuildContext context) {
    if (model.user_id == null) return const SizedBox.shrink();

    final LoginCredential loginCredential = LoginCredential();
    final int reactionCount = model.reactionCount ?? 0;
    final int commentCount = model.totalComments ?? 0;
    final int shareCount = model.postShareCount ?? 0;
    final int viewCount = model.view_count ?? 0;
    final bool isFriendsOnly = model.post_privacy == 'friends' &&
        (loginCredential.getUserData().id != model.user_id?.id);

    if (!useExclusiveNewsfeedDesign) {
      return _buildClassicFooter(
        context,
        reactionCount,
        commentCount,
        shareCount,
        isFriendsOnly,
        loginCredential,
      );
    }

    return _buildExclusiveFooter(
      context,
      reactionCount,
      commentCount,
      shareCount,
      viewCount,
      isFriendsOnly,
      loginCredential,
    );
  }

  Widget _buildClassicFooter(
    BuildContext context,
    int reactionCount,
    int commentCount,
    int shareCount,
    bool isFriendsOnly,
    LoginCredential loginCredential,
  ) {
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
                  _onShareOrCopy(isFriendsOnly);
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

  Widget _buildExclusiveFooter(
    BuildContext context,
    int reactionCount,
    int commentCount,
    int shareCount,
    int viewCount,
    bool isFriendsOnly,
    LoginCredential loginCredential,
  ) {
    final selectedReaction =
        getSelectedPostReaction(model, loginCredential.getUserData().id ?? '');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            FeedDesignTokens.cardPaddingH,
            8,
            FeedDesignTokens.cardPaddingH,
            6,
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: reactionCount > 0 ? onTapViewReactions : null,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        if (reactionCount > 0) ...[
                          _buildReactionIcons(context),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            reactionCount > 0
                                ? '${_formatCount(reactionCount)} reactions'
                                : 'Be first to react',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: FeedDesignTokens.textSecondary(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (commentCount > 0) ...[
                const SizedBox(width: 6),
                _buildMetaChip(
                  context,
                  icon: Icons.chat_bubble_outline_rounded,
                  label: _formatCount(commentCount),
                  onTap: onPressedComment,
                ),
              ],
              if (shareCount > 0) ...[
                const SizedBox(width: 6),
                _buildMetaChip(
                  context,
                  icon: Icons.reply_rounded,
                  label: _formatCount(shareCount),
                  onTap: () => _onShareOrCopy(isFriendsOnly),
                ),
              ],
              if (viewCount > 0) ...[
                const SizedBox(width: 6),
                _buildMetaChip(
                  context,
                  icon: Icons.visibility_outlined,
                  label: _formatCount(viewCount),
                ),
              ],
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            FeedDesignTokens.cardPaddingH,
            0,
            FeedDesignTokens.cardPaddingH,
            10,
          ),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: FeedDesignTokens.inputBg(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FeedDesignTokens.divider(context).withValues(alpha: 0.8),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                  SizedBox(
                    width: 34,
                    height: 28,
                    child: PostReactionButton(
                      selectedReaction: selectedReaction,
                      onChangedReaction: (reaction) {
                        HapticFeedback.lightImpact();
                        onSelectReaction(reaction.value);
                      },
                      isShowLikeText: false,
                    ),
                ),
                const SizedBox(width: 14),
                _buildCompactAction(
                  context,
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Comment',
                  onTap: onPressedComment,
                ),
                const SizedBox(width: 14),
                _buildCompactAction(
                  context,
                  icon: isFriendsOnly ? Icons.link_rounded : Icons.reply_rounded,
                  label: isFriendsOnly ? 'Copy Link' : 'Share',
                  onTap: () => _onShareOrCopy(isFriendsOnly),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),

        Container(
          height: FeedDesignTokens.separatorHeight,
          color: FeedDesignTokens.surfaceBg(context),
        ),
      ],
    );
  }

  Widget _buildMetaChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: FeedDesignTokens.inputBg(context),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: FeedDesignTokens.divider(context).withValues(alpha: 0.7),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: FeedDesignTokens.textSecondary(context),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: FeedDesignTokens.textSecondary(context),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return chip;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(999),
      child: chip,
    );
  }

  Widget _buildActionSurface(
    BuildContext context, {
    required Widget child,
    VoidCallback? onTap,
  }) {
    final surface = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: 40,
      decoration: BoxDecoration(
        color: FeedDesignTokens.inputBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FeedDesignTokens.divider(context).withValues(alpha: 0.8),
          width: 0.8,
        ),
      ),
      child: child,
    );

    if (onTap == null) return surface;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: surface,
    );
  }

  Widget _buildActionContent(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: FeedDesignTokens.textSecondary(context),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: FeedDesignTokens.textSecondary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17,
              color: FeedDesignTokens.textSecondary(context),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: FeedDesignTokens.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onShareOrCopy(bool isFriendsOnly) {
    if (isFriendsOnly) {
      CopyToClipboardUtils.copyToClipboard(
        '${ApiConstant.SERVER_IP}/notification/${model.id}',
        'Link',
      );
      return;
    }
    onPressedShare();
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
