import 'package:get/get.dart';
import '../../../services/socket_service.dart';
import '../controllers/live_stream_controller.dart';

class LiveStreamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveStreamController>(
      () => LiveStreamController(socketService: Get.find<SocketService>()),
    );
  }
}
