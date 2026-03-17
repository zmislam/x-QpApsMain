import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../components/single_image.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../routes/app_pages.dart';
import '../components/feed_component.dart';
import '../components/others_reels_component.dart';
import '../components/photos_component.dart';
import '../controller/other_profile_controller.dart';

class OtherProfileView extends GetView<OthersProfileController> {
  const OtherProfileView({super.key});

  // ─── Helpers ─────────────────────────────────────────────
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final dividerColor = FeedDesignTokens.divider(context);
    final surfaceBg = FeedDesignTokens.surfaceBg(context);
    final inputBg = FeedDesignTokens.inputBg(context);

    return Scaffold(
      backgroundColor: surfaceBg,
      body: RefreshIndicator(
        backgroundColor: bgColor,
        color: PRIMARY_COLOR,
        onRefresh: controller.refresh,
        child: Obx(() {
          final profile = controller.profileModel.value;

          return CustomScrollView(
            controller: controller.postScrollController,
            slivers: [
              // ════════════════════════════════════════════════
              // SECTION 1: Cover + Profile Pic + Name + Stats
              // ════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Container(
                  color: bgColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCoverAndAvatar(context, profile, bgColor),
                      const SizedBox(height: 8),
                      _buildNameRow(context, profile, textPrimary),
                      const SizedBox(height: 4),
                      _buildStatsRow(context, profile, textSecondary),
                      const SizedBox(height: 8),
                      if (profile?.user_bio != null &&
                          profile!.user_bio!.isNotEmpty)
                        _buildBio(context, profile, textPrimary),
                      if (profile?.present_town != null &&
                          profile!.present_town!.isNotEmpty)
                        _buildCategoryLine(context, profile, textSecondary),
                      const SizedBox(height: 12),
                      _buildActionButtons(context, profile, bgColor, inputBg, textPrimary),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // ════════════════════════════════════════════════
              // SECTION 2: Tab Chips (All / Reels / Photos)
              // ════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Container(
                  color: bgColor,
                  child: Column(
                    children: [
                      Divider(color: dividerColor, height: 1),
                      const SizedBox(height: 8),
                      _buildTabChips(context, bgColor, textPrimary, textSecondary),
                      const SizedBox(height: 8),
                      Divider(color: dividerColor, height: 1),
                    ],
                  ),
                ),
              ),

              // Separator
              SliverToBoxAdapter(child: SizedBox(height: 8)),

              // ════════════════════════════════════════════════
              // SECTION 3: Content based on selected tab
              // ════════════════════════════════════════════════
              _buildTabContent(context, profile, bgColor, textPrimary,
                  textSecondary, dividerColor, inputBg, surfaceBg),
            ],
          );
        }),
      ),
    );
  }

  // ─── Cover Photo + Profile Pic ───────────────────────────
  Widget _buildCoverAndAvatar(
      BuildContext context, dynamic profile, Color bgColor) {
    final coverUrl = profile?.cover_pic != null
        ? '${profile!.cover_pic}'.formatedProfileUrl
        : '';
    final profilePicUrl = profile?.profile_pic != null
        ? '${profile!.profile_pic}'.formatedProfileUrl
        : '';
    final hasCover =
        profile?.cover_pic != null && profile!.cover_pic!.isNotEmpty;
    final hasProfilePic =
        profile?.profile_pic != null && profile!.profile_pic!.isNotEmpty;

    return SizedBox(
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover photo with gradient overlay
          GestureDetector(
            onTap: hasCover
                ? () => Get.to(() => SingleImage(imgURL: coverUrl))
                : null,
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: hasCover
                        ? Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              AppAssets.DEFAULT_IMAGE,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(AppAssets.DEFAULT_IMAGE,
                            fit: BoxFit.cover),
                  ),
                  // Gradient overlay at top for status bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top action buttons (back, search, more)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => Get.back(),
                ),
                Row(
                  children: [
                    _circleIconButton(
                      icon: Icons.search,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _circleIconButton(
                      icon: Icons.more_horiz,
                      onTap: () => _showMoreSheet(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Profile pic
          Positioned(
            bottom: 0,
            left: 16,
            child: GestureDetector(
              onTap: hasProfilePic
                  ? () => Get.to(() => SingleImage(imgURL: profilePicUrl))
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: bgColor, width: 4),
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: hasProfilePic
                      ? NetworkImage(profilePicUrl)
                      : const AssetImage(
                              AppAssets.DEFAULT_CIRCLE_PROFILE_IMAGE)
                          as ImageProvider,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 36,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.4),
        ),
        child: Icon(icon, size: size * 0.5, color: Colors.white),
      ),
    );
  }

  // ─── Name Row ────────────────────────────────────────────
  Widget _buildNameRow(
      BuildContext context, dynamic profile, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Flexible(
            child: Text(
              '${profile?.first_name ?? ''} ${profile?.last_name ?? ''}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (profile?.isProfileVerified == true) ...[
            const SizedBox(width: 6),
            const Icon(
              Icons.verified,
              color: Color(0xFF0D7377),
              size: 22,
            ),
          ],
        ],
      ),
    );
  }

  // ─── Stats Row ───────────────────────────────────────────
  Widget _buildStatsRow(
      BuildContext context, dynamic profile, Color textSecondary) {
    final followers = profile?.followersCount ?? 0;
    final following = profile?.followingCount ?? 0;
    final posts = profile?.postsCount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.OTHER_FRIEND_LIST,
                arguments: controller.username),
            child: Text(
              '${_formatCount(followers)} ${'followers'.tr}',
              style: TextStyle(
                fontSize: 15,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(' · ', style: TextStyle(fontSize: 15, color: textSecondary)),
          Text(
            '${_formatCount(following)} ${'following'.tr}',
            style: TextStyle(fontSize: 15, color: textSecondary),
          ),
          Text(' · ', style: TextStyle(fontSize: 15, color: textSecondary)),
          Text(
            '${_formatCount(posts)} ${'posts'.tr}',
            style: TextStyle(fontSize: 15, color: textSecondary),
          ),
        ],
      ),
    );
  }

  // ─── Bio ─────────────────────────────────────────────────
  Widget _buildBio(
      BuildContext context, dynamic profile, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        profile?.user_bio ?? '',
        style: TextStyle(fontSize: 15, color: textPrimary),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // ─── Category / Work Line ────────────────────────────────
  Widget _buildCategoryLine(
      BuildContext context, dynamic profile, Color textSecondary) {
    final parts = <String>[];
    if (profile?.present_town != null && profile!.present_town!.isNotEmpty) {
      parts.add(profile.present_town!);
    }
    if (profile?.userWorkplaces?.isNotEmpty ?? false) {
      final wp = profile!.userWorkplaces!.first;
      if (wp.org_name != null && wp.org_name!.isNotEmpty) {
        parts.add(wp.org_name!);
      }
    }
    if (parts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 16, color: textSecondary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              parts.join(' · '),
              style: TextStyle(fontSize: 14, color: textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Action Buttons ──────────────────────────────────────
  Widget _buildActionButtons(BuildContext context, dynamic profile,
      Color bgColor, Color inputBg, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Friend / Add Friend / Respond button
          Expanded(child: _buildFriendButton(context, inputBg, textPrimary)),
          const SizedBox(width: 6),
          // Message button
          Expanded(
            child: SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Almost Ready!',
                    'Get the messenger app and start amazing conversations with your friends!',
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 16),
                label: Text('Message'.tr,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Follow / Unfollow button
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () async {
                if (controller.isFollowerResult.value) {
                  controller.followUnfollowStatus.value = '0';
                } else {
                  controller.followUnfollowStatus.value = '1';
                }
                await controller.followUnfollowOtherUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: inputBg,
                foregroundColor: textPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                controller.isFollowerResult.value
                    ? 'Following'.tr
                    : 'Follow'.tr,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // More options
          SizedBox(
            width: 36,
            height: 36,
            child: GestureDetector(
              onTap: () => _showMoreSheet(context),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: inputBg,
                ),
                child: Icon(Icons.more_horiz,
                    size: 18, color: textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Friend Button (state-aware) ─────────────────────────
  Widget _buildFriendButton(
      BuildContext context, Color inputBg, Color textPrimary) {
    final status = controller.friendStatus.value;
    final isFriend = status == '1';
    final isPending = status == '0';
    final isIncomingRequest = isPending &&
        controller.connectedUserID.value == controller.currentUserModel.id;

    String label;
    IconData icon;
    Color bg;
    Color fg;
    VoidCallback onTap;

    if (isFriend) {
      label = 'Friends'.tr;
      icon = Icons.people;
      bg = inputBg;
      fg = textPrimary;
      onTap = () => _showFriendOptionsSheet(context);
    } else if (isIncomingRequest) {
      label = 'Respond'.tr;
      icon = Icons.person_add;
      bg = PRIMARY_COLOR;
      fg = Colors.white;
      onTap = () => _showRespondSheet(context);
    } else if (isPending) {
      label = 'Requested'.tr;
      icon = Icons.person_add;
      bg = inputBg;
      fg = textPrimary;
      onTap = () {
        controller.cancelFriendRequest(
            userId: controller.profileModel.value?.id ?? '');
        controller.friendStatus.value = '';
      };
    } else {
      label = 'Add Friend'.tr;
      icon = Icons.person_add;
      bg = PRIMARY_COLOR;
      fg = Colors.white;
      onTap = () {
        controller.sendFriendRequest(
            userId: controller.profileModel.value?.id ?? '');
        controller.friendStatus.value = '0';
      };
    }

    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label,
            style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // ─── Tab Chips (All / Reels / Photos) ────────────────────
  Widget _buildTabChips(BuildContext context, Color bgColor,
      Color textPrimary, Color textSecondary) {
    final tabs = ['All'.tr, 'Reels'.tr, 'Photos'.tr];
    final currentTab = controller.selectedProfileTab.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = currentTab == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                controller.selectedProfileTab.value = index;
                if (index == 0) {
                  controller.otherProfileWidgetViewNumber.value = 0;
                } else if (index == 1) {
                  controller.otherProfileWidgetViewNumber.value = 2;
                  controller.getUserReels(controller.username ?? '');
                } else if (index == 2) {
                  controller.otherProfileWidgetViewNumber.value = 1;
                  controller.getOtherPhotos();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? PRIMARY_COLOR : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(color: FeedDesignTokens.divider(context)),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Tab Content Switcher ────────────────────────────────
  Widget _buildTabContent(
      BuildContext context,
      dynamic profile,
      Color bgColor,
      Color textPrimary,
      Color textSecondary,
      Color dividerColor,
      Color inputBg,
      Color surfaceBg) {
    final selectedTab = controller.selectedProfileTab.value;

    if (selectedTab == 1) {
      // Reels tab
      return SliverToBoxAdapter(
        child: OthersProfileReelsComponent(controller: controller),
      );
    } else if (selectedTab == 2) {
      // Photos tab
      return SliverToBoxAdapter(
        child: OtherPhotosComponent(controller: controller),
      );
    }

    // ALL tab: Details + Work + Highlights + Friends + Posts
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Personal details section
          _buildPersonalDetails(
              context, profile, bgColor, textPrimary, textSecondary, dividerColor),
          const SizedBox(height: 8),

          // Work section
          _buildWorkSection(
              context, profile, bgColor, textPrimary, textSecondary, dividerColor),
          const SizedBox(height: 8),

          // Highlights section (photos)
          _buildHighlights(
              context, bgColor, textPrimary, textSecondary, dividerColor),
          const SizedBox(height: 8),

          // Friends section
          _buildFriendsSection(
              context, bgColor, textPrimary, textSecondary, dividerColor),

          // All posts header
          Container(
            color: bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: dividerColor, height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                  child: Text(
                    'All posts'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                ),
                Divider(color: dividerColor, height: 1),
              ],
            ),
          ),

          // Feed posts
          Container(
            color: bgColor,
            child: OtherFeedComponent(controller: controller),
          ),
        ],
      ),
    );
  }

  // ─── Personal Details Section ────────────────────────────
  Widget _buildPersonalDetails(
      BuildContext context,
      dynamic profile,
      Color bgColor,
      Color textPrimary,
      Color textSecondary,
      Color dividerColor) {
    if (profile == null) return const SizedBox.shrink();

    final details = <_DI>[];

    if (profile.present_town != null && profile.present_town!.isNotEmpty) {
      details.add(_DI(
        icon: Icons.location_on,
        label: '${'Lives in'.tr} ',
        value: profile.present_town!,
      ));
    }

    if (profile.home_town != null && profile.home_town!.isNotEmpty) {
      details.add(_DI(
        icon: Icons.home,
        label: '${'From'.tr} ',
        value: profile.home_town!,
      ));
    }

    if (profile.language != null && profile.language!.isNotEmpty) {
      final langs =
          profile.language!.map((l) => l.language ?? '').join(', ');
      if (langs.isNotEmpty) {
        details.add(_DI(
          icon: Icons.language,
          label: '${'Speaks'.tr} ',
          value: langs,
        ));
      }
    }

    if (profile.relation_status != null &&
        profile.relation_status!.isNotEmpty) {
      details.add(_DI(
        icon: Icons.favorite,
        label: '',
        value: profile.relation_status!,
      ));
    }

    if (details.isEmpty) return const SizedBox.shrink();

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Personal details'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...details.map((d) => _buildDetailRow(
              context, d, textPrimary, textSecondary)),
          // See about info link
          InkWell(
            onTap: () => Get.toNamed(Routes.OTHER_PROFILA_DETAIL),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 22, color: textSecondary),
                  const SizedBox(width: 12),
                  Text(
                    'See ${profile?.first_name ?? ''}\'s about info'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, _DI item,
      Color textPrimary, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(item.icon, size: 22, color: textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: item.label,
                style: TextStyle(fontSize: 15, color: textSecondary),
                children: [
                  TextSpan(
                    text: item.value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Work Section ────────────────────────────────────────
  Widget _buildWorkSection(
      BuildContext context,
      dynamic profile,
      Color bgColor,
      Color textPrimary,
      Color textSecondary,
      Color dividerColor) {
    if (profile == null) return const SizedBox.shrink();

    final workplaces = profile.userWorkplaces ?? [];
    final education = profile.educationWorkplaces ?? [];

    if (workplaces.isEmpty && education.isEmpty) return const SizedBox.shrink();

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (workplaces.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Work'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...workplaces.map<Widget>((wp) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(AppAssets.WORK_ICON,
                        width: 22, height: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wp.org_name ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          if (wp.designation != null &&
                              wp.designation!.isNotEmpty)
                            Text(
                              wp.designation!,
                              style: TextStyle(
                                  fontSize: 13, color: textSecondary),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (education.isNotEmpty) ...[
            if (workplaces.isNotEmpty) const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Education'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...education.map<Widget>((edu) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(AppAssets.SCHOOL_ICON,
                        width: 22, height: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            edu.institute_name ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          if (edu.designation != null &&
                              edu.designation!.isNotEmpty)
                            Text(
                              edu.designation!,
                              style: TextStyle(
                                  fontSize: 13, color: textSecondary),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  // ─── Highlights (Photos) Section ─────────────────────────
  Widget _buildHighlights(BuildContext context, Color bgColor,
      Color textPrimary, Color textSecondary, Color dividerColor) {
    final photos = controller.highlightPhotos.value;
    if (photos.isEmpty) return const SizedBox.shrink();

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Photos'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.selectedProfileTab.value = 2;
                    controller.otherProfileWidgetViewNumber.value = 1;
                    controller.getOtherPhotos();
                  },
                  child: Text(
                    'See all'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                final photoUrl =
                    ('${photo.media}').formatedPostUrl;
                return GestureDetector(
                  onTap: () =>
                      Get.to(() => SingleImage(imgURL: photoUrl)),
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AppAssets.DEFAULT_IMAGE,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Friends Horizontal Section ──────────────────────────
  Widget _buildFriendsSection(BuildContext context, Color bgColor,
      Color textPrimary, Color textSecondary, Color dividerColor) {
    final friends = controller.friendList.value;
    final count = controller.friendCount;
    final isLoadingFriends = controller.isLoadingFriendList.value;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Friends'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    if (count > 0)
                      Text(
                        '${_formatCount(count)} ${'friends'.tr}',
                        style: TextStyle(fontSize: 14, color: textSecondary),
                      ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.OTHER_FRIEND_LIST,
                      arguments: controller.username),
                  child: Text(
                    'See all'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (isLoadingFriends)
            const SizedBox(
              height: 100,
              child: Center(
                  child: CircularProgressIndicator(color: PRIMARY_COLOR)),
            )
          else if (friends.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No friends to show'.tr,
                style: TextStyle(fontSize: 14, color: textSecondary),
              ),
            )
          else
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: friends.length > 10 ? 10 : friends.length,
                itemBuilder: (context, index) {
                  final f = friends[index];
                  final friendProfilePic = f.friend?.profilePic != null
                      ? f.friend!.profilePic!.formatedProfileUrl
                      : '';
                  final hasProfilePic = f.friend?.profilePic != null &&
                      f.friend!.profilePic!.isNotEmpty;
                  final name =
                      '${f.friend?.firstName ?? ''} ${f.friend?.lastName ?? ''}';

                  return GestureDetector(
                    onTap: () => Get.toNamed(Routes.OTHERS_PROFILE,
                        arguments: {
                          'username': f.friend?.username ?? '',
                          'isFromReels': 'false',
                        }),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: hasProfilePic
                                ? NetworkImage(friendProfilePic)
                                : const AssetImage(
                                        AppAssets
                                            .DEFAULT_CIRCLE_PROFILE_IMAGE)
                                    as ImageProvider,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name.trim(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // ─── Bottom Sheets ───────────────────────────────────────

  void _showMoreSheet(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final dividerColor = FeedDesignTokens.divider(context);

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (controller.friendStatus.value == '1')
              _sheetItem(
                icon: Icons.person_remove,
                label: 'Unfriend'.tr,
                color: textPrimary,
                onTap: () async {
                  Get.back();
                  await controller.unfriendFriends(
                      controller.profileModel.value?.id ?? '');
                },
              ),
            if (controller.isFollowerResult.value)
              _sheetItem(
                icon: Icons.person_off,
                label: 'Unfollow'.tr,
                color: textPrimary,
                onTap: () async {
                  Get.back();
                  controller.followUnfollowStatus.value = '0';
                  await controller.followUnfollowOtherUser();
                },
              ),
            if (!controller.isFollowerResult.value)
              _sheetItem(
                icon: Icons.person_add,
                label: 'Follow'.tr,
                color: textPrimary,
                onTap: () async {
                  Get.back();
                  controller.followUnfollowStatus.value = '1';
                  await controller.followUnfollowOtherUser();
                },
              ),
            _sheetItem(
              icon: Icons.block,
              label: 'Block'.tr,
              color: Colors.red,
              onTap: () {
                Get.back();
                _showBlockDialog(context);
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _sheetItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(label, style: TextStyle(fontSize: 16, color: color)),
      onTap: onTap,
      dense: true,
    );
  }

  void _showBlockDialog(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);

    Get.dialog(
      AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Block this person?'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to block this person? They will no longer be able to see your profile or contact you.'
              .tr,
          style: TextStyle(
            fontSize: 15,
            color: FeedDesignTokens.textSecondary(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr,
                style: TextStyle(color: textPrimary, fontSize: 15)),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller
                  .blockFriends(controller.profileModel.value?.id ?? '');
              Get.back();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Block'.tr, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  void _showFriendOptionsSheet(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final dividerColor = FeedDesignTokens.divider(context);

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _sheetItem(
              icon: Icons.person_remove,
              label: 'Unfriend'.tr,
              color: textPrimary,
              onTap: () async {
                Get.back();
                await controller.unfriendFriends(
                    controller.profileModel.value?.id ?? '');
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showRespondSheet(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final dividerColor = FeedDesignTokens.divider(context);

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _sheetItem(
              icon: Icons.check_circle,
              label: 'Confirm Friend'.tr,
              color: PRIMARY_COLOR,
              onTap: () {
                Get.back();
                controller.actionOnFriendRequest(
                    action: 1,
                    requestId: controller.respondToUserID.value);
              },
            ),
            _sheetItem(
              icon: Icons.cancel_outlined,
              label: 'Delete Request'.tr,
              color: Colors.red,
              onTap: () {
                Get.back();
                controller.actionOnFriendRequest(
                    action: 0,
                    requestId: controller.respondToUserID.value);
                controller.unfriendId.value = '';
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// ─── Helper class for detail items ─────────────────────────
class _DI {
  final IconData icon;
  final String label;
  final String value;

  const _DI({
    required this.icon,
    required this.label,
    required this.value,
  });
}
