import 'package:get/get.dart';

import '../../../../components/share/share_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/REST_cacheing_service/cache_util.dart';
import '../../friend/controllers/friend_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../marketplace/marketplace_cart/controllers/cart_controller.dart';
import '../../marketplace/marketplace_products/controllers/marketplace_controller.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../reels/controllers/reels_controller.dart';
import '../../user_menu/controllers/user_menu_controller.dart';
import '../../user_menu/sub_menus/all_pages/pages/controllers/pages_controller.dart';

class AccountSwitchPageController extends GetxController {
  CacheUtil cacheUtil = CacheUtil.instance;

  Future<void> goToHomeTabWithDelay() async {
    Get.delete<HomeController>();
    Get.delete<NotificationController>();
    Get.delete<ReelsController>();
    Get.delete<FriendController>();
    Get.delete<MarketplaceController>();
    Get.delete<CartController>();
    Get.delete<UserMenuController>();
    Get.delete<PagesController>();
    Get.delete<ShareController>();
    // Get.delete<InitService>();

    await Future.delayed(
      const Duration(seconds: 6),
      () {
        //! CLEAR ALL STORED DATA WHILE PROFILE IS BEING SWITCHED

        cacheUtil.clearAllCache();

        Get.offAndToNamed(Routes.SPLASH);
      },
    );
  }
}
