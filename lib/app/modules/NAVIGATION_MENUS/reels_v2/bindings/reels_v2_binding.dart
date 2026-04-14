import 'package:get/get.dart';

import '../controllers/reels_v2_main_controller.dart';
import '../controllers/reels_feed_controller.dart';
import '../controllers/reel_player_controller.dart';
import '../controllers/reels_interaction_controller.dart';
import '../controllers/reels_comment_controller.dart';
import '../services/reels_v2_api_service.dart';
import '../services/reels_v2_feed_service.dart';
import '../services/reels_v2_cache_service.dart';
import '../services/reels_v2_preload_service.dart';

class ReelsV2Binding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<ReelsV2ApiService>(() => ReelsV2ApiService());
    Get.lazyPut<ReelsV2FeedService>(() => ReelsV2FeedService());
    Get.lazyPut<ReelsV2CacheService>(() => ReelsV2CacheService());
    Get.lazyPut<ReelsV2PreloadService>(() => ReelsV2PreloadService());

    // Controllers
    Get.lazyPut<ReelsV2MainController>(() => ReelsV2MainController());
    Get.lazyPut<ReelsFeedController>(() => ReelsFeedController());
    Get.lazyPut<ReelPlayerController>(() => ReelPlayerController());
    Get.lazyPut<ReelsInteractionController>(() => ReelsInteractionController());
    Get.lazyPut<ReelsCommentController>(() => ReelsCommentController());
  }
}
