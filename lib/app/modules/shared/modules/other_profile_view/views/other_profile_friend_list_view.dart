import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/simmar_loader.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../enum/other_user_friend_follower_following.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../models/friend.dart';
import '../../../../../routes/app_pages.dart';
import '../components/other_user_follower_list.dart';
import '../components/other_user_following_list.dart';
import '../controller/other_profile_controller.dart';

/// Facebook-style friend list page (other user)
class OtherProfileFriendsView extends StatelessWidget {
  const OtherProfileFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OthersProfileController>();
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final dividerColor = FeedDesignTokens.divider(context);
    final inputBg = FeedDesignTokens.inputBg(context);

    final firstName =
        controller.profileModel.value?.first_name ?? '';
    final title = firstName.isNotEmpty
        ? '$firstName\'s ${'friends'.tr}'
        : 'Friends'.tr;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: IconThemeData(color: textPrimary),
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_outlined, color: textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Pill-chip tabs (Mutual / All / Following / Followers) ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: FriendCategory.values.map((category) {
                  return Obx(() {
                    final isSelected =
                        controller.selectedCategory.value == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => controller.filterByCategory(category),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? PRIMARY_COLOR
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(color: dividerColor, width: 1),
                          ),
                          child: Text(
                            category.displayTitle.tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color:
                                  isSelected ? Colors.white : textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
            ),
          ),

          // ─── Search bar ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onChanged: (v) => controller.filterFriend(v),
                style: TextStyle(fontSize: 15, color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search friends'.tr,
                  hintStyle: TextStyle(fontSize: 15, color: textSecondary),
                  prefixIcon: Icon(Icons.search, color: textSecondary, size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),

          // ─── Tab content ─────────────────────────────────
          Expanded(
            child: Obx(() {
              final viewIndex =
                  controller.otherProfileFriendsViewNumber.value;
              if (viewIndex == 2) {
                return OtherUserFollowingListComponent(
                    controller: controller);
              }
              if (viewIndex == 3) {
                return OtherUserFollowerListComponent(
                    controller: controller);
              }
              // viewIndex 0 (All) and 1 (Mutual) both show friend list
              return _buildFriendList(
                context,
                controller,
                bgColor,
                textPrimary,
                textSecondary,
                dividerColor,
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── Friend list (All / Mutual tab) ────────────────────────
  Widget _buildFriendList(
    BuildContext context,
    OthersProfileController controller,
    Color bgColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
  ) {
    return Obx(() {
      if (controller.isLoadingFriendList.value) {
        return _buildShimmerList();
      }

      final friends = controller.searchKey.value.isEmpty
          ? controller.friendList.value
          : controller.searchedFriendList.value;

      if (friends.isEmpty) {
        return _buildEmptyState(controller, textPrimary, textSecondary);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Count header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              '${friends.length} ${'friends'.tr}',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),
          // Friend list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: friends.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final f = friends[index];
                return _buildFriendRow(
                    context, controller, f, textPrimary, textSecondary, dividerColor);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFriendRow(BuildContext context, OthersProfileController controller,
      FriendModel f, Color textPrimary, Color textSecondary, Color dividerColor) {
    final profilePic = f.friend?.profilePic != null
        ? f.friend!.profilePic!.formatedProfileUrl
        : '';
    final hasProfilePic =
        f.friend?.profilePic != null && f.friend!.profilePic!.isNotEmpty;
    final name =
        '${f.friend?.firstName ?? ''} ${f.friend?.lastName ?? ''}'.trim();

    return InkWell(
      onTap: () {
        if (f.friend?.username != LoginCredential().getUserData().username) {
          if (Get.isRegistered<OthersProfileController>()) {
            Get.delete<OthersProfileController>();
          }
          Get.toNamed(
            Routes.OTHERS_PROFILE,
            arguments: {
              'username': f.friend?.username ?? '',
              'isFromReels': 'false',
            },
          );
        } else {
          Get.toNamed(Routes.PROFILE);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              backgroundImage: hasProfilePic
                  ? NetworkImage(profilePic)
                  : const AssetImage(AppAssets.DEFAULT_CIRCLE_PROFILE_IMAGE)
                      as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'No mutual friend'.tr,
                    style: TextStyle(fontSize: 14, color: textSecondary),
                  ),
                ],
              ),
            ),
            _buildMoreMenu(context, controller, f, textPrimary),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreMenu(
      BuildContext context, OthersProfileController controller, FriendModel f, Color textPrimary) {
    return PopupMenuButton(
      icon: Icon(Icons.more_horiz, color: textPrimary, size: 24),
      color: FeedDesignTokens.cardBg(context),
      offset: const Offset(-40, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.person_remove_outlined, color: textPrimary, size: 20),
              const SizedBox(width: 10),
              Text('Unfriend'.tr,
                  style: TextStyle(color: textPrimary, fontSize: 15)),
            ],
          ),
          onTap: () {
            controller.unfriendFriends('${f.id}');
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(Icons.block, color: Colors.red, size: 20),
              const SizedBox(width: 10),
              Text('Block'.tr,
                  style: const TextStyle(color: Colors.red, fontSize: 15)),
            ],
          ),
          onTap: () {
            controller.blockFriends('${f.friend?.id}');
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(OthersProfileController controller, Color textPrimary, Color textSecondary) {
    final firstName =
        controller.profileModel.value?.first_name ?? '';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.person_outline,
                  size: 56, color: Colors.blue.shade400),
            ),
            const SizedBox(height: 20),
            Text(
              'No friends to show'.tr,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              firstName.isNotEmpty
                  ? '$firstName\'s friend list is private.'.tr
                  : 'This user\'s friend list is private.'.tr,
              style: TextStyle(fontSize: 15, color: textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (_, __) {
        return ShimmerLoader(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
