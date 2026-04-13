import 'package:get/get.dart';
import '../../add_product/controllers/add_product_controller.dart';
import '../controllers/edit_product_controller.dart';

class EditProductBinding extends Bindings {
  @override
  void dependencies() {
    // Register as AddProductController so AddProductView widgets can find it
    Get.lazyPut<AddProductController>(() => EditProductController());
  }
}
