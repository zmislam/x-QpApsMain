import 'package:get/get.dart';
import '../controllers/reels_boost_controller.dart';

class ReelsBoostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsBoostController>(() => ReelsBoostController());
  }
}
