import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';

import '../components/share/share_controller.dart';
import '../modules/NAVIGATION_MENUS/friend/controllers/friend_controller.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_cart/controllers/cart_controller.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_products/controllers/marketplace_controller.dart';
import '../modules/NAVIGATION_MENUS/notification/controllers/notification_controller.dart';
import '../modules/NAVIGATION_MENUS/reels/controllers/reels_controller.dart';
import '../modules/NAVIGATION_MENUS/user_menu/controllers/user_menu_controller.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/controllers/pages_controller.dart';

class InitService extends GetxService {
  Future<void> init() async {
    //* INIT **************************************************************************
    HomeController homeController = Get.find<HomeController>();
    NotificationController notificationController = Get.find<NotificationController>();
    ReelsController videoController = Get.find<ReelsController>();
    FriendController friendController = Get.find<FriendController>();
    MarketplaceController marketplaceController = Get.find<MarketplaceController>();
    CartController cartController = Get.find<CartController>();
    UserMenuController userMenuController = Get.find<UserMenuController>();
    PagesController pagesController = Get.find<PagesController>();
    ShareController shareController = Get.find<ShareController>();

    //* ********************************************************************************

    //? SETTING THE PAGE LOADING ANIMATION TO TRUE
    pagesController.isLoadingUserPages.value = true;

    //? SETTING THE FRIENDS LOADING ANIMATION TO TRUE
    friendController.suggestedFriendsGetterApiOnCall = true;
    friendController.isLoadingNewsFeed.value = true;

    // ═══════════════════════════════════════════════════════════════════
    //  PHASE 1 — Critical home page data (parallelized)
    //  NOTE: Feed fetch is REMOVED here — HomeController.onInit() already
    //  calls fetchEdgeRankFeed(isInitial: true). Running it twice caused
    //  duplicate fetches and race conditions with post ordering.
    // ═══════════════════════════════════════════════════════════════════
    await Future.wait([
      homeController.getMessengerUserData(),
      homeController.getAllStory(forceRecallAPI: true),
      homeController.getAdsPagePosts(),
      homeController.getVideoAds(),
      notificationController.getUnseenNotificationsCount(),
    ]);

    // ═══════════════════════════════════════════════════════════════════
    //  PHASE 2 — Secondary data (fire-and-forget, non-blocking)
    //  These are not needed for the initial home page render.
    // ═══════════════════════════════════════════════════════════════════
    friendController.getPeopleMayYouKnow(skip: 0);
    pagesController.getAllPages(initial: true);

    unawaited(Future.wait([
      videoController.getReels(),
      videoController.getReelsCampaignList(),
      cartController.getCartDetails(),
      marketplaceController.getMarketPlaceProduct(),
      cartController.getAddressList().then((_) {
        cartController.setDefaultAddress();
      }),
    ]).catchError((e) {
      debugPrint('[InitService] Secondary data error: $e');
    }));
  }
}
