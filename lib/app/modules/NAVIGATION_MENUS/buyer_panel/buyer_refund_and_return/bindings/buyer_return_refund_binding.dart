import 'package:get/get.dart';
import '../controllers/buyer_return_refund_controller.dart';

class BuyerReturnRefundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerReturnRefundController>(
      () => BuyerReturnRefundController(),
    );
  }
}
