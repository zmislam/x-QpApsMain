import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/login_creadential.dart';
import '../../../../extension/string/string_image_path.dart';

import '../../../../components/image.dart';
import '../../../../routes/app_pages.dart';
import '../../settings_privacy/views/settings_privacy_view.dart';
import '../controllers/user_menu_controller.dart';
import '../widget/change_to_original_profile.dart';
import '../widget/user_profile_change_button.dart';
import '../../../tab_view/controllers/tab_view_controller.dart';

// ═════════════════════════════════════════════════════════════════════════════
//  User Menu — Facebook-inspired hamburger menu redesign
//  Backup: _backup_user_menu/user_menu_view.dart.bak
// ═════════════════════════════════════════════════════════════════════════════

class UserMenuView extends GetView<UserMenuController> {
  const UserMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = LoginCredential().getUserInfoData().isProfileVerified;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPageProfile = controller.loginCredential.getProfileSwitch();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF18191A) : const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ════════════════════════════════════════════════════════════
                //  1. PROFILE CARD — Avatar + Name + Page switcher
                // ════════════════════════════════════════════════════════════
                _buildProfileCard(context, profile, isDark),

                const SizedBox(height: 20),

                // ════════════════════════════════════════════════════════════
                //  2. YOUR SHORTCUTS — Horizontal scrollable
                // ════════════════════════════════════════════════════════════
                if (!isPageProfile) ...[
                  Text(
                    'Your shortcuts'.tr,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1C1E21),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildShortcutsRow(context, isDark),
                  const SizedBox(height: 20),
                ],

                // ════════════════════════════════════════════════════════════
                //  3. MENU GRID — 2-column cards
                // ════════════════════════════════════════════════════════════
                _buildMenuGrid(context, isDark, isPageProfile),

                const SizedBox(height: 8),

                // ════════════════════════════════════════════════════════════
                //  4. SEE MORE BUTTON
                // ════════════════════════════════════════════════════════════
                _buildSeeMoreButton(context, isDark, isPageProfile),

                const SizedBox(height: 16),

                // ════════════════════════════════════════════════════════════
                //  5. BOTTOM SECTIONS — Help, Settings, Sign Out
                // ════════════════════════════════════════════════════════════
                _buildBottomActions(context, isDark),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  1. PROFILE CARD
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildProfileCard(BuildContext context, bool? profile, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        if (controller.loginCredential.getProfileSwitch()) {
          await Get.toNamed(Routes.ADMIN_PAGE,
              arguments: controller.loginCredential.getUserData().pageUserName);
        } else {
          await Get.toNamed(Routes.PROFILE, preventDuplicates: false);
          controller.userModel.value = controller.loginCredential.getUserData();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242526) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Avatar ────────────────────────────────────────────────
            Obx(
              () => ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: NetworkCircleAvatar(
                    imageUrl: (controller.profileImage.value).formatedProfileUrl,
                    radius: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Name + verified ──────────────────────────────────────
            Expanded(
              child: Obx(() {
                final name = controller.profileName.value;
                return RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1C1E21),
                        ),
                      ),
                      if (profile == true)
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.verified,
                              color: Color(0xFF0D7377),
                              size: 17,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(width: 8),

            // ── Profile switch buttons ────────────────────────────────
            if (controller.loginCredential.getProfileSwitch())
              const ChangeToOriginalProfile(),
            const UserProfileChangeButton(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2. YOUR SHORTCUTS — Horizontal scrollable row
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildShortcutsRow(BuildContext context, bool isDark) {
    // Shortcut items from user's recent pages/groups
    // For now showing the explore/groups/pages as shortcuts
    final shortcuts = <_ShortcutItem>[
      _ShortcutItem(
        label: 'Explore',
        icon: Icons.explore_outlined,
        onTap: () => Get.toNamed(Routes.EXPLORE),
      ),
      _ShortcutItem(
        label: 'Groups',
        icon: Icons.group_outlined,
        onTap: () => Get.toNamed(Routes.GROUPS),
      ),
      _ShortcutItem(
        label: 'Pages',
        icon: Icons.flag_outlined,
        onTap: () {
          try {
            TabViewController tabCtrl = Get.find<TabViewController>();
            LoginCredential cred = LoginCredential();
            final pageTabIndex = cred.getProfileSwitch() ? 2 : 3;
            tabCtrl.tabIndex.value = pageTabIndex;
            tabCtrl.tabController.animateTo(pageTabIndex);
          } catch (_) {}
        },
      ),
      _ShortcutItem(
        label: 'Reels',
        icon: Icons.play_circle_outline_rounded,
        onTap: () {
          try {
            TabViewController tabViewController = Get.find<TabViewController>();
            tabViewController.tabController.animateTo(1);
          } catch (_) {}
        },
      ),
      _ShortcutItem(
        label: 'Marketplace',
        icon: Icons.storefront_outlined,
        onTap: () {
          try {
            TabViewController tabViewController = Get.find<TabViewController>();
            LoginCredential loginCredential = LoginCredential();
            if (loginCredential.getProfileSwitch()) {
              tabViewController.tabController.animateTo(3);
            } else {
              tabViewController.tabController.animateTo(4);
            }
          } catch (_) {}
        },
      ),
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: shortcuts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = shortcuts[index];
          return GestureDetector(
            onTap: item.onTap,
            child: SizedBox(
              width: 80,
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF3A3B3C)
                          : const Color(0xFFE4E6EB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      item.icon,
                      size: 26,
                      color: isDark
                          ? const Color(0xFFB0B3B8)
                          : const Color(0xFF65676B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFB0B3B8) : const Color(0xFF65676B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  3. MENU GRID — 2-column cards with Facebook-style icons
  // ═══════════════════════════════════════════════════════════════════════════

  // Number of items initially visible (can expand with "See more")
  static const int _initialVisibleCount = 8;

  List<_MenuGridItem> _getMenuItems(bool isPageProfile) {
    if (isPageProfile) {
      return [
        _MenuGridItem(
          icon: Icons.dynamic_feed_rounded,
          iconColor: const Color(0xFF1877F2),
          label: 'Feeds',
          onTap: () => Get.toNamed(Routes.FEEDS),
        ),
        _MenuGridItem(
          icon: Icons.flag_rounded,
          iconColor: const Color(0xFFFF6D00),
          label: 'Pages',
          onTap: () {
            try {
              TabViewController tabCtrl = Get.find<TabViewController>();
              LoginCredential cred = LoginCredential();
              final pageTabIndex = cred.getProfileSwitch() ? 2 : 3;
              tabCtrl.tabIndex.value = pageTabIndex;
              tabCtrl.tabController.animateTo(pageTabIndex);
            } catch (_) {}
          },
        ),
        _MenuGridItem(
          icon: Icons.bookmark_rounded,
          iconColor: const Color(0xFF9C27B0),
          label: 'Bookmarks',
          onTap: () => Get.toNamed(Routes.BOOKMARKS),
        ),
        _MenuGridItem(
          icon: Icons.storefront_rounded,
          iconColor: const Color(0xFF1877F2),
          label: 'Marketplace',
          onTap: () {
            try {
              TabViewController tabViewController = Get.find<TabViewController>();
              tabViewController.tabController.animateTo(3);
            } catch (_) {}
          },
        ),
        _MenuGridItem(
          icon: Icons.shopping_bag_rounded,
          iconColor: const Color(0xFF43A047),
          label: 'Buyer Panel',
          onTap: () => Get.toNamed(Routes.BUYER_DASHBOARD),
        ),
        _MenuGridItem(
          icon: Icons.sell_rounded,
          iconColor: const Color(0xFFE65100),
          label: 'Seller Panel',
          onTap: () => Get.toNamed(Routes.SELLER_DASHBOARD),
        ),
        _MenuGridItem(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: const Color(0xFF6A1B9A),
          label: 'Wallet',
          onTap: () => Get.toNamed(Routes.QP_WALLET_DASHBOARD),
        ),
      ];
    }

    return [
      _MenuGridItem(
        icon: Icons.dynamic_feed_rounded,
        iconColor: const Color(0xFF1877F2),
        label: 'Feeds',
        onTap: () => Get.toNamed(Routes.FEEDS),
      ),
      _MenuGridItem(
        icon: Icons.people_rounded,
        iconColor: const Color(0xFF1EBEA5),
        label: 'Friends',
        onTap: () {
          final tabCtrl = Get.find<TabViewController>();
          tabCtrl.tabIndex.value = 2;
          if (tabCtrl.tabControllerInitComplete.value) {
            tabCtrl.tabController.animateTo(2);
          }
        },
      ),
      _MenuGridItem(
        icon: Icons.event_rounded,
        iconColor: const Color(0xFFD32F2F),
        label: 'Events',
        onTap: () => Get.toNamed(Routes.EVENTS),
      ),
      _MenuGridItem(
        icon: Icons.card_giftcard_rounded,
        iconColor: const Color(0xFF1EBEA5),
        label: 'Birthdays',
        onTap: () => Get.toNamed(Routes.BIRTHDAYS),
      ),
      _MenuGridItem(
        icon: Icons.bookmark_rounded,
        iconColor: const Color(0xFF9C27B0),
        label: 'Saved',
        onTap: () => Get.toNamed(Routes.BOOKMARKS),
      ),
      _MenuGridItem(
        icon: Icons.groups_rounded,
        iconColor: const Color(0xFF1877F2),
        label: 'Groups',
        onTap: () => Get.toNamed(Routes.GROUPS),
      ),
      _MenuGridItem(
        icon: Icons.play_circle_filled_rounded,
        iconColor: const Color(0xFFFF4444),
        label: 'Reels',
        onTap: () {
          try {
            TabViewController tabViewController = Get.find<TabViewController>();
            tabViewController.tabController.animateTo(1);
          } catch (_) {}
        },
      ),
      _MenuGridItem(
        icon: Icons.flag_rounded,
        iconColor: const Color(0xFFFF6D00),
        label: 'Pages',
        onTap: () {
          try {
            TabViewController tabCtrl = Get.find<TabViewController>();
            LoginCredential cred = LoginCredential();
            final pageTabIndex = cred.getProfileSwitch() ? 2 : 3;
            tabCtrl.tabIndex.value = pageTabIndex;
            tabCtrl.tabController.animateTo(pageTabIndex);
          } catch (_) {}
        },
      ),
      // ── Below items shown after "See more" ────────────────────────
      _MenuGridItem(
        icon: Icons.explore_rounded,
        iconColor: const Color(0xFF00897B),
        label: 'Explore',
        onTap: () => Get.toNamed(Routes.EXPLORE),
      ),
      _MenuGridItem(
        icon: Icons.storefront_rounded,
        iconColor: const Color(0xFF1877F2),
        label: 'Marketplace',
        onTap: () {
          try {
            TabViewController tabViewController = Get.find<TabViewController>();
            tabViewController.tabController.animateTo(4);
          } catch (_) {}
        },
      ),
      _MenuGridItem(
        icon: Icons.shopping_bag_rounded,
        iconColor: const Color(0xFF43A047),
        label: 'Buyer Panel',
        onTap: () => Get.toNamed(Routes.BUYER_DASHBOARD),
      ),
      _MenuGridItem(
        icon: Icons.sell_rounded,
        iconColor: const Color(0xFFE65100),
        label: 'Seller Panel',
        onTap: () => Get.toNamed(Routes.SELLER_DASHBOARD),
      ),
      _MenuGridItem(
        icon: Icons.account_balance_wallet_rounded,
        iconColor: const Color(0xFF6A1B9A),
        label: 'Wallet',
        onTap: () => Get.toNamed(Routes.QP_WALLET_DASHBOARD),
      ),
      _MenuGridItem(
        icon: Icons.campaign_rounded,
        iconColor: const Color(0xFF00897B),
        label: 'Ad Manager',
        onTap: () => Get.toNamed(Routes.ADS_CAMPAIGN_HOME),
      ),
    ];
  }

  Widget _buildMenuGrid(BuildContext context, bool isDark, bool isPageProfile) {
    final items = _getMenuItems(isPageProfile);
    final visibleCount = items.length <= _initialVisibleCount
        ? items.length
        : _initialVisibleCount;
    final visibleItems = items.sublist(0, visibleCount);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.0,
      ),
      itemCount: visibleItems.length,
      itemBuilder: (context, index) {
        final item = visibleItems[index];
        return _MenuCard(item: item, isDark: isDark);
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  4. SEE MORE BUTTON
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSeeMoreButton(BuildContext context, bool isDark, bool isPageProfile) {
    final items = _getMenuItems(isPageProfile);
    if (items.length <= _initialVisibleCount) return const SizedBox.shrink();

    return _SeeMoreSection(
      isDark: isDark,
      hiddenItems: items.sublist(_initialVisibleCount),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  5. BOTTOM ACTIONS — Help, Settings, Sign Out
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBottomActions(BuildContext context, bool isDark) {
    return Column(
      children: [
        // ── Help & Support ───────────────────────────────────────────
        _ExpandableSettingRow(
          icon: Icons.help_outline_rounded,
          title: 'Help & support'.tr,
          isDark: isDark,
          onTap: () => Get.toNamed(Routes.HELP_SUPPORT),
        ),
        Divider(
          height: 1,
          color: isDark ? const Color(0xFF3A3B3C) : const Color(0xFFE4E6EB),
        ),

        // ── Settings & Privacy ──────────────────────────────────────
        _ExpandableSettingRow(
          icon: Icons.settings_outlined,
          title: 'Settings & privacy'.tr,
          isDark: isDark,
          onTap: () async {
            await Get.to(() => const SettingsPrivacyView());
            controller.userModel.value = controller.loginCredential.getUserData();
          },
        ),
        Divider(
          height: 1,
          color: isDark ? const Color(0xFF3A3B3C) : const Color(0xFFE4E6EB),
        ),

        // ── Give Feedback ───────────────────────────────────────────
        _ExpandableSettingRow(
          icon: Icons.feedback_outlined,
          title: 'Give us Feedback'.tr,
          isDark: isDark,
          onTap: () {},
        ),
        Divider(
          height: 1,
          color: isDark ? const Color(0xFF3A3B3C) : const Color(0xFFE4E6EB),
        ),

        // ── Sign Out ────────────────────────────────────────────────
        _ExpandableSettingRow(
          icon: Icons.logout_rounded,
          title: 'Sign Out'.tr,
          isDark: isDark,
          onTap: controller.onTapSignOut,
          isDestructive: true,
        ),
      ],
    );
  }
}

// =============================================================================
//  DATA CLASSES
// =============================================================================

class _ShortcutItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ShortcutItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class _MenuGridItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _MenuGridItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
}

// =============================================================================
//  MENU CARD — Individual grid item with Facebook-style colored icon
// =============================================================================

class _MenuCard extends StatelessWidget {
  final _MenuGridItem item;
  final bool isDark;

  const _MenuCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? const Color(0xFF242526) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF3A3B3C)
                  : const Color(0xFFE4E6EB),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 26,
                color: item.iconColor,
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1C1E21),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  SEE MORE SECTION — Expandable grid for hidden items
// =============================================================================

class _SeeMoreSection extends StatefulWidget {
  final bool isDark;
  final List<_MenuGridItem> hiddenItems;

  const _SeeMoreSection({
    required this.isDark,
    required this.hiddenItems,
  });

  @override
  State<_SeeMoreSection> createState() => _SeeMoreSectionState();
}

class _SeeMoreSectionState extends State<_SeeMoreSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Expanded items ──────────────────────────────────────────
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.0,
              ),
              itemCount: widget.hiddenItems.length,
              itemBuilder: (context, index) {
                final item = widget.hiddenItems[index];
                return _MenuCard(item: item, isDark: widget.isDark);
              },
            ),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),

        // ── See more / See less button ──────────────────────────────
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? const Color(0xFF3A3B3C)
                  : const Color(0xFFE4E6EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _expanded ? 'See less' : 'See more',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.white : const Color(0xFF1C1E21),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
//  EXPANDABLE SETTING ROW — Bottom section items
// =============================================================================

class _ExpandableSettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ExpandableSettingRow({
    required this.icon,
    required this.title,
    required this.isDark,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive
        ? Colors.red
        : (isDark ? Colors.white : const Color(0xFF1C1E21));
    final iconBgColor = isDark
        ? const Color(0xFF3A3B3C)
        : const Color(0xFFE4E6EB);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive
                    ? Colors.red
                    : (isDark ? const Color(0xFFB0B3B8) : const Color(0xFF65676B)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: isDark ? const Color(0xFF65676B) : const Color(0xFF8A8D91),
            ),
          ],
        ),
      ),
    );
  }
}

