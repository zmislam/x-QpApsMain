import 'package:flutter/material.dart';
import '../../../../reactions.dart';
import '../../../config/constants/api_constant.dart';
import '../../../utils/copy_to_clipboard_utils.dart';
import '../../reaction_button/post_reaction_button.dart';
import '../../../data/login_creadential.dart';
import '../../../config/constants/app_assets.dart';
import '../../../models/post.dart';
import '../../button.dart';
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
  @override
  Widget build(BuildContext context) {
    final LoginCredential loginCredential = LoginCredential();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        PostActionButton(
          assetName: AppAssets.COMMENT_ACTION_ICON,
          text: 'Comment'.tr,
          onPressed: onPressedComment,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (model.post_privacy == 'friends' &&
                  (loginCredential.getUserData().id != model.user_id?.id))
                  ? PostActionButton(
                assetName: AppAssets.COPY_ACTION_ICON,
                text: 'Copy Link'.tr,
                onPressed: () async {
                  CopyToClipboardUtils.copyToClipboard(
                    '${ApiConstant.SERVER_IP}/notification/${model.id}',
                    'Link',
                  );
                },
              )
                  : PostActionButton(
                assetName: AppAssets.SHARE_ACTION_ICON,
                text: 'Share'.tr,
                onPressed: onPressedShare,
              ),
            ],
          ),
        )
      ],
    );
  }

}
