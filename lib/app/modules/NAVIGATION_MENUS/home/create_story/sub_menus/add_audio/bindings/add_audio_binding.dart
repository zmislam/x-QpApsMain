import 'package:get/get.dart';

import '../controllers/add_audio_controller.dart';

class AddAudioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAudioController>(
      () => AddAudioController(),
    );
  }
}
