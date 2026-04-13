import 'package:get/get.dart';
import '../controllers/marketplace_conversation_controller.dart';

class MarketplaceConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketplaceConversationController>(
      () => MarketplaceConversationController(),
    );
  }
}
