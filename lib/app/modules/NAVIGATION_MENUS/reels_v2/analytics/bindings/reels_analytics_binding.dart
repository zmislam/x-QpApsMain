import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';

class ReelsAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsAnalyticsController>(() => ReelsAnalyticsController());
  }
}
