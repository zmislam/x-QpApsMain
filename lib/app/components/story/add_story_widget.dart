import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../extension/string/string_image_path.dart';
import '../../models/user.dart';
import '../../config/constants/feed_design_tokens.dart';

class AddStoryWidget extends StatelessWidget {
  const AddStoryWidget({
    super.key,
    required this.userModel,
    required this.onTapCreateStory,
  });

  final VoidCallback onTapCreateStory;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCreateStory,
      borderRadius: BorderRadius.circular(FeedDesignTokens.storyCardRadius),
      child: Container(
        width: FeedDesignTokens.storyCardWidth,
        height: FeedDesignTokens.storyCardHeight,
        decoration: BoxDecoration(
          color: FeedDesignTokens.cardBg(context),
          borderRadius: BorderRadius.circular(FeedDesignTokens.storyCardRadius),
          border: Border.all(
            color: FeedDesignTokens.cardBorder(context),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FeedDesignTokens.storyCardRadius),
          child: Stack(
            children: [
              Column(
                children: [
                  // ─── Profile Picture (Top 2/3) ───
                  Expanded(
                    flex: 2,
                    child: CachedNetworkImage(
                      imageUrl: (userModel.profile_pic ?? '').formatedProfileUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(color: Colors.grey.shade300),
                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.person, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  // ─── Bottom Text Area (Bottom 1/3) ───
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: FeedDesignTokens.cardBg(context),
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(
                          bottom: 12, left: 4, right: 4),
                      child: Text(
                        'Create story'.tr,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: FeedDesignTokens.textPrimary(context),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ─── Overlapping Plus Button ───
              Positioned(
                bottom: (FeedDesignTokens.storyCardHeight / 3) - 18,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FeedDesignTokens.cardBg(context),
                    ),
                    padding: const EdgeInsets.all(2), // White border spacing
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FeedDesignTokens.brand(context),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
