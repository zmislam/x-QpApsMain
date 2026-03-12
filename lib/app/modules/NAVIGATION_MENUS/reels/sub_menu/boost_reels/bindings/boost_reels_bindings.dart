import 'package:get/get.dart';
import '../controllers/boost_reels_controller.dart';


class BoostReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoostReelsController>(
      () => BoostReelsController(),
    );
  }
}
