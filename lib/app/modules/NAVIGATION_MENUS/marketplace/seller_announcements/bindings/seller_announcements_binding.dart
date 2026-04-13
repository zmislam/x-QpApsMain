import 'package:get/get.dart';
import '../controllers/seller_announcements_controller.dart';

class SellerAnnouncementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerAnnouncementsController>(
      () => SellerAnnouncementsController(),
    );
  }
}
