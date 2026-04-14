import 'package:get/get.dart';
import '../controllers/tipping_controller.dart';

class TippingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TippingController>(() => TippingController());
  }
}
