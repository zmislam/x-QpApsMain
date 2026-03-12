import 'package:flutter/cupertino.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

import '../config/constants/app_assets.dart';
import '../utils/post_utlis.dart';

class CommentReactionButton extends StatelessWidget {
  const CommentReactionButton({
    super.key,
    required this.onReactionChanged,
    required this.placeholder,
    this.placeholderIconSize,
  });
  final void Function(Reaction<String>?) onReactionChanged;
  final Reaction<String>? placeholder;
  final double? placeholderIconSize;
  @override
  Widget build(BuildContext context) {
    return ReactionButton<String>(
      itemSize: const Size(32, 32),
      onReactionChanged: onReactionChanged,
      placeholder: placeholder,
      reactions: <Reaction<String>>[
        Reaction<String>(
          value: 'like',
          icon: ReactionIcon(AppAssets.LIKE_ICON, height: placeholderIconSize),
        ),
        Reaction<String>(
          value: 'love',
          icon: ReactionIcon(AppAssets.LOVE_ICON, height: placeholderIconSize),
        ),
        Reaction<String>(
          value: 'haha',
          icon: ReactionIcon(AppAssets.HAHA_ICON, height: placeholderIconSize),
        ),
        Reaction<String>(
          value: 'wow',
          icon: ReactionIcon(AppAssets.WOW_ICON, height: placeholderIconSize),
        ),
        Reaction<String>(
          value: 'sad',
          icon: ReactionIcon(AppAssets.SAD_ICON, height: placeholderIconSize),
        ),
        Reaction<String>(
          value: 'angry',
          icon: ReactionIcon(AppAssets.ANGRY_ICON, height: placeholderIconSize),
        ),
        Reaction<String>(
          value: 'dislike',
          icon:
              ReactionIcon(AppAssets.UNLIKE_ICON, height: placeholderIconSize),
        )
      ],
    );
  }
}
