import 'package:get/get.dart';
import '../controllers/seller_order_detail_controller.dart';

class SellerOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerOrderDetailController>(
        () => SellerOrderDetailController());
  }
}
