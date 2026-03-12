import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/constants/api_constant.dart';
import '../../../config/constants/feed_design_tokens.dart';
import '../../../utils/copy_to_clipboard_utils.dart';
import '../../reaction_button/post_reaction_button.dart';
import '../../../data/login_creadential.dart';
import '../../../config/constants/app_assets.dart';
import '../../../models/post.dart';
import 'package:get/get.dart';

class BottomAction extends StatelessWidget {
  const BottomAction({
    super.key,
    required this.onSelectReaction,
    required this.onPressedComment,
    required this.onPressedShare,
    required this.model,
  });

  final Function(String reaction) onSelectReaction;
  final VoidCallback onPressedComment;
  final VoidCallback onPressedShare;
  final PostModel model;

  @override
  Widget build(BuildContext context) {
    final LoginCredential loginCredential = LoginCredential();
    final bool isFriendsOnly = model.post_privacy == 'friends' &&
        (loginCredential.getUserData().id != model.user_id?.id);

    return SizedBox(
      height: FeedDesignTokens.actionBarHeight,
      child: Row(
        children: [
          // ─── Like / React Button ───
          Expanded(
            child: PostReactionButton(
              selectedReaction: getSelectedPostReaction(
                  model, loginCredential.getUserData().id ?? ''),
              onChangedReaction: (reaction) {
                onSelectReaction(reaction.value);
              },
              isShowLikeText: false,
            ),
          ),

          // ─── Comment Button ───
          Expanded(
            child: _ActionButton(
              icon: AppAssets.COMMENT_ACTION_ICON,
              label: 'Comment'.tr,
              onTap: onPressedComment,
              context: context,
            ),
          ),

          // ─── Share / Copy Link Button ───
          Expanded(
            child: isFriendsOnly
                ? _ActionButton(
                    icon: AppAssets.COPY_ACTION_ICON,
                    label: 'Copy Link'.tr,
                    onTap: () async {
                      CopyToClipboardUtils.copyToClipboard(
                        '${ApiConstant.SERVER_IP}/notification/${model.id}',
                        'Link',
                      );
                    },
                    context: context,
                  )
                : _ActionButton(
                    icon: AppAssets.SHARE_ACTION_ICON,
                    label: 'Share'.tr,
                    onTap: onPressedShare,
                    context: context,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Facebook-style action button: centered icon + label.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.context,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: SizedBox(
        height: FeedDesignTokens.actionBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: FeedDesignTokens.actionIconSize,
              width: FeedDesignTokens.actionIconSize,
              color: FeedDesignTokens.textSecondary(context),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: FeedDesignTokens.actionButtonSize,
                fontWeight: FontWeight.w600,
                color: FeedDesignTokens.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
