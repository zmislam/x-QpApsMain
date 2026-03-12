import 'package:get/get.dart';

import '../config/theme/core_app_theme.dart';
import '../services/ads_service.dart';
// import '../services/global_video_playing_service.dart';

abstract class DependencyInjection {
  static init() {
    Get.put(ThemeController(), permanent: true);
    //Get.put(GlobalVideoPayingService(),permanent: true);
    Get.put(AdsService(), permanent: true);
  }
}
