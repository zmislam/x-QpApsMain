import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../components/image.dart';
import '../../../../../../../../components/simmar_loader.dart';
import '../../../../../../../../config/constants/color.dart';
import '../../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../models/following_user_model.dart';
import '../../../../../../../../models/friend.dart';
import '../../../../../../../../routes/profile_navigator.dart';
import '../controllers/my_profile_friends_controller.dart';
import '../models/things_in_common_model.dart';

// =============================================================================
//  My Profile Friends — 3-Tab Redesign
//  Tabs: Friends · Following · Things in common
// =============================================================================

class MyProfileFriendsView extends GetView<MyProfileFriendsController> {
  const MyProfileFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = FeedDesignTokens.surfaceBg(context);
    final cardBg = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);

    final userName = LoginCredential().getUserData().first_name ?? '';

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary, size: 22),
          onPressed: () => Get.back(),
        ),
        title: Text(
          userName,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Tab bar (pill-style chips) ──────────────────────────────
          _buildTabBar(context, isDark, cardBg, textPrimary, textSecondary),

          // ── Tab content ────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              switch (controller.selectedTab.value) {
                case 0:
                  return _buildFriendsTab(
                      context, isDark, cardBg, textPrimary, textSecondary);
                case 1:
                  return _buildFollowingTab(
                      context, isDark, cardBg, textPrimary, textSecondary);
                case 2:
                  return _buildThingsInCommonTab(
                      context, isDark, cardBg, textPrimary, textSecondary);
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB BAR — Pill-style chips
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildTabBar(BuildContext context, bool isDark, Color cardBg,
      Color textPrimary, Color textSecondary) {
    final tabs = ['Friends'.tr, 'Following'.tr, 'Things in common'.tr];

    return Container(
      color: cardBg,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tabs.asMap().entries.map((entry) {
              final idx = entry.key;
              final label = entry.value;
              final isSelected = controller.selectedTab.value == idx;

              return Padding(
                padding: EdgeInsets.only(right: idx < tabs.length - 1 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => controller.onTabChanged(idx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? PRIMARY_COLOR
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : Colors.grey.shade300,
                            ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.7)
                                : Colors.black87),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  SEARCH BAR — Shared
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildSearchBar(
    BuildContext context,
    bool isDark,
    Color cardBg,
    Color textSecondary, {
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20, color: textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 15,
                color: FeedDesignTokens.textPrimary(context),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(fontSize: 15, color: textSecondary),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 1 — FRIENDS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildFriendsTab(BuildContext context, bool isDark, Color cardBg,
      Color textPrimary, Color textSecondary) {
    return Obx(() {
      if (controller.isLoadingFriendList.value) {
        return _buildShimmerList();
      }

      final list = controller.friendSearchKey.value.isEmpty
          ? controller.friendList.value
          : controller.searchedFriendList.value;

      return Column(
        children: [
          // Search bar
          _buildSearchBar(
            context, isDark, cardBg, textSecondary,
            hint: 'Search friends'.tr,
            onChanged: (v) => controller.filterFriends(v),
          ),

          // Friend requests banner
          _buildFriendRequestBanner(
              context, isDark, cardBg, textPrimary, textSecondary),

          // Count header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${'Friends'.tr} (${controller.friendSearchKey.value.isEmpty ? controller.friendList.value.length : controller.searchedFriendList.value.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
            ),
          ),

          // List
          Expanded(
            child: list.isEmpty
                ? _buildEmpty('No friends found'.tr, textSecondary)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: list.length,
                    itemBuilder: (_, i) =>
                        _buildFriendTile(context, list[i], isDark, textPrimary, textSecondary),
                  ),
          ),
        ],
      );
    });
  }

  // ─── Friend request banner ─────────────────────────────────────────

  Widget _buildFriendRequestBanner(BuildContext context, bool isDark,
      Color cardBg, Color textPrimary, Color textSecondary) {
    return Obx(() {
      if (!controller.showRequestBanner.value ||
          controller.friendRequestCount.value == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_rounded,
                      size: 18, color: PRIMARY_COLOR),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${'You have'.tr} ${controller.friendRequestCount.value} ${'friend requests waiting.'.tr}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.showRequestBanner.value = false,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16, color: textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/friend'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'See requests'.tr,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── Friend tile ───────────────────────────────────────────────────

  Widget _buildFriendTile(BuildContext context, FriendModel model, bool isDark,
      Color textPrimary, Color textSecondary) {
    final name =
        '${model.friend?.firstName ?? ''} ${model.friend?.lastName ?? ''}'
            .trim();
    final pic = (model.friend?.profilePic ?? '').formatedProfileUrl;

    return InkWell(
      onTap: () => ProfileNavigator.navigateToProfile(
        username: model.friend?.username ?? '',
        isFromReels: 'false',
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Avatar
            SizedBox(
              width: 52,
              height: 52,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: RoundCornerNetworkImage(
                  imageUrl: pic,
                  width: 52,
                  height: 52,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // More menu
            _buildFriendMenu(context, model, isDark, textPrimary),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendMenu(
      BuildContext context, FriendModel model, bool isDark, Color textPrimary) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: textPrimary, size: 22),
      color: FeedDesignTokens.cardBg(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 40),
      itemBuilder: (_) => [
        _popupItem('Unfriend'.tr, Icons.person_remove_outlined),
        _popupItem('Block'.tr, Icons.block_outlined),
      ],
      onSelected: (val) {
        if (val == 'Unfriend'.tr) {
          _showConfirmDialog(
            context: context,
            title: 'Unfriend'.tr,
            message: 'Are you sure you want to unfriend?'.tr,
            isDark: isDark,
            onConfirm: () {
              controller.unfriendFriend('${model.id}');
              Get.back();
            },
          );
        } else if (val == 'Block'.tr) {
          _showConfirmDialog(
            context: context,
            title: 'Block'.tr,
            message: 'Are you sure you want to block this person?'.tr,
            isDark: isDark,
            onConfirm: () {
              controller.blockUser('${model.friend?.id}');
              Get.back();
            },
          );
        }
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 2 — FOLLOWING
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildFollowingTab(BuildContext context, bool isDark, Color cardBg,
      Color textPrimary, Color textSecondary) {
    return Obx(() {
      if (controller.isLoadingFollowing.value) {
        return _buildShimmerList();
      }

      final list = controller.followingSearchKey.value.isEmpty
          ? controller.followingList.value
          : controller.searchedFollowingList.value;

      return Column(
        children: [
          // Search bar
          _buildSearchBar(
            context, isDark, cardBg, textSecondary,
            hint: 'Search'.tr,
            onChanged: (v) => controller.filterFollowing(v),
          ),

          // Count header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${'Following'.tr} (${controller.followingSearchKey.value.isEmpty ? controller.followingList.value.length : controller.searchedFollowingList.value.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
            ),
          ),

          // List
          Expanded(
            child: list.isEmpty
                ? _buildEmpty('No following found'.tr, textSecondary)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _buildFollowingTile(
                        context, list[i], isDark, textPrimary, textSecondary),
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildFollowingTile(BuildContext context, FollowingUserModel model,
      bool isDark, Color textPrimary, Color textSecondary) {
    final user = model.followerUserId;
    final name = '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
    final pic = (user?.profilePic ?? '').formatedProfileUrl;

    return InkWell(
      onTap: () => ProfileNavigator.navigateToProfile(
        username: user?.username ?? '',
        isFromReels: 'false',
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: RoundCornerNetworkImage(
                  imageUrl: pic,
                  width: 52,
                  height: 52,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz, color: textPrimary, size: 22),
              color: FeedDesignTokens.cardBg(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              offset: const Offset(0, 40),
              itemBuilder: (_) => [
                _popupItem('Unfollow'.tr, Icons.person_remove_outlined),
                _popupItem('Block'.tr, Icons.block_outlined),
              ],
              onSelected: (val) {
                if (val == 'Unfollow'.tr) {
                  controller.unfollowUser('${model.id}');
                } else if (val == 'Block'.tr) {
                  _showConfirmDialog(
                    context: context,
                    title: 'Block'.tr,
                    message: 'Are you sure you want to block this person?'.tr,
                    isDark: isDark,
                    onConfirm: () {
                      controller.blockUser('${user?.id}');
                      Get.back();
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 3 — THINGS IN COMMON
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildThingsInCommonTab(BuildContext context, bool isDark,
      Color cardBg, Color textPrimary, Color textSecondary) {
    return Obx(() {
      if (controller.isLoadingThingsInCommon.value) {
        return _buildShimmerList();
      }

      final list = controller.thingsInCommonList.value;

      if (list.isEmpty) {
        return _buildEmpty(
            'No things in common found with friends'.tr, textSecondary);
      }

      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: list.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 56,
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
        ),
        itemBuilder: (_, i) => _buildThingsInCommonTile(
            context, list[i], isDark, cardBg, textPrimary, textSecondary),
      );
    });
  }

  Widget _buildThingsInCommonTile(
    BuildContext context,
    ThingsInCommonItem item,
    bool isDark,
    Color cardBg,
    Color textPrimary,
    Color textSecondary,
  ) {
    // Icon mapping
    final iconData = _thingsInCommonIcon(item.type);
    final iconColor = _thingsInCommonColor(item.type);

    // Build "friends text" line
    final sampleNames = item.sampleFriends
        .take(2)
        .map((f) => f.fullName)
        .where((n) => n.isNotEmpty)
        .toList();

    String friendsText = '';
    final remaining = item.totalCount - sampleNames.length;
    if (sampleNames.isNotEmpty) {
      friendsText = sampleNames.join(', ');
      if (remaining > 0) {
        friendsText += ' ${'and'.tr} $remaining ${'others also added this.'.tr}';
      } else {
        friendsText += ' ${'also added this.'.tr}';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label (value)
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 2),
                // Subtitle (category)
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                  ),
                ),

                // Sample friend avatars + text
                if (friendsText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Stacked avatars
                      if (item.sampleFriends.isNotEmpty)
                        SizedBox(
                          width: item.sampleFriends.length <= 1
                              ? 28
                              : (28 + (item.sampleFriends.length - 1) * 18)
                                  .toDouble(),
                          height: 28,
                          child: Stack(
                            children: item.sampleFriends
                                .take(3)
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                              final idx = entry.key;
                              final friend = entry.value;
                              return Positioned(
                                left: idx * 18.0,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF1C1C1E)
                                          : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: RoundCornerNetworkImage(
                                      imageUrl: friend.profilePic
                                          .formatedProfileUrl,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          friendsText,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _thingsInCommonIcon(String type) {
    switch (type) {
      case 'location':
        return Icons.location_on_outlined;
      case 'home_town':
        return Icons.home_outlined;
      case 'education':
        return Icons.school_outlined;
      case 'workplace':
        return Icons.work_outline;
      case 'language':
        return Icons.translate;
      case 'date_of_birth':
        return Icons.cake_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _thingsInCommonColor(String type) {
    switch (type) {
      case 'location':
        return const Color(0xFFEF4444);
      case 'home_town':
        return const Color(0xFF3B82F6);
      case 'education':
        return const Color(0xFF8B5CF6);
      case 'workplace':
        return const Color(0xFF10B981);
      case 'language':
        return const Color(0xFFF59E0B);
      case 'date_of_birth':
        return const Color(0xFFEC4899);
      default:
        return const Color(0xFF6B7280);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  SHARED COMPONENTS
  // ═══════════════════════════════════════════════════════════════════════

  PopupMenuEntry<String> _popupItem(String label, IconData icon) {
    return PopupMenuItem<String>(
      value: label,
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required bool isDark,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text(
              'Confirm'.tr,
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(String message, Color textSecondary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text(
          message,
          style: TextStyle(fontSize: 14, color: textSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (_, __) => ShimmerLoader(
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
      ),
    );
  }
}
