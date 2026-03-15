import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/models/firend_request.dart';
import 'package:quantum_possibilities_flutter/app/models/user_id.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../config/constants/app_assets.dart';
import '../config/constants/color.dart';
import '../config/constants/feed_design_tokens.dart';
import '../routes/app_pages.dart';
import '../routes/profile_navigator.dart';

class FriendRequestCard extends StatelessWidget {
  const FriendRequestCard({
    super.key,
    required this.friendRequestModel,
    required this.onPressedAccept,
    required this.onPressedReject,
  });

  final FriendRequestModel friendRequestModel;
  final VoidCallback onPressedAccept;
  final VoidCallback onPressedReject;

  @override
  Widget build(BuildContext context) {
    final UserIdModel userIdModel = friendRequestModel.user_id!;
    final String name =
        '${userIdModel.first_name ?? ''} ${userIdModel.last_name ?? ''}'.trim();
    final String profilePic =
        (userIdModel.profile_pic ?? '').formatedProfileUrl;
    final String username = userIdModel.username ?? '';

    // Format time ago
    String timeAgo = '';
    if (friendRequestModel.createdAt != null) {
      try {
        final date = DateTime.parse(friendRequestModel.createdAt!);
        timeAgo = timeago.format(date, locale: 'en_short');
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Avatar
          GestureDetector(
            onTap: () {
              if (username.isNotEmpty) {
                ProfileNavigator.navigateToProfile(username: username);
              } else {
                Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
                  'username': username,
                  'isFromReels': 'false',
                });
              }
            },
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
                // Name + Time
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (username.isNotEmpty) {
                            ProfileNavigator.navigateToProfile(
                                username: username);
                          } else {
                            Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
                              'username': username,
                              'isFromReels': 'false',
                            });
                          }
                        },
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
                    ),
                    if (timeAgo.isNotEmpty)
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                  ],
                ),

                // Mutual friends info
                if (userIdModel.isProfileVerified == true)
                  Row(
                    children: [
                      Icon(Icons.verified,
                          color: PRIMARY_COLOR, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Verified'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 10),

                // Action Buttons
                Row(
                  children: [
                    // Confirm / Accept button
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: onPressedAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Confirm'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Delete / Decline button
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: onPressedReject,
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
                            'Delete'.tr,
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
}
