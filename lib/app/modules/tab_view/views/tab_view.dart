import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../config/constants/qp_icons_icons.dart';
import '../../../extension/string/string_image_path.dart';

import '../../../config/constants/color.dart';
import '../../../data/login_creadential.dart';
import '../../../routes/app_pages.dart';
import '../../NAVIGATION_MENUS/friend/views/friend_view.dart';
import '../../NAVIGATION_MENUS/home/views/home_view.dart';
import '../../NAVIGATION_MENUS/marketplace/marketplace_products/views/marketplace_view.dart';
import '../../NAVIGATION_MENUS/notification/controllers/notification_controller.dart';
import '../../NAVIGATION_MENUS/notification/views/notification_view.dart';
import '../../NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/views/pages_view_tab.dart';
import '../../NAVIGATION_MENUS/user_menu/views/user_menu_view.dart';
import '../../NAVIGATION_MENUS/reels/views/reels_view.dart';
import '../../NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../controllers/tab_view_controller.dart';
import 'brand_design_preview.dart';

// =============================================================================
// TabView — Facebook-inspired bottom navigation redesign
// =============================================================================
// The internal TabController indices are preserved for backward compatibility
// with locked files that call tabController.animateTo(index).
//
// Normal profile tabs (7): Home(0) Reels(1) Friends(2) Pages(3) Marketplace(4) Notifications(5) Menu(6)
// Page   profile tabs (6): Home(0) Reels(1) Pages(2) Marketplace(3) Notifications(4) Menu(5)
//
// Bottom nav shows 6 items (normal) or 5 items (page profile), mapping to the
// internal controller indices above.
// =============================================================================

class TabView extends GetView<TabViewController> {
  const TabView({super.key});

  // ─── Bottom-nav ↔ TabController index mapping ───────────────────────────

  /// Normal profile: bottom-nav items → TabController index
  static const List<int> _normalNavToTab = [0, 1, 2, 4, 5, 6];

  /// Page profile: bottom-nav items → TabController index
  static const List<int> _pageNavToTab = [0, 1, 2, 3, 4, 5];

  List<int> _navMapping(bool isPage) => isPage ? _pageNavToTab : _normalNavToTab;

  /// Convert TabController index → bottom-nav highlighted index
  int _tabToNavIndex(int tabIndex, bool isPage) {
    final mapping = _navMapping(isPage);
    final idx = mapping.indexOf(tabIndex);
    return idx >= 0 ? idx : 0;
  }

  // ─── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isReels = controller.tabIndex.value == 1;
      final isFriends = controller.tabIndex.value == 2 &&
          !controller.loginCredential.getProfileSwitch();
      final isPages = controller.loginCredential.getProfileSwitch()
          ? controller.tabIndex.value == 2
          : controller.tabIndex.value == 3;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: isReels
            ? SystemUiOverlayStyle.light
            : (Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark),
        child: Scaffold(
          // ─── AppBar (hidden on Reels, Friends & Pages tabs) ───────────
          appBar: (isReels || isFriends || isPages) ? null : _buildAppBar(context),
          // ─── Body ─────────────────────────────────────────────────────
          body: _buildBody(context),
          // ─── Bottom Navigation ────────────────────────────────────────
          bottomNavigationBar: _buildBottomNav(context),
          extendBody: isReels,
        ),
      );
    });
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  APP BAR — Instagram-inspired (centered brand text + outline icons)
  // ═════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive font size — scales with screen width (Instagram-like)
    final brandFontSize = screenWidth * 0.060; // ~23 on 390px screen — slightly smaller for centering balance
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black87;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      toolbarHeight: 56,
      titleSpacing: 0,
      // ── Layout: [Hamburger] ---- [QP text ▾] ---- [Search] ──────────
      title: Row(
        children: [
          const SizedBox(width: 4),
          // ── Hamburger menu (left) ──────────────────────────────────
          GestureDetector(
            onTap: () {
              // Navigate to the Profile/Menu tab (last tab)
              final bool isPageProfile = controller.loginCredential.getProfileSwitch();
              final int menuTabIndex = isPageProfile ? 5 : 6;
              controller.tabIndex.value = menuTabIndex;
              if (controller.tabControllerInitComplete.value) {
                controller.tabController.animateTo(menuTabIndex);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.menu,
                size: 26,
                color: iconColor,
              ),
            ),
          ),
          // ── Centered brand text + dropdown arrow ───────────────────
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => _showCreateBottomSheet(context),
                onLongPress: () => showBrandDesignPreview(context), // TEMP — remove after approval
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Design 25: Script Compact ─────────────────────
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF287070), Color(0xFF307777)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        'quantum possibilities',
                        style: TextStyle(
                          fontFamily: 'GrandHotel',
                          fontSize: brandFontSize * 0.91,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // ── Dropdown arrow (Instagram-style) ──────────────
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: iconColor.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // ── Right-side: only Search icon ──────────────────────────────────
      actions: [
        // ── Search button (Facebook-style: big circle, short handle) ───
        GestureDetector(
          onTap: () => Get.toNamed(Routes.ADVANCE_SEARCH),
          child: SizedBox(
            width: 26,
            height: 26,
            child: CustomPaint(painter: _FbSearchIconPainter(color: iconColor)),
          ),
        ),
        const SizedBox(width: 14),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  CREATE BOTTOM SHEET — Instagram-style
  // ═════════════════════════════════════════════════════════════════════════

  void _showCreateBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final sheetBg = isDark ? const Color(0xFF262626) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
        final iconBgColor = isDark
            ? Colors.grey.shade800
            : Colors.grey.shade100;
        final handleColor = isDark ? Colors.grey.shade600 : Colors.grey.shade300;

        // Menu items configuration — order: Post, Story, Reel, Live
        final items = <_CreateMenuItem>[
          _CreateMenuItem(
            icon: QpIcon.post,
            label: 'Post'.tr,
            iconColor: const Color(0xFF4CAF50), // green
            onTap: () {
              Navigator.of(ctx).pop();
              Get.toNamed(Routes.CREAT_POST);
            },
          ),
          _CreateMenuItem(
            icon: QpIcon.story,
            label: 'Story'.tr,
            iconColor: const Color(0xFF2196F3), // blue
            onTap: () {
              Navigator.of(ctx).pop();
              Get.toNamed(Routes.CREATE_STORY);
            },
          ),
          _CreateMenuItem(
            icon: Icons.event,
            label: 'Event'.tr,
            iconColor: const Color(0xFFFF6D00), // warm orange
            onTap: () {
              Navigator.of(ctx).pop();
              Get.toNamed(Routes.CREATE_EVENT);
            },
          ),
          _CreateMenuItem(
            icon: QpIcon.reel,
            label: 'Reel'.tr,
            iconColor: const Color(0xFFE91E63), // pink
            onTap: () {
              Navigator.of(ctx).pop();
              Get.toNamed(Routes.CUSTOM_CAMERA);
            },
          ),
          _CreateMenuItem(
            icon: QpIcon.live,
            label: 'Live'.tr,
            iconColor: const Color(0xFFFF5722), // deep orange
            onTap: () {
              Navigator.of(ctx).pop();
              Get.toNamed(Routes.GO_LIVE);
            },
          ),
        ];

        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag handle ──────────────────────────────────────
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // ── Title ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Create'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                ),
                // ── Menu items ───────────────────────────────────────
                const SizedBox(height: 8),
                ...items.map((item) => _CreateSheetTile(
                      item: item,
                      iconBgColor: iconBgColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    )),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  BODY — TabBarView preserving backward-compatible TabController
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildBody(BuildContext context) {
    final bool isPageProfile = controller.loginCredential.getProfileSwitch();

    // Tab view children — same order as before for index compatibility
    final List<Widget> tabBarViewsForProfile = [
      const HomeView(),
      const ReelsView(),
      const FriendView(),
      const PagesViewTab(isFromTab: true),
      const MarketplaceView(),
      const NotificationView(),
      const UserMenuView(),
    ];

    final List<Widget> tabBarViewsPageProfile = [
      const HomeView(),
      const ReelsView(),
      const PagesViewTab(isFromTab: true),
      const MarketplaceView(),
      const NotificationView(),
      const UserMenuView(),
    ];

    return Builder(
      builder: (context) {
        controller.updateTabControllerAfterReelCreation();
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (boolValue, result) {
            if (!boolValue) {
              controller.onBackPress(context);
            }
          },
          child: Obx(() {
            return controller.tabControllerInitComplete.value
                ? TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.tabController,
                    children: isPageProfile
                        ? tabBarViewsPageProfile
                        : tabBarViewsForProfile,
                  )
                : Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  );
          }),
        );
      },
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  BOTTOM NAVIGATION BAR — Facebook-inspired, thumb-friendly
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildBottomNav(BuildContext context) {
    final bool isPageProfile = controller.loginCredential.getProfileSwitch();
    final int currentTab = controller.tabIndex.value;
    final int activeNavIndex = _tabToNavIndex(currentTab, isPageProfile);
    final mapping = _navMapping(isPageProfile);

    // ── Define nav items ───────────────────────────────────────────────
    final List<_BottomNavItemData> items = isPageProfile
        ? [
            _BottomNavItemData(icon: QpIcon.home, label: 'Home'.tr),
            _BottomNavItemData(icon: QpIcon.reels, label: 'Reels'.tr),
            _BottomNavItemData(icon: QpIcon.pages, label: 'Pages'.tr),
            _BottomNavItemData(icon: QpIcon.market, label: 'Marketplace'.tr),
            _BottomNavItemData(
              icon: QpIcon.notification,
              label: 'Notifications'.tr,
              badgeBuilder: _notificationBadge,
            ),
            _BottomNavItemData(
              icon: Icons.person_outline_rounded,
              label: 'Profile'.tr,
              isProfile: true,
            ),
          ]
        : [
            _BottomNavItemData(icon: QpIcon.home, label: 'Home'.tr),
            _BottomNavItemData(icon: QpIcon.reels, label: 'Reels'.tr),
            _BottomNavItemData(icon: QpIcon.friends, label: 'Friends'.tr),
            _BottomNavItemData(icon: QpIcon.market, label: 'Marketplace'.tr),
            _BottomNavItemData(
              icon: QpIcon.notification,
              label: 'Notifications'.tr,
              badgeBuilder: _notificationBadge,
            ),
            _BottomNavItemData(
              icon: Icons.person_outline_rounded,
              label: 'Profile'.tr,
              isProfile: true,
            ),
          ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final bool isActive = index == activeNavIndex;
              return Expanded(
                child: _BottomNavItem(
                  data: item,
                  isActive: isActive,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // ── Profile tab → navigate to user profile page ──
                    if (item.isProfile) {
                      if (controller.loginCredential.getProfileSwitch()) {
                        Get.toNamed(Routes.ADMIN_PAGE,
                            arguments: controller.loginCredential
                                .getUserData()
                                .pageUserName);
                      } else {
                        Get.toNamed(Routes.PROFILE, preventDuplicates: false);
                      }
                      return;
                    }
                    final tabIdx = mapping[index];
                    // If already on Home tab and tapping Home again → scroll to top
                    if (tabIdx == 0 && controller.tabIndex.value == 0) {
                      try {
                        Get.find<HomeController>().scrollToTop();
                      } catch (_) {}
                      return;
                    }
                    controller.tabIndex.value = tabIdx;
                    if (controller.tabControllerInitComplete.value) {
                      controller.tabController.animateTo(tabIdx);
                    }
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ── Notification badge builder ──────────────────────────────────────
  Widget? _notificationBadge() {
    try {
      final count =
          Get.find<NotificationController>().unseenNotificationCount.value;
      if (count > 0) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
          child: Text(
            count > 99 ? '99+' : count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
    } catch (_) {}
    return null;
  }
}

// =============================================================================
//  Custom Painters — Create icon, Search icon & Messenger icon
// =============================================================================

/// Facebook-style search icon — large circle, short handle
class _FbSearchIconPainter extends CustomPainter {
  final Color color;
  _FbSearchIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // ── Large circle (magnifying glass lens) ───────────────────────────
    final cx = w * 0.42;
    final cy = h * 0.42;
    final r = w * 0.32; // big radius
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // ── Short handle ───────────────────────────────────────────────────
    // Starts at ~45° from circle edge, short length
    final handleStart = Offset(cx + r * 0.7, cy + r * 0.7);
    final handleEnd = Offset(w * 0.88, h * 0.88);
    canvas.drawLine(handleStart, handleEnd, paint..strokeWidth = 2.2);
  }

  @override
  bool shouldRepaint(covariant _FbSearchIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

// _CreateIconPainter and _FbMessengerIconPainter removed — create menu now
// triggered via dropdown arrow next to brand text (Instagram-style).

// =============================================================================
//  Private Data — Bottom nav item definition
// =============================================================================

class _BottomNavItemData {
  final IconData icon;
  final String label;
  final bool isProfile;
  final Widget? Function()? badgeBuilder;

  const _BottomNavItemData({
    required this.icon,
    required this.label,
    this.isProfile = false,
    this.badgeBuilder,
  });
}

// =============================================================================
//  Private Widget — Single bottom nav item (Facebook-style)
// =============================================================================

class _BottomNavItem extends StatelessWidget {
  final _BottomNavItemData data;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = PRIMARY_COLOR;
    final Color inactiveColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Active indicator line ───────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 24 : 0,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: isActive ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // ── Icon with optional badge ────────────────────────────────
          SizedBox(
            height: 24,
            width: 28,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: data.isProfile
                      ? _buildProfileAvatar(context)
                      : Icon(
                          data.icon,
                          size: 22,
                          color: isActive ? activeColor : inactiveColor,
                        ),
                ),
                if (data.badgeBuilder != null)
                  Obx(() {
                    final badge = data.badgeBuilder!();
                    if (badge != null) {
                      return Positioned(
                        right: -6,
                        top: -4,
                        child: badge,
                      );
                    }
                    return const SizedBox.shrink();
                  }),
              ],
            ),
          ),
          const SizedBox(height: 2),
          // ── Label ───────────────────────────────────────────────────
          Text(
            data.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? activeColor : inactiveColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    final profilePic =
        (LoginCredential().getUserData().profile_pic ?? '').formatedProfileUrl;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? PRIMARY_COLOR : Colors.transparent,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 10,
        backgroundImage: NetworkImage(profilePic),
        backgroundColor: Colors.grey.shade300,
      ),
    );
  }
}

// =============================================================================
//  Private Data — Create bottom sheet menu item
// =============================================================================

class _CreateMenuItem {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _CreateMenuItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });
}

// =============================================================================
//  Private Widget — Single create sheet tile (Instagram-style)
// =============================================================================

class _CreateSheetTile extends StatelessWidget {
  final _CreateMenuItem item;
  final Color iconBgColor;
  final Color textColor;
  final Color subtitleColor;

  const _CreateSheetTile({
    required this.item,
    required this.iconBgColor,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // ── Icon in rounded container ─────────────────────────────
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: item.iconColor.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  size: 22,
                  color: item.iconColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // ── Label ─────────────────────────────────────────────────
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
