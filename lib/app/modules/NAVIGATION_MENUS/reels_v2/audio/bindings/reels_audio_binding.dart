import 'package:get/get.dart';
import '../controllers/reels_audio_controller.dart';

class ReelsAudioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsAudioController>(() => ReelsAudioController());
  }
}
