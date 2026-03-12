import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/components/image.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/feed_design_tokens.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/models/user.dart';

class PostCreatorBar extends StatelessWidget {
  const PostCreatorBar({
    super.key,
    required this.userModel,
    required this.onTapCreatePost,
    required this.onTapPhoto,
  });

  final UserModel userModel;
  final VoidCallback onTapCreatePost;
  final VoidCallback onTapPhoto;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Top row: Avatar + Input pill + Gallery ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
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

                // Input trigger pill
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
                      alignment: Alignment.centerLeft,
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
                  ),
                ),
              ],
            ),
          ),

          // ─── Divider ───
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: FeedDesignTokens.divider(context),
          ),

          // ─── Action buttons row ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                // Live Video
                _ActionButton(
                  icon: Icons.videocam_rounded,
                  iconColor: const Color(0xFFF3425F),
                  label: 'Live'.tr,
                  onTap: onTapCreatePost,
                  context: context,
                ),
                // Vertical divider
                _verticalDivider(context),
                // Photo
                _ActionButton(
                  icon: Icons.photo_library_rounded,
                  iconColor: const Color(0xFF45BD62),
                  label: 'Photo'.tr,
                  onTap: onTapPhoto,
                  context: context,
                ),
                // Vertical divider
                _verticalDivider(context),
                // Feeling
                _ActionButton(
                  icon: Icons.emoji_emotions_rounded,
                  iconColor: const Color(0xFFF7B928),
                  label: 'Feeling'.tr,
                  onTap: onTapCreatePost,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return Container(
      width: 0.5,
      height: 24,
      color: FeedDesignTokens.divider(context),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    required this.context,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 6),
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
      ),
    );
  }
}
