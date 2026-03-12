import 'package:get/get.dart';

import '../controllers/minted_events_controller.dart';

class MintedEventsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MintedEventsController>(
      () => MintedEventsController(),
    );
  }
}
