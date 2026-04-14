import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../routes/app_pages.dart';
import '../controllers/pages_controller.dart';
import '../model/invitation_model.dart';
import '../model/mypage_model.dart';
import '../../../../../../modules/earnDashboard/services/earning_config_service.dart';
import '../../../../../../modules/pageMonetization/widgets/page_tier_badge.dart';

class MyPagesView extends GetView<PagesController> {
  const MyPagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const BackButton(),
          title: Text(
            'My Pages'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: FeedDesignTokens.textPrimary(context),
            ),
          ),
          centerTitle: false,
        ),
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).cardTheme.color,
          color: PRIMARY_COLOR,
          onRefresh: () async {
            await controller.getMyPages(forceFetch: true);
          },
          child: Obx(() {
            final isLoading = controller.isLoadingMyPages.value;
            final myPages = controller.myPagesList.value;

            if (isLoading && myPages.isEmpty) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  ...List.generate(6, (_) => _buildShimmerItem(context)),
                ],
              );
            }

            if (myPages.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.flag_outlined,
                            size: 48,
                            color: FeedDesignTokens.textSecondary(context)),
                        const SizedBox(height: 12),
                        Text(
                          'You have no pages yet'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              controller: controller.myPageScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: myPages.length,
              itemBuilder: (context, index) {
                return _buildMyPageItem(context, myPages[index]);
              },
            );
          }),
        ),
      ),
    );
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          page.pageName ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: FeedDesignTokens.textPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Page Tier Badge (Phase 7)
                      Builder(builder: (_) {
                        try {
                          final cfg = Get.find<EarningConfigService>();
                          if (cfg.pageMonetizationEnabled) {
                            final tiers = cfg.pageTiers;
                            if (tiers.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: PageTierBadge(
                                  tierName: tiers.first.label,
                                  multiplier: tiers.first.multiplier,
                                  size: 'small',
                                ),
                              );
                            }
                          }
                        } catch (_) {}
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${page.followerCount ?? 0} ${'followers'.tr}',
                    style: TextStyle(
                      fontSize: 13,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
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

  // ─── Shimmer Item ────────────────────────────────────────
  Widget _buildShimmerItem(BuildContext context) {
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
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.textSecondary(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
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
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.sendFriendInvitation(page.id ?? '');
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
