import 'package:get/get.dart';
import '../controllers/buyer_refund_detials_controller.dart';

class BuyerReturnRefundDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerReturnRefundDetailsController>(
      () => BuyerReturnRefundDetailsController(),
    );
  }
}
