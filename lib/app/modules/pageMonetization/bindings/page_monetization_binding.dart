import 'package:get/get.dart';
import '../controllers/page_monetization_controller.dart';

class PageMonetizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageMonetizationController>(
        () => PageMonetizationController());
  }
}
