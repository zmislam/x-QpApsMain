import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../tab_view/controllers/tab_view_controller.dart';
import '../controllers/pages_controller.dart';
import '../model/invitation_model.dart';
import '../model/mypage_model.dart';
import 'create_page_view.dart';
import 'discover_pages_view.dart';
import 'followed_page_view.dart';
import 'invites_page_view.dart';

class PagesViewTab extends GetView<PagesController> {
  final bool? isFromTab;

  const PagesViewTab({super.key, this.isFromTab});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: FeedDesignTokens.textPrimary(context)),
            onPressed: () {
              if (isFromTab == true) {
                final tabController = Get.find<TabViewController>();
                tabController.tabIndex.value = 0;
                if (tabController.tabControllerInitComplete.value) {
                  tabController.tabController.animateTo(0);
                }
              } else {
                Get.back();
              }
            },
          ),
          title: Text(
            'Pages'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: FeedDesignTokens.textPrimary(context),
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.search,
                  color: FeedDesignTokens.textPrimary(context), size: 24),
              onPressed: () => Get.toNamed(Routes.ADVANCE_SEARCH),
            ),
          ],
        ),
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).cardTheme.color,
          color: PRIMARY_COLOR,
          onRefresh: () => controller.refreshAllPages(),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 12),
              _buildFilterChips(context),
              const SizedBox(height: 20),
              _buildMyPagesSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Filter Chips ────────────────────────────────────────
  Widget _buildFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Create chip
          if (!controller.loginCredential.getProfileSwitch())
            _PagesFilterChip(
              label: 'Create'.tr,
              icon: Icons.add,
              onTap: () => Get.to(() => const CreatePageView()),
            ),
          if (!controller.loginCredential.getProfileSwitch())
            const SizedBox(width: 8),
          // Discover chip
          _PagesFilterChip(
            label: 'Discover'.tr,
            onTap: () {
              controller.getAllPages(initial: true);
              Get.to(() => const DiscoverPagesView());
            },
          ),
          const SizedBox(width: 8),
          // Invitations chip (only for normal profile)
          if (!controller.loginCredential.getProfileSwitch())
            _PagesFilterChip(
              label: 'Invitations'.tr,
              onTap: () {
                controller.getInvites();
                Get.to(() => const InvitesPageView());
              },
            ),
          if (!controller.loginCredential.getProfileSwitch())
            const SizedBox(width: 8),
          // Followed Pages chip
          _PagesFilterChip(
            label: 'Followed Pages'.tr,
            onTap: () {
              controller.getFollowedPages(forceFetch: true);
              Get.to(() => const FollowedPageView());
            },
          ),
        ],
      ),
    );
  }

  // ─── My Pages Section ───────────────────────────────────
  Widget _buildMyPagesSection(BuildContext context) {
    if (controller.loginCredential.getProfileSwitch()) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final isLoading = controller.isLoadingMyPages.value;
      final myPages = controller.myPagesList.value;

      if (isLoading && myPages.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pages you manage'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: FeedDesignTokens.textPrimary(context),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(3, (_) => _buildShimmerPageItem(context)),
          ],
        );
      }

      if (myPages.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pages you manage'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: FeedDesignTokens.textPrimary(context),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Icon(Icons.flag_outlined,
                      size: 48,
                      color: FeedDesignTokens.textSecondary(context)),
                  const SizedBox(height: 12),
                  Text(
                    'No pages yet'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.to(() => const CreatePageView()),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text('Create a Page'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pages you manage'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: FeedDesignTokens.textPrimary(context),
            ),
          ),
          const SizedBox(height: 12),
          ...myPages.map((page) => _buildMyPageItem(context, page)),
        ],
      );
    });
  }

  // ─── Single My Page Item ─────────────────────────────────
  Widget _buildMyPageItem(BuildContext context, MyPagesModel page) {
    return InkWell(
      onTap: () =>
          Get.toNamed(Routes.ADMIN_PAGE, arguments: page.pageUserName),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Page profile pic
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: (page.profilePic ?? '').formatedProfileUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 56,
                  height: 56,
                  color: FeedDesignTokens.inputBg(context),
                  child: Icon(Icons.flag,
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
            // Page info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.pageName ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    (page.category ?? []).join(', '),
                    style: TextStyle(
                      fontSize: 13,
                      color: FeedDesignTokens.textSecondary(context),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'view') {
                  Get.toNamed(Routes.ADMIN_PAGE,
                      arguments: page.pageUserName);
                } else if (value == 'invite') {
                  controller.getPagesInvites(page.id ?? '');
                  _showInviteBottomSheet(context, page);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility_outlined,
                          size: 20,
                          color: FeedDesignTokens.textPrimary(context)),
                      const SizedBox(width: 12),
                      Text('View Page'.tr),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'invite',
                  child: Row(
                    children: [
                      Icon(Icons.person_add_outlined,
                          size: 20,
                          color: FeedDesignTokens.textPrimary(context)),
                      const SizedBox(width: 12),
                      Text('Invite Connections'.tr),
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

  // ─── Shimmer Loading Page Item ───────────────────────────
  Widget _buildShimmerPageItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  width: 120,
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

  // ─── Invite Bottom Sheet ─────────────────────────────────
  void _showInviteBottomSheet(BuildContext context, MyPagesModel page) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.textSecondary(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invite friends to this Page'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: FeedDesignTokens.textPrimary(context),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close,
                            color: FeedDesignTokens.textSecondary(context)),
                      ),
                    ],
                  ),
                ),
                Divider(color: FeedDesignTokens.divider(context)),
                // Select all
                Obx(() => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select All'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: FeedDesignTokens.textPrimary(context),
                            ),
                          ),
                          Checkbox(
                            activeColor: PRIMARY_COLOR,
                            value: controller
                                    .selectedPageInvitationList
                                    .value
                                    .length ==
                                controller.pageInvitationList.value.length &&
                                controller
                                    .pageInvitationList.value.isNotEmpty,
                            onChanged: (bool? value) {
                              if (value != null) {
                                if (value) {
                                  controller
                                          .selectedPageInvitationList.value =
                                      controller.pageInvitationList.value
                                          .toList();
                                } else {
                                  controller
                                      .selectedPageInvitationList.value
                                      .clear();
                                }
                                controller.selectedPageInvitationList
                                    .refresh();
                              }
                            },
                          ),
                        ],
                      ),
                    )),
                // Friend list
                Expanded(
                  child: Obx(() {
                    if (controller.pageInvitationList.value.isEmpty) {
                      return Center(
                        child: Text(
                          'No friends to invite'.tr,
                          style: TextStyle(
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: controller.pageInvitationList.value.length,
                      itemBuilder: (context, index) {
                        final PageInvitationModel friend =
                            controller.pageInvitationList.value[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              (friend.profilePic ?? '').formatedProfileUrl,
                            ),
                          ),
                          title: Text(
                            friend.fullName ?? '',
                            style: TextStyle(
                              color: FeedDesignTokens.textPrimary(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Obx(() => Checkbox(
                                activeColor: PRIMARY_COLOR,
                                value: controller
                                    .selectedPageInvitationList.value
                                    .contains(friend),
                                onChanged: (bool? changed) {
                                  if (changed != null) {
                                    if (changed) {
                                      controller.selectedPageInvitationList
                                          .value
                                          .add(friend);
                                    } else {
                                      controller.selectedPageInvitationList
                                          .value
                                          .remove(friend);
                                    }
                                    controller.selectedPageInvitationList
                                        .refresh();
                                  }
                                },
                              )),
                        );
                      },
                    );
                  }),
                ),
                // Send button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          controller
                              .sendFriendInvitation(page.id ?? '');
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Send'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ─── Filter Chip Widget ────────────────────────────────────
class _PagesFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _PagesFilterChip({
    required this.label,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FeedDesignTokens.inputBg(context),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: FeedDesignTokens.textPrimary(context)),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FeedDesignTokens.textPrimary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
