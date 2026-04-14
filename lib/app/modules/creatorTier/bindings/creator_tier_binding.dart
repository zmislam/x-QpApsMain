import 'package:get/get.dart';
import '../controllers/creator_tier_controller.dart';

class CreatorTierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatorTierController>(() => CreatorTierController());
  }
}
