import 'package:get/get.dart';
import '../controllers/store_reviews_controller.dart';

class StoreReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreReviewsController>(() => StoreReviewsController());
  }
}
