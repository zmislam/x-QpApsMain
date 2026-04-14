import 'package:get/get.dart';
import '../controllers/reels_draft_controller.dart';

class ReelsDraftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsDraftController>(() => ReelsDraftController());
  }
}
