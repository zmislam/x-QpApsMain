import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../models/post.dart';
import '../../group_feed/controllers/group_feed_controller.dart';
import '../../group_feed/components/feed_post_component.dart';
import '../controllers/discover_groups_controller.dart';
import '../models/all_group_model.dart';
import '../../invite_groups/models/all_invite_group_model.dart';

class GroupsViewTab extends StatefulWidget {
  const GroupsViewTab({Key? key}) : super(key: key);

  @override
  State<GroupsViewTab> createState() => _GroupsViewTabState();
}

class _GroupsViewTabState extends State<GroupsViewTab> {
  final DiscoverGroupsController controller =
      Get.find<DiscoverGroupsController>();

  final List<String> _tabs = [
    'For you',
    'Your groups',
    'Jump back in',
    'Posts',
    'Discover',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            // ─── Horizontal Scrollable Tab Chips ──────────────────
            _buildTabChips(context),
            Divider(
                height: 1,
                color: FeedDesignTokens.divider(context)),
            // ─── Tab Content ──────────────────────────────────────
            Expanded(
              child: Obx(() {
                switch (controller.selectedTabIndex.value) {
                  case 0:
                    return _ForYouTab(controller: controller);
                  case 1:
                    return _YourGroupsTab(controller: controller);
                  case 2:
                    return _JumpBackInTab(controller: controller);
                  case 3:
                    return _PostsTab(controller: controller);
                  case 4:
                    return _DiscoverTab(controller: controller);
                  default:
                    return _ForYouTab(controller: controller);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: const BackButton(),
      title: Text(
        'Groups'.tr,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 22,
          color: FeedDesignTokens.textPrimary(context),
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(Routes.CREATE_GROUP),
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: FeedDesignTokens.inputBg(context),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add,
                size: 22,
                color: FeedDesignTokens.textPrimary(context)),
          ),
        ),
        IconButton(
          onPressed: () => Get.toNamed(Routes.ADVANCE_SEARCH),
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: FeedDesignTokens.inputBg(context),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search,
                size: 22,
                color: FeedDesignTokens.textPrimary(context)),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildTabChips(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Obx(() {
            final currentTab = controller.selectedTabIndex.value;
            return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final selected = currentTab == index;
              return GestureDetector(
                onTap: () {
                  controller.selectedTabIndex.value = index;
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? PRIMARY_COLOR
                        : FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _tabs[index].tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : FeedDesignTokens.textPrimary(context),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TAB 0: FOR YOU — Your groups summary + group feed posts
// ═══════════════════════════════════════════════════════════════════════════════
class _ForYouTab extends StatelessWidget {
  final DiscoverGroupsController controller;
  const _ForYouTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      backgroundColor: Theme.of(context).cardTheme.color,
      onRefresh: () async {
        await controller.refreshAllData();
        try {
          final feedCtrl = Get.find<GroupFeedController>();
          await feedCtrl.getGroupFeedPosts(forceRecallAPI: true);
        } catch (_) {}
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ─── Your Groups Section ──────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              final groups = controller.joinedGroupList.value;
              final isLoading = controller.isLoadingJoinedGroups.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your groups'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: FeedDesignTokens.textPrimary(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.selectedTabIndex.value = 1;
                          },
                          child: Text(
                            'See All'.tr,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading && groups.isEmpty)
                    ...List.generate(
                        3, (_) => _buildGroupShimmer(context))
                  else
                    ...groups.take(5).map(
                        (g) => _buildGroupItem(context, g)),
                  Divider(
                    color: FeedDesignTokens.divider(context),
                    thickness: 8,
                  ),
                ],
              );
            }),
          ),

          // ─── Invitations Section (if any) ─────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              final invites = controller.invitedGroupList.value;
              if (invites.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Text(
                      'Group invitations'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: FeedDesignTokens.textPrimary(context),
                      ),
                    ),
                  ),
                  ...invites.take(3).map(
                      (inv) => _buildInviteItem(context, inv)),
                  Divider(
                    color: FeedDesignTokens.divider(context),
                    thickness: 8,
                  ),
                ],
              );
            }),
          ),

          // ─── From Your Groups — Feed Posts ────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'From your groups'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: FeedDesignTokens.textPrimary(context),
                ),
              ),
            ),
          ),

          // Embed the group feed posts
          _buildFeedPosts(context),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildFeedPosts(BuildContext context) {
    try {
      final feedCtrl = Get.find<GroupFeedController>();
      return GroupFeedPostComponent(controller: feedCtrl);
    } catch (_) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(Icons.group_outlined,
                    size: 48,
                    color: FeedDesignTokens.textSecondary(context)),
                const SizedBox(height: 12),
                Text(
                  'Join groups to see posts here'.tr,
                  style: TextStyle(
                    fontSize: 15,
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

  Widget _buildGroupItem(BuildContext context, AllGroupModel group) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.GROUP_PROFILE, arguments: {
        'id': group.id,
        'group_type': 'joinedGroup',
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl:
                    (group.groupCoverPic ?? '').formatedGroupProfileUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 56,
                  height: 56,
                  color: FeedDesignTokens.inputBg(context),
                  child: Icon(Icons.groups,
                      color: FeedDesignTokens.textSecondary(context)),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 56,
                  height: 56,
                  color: FeedDesignTokens.inputBg(context),
                  child: const Image(
                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName?.capitalizeFirst ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: 8, color: PRIMARY_COLOR),
                      const SizedBox(width: 4),
                      Text(
                        '${group.joinedGroupsCount} ${'members'.tr}',
                        style: TextStyle(
                          fontSize: 13,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteItem(
      BuildContext context, InviteGroupsModel invite) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: (invite.group?.groupCoverPic ?? '')
                  .formatedGroupProfileUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 56,
                height: 56,
                color: FeedDesignTokens.inputBg(context),
                child: const Image(
                  image: AssetImage(AppAssets.DEFAULT_IMAGE),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invite.group?.groupName?.capitalizeFirst ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${invite.user?.firstName ?? ''} ${invite.user?.lastName ?? ''} invited you',
                  style: TextStyle(
                    fontSize: 13,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.acceptDeclineInvitation(
                              id: invite.id ?? '',
                              accept: true,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text('Accept'.tr,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 32,
                        child: OutlinedButton(
                          onPressed: () {
                            controller.acceptDeclineInvitation(
                              id: invite.id ?? '',
                              accept: false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                FeedDesignTokens.textPrimary(context),
                            side: BorderSide(
                                color: FeedDesignTokens.divider(context)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text('Decline'.tr,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
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

  Widget _buildGroupShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: FeedDesignTokens.inputBg(context),
              borderRadius: BorderRadius.circular(12),
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
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TAB 1: YOUR GROUPS — Searchable sorted list of joined groups
// ═══════════════════════════════════════════════════════════════════════════════
class _YourGroupsTab extends StatefulWidget {
  final DiscoverGroupsController controller;
  const _YourGroupsTab({required this.controller});

  @override
  State<_YourGroupsTab> createState() => _YourGroupsTabState();
}

class _YourGroupsTabState extends State<_YourGroupsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      backgroundColor: Theme.of(context).cardTheme.color,
      onRefresh: () async {
        await widget.controller.getAllJoinedGroups(forceFetch: true);
      },
      child: Obx(() {
        final isLoading = widget.controller.isLoadingJoinedGroups.value;
        final allGroups = widget.controller.joinedGroupList.value;
        final filteredGroups = _searchQuery.isEmpty
            ? allGroups
            : allGroups
                .where((g) =>
                    (g.groupName ?? '')
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                .toList();

        return CustomScrollView(
          controller: widget.controller.joinedGroupScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header: Most visited + Sort
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Most visited'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: FeedDesignTokens.textPrimary(context),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Sort alphabetically toggle
                        widget.controller.joinedGroupList.value.sort(
                          (a, b) => (a.groupName ?? '')
                              .compareTo(b.groupName ?? ''),
                        );
                        widget.controller.joinedGroupList.refresh();
                      },
                      child: Text(
                        'Sort'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search group name'.tr,
                      hintStyle: TextStyle(
                        color: FeedDesignTokens.textSecondary(context),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search,
                          color: FeedDesignTokens.textSecondary(context)),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: TextStyle(
                      color: FeedDesignTokens.textPrimary(context),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Group list
            if (isLoading && allGroups.isEmpty)
              SliverToBoxAdapter(
                child: Column(
                  children: List.generate(
                    8,
                    (_) => _buildGroupShimmerItem(context),
                  ),
                ),
              )
            else if (filteredGroups.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      children: [
                        Icon(Icons.group_outlined,
                            size: 48,
                            color: FeedDesignTokens.textSecondary(context)),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No groups joined yet'.tr
                              : 'No groups found'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final group = filteredGroups[index];
                    return _buildYourGroupItem(context, group);
                  },
                  childCount: filteredGroups.length,
                ),
              ),

            // Loading more indicator
            if (isLoading && allGroups.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(color: PRIMARY_COLOR),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        );
      }),
    );
  }

  Widget _buildYourGroupItem(BuildContext context, AllGroupModel group) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.GROUP_PROFILE, arguments: {
        'id': group.id,
        'group_type': 'joinedGroup',
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl:
                    (group.groupCoverPic ?? '').formatedGroupProfileUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 56,
                  height: 56,
                  color: FeedDesignTokens.inputBg(context),
                  child: Icon(Icons.groups,
                      color: FeedDesignTokens.textSecondary(context)),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 56,
                  height: 56,
                  color: FeedDesignTokens.inputBg(context),
                  child: const Image(
                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName?.capitalizeFirst ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: 8, color: PRIMARY_COLOR),
                      const SizedBox(width: 4),
                      Text(
                        '${group.joinedGroupsCount} ${'members'.tr}',
                        style: TextStyle(
                          fontSize: 13,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupShimmerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: FeedDesignTokens.inputBg(context),
              borderRadius: BorderRadius.circular(12),
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
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TAB 2: JUMP BACK IN — Compact post card grid
// ═══════════════════════════════════════════════════════════════════════════════
class _JumpBackInTab extends StatefulWidget {
  final DiscoverGroupsController controller;
  const _JumpBackInTab({required this.controller});

  @override
  State<_JumpBackInTab> createState() => _JumpBackInTabState();
}

class _JumpBackInTabState extends State<_JumpBackInTab> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Tagged', 'Commented', 'Authored'];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      backgroundColor: Theme.of(context).cardTheme.color,
      onRefresh: () async {
        try {
          final feedCtrl = Get.find<GroupFeedController>();
          await feedCtrl.getGroupFeedPosts(forceRecallAPI: true);
        } catch (_) {}
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ─── Sub-filter chips ──────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final selected = _selectedFilter == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? PRIMARY_COLOR
                            : FeedDesignTokens.inputBg(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          _filters[index].tr,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : FeedDesignTokens.textPrimary(context),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ─── Post cards in a masonry-like grid ─────────────────
          _buildPostGrid(context),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildPostGrid(BuildContext context) {
    try {
      final feedCtrl = Get.find<GroupFeedController>();
      return Obx(() {
        final posts = feedCtrl.postList.value;
        if (feedCtrl.isLoadingNewsFeed.value && posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: CircularProgressIndicator(color: PRIMARY_COLOR),
              ),
            ),
          );
        }
        if (posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    Icon(Icons.history,
                        size: 48,
                        color: FeedDesignTokens.textSecondary(context)),
                    const SizedBox(height: 12),
                    Text(
                      'No recent group activity'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final post = posts[index];
                return _buildJumpBackCard(context, post);
              },
              childCount: posts.length > 20 ? 20 : posts.length,
            ),
          ),
        );
      });
    } catch (_) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Text(
              'Loading...'.tr,
              style: TextStyle(
                color: FeedDesignTokens.textSecondary(context),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildJumpBackCard(BuildContext context, PostModel post) {
    final groupName = post.groupId.groupName ?? '';
    final groupCover =
        (post.groupId.groupCoverPic ?? '').toString();
    final caption = post.description ?? '';
    final mediaList = post.media ?? [];
    final thumbnailUrl = mediaList.isNotEmpty
        ? (mediaList.first.media ?? '').formatedProfileUrl
        : '';
    final likeCount = post.reactionCount ?? 0;
    final commentCount = post.totalComments ?? 0;

    return GestureDetector(
      onTap: () {
        if (post.groupId.id != null && post.groupId.id!.isNotEmpty) {
          Get.toNamed(Routes.GROUP_PROFILE, arguments: {
            'id': post.groupId.id,
            'group_type': 'joinedGroup',
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: FeedDesignTokens.cardBg(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FeedDesignTokens.divider(context),
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: groupCover.formatedGroupProfileUrl,
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 28,
                        height: 28,
                        color: FeedDesignTokens.inputBg(context),
                        child: Icon(Icons.groups,
                            size: 16,
                            color:
                                FeedDesignTokens.textSecondary(context)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      groupName.toString().capitalizeFirst ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: FeedDesignTokens.textPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Post content preview
            if (caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  caption,
                  style: TextStyle(
                    fontSize: 13,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Thumbnail
            if (thumbnailUrl.isNotEmpty) ...[
              const SizedBox(height: 6),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: FeedDesignTokens.inputBg(context),
                  ),
                ),
              ),
            ] else
              const Spacer(),

            // Reactions row
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  if (likeCount > 0) ...[
                    Icon(Icons.thumb_up,
                        size: 14, color: PRIMARY_COLOR),
                    const SizedBox(width: 4),
                    Text('$likeCount',
                        style: TextStyle(
                          fontSize: 12,
                          color: FeedDesignTokens.textSecondary(context),
                        )),
                  ],
                  const Spacer(),
                  if (commentCount > 0) ...[
                    Icon(Icons.chat_bubble_outline,
                        size: 14,
                        color: FeedDesignTokens.textSecondary(context)),
                    const SizedBox(width: 4),
                    Text('$commentCount',
                        style: TextStyle(
                          fontSize: 12,
                          color: FeedDesignTokens.textSecondary(context),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TAB 3: POSTS — Full group feed
// ═══════════════════════════════════════════════════════════════════════════════
class _PostsTab extends StatelessWidget {
  final DiscoverGroupsController controller;
  const _PostsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    try {
      final feedCtrl = Get.find<GroupFeedController>();
      return RefreshIndicator(
        color: PRIMARY_COLOR,
        backgroundColor: Theme.of(context).cardTheme.color,
        onRefresh: () async {
          await feedCtrl.getGroupFeedPosts(forceRecallAPI: true);
        },
        child: CustomScrollView(
          controller: feedCtrl.postScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            GroupFeedPostComponent(controller: feedCtrl),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      );
    } catch (_) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined,
                size: 48,
                color: FeedDesignTokens.textSecondary(context)),
            const SizedBox(height: 12),
            Text(
              'Join groups to see posts'.tr,
              style: TextStyle(
                fontSize: 16,
                color: FeedDesignTokens.textSecondary(context),
              ),
            ),
          ],
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TAB 4: DISCOVER — 2-column grid of suggested groups
// ═══════════════════════════════════════════════════════════════════════════════
class _DiscoverTab extends StatelessWidget {
  final DiscoverGroupsController controller;
  const _DiscoverTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      backgroundColor: Theme.of(context).cardTheme.color,
      onRefresh: () async {
        controller.allGroupList.value.clear();
        controller.skip = 0;
        await controller.getAllGroups();
      },
      child: CustomScrollView(
        controller: controller.groupScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Suggested for you'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: FeedDesignTokens.textPrimary(context),
                ),
              ),
            ),
          ),

          Obx(() {
            final groups = controller.allGroupList.value;
            final isLoading = controller.isLoadingUserGroups.value;

            if (isLoading && groups.isEmpty) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildDiscoverShimmer(context),
                    childCount: 6,
                  ),
                ),
              );
            }

            if (groups.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        Icon(Icons.explore_outlined,
                            size: 48,
                            color:
                                FeedDesignTokens.textSecondary(context)),
                        const SizedBox(height: 12),
                        Text(
                          'No groups to discover'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final group = groups[index];
                    return _buildDiscoverCard(context, group);
                  },
                  childCount: groups.length,
                ),
              ),
            );
          }),

          // Loading more
          Obx(() {
            if (controller.isLoadingUserGroups.value &&
                controller.allGroupList.value.isNotEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: PRIMARY_COLOR),
                  ),
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildDiscoverCard(
      BuildContext context, AllGroupModel group) {
    return Container(
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FeedDesignTokens.divider(context),
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image + dismiss
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: (group.groupCoverPic ?? '')
                    .formatedGroupProfileUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 110,
                  color: FeedDesignTokens.inputBg(context),
                  child: Center(
                    child: Icon(Icons.groups,
                        size: 40,
                        color:
                            FeedDesignTokens.textSecondary(context)),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () =>
                      controller.dismissDiscoverGroup(group.id ?? ''),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          // Group info
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Text(
              group.groupName?.capitalizeFirst ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: FeedDesignTokens.textPrimary(context),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            child: Text(
              '${group.groupPrivacy?.capitalizeFirst ?? 'Public'} group · ${group.joinedGroupsCount} ${'members'.tr}',
              style: TextStyle(
                fontSize: 12,
                color: FeedDesignTokens.textSecondary(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Spacer(),

          // Join button
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  controller.joinGroupRequestPost(
                    groupId: group.id,
                    type: 'join',
                    userIdArray:
                        controller.loginCredential.getUserData().id,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Join'.tr,
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
    );
  }

  Widget _buildDiscoverShimmer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            color: FeedDesignTokens.inputBg(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Container(
              height: 14,
              width: 100,
              decoration: BoxDecoration(
                color: FeedDesignTokens.inputBg(context),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
            child: Container(
              height: 12,
              width: 80,
              decoration: BoxDecoration(
                color: FeedDesignTokens.inputBg(context),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: FeedDesignTokens.inputBg(context),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
