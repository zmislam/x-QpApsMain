import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../config/constants/app_assets.dart';
import '../models/post.dart';
import 'single_image.dart';

class MultipleImageTile extends StatelessWidget {
  final String imageUrl;
  final PostModel model;
  final VoidCallback onPressedComment;
  final VoidCallback onPressedShare;
  final VoidCallback onTapViewReactions;
  final Function(String reaction) onSelectReaction;

  const MultipleImageTile(
      {super.key,
      required this.imageUrl,
      required this.model,
      required this.onSelectReaction,
      required this.onPressedComment,
      required this.onPressedShare,
      required this.onTapViewReactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => SingleImage(imgURL: imageUrl));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
              height: 200,
              width: Get.width,
              fit: BoxFit.cover,
              image: NetworkImage(
                imageUrl,
              ),
              errorBuilder: (context, error, stackTrace) {
                return Image(
                  height: 200,
                  width: Get.width,
                  fit: BoxFit.cover,
                  image: const AssetImage(AppAssets.DEFAULT_IMAGE),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        // PostFooter(
        //   model: model,
        //   onSelectReaction: onSelectReaction,
        //   onPressedComment: onPressedComment,
        //   onPressedShare: onPressedShare,
        //   onTapViewReactions: onTapViewReactions,
        // ),
      ],
    );
  }
}
