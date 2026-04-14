import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../utils/url_utils.dart';
import '../../../all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../component/page_feed_component.dart';
import '../component/page_photos_component.dart';
import '../component/page_reels_all_components/page_main_reels_component.dart';
import '../component/page_more_component.dart';
import '../controllers/page_profile_controller.dart';
import '../../../../../../pageMonetization/widgets/page_tier_badge.dart';
import '../../../../../../earnDashboard/services/earning_config_service.dart';

/// Facebook-style Page Profile View (Visitor/Follower)
class PageProfileView extends StatefulWidget {
  const PageProfileView({super.key});

  @override
  State<PageProfileView> createState() => _PageProfileViewState();
}

class _PageProfileViewState extends State<PageProfileView>
    with SingleTickerProviderStateMixin {
  late final PageProfileController controller;

  // Tab labels matching Facebook Pages
  static const List<String> _tabLabels = [
    'All',
    'Photos',
    'Reels',
    'Events',
    'Mentions',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(PageProfileController());

    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      controller.pageUserName = Get.arguments['pageUserName'] ?? '';
      controller.isFromPageReels = Get.arguments['isFromPageReels'] ?? 'false';
    } else if (Get.arguments != null) {
      controller.pageUserName = Get.arguments as String;
      controller.isFromPageReels = 'false';
    } else {
      controller.pageUserName = '';
      controller.isFromPageReels = 'false';
    }

    controller.userModel = controller.loginCredential.getUserData();
    controller.getWidgetNumber(pageUserName: controller.pageUserName ?? '');
    controller.initiateAllAPiCall();

    controller.tabController = TabController(
      length: _tabLabels.length,
      vsync: this,
    );
    controller.tabController.addListener(() {
      if (!controller.tabController.indexIsChanging) {
        controller.viewNumber.value = controller.tabController.index;
      }
    });
  }

  @override
  void dispose() {
    controller.tabController.dispose();
    super.dispose();
  }

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
    final brand = FeedDesignTokens.brand(context);

    return Scaffold(
      backgroundColor: surfaceBg,
      body: RefreshIndicator(
        backgroundColor: bgColor,
        color: brand,
        onRefresh: () async {
          controller.postList.value.clear();
          controller.pinnedPostList.value.clear();
          controller.pageNo = 1;
          await controller.initiateAllAPiCall(force: true);
        },
        child: Obx(() {
          final pageDetails = controller.pageProfileModel.value?.pageDetails;

          return CustomScrollView(
            controller: controller.postScrollController,
            slivers: [
              // ═══════════════════════════════════════════════════
              // SECTION 1: Cover + Profile Pic + Name + Stats
              // ═══════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Container(
                  color: bgColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCoverAndAvatar(context, pageDetails, bgColor),
                      const SizedBox(height: 8),
                      _buildNameAndStats(
                          context, pageDetails, textPrimary, textSecondary),
                      const SizedBox(height: 8),
                      if (pageDetails?.bio != null &&
                          pageDetails!.bio!.isNotEmpty)
                        _buildBio(context, pageDetails, textPrimary,
                            textSecondary),
                      if (pageDetails?.category.isNotEmpty == true)
                        _buildCategoryBadge(
                            context, pageDetails!, textSecondary),
                      if ((pageDetails?.followerCount ?? 0) > 0)
                        _buildFollowedByRow(
                            context, pageDetails!, textSecondary),
                      const SizedBox(height: 12),
                      _buildActionButtons(
                          context, brand, bgColor, inputBg, textPrimary),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════
              // SECTION 2: Tab Chips (All / Photos / Reels / Events / Mentions)
              // ═══════════════════════════════════════════════════
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  child: Container(
                    color: bgColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _tabLabels.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return Obx(() {
                                final isSelected =
                                    controller.viewNumber.value == index;
                                return GestureDetector(
                                  onTap: () {
                                    controller.viewNumber.value = index;
                                    controller.tabController.animateTo(index);
                                  },
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
                                          : Border.all(
                                              color: dividerColor, width: 1),
                                    ),
                                    child: Text(
                                      _tabLabels[index].tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : textSecondary,
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                        Divider(color: dividerColor, height: 1),
                      ],
                    ),
                  ),
                ),
              ),

              // Separator
              SliverToBoxAdapter(
                  child: SizedBox(
                      height: FeedDesignTokens.separatorHeight,
                      child: ColoredBox(color: surfaceBg))),

              // ═══════════════════════════════════════════════════
              // SECTION 3: Tab Content
              // ═══════════════════════════════════════════════════
              ..._buildTabContent(
                context,
                pageDetails,
                bgColor,
                textPrimary,
                textSecondary,
                dividerColor,
                inputBg,
                surfaceBg,
                brand,
              ),
            ],
          );
        }),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // COVER PHOTO + PROFILE PIC (Facebook-style)
  // ═════════════════════════════════════════════════════════
  Widget _buildCoverAndAvatar(
      BuildContext context, dynamic pageDetails, Color bgColor) {
    final coverUrl = pageDetails?.coverPic != null
        ? '${pageDetails!.coverPic}'.formatedProfileUrl
        : '';
    final profilePicUrl = pageDetails?.profilePic != null
        ? '${pageDetails!.profilePic}'.formatedProfileUrl
        : '';
    final hasCover =
        pageDetails?.coverPic != null && pageDetails!.coverPic!.isNotEmpty;
    final hasProfilePic = pageDetails?.profilePic != null &&
        pageDetails!.profilePic!.isNotEmpty;

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
                  // Gradient at top for status bar
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

          // Top action buttons (back, more, search)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleIconButton(
                    icon: Icons.arrow_back, onTap: () => Get.back()),
                Row(
                  children: [
                    _circleIconButton(icon: Icons.search, onTap: () {}),
                    const SizedBox(width: 8),
                    _circleIconButton(
                        icon: Icons.more_horiz,
                        onTap: () {}),
                  ],
                ),
              ],
            ),
          ),

          // Profile pic overlapping cover
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

  // ═════════════════════════════════════════════════════════
  // PAGE NAME + STATS ROW
  // ═════════════════════════════════════════════════════════
  Widget _buildNameAndStats(BuildContext context, dynamic pageDetails,
      Color textPrimary, Color textSecondary) {
    final pageName = pageDetails?.pageName ?? '';
    final followers = pageDetails?.followerCount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  pageName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
              // Page Tier Badge (Phase 7)
              Builder(builder: (_) {
                try {
                  final configService = Get.find<EarningConfigService>();
                  if (configService.pageMonetizationEnabled) {
                    final tiers = configService.pageTiers;
                    if (tiers.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: PageTierBadge(
                          tierName: tiers.first.label,
                          size: PageTierBadgeSize.small,
                        ),
                      );
                    }
                  }
                } catch (_) {}
                return const SizedBox.shrink();
              }),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatCount(followers)} ${"followers".tr}',
            style: TextStyle(fontSize: 15, color: textSecondary),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // BIO
  // ═════════════════════════════════════════════════════════
  Widget _buildBio(BuildContext context, dynamic pageDetails,
      Color textPrimary, Color textSecondary) {
    final bio = pageDetails?.bio ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bio,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: textPrimary),
          ),
          if (bio.length > 100)
            GestureDetector(
              onTap: () => _showFullBioSheet(context, bio, textPrimary),
              child: Text(
                'See more'.tr,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textSecondary),
              ),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _showFullBioSheet(
      BuildContext context, String bio, Color textPrimary) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: FeedDesignTokens.cardBg(context),
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About'.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary)),
            const SizedBox(height: 12),
            Text(bio,
                style: TextStyle(fontSize: 15, color: textPrimary)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // CATEGORY BADGE
  // ═════════════════════════════════════════════════════════
  Widget _buildCategoryBadge(
      BuildContext context, dynamic pageDetails, Color textSecondary) {
    final category =
        (pageDetails?.category as List<String>?)?.join(', ') ?? '';
    if (category.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.folder_outlined, size: 16, color: textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              category,
              style: TextStyle(fontSize: 14, color: textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // FOLLOWED BY ROW
  // ═════════════════════════════════════════════════════════
  Widget _buildFollowedByRow(
      BuildContext context, dynamic pageDetails, Color textSecondary) {
    final followers = pageDetails?.followerCount ?? 0;
    if (followers == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 24,
            child: Stack(
              children: List.generate(
                3,
                (i) => Positioned(
                  left: i * 14.0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                      border: Border.all(
                          color: FeedDesignTokens.cardBg(context), width: 1.5),
                    ),
                    child:
                        const Icon(Icons.person, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${'Followed by'.tr} ${_formatCount(followers)} ${'people'.tr}',
              style: TextStyle(fontSize: 13, color: textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // ACTION BUTTONS (Follow + Message) — compact, matches user profile
  // ═════════════════════════════════════════════════════════
  Widget _buildActionButtons(BuildContext context, Color brand, Color bgColor,
      Color inputBg, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Follow / Unfollow (teal filled)
          Expanded(
            child: Obx(() {
              final isFollowing = controller.isFollowing.value;
              return SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final pageId =
                        controller.pageProfileModel.value?.pageDetails?.id ??
                            '';
                    if (isFollowing) {
                      controller.unfollow(pageId);
                      controller.isFollowing.value = false;
                    } else {
                      controller.followPage(pageId);
                      controller.isFollowing.value = true;
                    }
                  },
                  icon: Icon(isFollowing ? Icons.check : Icons.add, size: 16),
                  label: Text(
                    isFollowing ? 'Following'.tr : 'Follow'.tr,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFollowing ? inputBg : PRIMARY_COLOR,
                    foregroundColor:
                        isFollowing ? textPrimary : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 6),
          // Message (teal filled)
          Expanded(
            child: SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, size: 16),
                label: Text(
                  'Message'.tr,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
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
          // More (...) circle button
          GestureDetector(
            onTap: () => _showMoreSheet(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: inputBg,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.more_horiz, size: 18, color: textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // MORE SHEET
  // ═════════════════════════════════════════════════════════
  void _showMoreSheet(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final dividerColor = FeedDesignTokens.divider(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.info_outline, color: textPrimary),
              title: Text('More'.tr, style: TextStyle(color: textPrimary)),
              onTap: () {
                Get.back();
                Get.bottomSheet(PageMoreComponent(
                  controller: controller,
                  onClose: () => Get.back(),
                ));
              },
            ),
            Divider(color: dividerColor, height: 1),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.red),
              title:
                  Text('Report'.tr, style: const TextStyle(color: Colors.red)),
              onTap: () async {
                Get.back();
                await controller.homeController.getReports();
                if (!context.mounted) return;
                CustomReportBottomSheet.showReportOptions(
                  context: context,
                  pageReportList:
                      controller.homeController.pageReportList.value,
                  selectedReportType:
                      controller.homeController.selectedReportType,
                  selectedReportId:
                      controller.homeController.selectedReportId,
                  reportDescription:
                      controller.homeController.reportDescription,
                  onCancel: () => Get.back(),
                  reportAction: (String reportTypeId, String reportType,
                      String pageId, String description) {
                    controller.reportAPost(
                      report_type:
                          controller.homeController.selectedReportType.value,
                      description:
                          controller.homeController.reportDescription.text,
                      page_id:
                          controller.pageProfileModel.value?.pageDetails?.id ??
                              '',
                      report_type_id:
                          controller.homeController.selectedReportId.value,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // TAB CONTENT
  // ═════════════════════════════════════════════════════════
  List<Widget> _buildTabContent(
    BuildContext context,
    dynamic pageDetails,
    Color bgColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
    Color inputBg,
    Color surfaceBg,
    Color brand,
  ) {
    switch (controller.viewNumber.value) {
      case 0: // All — Details + Feed
        return [
          _buildAllTabDetails(context, pageDetails, bgColor, textPrimary,
              textSecondary, dividerColor, surfaceBg),
          PageFeedComponent(controller: controller),
        ];
      case 1: // Photos
        return [PagePhotosComponent(controller: controller)];
      case 2: // Reels
        return [
          SliverToBoxAdapter(
              child: PageProfileReelsComponent(controller: controller))
        ];
      case 3: // Events
        return [
          _buildEventsTab(
              context, bgColor, textPrimary, textSecondary, dividerColor)
        ];
      case 4: // Mentions
        return [
          _buildMentionsTab(
              context, bgColor, textPrimary, textSecondary, dividerColor, inputBg)
        ];
      default:
        return [const SliverToBoxAdapter()];
    }
  }

  // ═════════════════════════════════════════════════════════
  // ALL TAB — Details section
  // ═════════════════════════════════════════════════════════
  Widget _buildAllTabDetails(
    BuildContext context,
    dynamic pageDetails,
    Color bgColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
    Color surfaceBg,
  ) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Details Section ────────────────────────────
          Container(
            color: bgColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Details'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (pageDetails?.description != null &&
                    '${pageDetails.description}'.isNotEmpty)
                  _detailRow(context, Icons.info_outline,
                      '${pageDetails.description}', textPrimary, textSecondary),
                if (pageDetails?.category?.isNotEmpty == true)
                  _detailRow(
                      context,
                      Icons.folder_outlined,
                      (pageDetails.category as List).join(', '),
                      textPrimary,
                      textSecondary),
                if (pageDetails?.location?.isNotEmpty == true)
                  _detailRow(
                    context,
                    Icons.location_on_outlined,
                    (pageDetails.location as List).join(', '),
                    textPrimary,
                    textSecondary,
                    onTap: () {
                      final loc = (pageDetails.location as List).join(', ');
                      UriUtils.launchUrlInBrowser(
                          'https://maps.google.com/?q=$loc');
                    },
                  ),
                _detailRow(context, Icons.access_time_outlined,
                    'Always open'.tr, textPrimary, textSecondary),
              ],
            ),
          ),

          SizedBox(
              height: FeedDesignTokens.separatorHeight,
              child: ColoredBox(color: surfaceBg)),

          // ─── Links Section ────────────────────────────
          if (pageDetails?.website != null &&
              pageDetails!.website!.isNotEmpty) ...[
            Container(
              color: bgColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Links'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _detailRow(
                    context,
                    Icons.link,
                    pageDetails!.website!,
                    textPrimary,
                    textSecondary,
                    onTap: () =>
                        UriUtils.launchUrlInBrowser(pageDetails.website!),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: FeedDesignTokens.separatorHeight,
                child: ColoredBox(color: surfaceBg)),
          ],

          // ─── Contact Info Section ────────────────────────
          if (_hasContactInfo(pageDetails)) ...[
            Container(
              color: bgColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact info'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (pageDetails?.phoneNumber != null &&
                      pageDetails!.phoneNumber!.isNotEmpty)
                    _detailRow(
                      context,
                      Icons.phone_outlined,
                      pageDetails!.phoneNumber!,
                      textPrimary,
                      textSecondary,
                      onTap: () => UriUtils.launchUrlInBrowser(
                          'tel:${pageDetails.phoneNumber}'),
                    ),
                  if (pageDetails?.email != null &&
                      pageDetails!.email!.isNotEmpty)
                    _detailRow(
                      context,
                      Icons.email_outlined,
                      pageDetails!.email!,
                      textPrimary,
                      textSecondary,
                      onTap: () async {
                        final uri =
                            Uri(scheme: 'mailto', path: pageDetails.email);
                        if (await canLaunchUrl(uri)) await launchUrl(uri);
                      },
                    ),
                  if (pageDetails?.whatsappNumber != null &&
                      pageDetails!.whatsappNumber!.isNotEmpty)
                    _detailRow(
                      context,
                      Icons.chat_outlined,
                      pageDetails!.whatsappNumber!,
                      textPrimary,
                      textSecondary,
                      onTap: () async {
                        final uri = Uri.parse(
                            'whatsapp://send?phone=${pageDetails.whatsappNumber}&text=hello');
                        if (await canLaunchUrl(uri)) await launchUrl(uri);
                      },
                    ),
                ],
              ),
            ),
            SizedBox(
                height: FeedDesignTokens.separatorHeight,
                child: ColoredBox(color: surfaceBg)),
          ],

          // ─── All Posts header ────────────────────────────
          Container(
            color: bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: dividerColor, height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Text(
                    'All posts'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasContactInfo(dynamic pageDetails) {
    return (pageDetails?.phoneNumber != null &&
            pageDetails!.phoneNumber!.isNotEmpty) ||
        (pageDetails?.email != null && pageDetails!.email!.isNotEmpty) ||
        (pageDetails?.whatsappNumber != null &&
            pageDetails!.whatsappNumber!.isNotEmpty);
  }

  Widget _detailRow(BuildContext context, IconData icon, String text,
      Color textPrimary, Color textSecondary,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: onTap != null
                      ? FeedDesignTokens.brand(context)
                      : textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // EVENTS TAB
  // ═════════════════════════════════════════════════════════
  Widget _buildEventsTab(BuildContext context, Color bgColor,
      Color textPrimary, Color textSecondary, Color dividerColor) {
    return SliverToBoxAdapter(
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(Icons.event_outlined, size: 64, color: textSecondary),
            const SizedBox(height: 16),
            Text(
              'No events'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Events created by this page will appear here.'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textSecondary),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // MENTIONS TAB
  // ═════════════════════════════════════════════════════════
  Widget _buildMentionsTab(BuildContext context, Color bgColor,
      Color textPrimary, Color textSecondary, Color dividerColor, Color inputBg) {
    return SliverToBoxAdapter(
      child: Container(
        color: bgColor,
        child: Column(
          children: [
            // "Write something" prompt
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: controller.userModel.profile_pic != null
                        ? NetworkImage(
                            '${controller.userModel.profile_pic}'
                                .formatedProfileUrl)
                        : null,
                    child: controller.userModel.profile_pic == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${'Write something to'.tr} ${controller.pageProfileModel.value?.pageDetails?.pageName ?? ''}...',
                        style: TextStyle(fontSize: 14, color: textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: dividerColor, height: 1),
            // Write post + Share photo
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_outlined,
                              size: 20, color: textSecondary),
                          const SizedBox(width: 6),
                          Text('Write post'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 24, color: dividerColor),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo_outlined,
                              size: 20, color: Colors.green),
                          const SizedBox(width: 6),
                          Text('Share photo'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: dividerColor, height: 1),
            // Empty state
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Icon(Icons.alternate_email, size: 56, color: textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'No mentions yet'.tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'When people mention this page, their posts will show up here.'
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: textSecondary),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// Sticky Tab Bar Delegate
// ═════════════════════════════════════════════════════════
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 45;
  @override
  double get maxExtent => 45;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) =>
      oldDelegate.child != child;
}
