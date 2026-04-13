import 'package:get/get.dart';
import '../controllers/buyer_refunds_controller.dart';

class RefundDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerRefundsController>(() => BuyerRefundsController());
  }
}
