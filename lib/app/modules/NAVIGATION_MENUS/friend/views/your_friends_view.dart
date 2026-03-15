import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/simmar_loader.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../config/constants/color.dart';
import '../../../../config/constants/feed_design_tokens.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../models/friend.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/profile_navigator.dart';
import '../controllers/friend_controller.dart';

class YourFriendsView extends GetView<FriendController> {
  const YourFriendsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load friend list if not already loaded
    if (controller.fullFriendList.value.isEmpty &&
        !controller.isLoadingFullFriendList.value) {
      controller.getFullFriendList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FeedDesignTokens.cardBg(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: FeedDesignTokens.textPrimary(context)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Your Friends'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: FeedDesignTokens.inputBg(context),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search,
                  size: 20, color: FeedDesignTokens.textPrimary(context)),
            ),
            onPressed: () {
              // Toggle search visibility
              _showSearchField(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingFullFriendList.value &&
            controller.fullFriendList.value.isEmpty) {
          return _buildShimmer();
        }

        final friends = controller.filteredFriendList;
        final totalCount = controller.totalFriendCount.value;

        return RefreshIndicator(
          color: PRIMARY_COLOR,
          backgroundColor: FeedDesignTokens.cardBg(context),
          onRefresh: () => controller.getFullFriendList(),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 12),

              // Search Field
              _buildSearchField(context),
              const SizedBox(height: 16),

              // Birthday Banner
              _buildBirthdayBanner(context),

              // Friend Count
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '$totalCount ${'friends'.tr}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                ),
              ),

              // Sort Button
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sort,
                          size: 16,
                          color: FeedDesignTokens.textPrimary(context)),
                      const SizedBox(width: 4),
                      Text(
                        'All friends'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: FeedDesignTokens.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              if (friends.isEmpty && !controller.isLoadingFullFriendList.value)
                _buildEmptyState(context),

              // Friend List
              ...friends.map((friend) => _FriendListItem(
                    friend: friend,
                    controller: controller,
                  )),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  void _showSearchField(BuildContext context) {
    // Focus the search field — it's already visible
    // The search field is always visible in the list
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: FeedDesignTokens.inputBg(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => controller.friendSearchQuery.value = value,
        decoration: InputDecoration(
          hintText: 'Search friends'.tr,
          hintStyle: TextStyle(
            color: FeedDesignTokens.textSecondary(context),
            fontSize: 15,
          ),
          prefixIcon: Icon(Icons.search,
              color: FeedDesignTokens.textSecondary(context), size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        style: TextStyle(
          color: FeedDesignTokens.textPrimary(context),
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildBirthdayBanner(BuildContext context) {
    // Show birthday banner
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FeedDesignTokens.inputBg(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PRIMARY_COLOR.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cake_rounded,
                color: PRIMARY_COLOR, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Birthdays'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'See upcoming birthdays'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(Routes.BIRTHDAYS),
            style: TextButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('See'.tr,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.people_outline,
                size: 64, color: FeedDesignTokens.textSecondary(context)),
            const SizedBox(height: 12),
            Text(
              'No friends found'.tr,
              style: TextStyle(
                fontSize: 16,
                color: FeedDesignTokens.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return ShimmerLoader(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
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

// ═══════════════════════════════════════════════════════════════
//  Friend List Item
// ═══════════════════════════════════════════════════════════════
class _FriendListItem extends StatelessWidget {
  const _FriendListItem({
    required this.friend,
    required this.controller,
  });

  final FriendModel friend;
  final FriendController controller;

  @override
  Widget build(BuildContext context) {
    final name = friend.fullName ??
        '${friend.friend?.firstName ?? ''} ${friend.friend?.lastName ?? ''}'
            .trim();
    final profilePic =
        (friend.profilePic ?? friend.friend?.profilePic ?? '')
            .formatedProfileUrl;
    final username = friend.friend?.username ?? '';

    return InkWell(
      onTap: () {
        if (username.isNotEmpty) {
          ProfileNavigator.navigateToProfile(username: username);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                ClipOval(
                  child: Image.network(
                    profilePic,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 52,
                      height: 52,
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
              ],
            ),
            const SizedBox(width: 12),

            // Name + username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Three-dot menu
            PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz,
                  color: FeedDesignTokens.textSecondary(context)),
              onSelected: (value) {
                switch (value) {
                  case 'unfriend':
                    _showUnfriendDialog(context, name);
                    break;
                  case 'block':
                    controller.blockFriends(friend.friend?.id ?? friend.id ?? '');
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'unfriend',
                  child: Row(
                    children: [
                      const Icon(Icons.person_remove_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text('Unfriend'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: Row(
                    children: [
                      const Icon(Icons.block, size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      Text('Block'.tr,
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUnfriendDialog(BuildContext context, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: FeedDesignTokens.cardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Unfriend $name?',
            style: TextStyle(
              color: FeedDesignTokens.textPrimary(context),
              fontWeight: FontWeight.w600,
            )),
        content: Text(
          '$name will be removed from your friends list.',
          style:
              TextStyle(color: FeedDesignTokens.textSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr,
                style: const TextStyle(color: PRIMARY_COLOR)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller
                  .unfriendFriends(friend.friend?.id ?? friend.id ?? '');
            },
            child: Text('Unfriend'.tr,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
