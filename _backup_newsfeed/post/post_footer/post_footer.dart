import 'package:flutter/material.dart';

import '../../../config/constants/app_assets.dart';
import '../../../models/post.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (model.user_id == null)
          SizedBox.shrink()
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              InkWell(
                  onTap: onTapViewReactions, child: PostReactionIcons(model)),
              Expanded(
                child: Row(
                  children: [
                    (model.reactionCount ?? 0) > 0
                        ? Text(' ${model.reactionCount}'.tr)
                        : Text('No reaction'.tr),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(model.totalComments == 1
                      ? '${model.totalComments}'
                      : '${model.totalComments}'),
                  SizedBox(width: 4),
                  Image.asset(
                    AppAssets.COMMENT_ACTION_ICON,
                    height: 15,
                    width: 15,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 16),
                  Text(model.postShareCount == 1
                      ? '${model.postShareCount}'
                      : '${model.postShareCount}'),
                  SizedBox(width: 4),
                  Image.asset(
                    AppAssets.SHARE_ACTION_ICON,
                    height: 15,
                    width: 15,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
        const Divider(),
        BottomAction(
          onSelectReaction: onSelectReaction,
          onPressedComment: onPressedComment,
          onPressedShare: onPressedShare,
          model: model,
        ),
        Container(
          height: 10,
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.surfaceBright),
        )
      ],
    );
  }
}

//=============================================================== Post Reaction List

Widget PostReactionIcons(PostModel postModel) {
  Set<Image> postReactionIcons = {};
  if (postModel.reactionTypeCountsByPost != null) {
    for (ReactionModel reactionModel in postModel.reactionTypeCountsByPost!) {
      if (reactionModel.reaction_type == '') {}
      switch (reactionModel.reaction_type) {
        case 'like':
          postReactionIcons.add(const Image(
              height: 30, width: 30, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
        case 'love':
          postReactionIcons.add(const Image(
              height: 30, width: 30, image: AssetImage(AppAssets.LOVE_ICON)));
          break;
        case 'haha':
          postReactionIcons.add(const Image(
              height: 30, width: 30, image: AssetImage(AppAssets.HAHA_ICON)));
          break;
        case 'wow':
          postReactionIcons.add(const Image(
              height: 30, width: 30, image: AssetImage(AppAssets.WOW_ICON)));
          break;
        case 'sad':
          postReactionIcons.add(const Image(
              height: 30, width: 30, image: AssetImage(AppAssets.SAD_ICON)));
          break;
        case 'angry':
          postReactionIcons.add(const Image(
              height: 30, width: 30, image: AssetImage(AppAssets.ANGRY_ICON)));
          break;
        case 'dislike':
          postReactionIcons.add(const Image(
              height: 30, width: 30, image: AssetImage(AppAssets.UNLIKE_ICON)));
          break;
        default:
          postReactionIcons.add(const Image(
              height: 30, width: 30, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
      }
    }
  }

  List<Image> postReactionList = postReactionIcons.toList();
  if (postReactionList.length > 3) {
    return Row(children: postReactionList.getRange(0, 2).toList());
  } else {
    return Row(children: postReactionList);
  }
}

//=============================================================== Like, Comment, Share button
