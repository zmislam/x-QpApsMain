import 'package:get/get.dart';

import '../controllers/audience_live_stream_preview_controller.dart';

class AudienceLiveStreamPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudienceLiveStreamPreviewController>(
      () => AudienceLiveStreamPreviewController(),
    );
  }
}
