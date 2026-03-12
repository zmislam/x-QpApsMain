import 'package:get/get.dart';
import '../controllers/store_products_controller.dart';


class StoreProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreProductsController>(
      () => StoreProductsController(),
    );
  }
}
