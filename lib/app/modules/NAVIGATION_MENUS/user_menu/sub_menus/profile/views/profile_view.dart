import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../../../../../extension/url.dart';
import '../../../../../../config/constants/feed_design_tokens.dart';
import '../controllers/monitizationController.dart';
import 'components/profile_all_reels_component.dart';
import '../../../../../NAVIGATION_MENUS/reels_v2/widgets/profile_reels_v2_grid.dart';
import '../../../../../NAVIGATION_MENUS/reels_v2/utils/reels_v2_integration_config.dart';
import 'components/showMonitizationModel.dart';
import 'components/showVerificationModal.dart';
import 'components/feed.dart';
import 'components/photos.dart';
import '../../../../../../components/simmar_loader.dart';
import '../../../../../../components/single_image.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../routes/profile_navigator.dart';
import '../../../../../../config/constants/color.dart';
import '../controllers/profile_controller.dart';
import '../../../controllers/user_menu_controller.dart';
import '../../../../../../modules/creatorTier/widgets/creator_tier_badge.dart';
import '../../../../../../modules/earnDashboard/services/earning_config_service.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  // ─── Helpers ─────────────────────────────────────────────
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatBirthday(String? dob) {
    if (dob == null || dob.isEmpty) return '';
    try {
      final date = DateTime.parse(dob);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (_) {
      return dob;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final dividerColor = FeedDesignTokens.divider(context);
    final surfaceBg = FeedDesignTokens.surfaceBg(context);
    final inputBg = FeedDesignTokens.inputBg(context);

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: surfaceBg,
        body: RefreshIndicator(
          backgroundColor: bgColor,
          color: PRIMARY_COLOR,
          onRefresh: () async {
            controller.getUserData();
            controller.pinnedPostList.value.clear();
            controller.pinnedPostList.refresh();
            controller.postList.value.clear();
            controller.postList.refresh();
            controller.pageNo = 1;
            controller.totalPageCount = 0;
            controller.getPosts();
            controller.getFriends();
          },
          child: Obx(() {
            final profile = controller.profileModel.value;
            final isLoading = controller.isLoading.value;

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
                        // — Cover Photo + Profile Pic Stack —
                        _buildCoverAndAvatar(context, profile, bgColor),
                        const SizedBox(height: 8),

                        // — Name + Verified + Dropdown —
                        _buildNameRow(context, profile, textPrimary, isLoading),
                        const SizedBox(height: 4),

                        // — Stats: friends · posts —
                        _buildStatsRow(context, profile, textSecondary),
                        const SizedBox(height: 8),

                        // — Bio —
                        if (profile?.user_bio != null &&
                            profile!.user_bio!.isNotEmpty)
                          _buildBio(context, profile, textPrimary, textSecondary),

                        // — Location —
                        if (profile?.present_town != null &&
                            profile!.present_town!.isNotEmpty)
                          _buildLocation(context, profile, textSecondary),

                        const SizedBox(height: 12),

                        // — Action Buttons: Edit profile + Story + Earn + More —
                        _buildActionButtons(context, profile, bgColor, isDark),
                        const SizedBox(height: 12),

                        // — Lock Profile Notice —
                        if (profile?.lock_profile == 'locked')
                          _buildLockNotice(context, textSecondary, inputBg),

                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),

                // ════════════════════════════════════════════════
                // SECTION 2: Tab Chips (All / Photos / Reels)
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
                SliverToBoxAdapter(
                  child: SizedBox(height: 8),
                ),

                // ════════════════════════════════════════════════
                // SECTION 3: Content based on selected tab
                // ════════════════════════════════════════════════
                ..._buildTabContentSlivers(context, profile, bgColor, textPrimary,
                    textSecondary, dividerColor, inputBg, surfaceBg),
              ],
            );
          }),
        ),
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
    final hasCover = profile?.cover_pic != null && profile!.cover_pic!.isNotEmpty;
    final hasProfilePic =
        profile?.profile_pic != null && profile!.profile_pic!.isNotEmpty;

    return SizedBox(
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover photo
          GestureDetector(
            onTap: hasCover
                ? () => Get.to(() => SingleImage(imgURL: coverUrl))
                : null,
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: hasCover
                  ? Image.network(
                      coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        AppAssets.DEFAULT_IMAGE,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.cover),
            ),
          ),

          // Camera icon on cover
          Positioned(
            bottom: 70,
            right: 12,
            child: _circleIconButton(
              icon: Icons.camera_alt,
              onTap: () => _showCoverPhotoOptions(context),
              size: 34,
            ),
          ),

          // Back button (top-left, matching other profile style)
          Positioned(
            top: 8,
            left: 12,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
                child: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
              ),
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

          // Camera icon on profile pic
          Positioned(
            bottom: 2,
            left: 96,
            child: _circleIconButton(
              icon: Icons.camera_alt,
              onTap: () => _showProfilePhotoOptions(context),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Name Row ────────────────────────────────────────────
  Widget _buildNameRow(
      BuildContext context, dynamic profile, Color textPrimary, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showAccountSwitcher(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                  // Creator Tier Badge (Phase 7)
                  Builder(builder: (_) {
                    try {
                      final configService = Get.find<EarningConfigService>();
                      if (configService.tierEnabled) {
                        final tiers = configService.userTiers;
                        if (tiers.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: CreatorTierBadge(
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
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down,
                      color: textPrimary.withValues(alpha: 0.6), size: 22),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: FeedDesignTokens.inputBg(context),
        ),
        child: Icon(icon,
            size: 18, color: FeedDesignTokens.textPrimary(context)),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, dynamic profile) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: FeedDesignTokens.inputBg(context),
        ),
        child: Icon(Icons.more_horiz,
            size: 18, color: FeedDesignTokens.textPrimary(context)),
      ),
      color: FeedDesignTokens.cardBg(context),
      offset: const Offset(0, 40),
      onSelected: (String value) async {
        if (value == 'monetization') {
          showMonetizationModal(context);
        } else if (value == 'turnOffEarning') {
          final monitizationController =
              Get.isRegistered<MonetizationController>()
                  ? Get.find<MonetizationController>()
                  : Get.put(MonetizationController());
          await monitizationController.disableMonetization();
        } else if (value == 'verify') {
          if (profile != null) {
            await controller.createPaymentIntent();
            if (controller.clientSecretKey.value.isNotEmpty) {
              showVerificationModal(Get.context!, profile);
            } else {
              Get.snackbar(
                'Payment Error',
                'Unable to initialize payment session. Please try again.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          }
        }
      },
      itemBuilder: (BuildContext context) {
        final items = <PopupMenuEntry<String>>[];
        final monetization = profile?.monetization?.toLowerCase() ?? '';
        final isEarningDashboardOn =
            (monetization == 'pending' || monetization == 'approved');
        final isApproved = monetization == 'approved';
        final isVerified = profile?.isProfileVerified ?? false;

        if (!isEarningDashboardOn) {
          items.add(
            PopupMenuItem<String>(
              value: 'monetization',
              child: Text('Turn on Monetization'.tr),
            ),
          );
        }
        if (isApproved) {
          items.add(
            PopupMenuItem<String>(
              value: 'turnOffEarning',
              child: Text('Turn off Earning Mode'.tr),
            ),
          );
        }
        if (!isVerified) {
          items.add(
            PopupMenuItem<String>(
              value: 'verify',
              child: Text('Verify Now'.tr),
            ),
          );
        }
        return items;
      },
    );
  }

  // ─── Stats Row ───────────────────────────────────────────
  Widget _buildStatsRow(
      BuildContext context, dynamic profile, Color textSecondary) {
    final friends = controller.friendCount.value;
    final posts = profile?.postsCount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.MY_PROFILE_FRIENDS,
                  arguments: '${LoginCredential().getUserData().username}');
            },
            child: Text(
              '${_formatCount(friends)} ${'friends'.tr}',
              style: TextStyle(
                fontSize: 15,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(' · ', style: TextStyle(fontSize: 15, color: textSecondary)),
          Text(
            '${_formatCount(posts)} ${'posts'.tr}',
            style: TextStyle(
              fontSize: 15,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bio ─────────────────────────────────────────────────
  Widget _buildBio(BuildContext context, dynamic profile, Color textPrimary,
      Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTap: () => _showBioOptions(context),
        child: Text(
          profile?.user_bio ?? '',
          style: TextStyle(fontSize: 15, color: textPrimary),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // ─── Location ────────────────────────────────────────────
  Widget _buildLocation(
      BuildContext context, dynamic profile, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 16, color: textSecondary),
          const SizedBox(width: 4),
          Text(
            '${'Lives in'.tr} ${profile.present_town}',
            style: TextStyle(fontSize: 14, color: textSecondary),
          ),
        ],
      ),
    );
  }

  // ─── Action Buttons ──────────────────────────────────────
  Widget _buildActionButtons(
      BuildContext context, dynamic profile, Color bgColor, bool isDark) {
    final isApproved =
        (profile?.monetization?.toLowerCase() == 'approved');
    final inputBg = FeedDesignTokens.inputBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Edit profile — primary action
          Expanded(
            child: SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(Routes.ABOUT),
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: Text('Edit Profile'.tr,
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Add story — compact
          SizedBox(
            height: 36,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.CREATE_STORY),
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: Text('Story'.tr,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: inputBg,
                foregroundColor: textPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Earn Dashboard — compact (only if monetized)
          if (isApproved) ...[
            const SizedBox(width: 6),
            SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(Routes.EARN_DASHBOARD),
                icon: const Icon(Icons.bar_chart_rounded, size: 16),
                label: Text('Earn'.tr,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: inputBg,
                  foregroundColor: textPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(width: 6),
          // More options (popup)
          SizedBox(
            width: 36,
            height: 36,
            child: _buildPopupMenu(context, profile),
          ),
        ],
      ),
    );
  }

  // ─── Lock Profile Notice ─────────────────────────────────
  Widget _buildLockNotice(
      BuildContext context, Color textSecondary, Color inputBg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(AppAssets.PROFILE_LOCK_ICON, width: 20, height: 20),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: "You've locked your profile. ".tr,
                  style: TextStyle(fontSize: 13, color: textSecondary),
                  children: [
                    TextSpan(
                      text: 'Learn more'.tr,
                      style: TextStyle(
                        fontSize: 13,
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
      ),
    );
  }



  // ─── Tab Chips (All / Photos / Reels) ────────────────────
  Widget _buildTabChips(BuildContext context, Color bgColor,
      Color textPrimary, Color textSecondary) {
    final tabs = ['All'.tr, 'Photos'.tr, 'Reels'.tr];
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
                  controller.viewNumber.value = 0;
                } else if (index == 1) {
                  controller.viewNumber.value = 1;
                  controller.getPhotos();
                  controller.getAlbums();
                  controller.getProfilePictures();
                  controller.getVideos();
                } else if (index == 2) {
                  controller.viewNumber.value = 3;
                  controller.viewReelsTabNumber.value = 0;
                  controller.getPersonalReels();
                  controller.getRepostVideo();
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
                      : Border.all(
                          color: FeedDesignTokens.divider(context)),
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

  // ─── Tab Content Switcher (returns list of slivers) ────
  List<Widget> _buildTabContentSlivers(
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
      // Photos tab
      return [PhotosComponent(controller: controller)];
    } else if (selectedTab == 2) {
      // Reels tab — V2 grid when enabled, V1 otherwise
      if (ReelsV2IntegrationConfig.useV2ProfileGrid) {
        final userId = controller.profileModel.value?.id ?? '';
        return [ProfileReelsV2Grid(userId: userId)];
      }
      return [ProfileReelsComponent(controller: controller)];
    }

    // ALL tab: Details + Friends + Posts
    return [
      SliverToBoxAdapter(
        child: Column(
          children: [
            // Personal details section
            _buildPersonalDetailsSection(
                context, profile, bgColor, textPrimary, textSecondary, dividerColor),
            const SizedBox(height: 8),

            // Work section
            _buildWorkSection(
                context, profile, bgColor, textPrimary, textSecondary, dividerColor),
            const SizedBox(height: 8),

            // Friends horizontal section
            _buildFriendsSection(
                context, bgColor, textPrimary, textSecondary, dividerColor),
            const SizedBox(height: 8),

            // All posts section header + content
            Container(
              color: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All posts'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showFilterBottomSheet(context),
                    child: Text(
                      'Filters'.tr,
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

            // Create post bar
            _buildCreatePostBar(context, profile, bgColor, inputBg, textSecondary),

            // Manage posts button
            Container(
              color: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to manage posts
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: FeedDesignTokens.divider(context)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Manage posts'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            Divider(color: dividerColor, height: 1),
          ],
        ),
      ),

      // FeedComponent renders the actual post list as a SliverList
      FeedComponent(controller: controller),
    ];
  }

  // ─── Personal Details Section ────────────────────────────
  Widget _buildPersonalDetailsSection(
      BuildContext context,
      dynamic profile,
      Color bgColor,
      Color textPrimary,
      Color textSecondary,
      Color dividerColor) {
    if (profile == null) return const SizedBox.shrink();

    final details = <_DetailItem>[];

    // Location
    if (profile.present_town != null && profile.present_town!.isNotEmpty) {
      details.add(_DetailItem(
        icon: Icons.location_on,
        label: '${'Lives in'.tr} ',
        value: profile.present_town!,
        route: Routes.EDIT_PLACESLIVED,
      ));
    }

    // Hometown
    if (profile.home_town != null && profile.home_town!.isNotEmpty) {
      details.add(_DetailItem(
        icon: Icons.home,
        label: '${'From'.tr} ',
        value: profile.home_town!,
        route: Routes.EDIT_PLACESLIVED,
      ));
    }

    // Birthday
    if (profile.date_of_birth != null && profile.date_of_birth!.isNotEmpty) {
      details.add(_DetailItem(
        icon: Icons.cake,
        label: '${'Born'.tr} ',
        value: _formatBirthday(profile.date_of_birth),
        route: Routes.EDIT_BIRTH_DATE,
      ));
    }

    // Relationship
    if (profile.relation_status != null &&
        profile.relation_status!.isNotEmpty) {
      details.add(_DetailItem(
        icon: Icons.favorite,
        label: '',
        value: profile.relation_status!,
        route: Routes.EDIT_RELATIONSHIP,
      ));
    }

    // Languages
    if (profile.language != null && profile.language!.isNotEmpty) {
      final langs =
          profile.language!.map((l) => l.language ?? '').join(', ');
      if (langs.isNotEmpty) {
        details.add(_DetailItem(
          icon: Icons.language,
          label: '${'Speaks'.tr} ',
          value: langs,
          route: Routes.ADD_LANGUAGE,
        ));
      }
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal details'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.ABOUT),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FeedDesignTokens.inputBg(context),
                    ),
                    child: Icon(Icons.edit,
                        size: 16,
                        color: FeedDesignTokens.textPrimary(context)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...details.map((d) => _buildDetailRow(
              context, d, textPrimary, textSecondary)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, _DetailItem item,
      Color textPrimary, Color textSecondary) {
    return InkWell(
      onTap: () => Get.toNamed(item.route),
      child: Padding(
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
            Icon(Icons.lock_outline, size: 16, color: textSecondary.withValues(alpha: 0.5)),
          ],
        ),
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
          // Work
          if (workplaces.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Work'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.ADD_WORK_PLACE),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FeedDesignTokens.inputBg(context),
                      ),
                      child: Icon(Icons.edit,
                          size: 16,
                          color: FeedDesignTokens.textPrimary(context)),
                    ),
                  ),
                ],
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

          // Education
          if (education.isNotEmpty) ...[
            if (workplaces.isNotEmpty) const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Education'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.ADD_EDUCATION),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FeedDesignTokens.inputBg(context),
                      ),
                      child: Icon(Icons.edit,
                          size: 16,
                          color: FeedDesignTokens.textPrimary(context)),
                    ),
                  ),
                ],
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

  // ─── Friends Horizontal Section ──────────────────────────
  Widget _buildFriendsSection(BuildContext context, Color bgColor,
      Color textPrimary, Color textSecondary, Color dividerColor) {
    final friends = controller.friendList.value;
    final count = controller.friendCount.value;
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
                  onTap: () {
                    Get.toNamed(Routes.MY_PROFILE_FRIENDS,
                        arguments:
                            '${LoginCredential().getUserData().username}');
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

          // Horizontal friends list
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
                    onTap: () {
                      ProfileNavigator.navigateToProfile(
                        username: f.friend?.username ?? '',
                        isFromReels: 'false',
                      );
                    },
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
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                            ),
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

  // ─── Create Post Bar ─────────────────────────────────────
  Widget _buildCreatePostBar(BuildContext context, dynamic profile,
      Color bgColor, Color inputBg, Color textSecondary) {
    final profilePicUrl = profile?.profile_pic != null
        ? '${profile!.profile_pic}'.formatedProfileUrl
        : '';
    final hasProfilePic =
        profile?.profile_pic != null && profile!.profile_pic!.isNotEmpty;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: hasProfilePic
                ? NetworkImage(profilePicUrl)
                : const AssetImage(AppAssets.DEFAULT_CIRCLE_PROFILE_IMAGE)
                    as ImageProvider,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: controller.onTapCreatePost,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "What's on your mind?".tr,
                  style: TextStyle(fontSize: 14, color: textSecondary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Reel icon
          GestureDetector(
            onTap: () {
              controller.pickMediaFiles();
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.photo_library,
                  size: 20, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Filter Bottom Sheet ─────────────────────────────────
  void _showFilterBottomSheet(BuildContext context) {
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final bgColor = FeedDesignTokens.cardBg(context);
    final dividerColor = FeedDesignTokens.divider(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Go to → (Year filter)
              _buildFilterOption(
                context: ctx,
                label: 'Go to'.tr,
                value: controller.filterYear.value.isEmpty
                    ? 'Today'.tr
                    : controller.filterYear.value,
                onTap: () {
                  Get.back();
                  _showYearPicker(context);
                },
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              Divider(color: dividerColor),

              // Posted by
              _buildFilterOption(
                context: ctx,
                label: 'Posted by'.tr,
                value: controller.filterPostBy.value.isEmpty
                    ? 'Anyone'.tr
                    : controller.filterPostBy.value,
                onTap: () {
                  Get.back();
                  _showPostedByPicker(context);
                },
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              Divider(color: dividerColor),

              // Privacy
              _buildFilterOption(
                context: ctx,
                label: 'Privacy'.tr,
                value: controller.filterPrivacy.value.isEmpty
                    ? 'All posts'.tr
                    : controller.filterPrivacy.value.capitalizeFirst ?? '',
                onTap: () {
                  Get.back();
                  _showPrivacyPicker(context);
                },
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              Divider(color: dividerColor),

              // Tagged posts toggle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tagged posts'.tr,
                        style: TextStyle(fontSize: 16, color: textPrimary)),
                    Obx(() => Switch(
                          value: controller.filterTagBy.value == 'true',
                          onChanged: (val) {
                            controller.filterTagBy.value =
                                val ? 'true' : '';
                          },
                          activeTrackColor: PRIMARY_COLOR,
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Action row: Clear + Done
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.filterYear.value = '';
                        controller.filterPostBy.value = '';
                        controller.filterPrivacy.value = 'public';
                        controller.filterTagBy.value = '';
                        controller.postList.value.clear();
                        controller.pinnedPostList.value.clear();
                        controller.pageNo = 1;
                        controller.totalPageCount = 0;
                        controller.getPosts();
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: dividerColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Clear'.tr,
                          style: TextStyle(color: textPrimary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.getFilterPosts();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Done'.tr,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(fontSize: 16, color: textPrimary)),
            Row(
              children: [
                Text(value,
                    style: TextStyle(fontSize: 15, color: textSecondary)),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 20, color: textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Year Picker ─────────────────────────────────────────
  void _showYearPicker(BuildContext context) {
    final years = controller.postFilterYearList.value;
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Select Year'.tr,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: FeedDesignTokens.textPrimary(context))),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: years.length,
                  itemBuilder: (ctx, i) {
                    return ListTile(
                      title: Text(years[i]),
                      onTap: () {
                        controller.filterYear.value = years[i];
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Posted By Picker ────────────────────────────────────
  void _showPostedByPicker(BuildContext context) {
    final options = ['Anyone'.tr, 'You'.tr, 'Others'.tr];
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((opt) => ListTile(
                      title: Text(opt),
                      onTap: () {
                        controller.filterPostBy.value =
                            opt == 'Anyone'.tr ? '' : opt.toLowerCase();
                        Get.back();
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  // ─── Privacy Picker ──────────────────────────────────────
  void _showPrivacyPicker(BuildContext context) {
    final options = [
      'All posts'.tr,
      'Public'.tr,
      'Friends'.tr,
      'Only me'.tr
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((opt) => ListTile(
                      title: Text(opt),
                      onTap: () {
                        controller.filterPrivacy.value = opt == 'All posts'.tr
                            ? 'public'
                            : opt.toLowerCase();
                        Get.back();
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  // ─── Bio Options Bottom Sheet ────────────────────────────
  void _showBioOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.ADD_BIO, arguments: {
                    'bio': controller.profileModel.value?.user_bio ?? '',
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: PRIMARY_COLOR),
                    const SizedBox(width: 10),
                    Text('Edit Bio'.tr,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 10, child: Divider()),
              InkWell(
                onTap: () => controller.onTapEditBioPatch(),
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: PRIMARY_COLOR),
                    const SizedBox(width: 10),
                    Text('Remove Bio'.tr,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Cover Photo Options ─────────────────────────────────
  void _showCoverPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: PRIMARY_COLOR),
                title: Text('Upload Cover Photo'.tr),
                onTap: () async {
                  Get.back();
                  await controller.uploadUserCoverPicture();
                  controller.profileModel.refresh();
                  controller.getUserData();
                },
              ),
              if (controller.profileModel.value?.cover_pic != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text('Remove Cover Photo'.tr),
                  onTap: () => controller.removeCoverPhoto(),
                ),
            ],
          ),
        );
      },
    );
  }

  // ─── Profile Photo Options ───────────────────────────────
  void _showProfilePhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: PRIMARY_COLOR),
                title: Text('Upload Profile Photo'.tr),
                onTap: () async {
                  Get.back();
                  await controller.uploadUserProfilePicture();
                  controller.profileModel.refresh();
                  controller.getUserData();
                },
              ),
              if (controller.profileModel.value?.profile_pic != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text('Remove Profile Photo'.tr),
                  onTap: () => controller.removeProfilePhoto(),
                ),
            ],
          ),
        );
      },
    );
  }

  // ─── Account Switcher ────────────────────────────────────
  void _showAccountSwitcher(BuildContext context) {
    final profile = controller.profileModel.value;
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final profilePicUrl = profile?.profile_pic != null
        ? '${profile!.profile_pic}'.formatedProfileUrl
        : '';
    final hasProfilePic =
        profile?.profile_pic != null && profile!.profile_pic!.isNotEmpty;
    final isPageProfile = LoginCredential().getProfileSwitch();

    // Fetch page profiles
    final userMenuController = Get.find<UserMenuController>();
    userMenuController.getAllPages();

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.6,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Current personal profile
                ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: hasProfilePic
                        ? NetworkImage(profilePicUrl)
                        : const AssetImage(
                                AppAssets.DEFAULT_CIRCLE_PROFILE_IMAGE)
                            as ImageProvider,
                  ),
                  title: Text(
                    '${profile?.first_name ?? ''} ${profile?.last_name ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  trailing: !isPageProfile
                      ? Icon(Icons.check_circle,
                          color: PRIMARY_COLOR, size: 24)
                      : null,
                  onTap: isPageProfile
                      ? () {
                          Navigator.of(ctx).pop();
                          userMenuController.profileSwitch().then(
                            (value) => Get.offAndToNamed(Routes.ACCOUNT_SWITCH_PAGE),
                          );
                        }
                      : null,
                ),

                // Page profiles list (scrollable)
                Expanded(
                  child: Obx(() {
                    if (userMenuController.loading.value) {
                      return const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    if (userMenuController.listOfProfiles.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListView.builder(
                      itemCount: userMenuController.listOfProfiles.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final page = userMenuController.listOfProfiles[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: const AssetImage(AppAssets.DEFAULT_IMAGE),
                            foregroundImage: (page.profilePic != null && page.profilePic!.isNotEmpty)
                                ? NetworkImage(page.profilePic!.pageImageUrlBuild)
                                : null,
                          ),
                          title: Text(
                            page.pageName ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            '${page.followerCount ?? 0} ${'Followers'.tr}',
                            style: TextStyle(
                              fontSize: 12,
                              color: textPrimary.withValues(alpha: 0.6),
                            ),
                          ),
                          trailing: page.isSelected
                              ? Icon(Icons.check_circle,
                                  color: PRIMARY_COLOR, size: 24)
                              : null,
                          onTap: page.isSelected
                              ? null
                              : () {
                                  Navigator.of(ctx).pop();
                                  userMenuController
                                      .profileSwitch(id: page.id.toString())
                                      .then((value) => Get.offAndToNamed(
                                          Routes.ACCOUNT_SWITCH_PAGE));
                                },
                        );
                      },
                    );
                  }),
                ),

                const SizedBox(height: 8),
                Divider(color: FeedDesignTokens.divider(context)),
                const SizedBox(height: 8),

                // See all profiles
                ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FeedDesignTokens.inputBg(context),
                    ),
                    child: const Icon(Icons.people_outline, color: PRIMARY_COLOR),
                  ),
                  title: Text('See all profiles'.tr,
                      style: TextStyle(color: textPrimary)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(Routes.PAGES);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Circle Icon Button Helper ───────────────────────────
  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 34,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: size * 0.5, color: Colors.black87),
      ),
    );
  }

  // ─── Loading View ────────────────────────────────────────
  Widget shimmerLoadingView() {
    return SizedBox(
      height: Get.height,
      child: GridView.builder(
        physics: const ScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: Get.width / 3,
                height: 157,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withValues(alpha: 0.9),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Detail Item Helper Class ──────────────────────────────
class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final String route;

  _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.route,
  });
}
