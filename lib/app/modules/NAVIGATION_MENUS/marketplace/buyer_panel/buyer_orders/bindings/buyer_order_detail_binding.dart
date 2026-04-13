import 'package:get/get.dart';
import '../controllers/buyer_order_detail_controller.dart';

class BuyerOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerOrderDetailController>(
        () => BuyerOrderDetailController());
  }
}
