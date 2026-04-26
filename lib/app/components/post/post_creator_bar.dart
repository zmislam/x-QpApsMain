import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/components/image.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/feed_design_tokens.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/models/user.dart';

class PostCreatorBar extends StatelessWidget {
  const PostCreatorBar({
    super.key,
    required this.userModel,
    required this.onTapCreatePost,
    required this.onTapPhoto,
    this.trailingAction,
  });

  final UserModel userModel;
  final VoidCallback onTapCreatePost;
  final VoidCallback onTapPhoto;
  final Widget? trailingAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        border: Border(
          bottom: BorderSide(
            color: FeedDesignTokens.divider(context),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            // Avatar with subtle ring
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: FeedDesignTokens.divider(context),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: RoundCornerNetworkImage(
                  imageUrl:
                      (userModel.profile_pic ?? '').formatedProfileUrl,
                  height: FeedDesignTokens.avatarSize,
                  width: FeedDesignTokens.avatarSize,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Input trigger pill with photo icon inside
            Expanded(
              child: InkWell(
                onTap: onTapCreatePost,
                borderRadius:
                    BorderRadius.circular(FeedDesignTokens.inputBorderRadius),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(
                        FeedDesignTokens.inputBorderRadius),
                    border: Border.all(
                      color: FeedDesignTokens.divider(context),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${'What\'s on your mind'.tr}, ${userModel.first_name}?",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ),
                      // Photo icon inside the pill (like Facebook)
                      GestureDetector(
                        onTap: onTapPhoto,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.photo_library_rounded,
                            size: 22,
                            color: const Color(0xFF45BD62),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (trailingAction != null) ...[
              const SizedBox(width: 8),
              trailingAction!,
            ],
          ],
        ),
      ),
    );
  }
}
