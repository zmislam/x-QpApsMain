import 'package:get/get.dart';
import '../controllers/reels_search_controller.dart';

class ReelsSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsSearchController>(() => ReelsSearchController());
  }
}
