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
    // WalletManagementService walletManagementService = Get.find<WalletManagementService>();

    //* ********************************************************************************

    //? SETTING THE PAGE LOADING ANIMATION TO TRUE
    pagesController.isLoadingUserPages.value = true;
    homeController.isLoadingNewsFeed.value = true;

    //? SETTING THE FRIENDS LOADING ANIMATION TO TRUE
    friendController.suggestedFriendsGetterApiOnCall = true;
    friendController.isLoadingNewsFeed.value = true;

    // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // *┃  GET ALL STORY FOR HOME                                               ┃
    // *┃  THEN GET ALL POSTS AND AD'S SO THAT THEY CAN MAKE UP THE             ┃
    // *┃  INITIAL HOME PAGE VIEW                                               ┃
    // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    await homeController.getMessengerUserData();
    await homeController.getAllStory(forceRecallAPI: true);
    await homeController.fetchEdgeRankFeed(forceRecallAPI: true);
    await homeController.getAdsPagePosts(); // 2 days
    await homeController.getVideoAds(); // 2 days);

    // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // *┃  NEED TO GET THE NOTIFICATION COUNT                                   ┃
    // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    await notificationController.getUnseenNotificationsCount();

    //  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    //  ┃  WE ALSO NEED TO GET THE FRIENDS COUNT HERE                           ┃
    //  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // *┃  NEED TO GET SUGGESTED FRIENDS AND PAGES LIST                         ┃
    // *┃  Each controller fetches its own data directly                        ┃
    // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    friendController.getPeopleMayYouKnow(skip: 0);
    pagesController.getAllPages(initial: true);

    // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // *┃  NEED TO GET THE FIRST 2 REELS FOR THE USER                           ┃
    // *┃  WITH CAMPAIGN                                                        ┃
    // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    await videoController.getReels();
    await videoController.getReelsCampaignList(); // 2 days

    // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // *┃  GET THE DATA FORM USERS PRESENT CART                                 ┃
    // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    await cartController.getCartDetails();

    // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // *┃  GET ALL PRODUCTS FOR THE MARKET PLACE                                ┃
    // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    await marketplaceController.getMarketPlaceProduct(); // 5 hr

    // #┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    // #┃  CART CONTROLLER API                                                  ┃
    // #┃  WE ARE PUSHING THE THE API CALL AT THE BOTTOM DUE TO ITS PRIORITY    ┃
    // #┃  AND LARGE SIZE OF DATA VOLUME                                        ┃
    // #┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    await cartController.getAddressList().then(
      (value) {
        // ? SET THE DIFFICULT ADDRESS FOR THE CART
        cartController.setDefaultAddress();
      },
    );
  }
}
