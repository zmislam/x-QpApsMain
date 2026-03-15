import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../extension/string/string_image_path.dart';
import '../config/constants/app_assets.dart';
import '../config/constants/color.dart';
import '../config/constants/feed_design_tokens.dart';

import '../modules/NAVIGATION_MENUS/friend/model/people_may_you_khnow.dart';
import '../routes/app_pages.dart';
import '../routes/profile_navigator.dart';

class PeopleMayYouKnowCard extends StatelessWidget {
  const PeopleMayYouKnowCard({
    super.key,
    required this.peopleMayYouKnowModel,
    required this.onPressedAddFriend,
    required this.onPressedRemove,
  });

  final PeopleMayYouKnowModel peopleMayYouKnowModel;
  final VoidCallback onPressedAddFriend;
  final VoidCallback onPressedRemove;

  @override
  Widget build(BuildContext context) {
    final String name =
        '${peopleMayYouKnowModel.first_name ?? ''} ${peopleMayYouKnowModel.last_name ?? ''}'
            .trim();
    final String profilePic =
        (peopleMayYouKnowModel.profile_pic ?? '').formatedProfileUrl;
    final String username = peopleMayYouKnowModel.username ?? '';
    final bool isVerified = peopleMayYouKnowModel.isProfileVerified == true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Avatar
          GestureDetector(
            onTap: () => _navigateToProfile(username),
            child: ClipOval(
              child: Image.network(
                profilePic,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info + Buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Verified
                GestureDetector(
                  onTap: () => _navigateToProfile(username),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: FeedDesignTokens.textPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            color: PRIMARY_COLOR, size: 16),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Action Buttons
                Row(
                  children: [
                    // Add Friend button
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: onPressedAddFriend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Add Friend'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Remove button
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: onPressedRemove,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                FeedDesignTokens.inputBg(context),
                            foregroundColor:
                                FeedDesignTokens.textPrimary(context),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Remove'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(String username) {
    if (username.isNotEmpty) {
      ProfileNavigator.navigateToProfile(username: username);
    } else {
      Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
        'username': peopleMayYouKnowModel.username,
        'isFromReels': 'false',
      });
    }
  }
}
