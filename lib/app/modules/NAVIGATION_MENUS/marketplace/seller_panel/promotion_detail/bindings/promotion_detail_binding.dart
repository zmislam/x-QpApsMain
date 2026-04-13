import 'package:get/get.dart';
import '../controllers/promotion_detail_controller.dart';

class PromotionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromotionDetailController>(
        () => PromotionDetailController());
  }
}
