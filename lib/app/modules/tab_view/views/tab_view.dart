import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/applauncher_helper/applauncher_helper.dart';
import '../../../config/constants/app_constant.dart';
import '../../../config/constants/qp_icons_icons.dart';
import '../../../extension/string/string_image_path.dart';

import '../../../config/constants/color.dart';
import '../../../data/login_creadential.dart';
import '../../../routes/app_pages.dart';
import '../../NAVIGATION_MENUS/friend/views/friend_view.dart';
import '../../NAVIGATION_MENUS/home/views/home_view.dart';
import '../../NAVIGATION_MENUS/marketplace/marketplace_products/controllers/marketplace_controller.dart';
import '../../NAVIGATION_MENUS/marketplace/marketplace_products/views/marketplace_view.dart';
import '../../NAVIGATION_MENUS/notification/controllers/notification_controller.dart';
import '../../NAVIGATION_MENUS/notification/views/notification_view.dart';
import '../../NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/views/pages_view_tab.dart';
import '../../NAVIGATION_MENUS/user_menu/views/user_menu_view.dart';
import '../../NAVIGATION_MENUS/reels/views/reels_view.dart';
import '../controllers/tab_view_controller.dart';
import '../widget/pop_up_menu_widget.dart';

class TabView extends GetView<TabViewController> {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.loginCredential.getProfileSwitch() == true ? controller.tabLength = 6 : controller.tabLength = 7;

    return Obx(() => Scaffold(
          // ========================= appbar section ==========================
          appBar: controller.tabIndex.value != 1
              ? AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ===================== app logo ========================
                      Image.asset(
                        'assets/logo/logo.png',
                        width: 25,
                        height: 25,
                      ),
                      // ===================== action buttons ==================
                      Row(
                        children: [
                          // ================= popup menu button ===============
                          CustomPopupMenu(
                            menuItems: [
                              // ============= post button =====================
                              PopupMenuItemData(
                                icon: QpIcon.post,
                                text: 'Post'.tr,
                                onTap: () => Get.toNamed(Routes.CREAT_POST),
                              ),
                              // ============= story button ====================
                              PopupMenuItemData(
                                icon: QpIcon.story,
                                text: 'Story'.tr,
                                onTap: () => Get.toNamed(Routes.CREATE_STORY),
                              ),
                              // ============== reels button ===================
                              PopupMenuItemData(
                                icon: QpIcon.reel,
                                text: 'Reels'.tr,
                                onTap: () => Get.toNamed(Routes.CUSTOM_CAMERA),
                              ),
                              // =============== go live button ================
                              PopupMenuItemData(
                                icon: QpIcon.live,
                                // icon: Icons.video_camera_back_outlined,
                                text: 'Go Live'.tr,
                                onTap: () => Get.toNamed(Routes.GO_LIVE),
                              ),
                            ],
                          ),
                          const SizedBox(width: 6),
                          // ================= search button ===================
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.GLOBAL_SEARCH);
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).appBarTheme.foregroundColor,
                              radius: 15,
                              child: Icon(
                                QpIcon.searchFill,
                                // Icons.search_rounded,
                                size: 29,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // ======================= cart button ===============
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.CART);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .foregroundColor!,
                                        width: .5), // border color & width
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).canvasColor,
                                    radius: 15,
                                    child: Icon(
                                      QpIcon.cart,
                                      // Icons.search_rounded,
                                      size: 16,
                                      color: Theme.of(context)
                                          .appBarTheme
                                          .foregroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                final count = Get.find<MarketplaceController>()
                                    .cartCount
                                    .value;
                                if (count > 0) {
                                  return Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: PRIMARY_COLOR,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        //  count <99?   count.toString(): '99+',
                                        count.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                            ],
                          ),
                          const SizedBox(width: 6),
                          // ======================= WishList button ===============
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.WISHLIST_PAGE);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .foregroundColor!,
                                        width: .5), // border color & width
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).canvasColor,
                                    radius: 15,
                                    child: Icon(
                                      Icons.favorite_border_outlined,
                                      // Icons.search_rounded,
                                      size: 16,
                                      color: Theme.of(context)
                                          .appBarTheme
                                          .foregroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                final count = Get.find<MarketplaceController>()
                                    .wishProductCount
                                    .value;
                                if (count > 0) {
                                  return Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: PRIMARY_COLOR,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        //  count <99?   count.toString(): '99+',
                                        count.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                            ],
                          ),
                          const SizedBox(width: 6),
                          // ===================== msg button ==================
                          InkWell(
                            onTap: () async {
                              Get.snackbar('🎉 Almost Ready!',
                                  'Get the messenger app and start amazing conversations with your friends! ✨');
                              // AppLauncherHelper.launchQPApp(
                              //   deepLinkUrl:
                              //       AppConstant.QP_MESSENGER_DEEP_LINK_URL,
                              //   fallbackUrl:
                              //       AppConstant.QP_MESSENGER_FALL_BACK_URL,
                              // );
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).appBarTheme.foregroundColor,
                              radius: 15,
                              child: Icon(
                                QpIcon.message,
                                // Icons.search_rounded,
                                size: 29,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),
                          // ===================== language button ==================
                          InkWell(
                            onTap: () async {
                              Get.toNamed(Routes.CHANGE_LANGUAGE);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)
                              ),
                              child: CircleAvatar(
                                backgroundColor:
                                Theme.of(context).canvasColor,
                                radius: 15,
                                child: Icon(
                                  QpIcon.language,
                                  // Icons.search_rounded,
                                  size: 20,
                                  color: Theme.of(context).appBarTheme.foregroundColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : null,
          // ========================= body section ============================
          body: bodyData(context),
        ));
  }

  Widget bodyData(BuildContext context) {
    final bool isPageProfile = controller.loginCredential.getProfileSwitch();
    final List<Widget> tabsForProfile = [
      Icon(
        QpIcon.home,
        size: 22,
        color: Theme.of(context).iconTheme.color,
      ),
      // Image.asset(
      //   AppAssets.HOME_NAVBAR_ICON,
      //   height: 20,
      //   width: 20,
      //   color: Theme.of(context).iconTheme.color,
      // ),

      Icon(
        QpIcon.reels,
        size: 24,
        color: Theme.of(context).iconTheme.color,
      ),
      // Image.asset(
      //   AppAssets.VIDEO_NAVBAR_ICON,
      //   height: 20,
      //   width: 20,
      //   color: Theme.of(context).iconTheme.color,
      // ),

      controller.loginCredential.getProfileSwitch() == true
          ? const SizedBox.shrink()
          : Icon(
              QpIcon.friends,
              size: 25,
              color: Theme.of(context).iconTheme.color,
            ),

      // controller.loginCredential.getProfileSwitch() == true
      //     ? const SizedBox.shrink()
      //     : Image.asset(
      //         AppAssets.FRIEND_NAVBAR_ICON,
      //         height: 20,
      //         width: 20,
      //         color: Theme.of(context).iconTheme.color,
      //       ),

      Icon(
        QpIcon.pages,
        size: 22,
        color: Theme.of(context).iconTheme.color,
      ),

      // Image.asset(
      //   AppAssets.PAGE_NAV_ICON,
      //   height: 20,
      //   width: 20,
      //   color: Theme.of(context).iconTheme.color,
      // ),

      Icon(
        QpIcon.market,
        size: 22,
        color: Theme.of(context).iconTheme.color,
      ),
      // Image.asset(
      //   AppAssets.MARKET_PLACE_NAVBAR_ICON,
      //   height: 20,
      //   width: 20,
      //   color: Theme.of(context).iconTheme.color,
      // ),
      Stack(
        alignment: Alignment.topRight,
        children: [
          InkWell(
            onTap: () {
              debugPrint('::::Notification  Button Pressed::::::::::::::');
              // Get.toNamed(Routes.NOTIFICATION);
              controller.tabIndex.value = 5;
              controller.tabIndex.value = isPageProfile ? 4 : 5;
              if (controller.tabControllerInitComplete.value) {
                controller.tabController.animateTo(isPageProfile ? 4 : 5);
              }
            },

            child: SizedBox(
              height: 35,
              width: 35,
              child: Icon(
                QpIcon.notification,
                size: 24,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            // child: Image.asset(
            //   'assets/icon/create_post/notification.png',
            //   color: Theme.of(context).iconTheme.color,
            //   height: 35,
            //   width: 35,
            // ),
          ),
          // if (controller.cartCount.value > 0)assets\icon\create_post\notification.png
          Obx(() {
            final count = Get.find<NotificationController>()
                .unseenNotificationCount
                .value;
            if (count > 0) {
              return Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: PRIMARY_COLOR,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    //  count <99?   count.toString(): '99+',
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
      CircleAvatar(
        radius: 15,
        backgroundColor: const Color.fromARGB(255, 45, 185, 185),
        child: CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage(
              scale: 30,
              (LoginCredential().getUserData().profile_pic ?? '')
                  .formatedProfileUrl),
        ),
      ),
    ];
    final List<Widget> tabsForPageProfile = [
      // Image.asset(
      //   AppAssets.HOME_NAVBAR_ICON,
      //   height: 20,
      //   width: 20,
      //   color: Theme.of(context).iconTheme.color,
      // ),
      // Image.asset(
      //   AppAssets.VIDEO_NAVBAR_ICON,
      //   height: 20,
      //   width: 20,
      //   color: Theme.of(context).iconTheme.color,
      // ),
      // Image.asset(
      //   AppAssets.PAGE_NAV_ICON,
      //   height: 20,
      //   width: 20,
      //   color: Theme.of(context).iconTheme.color,
      // ),
      // Image.asset(
      //   AppAssets.MARKET_PLACE_NAVBAR_ICON,
      //   height: 20,
      //   width: 20,
      //   color: Theme.of(context).iconTheme.color,
      // ),

      Icon(
        QpIcon.home,
        size: 22,
        color: Theme.of(context).iconTheme.color,
      ),

      Icon(
        QpIcon.reels,
        size: 24,
        color: Theme.of(context).iconTheme.color,
      ),

      Icon(
        QpIcon.pages,
        size: 22,
        color: Theme.of(context).iconTheme.color,
      ),

      Icon(
        QpIcon.market,
        size: 22,
        color: Theme.of(context).iconTheme.color,
      ),
      Stack(
        alignment: Alignment.topRight,
        children: [
          InkWell(
            onTap: () {
              debugPrint('::::Notification  Button Pressed::::::::::::::');
              // Get.toNamed(Routes.NOTIFICATION);
              controller.tabIndex.value = 4;
              controller.tabIndex.value = isPageProfile ? 4 : 5;
              if (controller.tabControllerInitComplete.value) {
                controller.tabController.animateTo(isPageProfile ? 4 : 5);
              }
            },
            child: SizedBox(
              height: 35,
              width: 35,
              child: Icon(
                QpIcon.notification,
                size: 24,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            // child: Image.asset(
            //   'assets/icon/create_post/notification.png',
            //   color: Theme.of(context).iconTheme.color,
            //   height: 35,
            //   width: 35,
            // ),
          ),
          // if (controller.cartCount.value > 0)assets\icon\create_post\notification.png
          Obx(() {
            final count = Get.find<NotificationController>()
                .unseenNotificationCount
                .value;
            if (count > 0) {
              return Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: PRIMARY_COLOR,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    //  count <99?   count.toString(): '99+',
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
      CircleAvatar(
        radius: 15,
        backgroundColor: const Color.fromARGB(255, 45, 185, 185),
        child: CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage(
              scale: 30,
              (LoginCredential().getUserData().profile_pic ?? '')
                  .formatedProfileUrl),
        ),
      ),
    ];

    // ============================= tab bar views for profile list =======================================
    final List<Widget> tabBarViewsForProfile = [
      // =========================== home view =================================
      const HomeView(),
      // =========================== video view ================================
      const ReelsView(),
      // =========================== friend view ===============================
      const FriendView(),
      // =========================== pages view ================================
      const PagesViewTab(
        isFromTab: true,
      ),
      // =========================== market place view =========================
      const MarketplaceView(),
      // =========================== notification view =========================
      const NotificationView(),
      // =========================== user menu view ============================
      const UserMenuView()
    ];

    // ======================== tabbar views for page profile ========================================
    final List<Widget> tabBarViewsPageProfile = [
      const HomeView(),
      const ReelsView(),
      const PagesViewTab(isFromTab: true),
      const MarketplaceView(),
      const NotificationView(),
      const UserMenuView()
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
            return Column(
              children: [
                Visibility(
                  visible: controller.tabIndex.value == 1 ? false : true,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 55,
                        width: Get.width,
                        child: controller.tabControllerInitComplete.value
                            ? TabBar(
                                onTap: (index) {
                                  controller.tabIndex.value = index;
                                },
                                dividerHeight: 2,
                                indicatorWeight: 0,
                                physics: const NeverScrollableScrollPhysics(),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicator: const UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.green,
                                  ),
                                  insets: EdgeInsets.symmetric(horizontal: 0),
                                ),
                                isScrollable: false,
                                controller: controller.tabController,
                                dividerColor: Colors.grey.shade300,
                                tabs: controller.loginCredential
                                            .getProfileSwitch() ==
                                        true
                                    ? tabsForPageProfile
                                    : tabsForProfile,
                              )
                            : Container(color: Colors.grey.shade100),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.tabControllerInitComplete.value
                      ? TabBarView(
                          controller: controller.tabController,
                          children:
                              controller.loginCredential.getProfileSwitch() ==
                                      true
                                  ? tabBarViewsPageProfile
                                  : tabBarViewsForProfile,
                        )
                      : Container(color: Colors.grey),
                )
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildVideoView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight, // Use full available height
          width: constraints.maxWidth,
          child: const ReelsView(),
        );
      },
    );
  }
}
