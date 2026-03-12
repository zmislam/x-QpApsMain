import 'package:get/get.dart';

import '../controllers/reels_reactions_controller.dart';

class ReelsReactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsReactionsController>(
      () => ReelsReactionsController(),
    );
  }
}
