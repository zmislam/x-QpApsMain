import 'package:get/get.dart';
import '../controllers/buyer_order_details_controller.dart';

class BuyerOrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerOrderDetailsController>(
      () => BuyerOrderDetailsController(),
    );
  }
}
