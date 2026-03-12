import 'package:flutter/material.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_comment_model.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_comment_reply_model.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_relpy_comment_reaction_model.dart';

import '../config/constants/app_assets.dart';

Widget ReelsCommentReactionIcons(ReelsCommentModel reelsCommentModel) {
  Set<Image> postReactionIcons = {};
  if (reelsCommentModel.comment_reactions != null) {
    for (ReelsCommentReactionModel reelsCommentReaction
        in reelsCommentModel.comment_reactions!) {
      if (reelsCommentReaction.reaction_type == '') {}
      switch (reelsCommentReaction.reaction_type) {
        case 'like':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
        case 'love':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LOVE_ICON)));
          break;
        case 'haha':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.HAHA_ICON)));
          break;
        case 'wow':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.WOW_ICON)));
          break;
        case 'sad':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.SAD_ICON)));
          break;
        case 'angry':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.ANGRY_ICON)));
          break;
        case 'dislike':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.UNLIKE_ICON)));
          break;
        default:
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
      }
    }
  }

  List<Image> reactionImageList = postReactionIcons.toList();

  if (reactionImageList.length > 3) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: reactionImageList.getRange(1, 3).toList());
  } else {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end, children: reactionImageList);
  }
}

Widget ReplayReactionIcons(ReelsCommentReplyModel commentReplay) {
  List<Image> postReactionIcons = [];
  if (commentReplay.replies_comment_reactions != null) {
    for (ReelsRepliesCommentReaction repliesCommentReaction
        in commentReplay.replies_comment_reactions!) {
      if (repliesCommentReaction.reaction_type == '') {}
      switch (repliesCommentReaction.reaction_type) {
        case 'like':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
        case 'love':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LOVE_ICON)));
          break;
        case 'haha':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.HAHA_ICON)));
          break;
        case 'wow':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.WOW_ICON)));
          break;
        case 'sad':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.SAD_ICON)));
          break;
        case 'angry':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.ANGRY_ICON)));
          break;
        case 'dislike':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.UNLIKE_ICON)));
          break;
        default:
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
      }
    }
  }

  List<Image> reactionImageList = postReactionIcons.toList();

  if (reactionImageList.length > 3) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: reactionImageList.getRange(1, 3).toList());
  } else {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end, children: reactionImageList);
  }
}
