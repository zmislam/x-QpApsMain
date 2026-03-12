import 'package:get/get.dart';

import '../controllers/post_reactions_controller.dart';

class ReactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReactionsController>(
      () => ReactionsController(),
    );
  }
}
