import 'package:flutter/material.dart';

import '../config/constants/app_assets.dart';
import '../models/comment_model.dart';
import 'package:get/get.dart';

Widget CommentReactionIcons(CommentModel commentModel) {
  Set<Image> postReactionIcons = {};
  if (commentModel.comment_reactions != null) {
    for (CommentReaction commentReaction in commentModel.comment_reactions!) {
      if (commentReaction.reaction_type == '') {}
      switch (commentReaction.reaction_type) {
        case 'like':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
        case 'love':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.LOVE_ICON)));
          break;
        case 'haha':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.HAHA_ICON)));
          break;
        case 'wow':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.WOW_ICON)));
          break;
        case 'sad':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.SAD_ICON)));
          break;
        case 'angry':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.ANGRY_ICON)));
          break;
        case 'dislike':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.UNLIKE_ICON)));
          break;
        default:
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
      }
    }
  }

  List<Widget> reactionImageList = postReactionIcons.toList();

  if (reactionImageList.length > 1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...reactionImageList.reversed.toList().getRange(0, 1),
        const SizedBox(width: 4), // spacing
        // # WE CANT USE THE LENGTH OF THE [reactionImageList] AS ITS A "SET" THUS WE USED THE [commentModel.comment_reactions]
        Text('+${commentModel.comment_reactions!.length - 1}'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  } else {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: reactionImageList);
  }
}

Widget ReplayReactionIcons(CommentReplay commentReplay) {
  Set<Image> postReactionIcons = {};
  if (commentReplay.replies_comment_reactions != null) {
    for (RepliesCommentReaction repliesCommentReaction in commentReplay.replies_comment_reactions!) {
      if (repliesCommentReaction.reaction_type == '') {}
      switch (repliesCommentReaction.reaction_type) {
        case 'like':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
        case 'love':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.LOVE_ICON)));
          break;
        case 'haha':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.HAHA_ICON)));
          break;
        case 'wow':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.WOW_ICON)));
          break;
        case 'sad':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.SAD_ICON)));
          break;
        case 'angry':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.ANGRY_ICON)));
          break;
        case 'dislike':
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.UNLIKE_ICON)));
          break;
        default:
          postReactionIcons.add(const Image(height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
      }
    }
  }

  List<Image> reactionImageList = postReactionIcons.toList();

  if (reactionImageList.length > 1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...reactionImageList.reversed.toList().getRange(0, 1),
        const SizedBox(width: 4), // spacing
        // # WE CANT USE THE LENGTH OF THE [reactionImageList] AS ITS A "SET" THUS WE USED THE [commentReplay.replies_comment_reactions]
        Text('+${commentReplay.replies_comment_reactions!.length - 1}'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  } else {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: reactionImageList);
  }
}
