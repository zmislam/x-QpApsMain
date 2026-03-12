import 'package:flutter/material.dart';
import '../../models/comment_model.dart';
import 'package:reaction_button/reaction_button.dart';

import '../../config/constants/app_assets.dart';
import 'package:get/get.dart';

const double selectedViewImagewidth = 24;
const double width = 32;
Color color = Colors.grey;
FontWeight fontWeight = FontWeight.normal;
var selectedViewTextStyle =
    TextStyle(fontSize: 14, color: color, fontWeight: fontWeight);
const SelectedViewGap = SizedBox(width: 5);

final commentReactions = [
  ReactionModel(
    value: 'like',
    initialView: const Image(
      width: width,
      image: AssetImage(AppAssets.LIKE_ICON),
    ),
    selectedView: Row(
      children: [
        // Image(
        //   width: selectedViewImagewidth,
        //   image: AssetImage(AppAssets.LIKE_ICON),
        // ),
        SelectedViewGap,
        Text('Like'.tr,
          style: selectedViewTextStyle.copyWith(
              color: Colors.blue.shade800, fontWeight: FontWeight.bold),
        )
      ],
    ),
  ),
  ReactionModel(
    value: 'love',
    initialView: const Image(
      width: width,
      image: AssetImage(AppAssets.LOVE_ICON),
    ),
    selectedView: Row(
      children: [
        // Image(
        //   width: selectedViewImagewidth,
        //   image: AssetImage(AppAssets.LOVE_ICON),
        // ),
        SelectedViewGap,
        Text('Love'.tr,
            style: selectedViewTextStyle.copyWith(
                color: Colors.red.shade400, fontWeight: FontWeight.bold)),
      ],
    ),
  ),
  ReactionModel(
    value: 'haha',
    initialView: const Image(
      width: width,
      image: AssetImage(AppAssets.HAHA_ICON),
    ),
    selectedView: Row(
      children: [
        // Image(
        //   width: selectedViewImagewidth,
        //   image: AssetImage(AppAssets.HAHA_ICON),
        // ),
        SelectedViewGap,
        Text('Haha'.tr,
            style: selectedViewTextStyle.copyWith(
                color: Colors.yellow.shade800, fontWeight: FontWeight.bold)),
      ],
    ),
  ),
  ReactionModel(
    value: 'wow',
    initialView: const Image(
      width: width,
      image: AssetImage(AppAssets.WOW_ICON),
    ),
    selectedView: Row(
      children: [
        // Image(
        //   width: selectedViewImagewidth,
        //   image: AssetImage(AppAssets.WOW_ICON),
        // ),
        SelectedViewGap,
        Text('Wow'.tr,
            style: selectedViewTextStyle.copyWith(
                color: Colors.yellow.shade800, fontWeight: FontWeight.bold)),
      ],
    ),
  ),
  ReactionModel(
    value: 'sad',
    initialView: const Image(
      width: width,
      image: AssetImage(AppAssets.SAD_ICON),
    ),
    selectedView: Row(
      children: [
        // Image(
        //   width: selectedViewImagewidth,
        //   image: AssetImage(AppAssets.SAD_ICON),
        // ),
        SelectedViewGap,
        Text('Sad'.tr,
            style: selectedViewTextStyle.copyWith(
                color: Colors.yellow.shade800, fontWeight: FontWeight.bold)),
      ],
    ),
  ),
  ReactionModel(
    value: 'angry',
    initialView: const Image(
      width: width,
      image: AssetImage(AppAssets.ANGRY_ICON),
    ),
    selectedView: Row(
      children: [
        // Image(
        //   width: selectedViewImagewidth,
        //   image: AssetImage(AppAssets.ANGRY_ICON),
        // ),
        SelectedViewGap,
        Text('Angry'.tr,
            style: selectedViewTextStyle.copyWith(
                color: Colors.red.shade700, fontWeight: FontWeight.bold)),
      ],
    ),
  ),
  ReactionModel(
    value: 'dislike',
    initialView: const Image(
      width: width,
      image: AssetImage(AppAssets.UNLIKE_ICON),
    ),
    selectedView: Row(
      children: [
        // Image(
        //   width: selectedViewImagewidth,
        //   image: AssetImage(AppAssets.UNLIKE_ICON),
        // ),
        SelectedViewGap,
        Text('Dislike'.tr,
            style: selectedViewTextStyle.copyWith(
                color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
      ],
    ),
  ),
];

class CommentReactionButton extends StatelessWidget {
  final ReactionModel? selectedReaction;
  final Function(ReactionModel reaction) onChangedReaction;

  const CommentReactionButton({
    super.key,
    required this.onChangedReaction,
    this.selectedReaction,
  });

  @override
  Widget build(BuildContext context) {
    return ReactionButton(
      placeHolder: ReactionModel(
        value: 'like',
        initialView: Row(
          children: [
            Text('Like'.tr,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        selectedView: Row(
          children: [
            // Image(
            //   width: 32,
            //   image: AssetImage(AppAssets.LIKE_ICON),
            // ),
            Text('Like'.tr,
              // style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      selectedReaction: selectedReaction,
      reactions: commentReactions,
      onChangedReaction: onChangedReaction,
    );
  }
}

ReactionModel? getSelectedCommentReaction(
  CommentModel commentModel,
  String userId,
) {
  List<CommentReaction> comment_reactions =
      commentModel.comment_reactions ?? [];
  CommentReaction commentReaction = comment_reactions.firstWhere(
      (commentReaction) => commentReaction.user_id == userId,
      orElse: () => CommentReaction(v: -1));

  if ((commentReaction.v ?? 0) != -1) {
    return getReactionModelAsType(commentReaction.reaction_type ?? '');
  }

  return null;
}

ReactionModel? getSelectedCommentReplayReaction(
  CommentReplay commentReplay,
  String userId,
) {
  List<RepliesCommentReaction> commentReplayReactions =
      commentReplay.replies_comment_reactions ?? [];
  RepliesCommentReaction commentReplayReaction =
      commentReplayReactions.firstWhere(
          (commentReplayReaction) => commentReplayReaction.user_id == userId,
          orElse: () => RepliesCommentReaction(v: -1));

  if ((commentReplayReaction.v ?? 0) != -1) {
    return getReactionModelAsType(commentReplayReaction.reaction_type ?? '');
  }

  return null;
}

ReactionModel? getReactionModelAsType(String type) {
  for (ReactionModel reactionModel in commentReactions) {
    if (reactionModel.value == type) {
      return reactionModel;
    }
  }
  return null;
}
