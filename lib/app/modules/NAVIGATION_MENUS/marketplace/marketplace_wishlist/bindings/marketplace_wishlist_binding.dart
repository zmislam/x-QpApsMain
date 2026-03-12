import 'package:get/get.dart';

import '../controllers/marketplace_wishlist_controller.dart';


class MarketplaceWishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketplaceWishlistController>(
      () => MarketplaceWishlistController(),
    );
  }
}
